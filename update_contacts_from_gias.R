## Reconcile bh_school_contacts.xlsx against authoritative DfE GIAS data
## scraped into _gias_scraped.csv.
##
## Rules:
##  - GIAS is authoritative for head_name and chair_name.
##  - Titles (Mr/Mrs/Ms/Miss/Dr/Rev/Prof) are stripped from GIAS values
##    before comparison to match the existing column convention.
##  - Where GIAS has a non-empty value that differs from ours, we update.
##  - Where GIAS is empty (academies / sixth-forms that don't publish
##    governance via GIAS, etc.), we keep our existing value.
##  - head_first / head_last / chair_first / chair_last are re-derived
##    after updates using the same parser as before.
##  - A new "verified" column records the outcome per row.
##  - Rows are highlighted in the written xlsx (via openxlsx) when
##    something is missing or stale:
##      * red-fill   = chair name missing entirely (no GIAS + none on file)
##      * amber-fill = chair email is office/clerk fallback (no personal)
##                     OR head email is office fallback
##      * green-fill = both head and chair have direct (personal) emails
##  - Office/clerk emails are detected via chair_email_source values.

suppressMessages({
  for (pkg in c("readxl", "tibble", "dplyr", "openxlsx")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      install.packages(pkg, repos = "https://cloud.r-project.org")
    }
  }
  library(readxl); library(tibble); library(dplyr); library(openxlsx)
})

xlsx_path <- "E:/BH_Schools_2/bh_school_contacts.xlsx"
gias_path <- "E:/BH_Schools_2/_gias_scraped.csv"

contacts <- read_excel(xlsx_path, sheet = "contacts")
gias     <- read.csv(gias_path, stringsAsFactors = FALSE, na.strings = "")

# --- Helper: strip leading title from a GIAS name ---
strip_title <- function(x) {
  if (is.na(x) || nchar(x) == 0) return("")
  s <- sub("^(Mrs|Mr|Ms|Miss|Dr|Rev|Revd|Reverend|Prof|Professor)\\.?\\s+",
           "", x, ignore.case = TRUE)
  trimws(s)
}

gias$gias_head_clean  <- vapply(gias$gias_head,  strip_title, character(1))
gias$gias_chair_clean <- vapply(gias$gias_chair, strip_title, character(1))

# --- Join GIAS data to contacts on URN (note: West Hove Infant has two
#     rows with the same URN, the join will replicate GIAS values to both)
joined <- contacts %>%
  left_join(gias %>% select(URN, gias_head, gias_head_clean,
                            gias_chair, gias_chair_clean, gias_status,
                            source_url),
            by = "URN")

# --- Decide updates ---
#
# For head/chair, the current value is sometimes more informative than
# GIAS (e.g. "Drew Dower (Head of School); Clara Daly (Executive Head)"
# vs GIAS "Clara Daly"). We log the *original* value into notes when we
# replace it, so the context isn't lost.

decide_update <- function(current, gias_clean) {
  # Returns list: list(new = ..., changed = TRUE/FALSE)
  cur <- if (is.null(current) || length(current) == 0 || is.na(current)) "" else trimws(as.character(current))
  g   <- if (is.null(gias_clean) || length(gias_clean) == 0 || is.na(gias_clean)) "" else trimws(as.character(gias_clean))
  if (!nzchar(g))   return(list(new = cur, changed = FALSE, reason = "no_gias"))
  if (!nzchar(cur)) return(list(new = g,   changed = TRUE,  reason = "filled_blank"))

  # Compare ignoring case + trailing parentheticals on the current value
  cur_stripped <- trimws(gsub("\\s*\\([^)]*\\)\\s*", " ", cur))
  parts <- strsplit(cur_stripped, "\\s*[;&]\\s*")[[1]]
  cur_first_person <- if (length(parts) >= 1) trimws(parts[1]) else ""
  if (!nzchar(cur_first_person)) cur_first_person <- cur_stripped

  if (identical(tolower(g), tolower(cur_first_person)) ||
      grepl(tolower(g), tolower(cur), fixed = TRUE)) {
    return(list(new = cur, changed = FALSE, reason = "matches"))
  }
  list(new = g, changed = TRUE, reason = "differs")
}

joined$head_updated  <- FALSE
joined$chair_updated <- FALSE
joined$verified      <- "ok"

for (i in seq_len(nrow(joined))) {
  h <- decide_update(joined$head_name[i],  joined$gias_head_clean[i])
  c <- decide_update(joined$chair_name[i], joined$gias_chair_clean[i])

  prev_head  <- joined$head_name[i]
  prev_chair <- joined$chair_name[i]

  if (h$changed) {
    joined$head_name[i] <- h$new
    joined$head_updated[i] <- TRUE
    note_bit <- paste0("[GIAS update ", Sys.Date(), "] head was: ",
                       ifelse(is.na(prev_head) | prev_head == "", "(blank)", prev_head))
    joined$notes[i] <- ifelse(is.na(joined$notes[i]) | joined$notes[i] == "",
                              note_bit,
                              paste0(joined$notes[i], " ", note_bit))
  }
  if (c$changed) {
    joined$chair_name[i] <- c$new
    joined$chair_updated[i] <- TRUE
    note_bit <- paste0("[GIAS update ", Sys.Date(), "] chair was: ",
                       ifelse(is.na(prev_chair) | prev_chair == "", "(blank)", prev_chair))
    joined$notes[i] <- ifelse(is.na(joined$notes[i]) | joined$notes[i] == "",
                              note_bit,
                              paste0(joined$notes[i], " ", note_bit))
  }

  # Verified status
  joined$verified[i] <- if (h$changed && c$changed)         "both_updated"
                       else if (h$changed)                  "head_updated"
                       else if (c$changed)                  "chair_updated"
                       else if (is.na(joined$gias_chair[i]) || joined$gias_chair[i] == "")
                                                            "chair_not_on_gias"
                       else                                 "verified"
}

# --- Re-derive first/last name columns from updated head_name / chair_name ---

split_name <- function(x) {
  if (is.null(x) || is.na(x) || nchar(x) == 0) return(c(first = "", last = ""))
  if (grepl("^\\(", x)) return(c(first = "", last = ""))
  s <- trimws(gsub("\\s*\\([^)]*\\)\\s*", " ", x))
  s <- trimws(strsplit(s, "\\s*[;&]\\s*")[[1]][1])
  s <- sub("^(Mrs|Mr|Ms|Miss|Dr|Rev|Revd|Reverend|Prof|Professor)\\.?\\s+",
           "", s, ignore.case = TRUE)
  parts <- strsplit(s, "\\s+")[[1]]
  parts <- parts[nchar(parts) > 0]
  if (length(parts) == 0) return(c(first = "", last = ""))
  if (length(parts) == 1) return(c(first = "", last = parts[1]))
  first_token <- parts[1]
  if (nchar(first_token) == 1 || grepl("^[A-Z]\\.$", first_token)) {
    return(c(first = "", last = paste(parts[-1], collapse = " ")))
  }
  c(first = first_token, last = paste(parts[-1], collapse = " "))
}

heads  <- t(vapply(joined$head_name,  split_name, character(2)))
chairs <- t(vapply(joined$chair_name, split_name, character(2)))
joined$head_first  <- unname(heads[,  "first"])
joined$head_last   <- unname(heads[,  "last"])
joined$chair_first <- unname(chairs[, "first"])
joined$chair_last  <- unname(chairs[, "last"])

# --- Strip helper columns and reorder ---

final_cols <- c("school", "phase", "URN",
                "head_name", "head_first", "head_last", "head_email", "office_email",
                "chair_name", "chair_first", "chair_last", "chair_email",
                "chair_email_source", "verified", "notes", "source")
final <- joined[, intersect(final_cols, names(joined))]

# --- README sheet ---

readme <- tibble::tibble(
  field = final_cols,
  meaning = c(
    "School name as used in school_locs tibble.",
    "'Primary', 'Secondary', or 'Sixth Form'.",
    "DfE Unique Reference Number.",
    "Full head/principal entry. Authoritative source: DfE Get Information About Schools (GIAS) page for the URN.",
    "Head's first name, parsed from head_name. Blank for initial-only entries.",
    "Head's surname, parsed from head_name.",
    "Best published direct email for the head. Office fallback if no personal email is published.",
    "School/college general office or enquiries inbox.",
    "Chair of governing board / local academy board / corporation. Authoritative source: GIAS where listed.",
    "Chair's first name, parsed from chair_name. For co-chairs, takes the first person listed.",
    "Chair's surname, parsed from chair_name.",
    "Best email to reach the chair (personal where published, else office/clerk).",
    "'direct', 'office (chair email not published)', 'clerk to governors', etc.",
    paste0("GIAS reconciliation status (added ", Sys.Date(), "): verified | head_updated | chair_updated | both_updated | chair_not_on_gias. Updated rows have the previous value preserved in notes."),
    "Anything unusual: co-chairs, vacancy, interim arrangements, GIAS-update history, etc.",
    "URL used as the original source for this row."
  )
)

# --- Write via openxlsx with row highlighting ---

wb <- createWorkbook()

addWorksheet(wb, "contacts")
writeData(wb, "contacts", final)

# Header style
header_style <- createStyle(textDecoration = "bold", fgFill = "#dddddd")
addStyle(wb, "contacts", header_style,
         rows = 1, cols = seq_len(ncol(final)), gridExpand = TRUE)

# Row colours by 'verified' status
red    <- createStyle(fgFill = "#fad4d4")   # chair missing entirely
amber  <- createStyle(fgFill = "#fff4cc")   # something was updated (review)
office <- createStyle(fgFill = "#eef3fb")   # chair only via office/clerk (no personal email)

# Highlight rows where verified != "verified"
status_col <- which(names(final) == "verified")
chair_source_col <- which(names(final) == "chair_email_source")

for (i in seq_len(nrow(final))) {
  excel_row <- i + 1L  # +1 for header
  v <- final$verified[i]
  src <- final$chair_email_source[i]

  # Chair entirely missing (no name on file)
  if (is.na(final$chair_name[i]) || nchar(trimws(final$chair_name[i])) == 0) {
    addStyle(wb, "contacts", red, rows = excel_row,
             cols = seq_len(ncol(final)), gridExpand = TRUE, stack = TRUE)
    next
  }

  # Updated this round - review
  if (v %in% c("head_updated", "chair_updated", "both_updated")) {
    addStyle(wb, "contacts", amber, rows = excel_row,
             cols = seq_len(ncol(final)), gridExpand = TRUE, stack = TRUE)
    next
  }

  # Office/clerk fallback for chair email
  if (!is.na(src) && (grepl("office", src, ignore.case = TRUE) ||
                      grepl("clerk",  src, ignore.case = TRUE) ||
                      grepl("trust",  src, ignore.case = TRUE) ||
                      grepl("dedicated chair inbox", src, ignore.case = TRUE))) {
    addStyle(wb, "contacts", office, rows = excel_row,
             cols = seq_len(ncol(final)), gridExpand = TRUE, stack = TRUE)
  }
}

# Column widths
setColWidths(wb, "contacts",
             cols = seq_len(ncol(final)),
             widths = c(35, 11, 8, 35, 12, 14, 38, 38, 35, 12, 16, 38, 30, 18, 60, 50)[seq_len(ncol(final))])
freezePane(wb, "contacts", firstRow = TRUE)

addWorksheet(wb, "README")
writeData(wb, "README", readme)
addStyle(wb, "README", header_style, rows = 1, cols = seq_len(ncol(readme)), gridExpand = TRUE)
setColWidths(wb, "README", cols = 1:2, widths = c(22, 95))

saveWorkbook(wb, xlsx_path, overwrite = TRUE)

# --- Summary report ---
cat("\n--- Summary ---\n")
cat("Total rows:        ", nrow(final), "\n")
cat("Verified unchanged:", sum(final$verified == "verified"), "\n")
cat("Head updated:      ", sum(final$verified == "head_updated"), "\n")
cat("Chair updated:     ", sum(final$verified == "chair_updated"), "\n")
cat("Both updated:      ", sum(final$verified == "both_updated"), "\n")
cat("Chair not on GIAS: ", sum(final$verified == "chair_not_on_gias"), "\n")
cat("Chair missing:     ",
    sum(is.na(final$chair_name) | nchar(trimws(final$chair_name)) == 0), "\n")

cat("\n--- Rows with updates ---\n")
upd <- final[final$verified %in% c("head_updated","chair_updated","both_updated"),
             c("school","verified","head_name","chair_name")]
print(upd, row.names = FALSE, right = FALSE)
