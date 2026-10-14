## Patch the existing contacts workbook in place:
##  - replace head_email for schools where a direct head email is now known
##  - append rows for BHASVIC and Varndean College (sixth-form colleges)
##  - re-derive head_first/head_last and chair_first/chair_last so the
##    parsed columns stay in sync with any head_name / chair_name changes
##  - write the same workbook back out (sheets: contacts + README)
##
## Reads the existing E:/BH_Schools_2/bh_school_contacts.xlsx so any manual
## edits the user has made (e.g. office_email column) are preserved.

suppressMessages({
  if (!requireNamespace("readxl",  quietly = TRUE)) install.packages("readxl",  repos = "https://cloud.r-project.org")
  if (!requireNamespace("writexl", quietly = TRUE)) install.packages("writexl", repos = "https://cloud.r-project.org")
  if (!requireNamespace("tibble",  quietly = TRUE)) install.packages("tibble",  repos = "https://cloud.r-project.org")
  library(readxl); library(writexl); library(tibble)
})

xlsx_path <- "E:/BH_Schools_2/bh_school_contacts.xlsx"
contacts  <- read_excel(xlsx_path, sheet = "contacts")

## --- 1. Direct head-email updates discovered in the latest pass ---
##
## Each entry: school name -> direct head email replacing the office one.

email_updates <- list(
  "Goldstone Primary"     = "annegibbs@goldstone.brighton-hove.sch.uk",
  "Peter Gladwin Primary" = "VickiStrange@gladwin.brighton-hove.sch.uk"
)

for (sch in names(email_updates)) {
  hit <- which(contacts$school == sch)
  if (length(hit) == 1) contacts$head_email[hit] <- email_updates[[sch]]
}

## --- 2. Append the two sixth-form colleges ---

new_rows <- tibble::tribble(
  ~school, ~phase, ~URN, ~head_name, ~head_first, ~head_last, ~head_email, ~office_email,
  ~chair_name, ~chair_first, ~chair_last, ~chair_email, ~chair_email_source, ~notes, ~source,

  "BHASVIC (Brighton, Hove & Sussex Sixth Form College)", "Sixth Form", 130669L,
  "William Baldwin", "William", "Baldwin",
  "w.baldwin@bhasvic.ac.uk", "info@bhasvic.ac.uk",
  "Kirstin Baker & Simon Porges (Co-Chairs of the Corporation)",
  "Kirstin", "Baker",
  "l.pennington@bhasvic.ac.uk", "clerk to the Corporation (Louise Pennington)",
  "FE college (Sixth Form Colleges Association). Adopted co-chair governance model; Porges leads Teaching & Learning, Baker leads Resources & Support.",
  "https://www.bhasvic.ac.uk/the-college/governance",

  "Varndean College", "Sixth Form", 130668L,
  "Donna-Marie Janson", "Donna-Marie", "Janson",
  "kst@varndean.ac.uk", "information@varndean.ac.uk",
  "John Williams (Chair); Simon Lindfield (Vice Chair)",
  "John", "Williams",
  "lep@varndean.ac.uk", "clerk to the Corporation (Louise Pennington)",
  "FE college. Chair role rotated from Jill Arnold (2024-25) to John Williams (2025-26). kst@ is the Principal/SLT EA inbox; verify before sending.",
  "https://www.varndean.ac.uk/governors/"
)

## Align columns and bind. Existing workbook has office_email between
## head_email and chair_name; new_rows uses the same order.
new_rows  <- new_rows[,  names(contacts)]
contacts  <- rbind(contacts, new_rows)

## --- 3. Re-derive head_first / head_last / chair_first / chair_last ---
##
## Re-running the parser keeps these columns in sync with any head_name /
## chair_name edits (including the new sixth-form rows above).

split_name <- function(x) {
  if (is.null(x) || is.na(x) || nchar(x) == 0) return(c(first = "", last = ""))
  if (grepl("^\\(", x)) return(c(first = "", last = ""))
  s <- trimws(gsub("\\s*\\([^)]*\\)\\s*", " ", x))
  s <- trimws(strsplit(s, "\\s*[;&]\\s*")[[1]][1])
  s <- sub("^(Mrs|Mr|Ms|Miss|Dr|Rev|Revd|Reverend|Prof|Professor)\\.?\\s+", "", s)
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

heads  <- t(vapply(contacts$head_name,  split_name, character(2)))
chairs <- t(vapply(contacts$chair_name, split_name, character(2)))
contacts$head_first  <- unname(heads[,  "first"])
contacts$head_last   <- unname(heads[,  "last"])
contacts$chair_first <- unname(chairs[, "first"])
contacts$chair_last  <- unname(chairs[, "last"])

## --- 4. Refresh the README sheet (now mentions office_email + Sixth Form phase) ---

readme <- tibble::tibble(
  field = c("school", "phase", "URN",
            "head_name", "head_first", "head_last", "head_email", "office_email",
            "chair_name", "chair_first", "chair_last", "chair_email",
            "chair_email_source", "notes", "source"),
  meaning = c(
    "School name as used in school_locs tibble.",
    "'Primary', 'Secondary', or 'Sixth Form'.",
    "DfE Unique Reference Number.",
    "Full head/principal entry as published (may include title, role qualifier, or co-/exec head).",
    "Head's first name, parsed from head_name. Blank where the head is published with an initial only or where multiple heads are listed (then takes the first person's first name).",
    "Head's surname, parsed from head_name.",
    "Best published direct email for the head. Falls back to school office email if no personal email is published.",
    "School/college general office or enquiries inbox, in addition to (or duplicating) head_email.",
    "Chair of the governing board / local academy board / corporation (full entry). Co-chairs listed together. Blank where not publicly named.",
    "Chair's first name, parsed from chair_name. For co-chairs, takes the first person listed (most natural for mail merge salutation).",
    "Chair's surname, parsed from chair_name.",
    "Best email to reach the chair. Personal where published; otherwise office or clerk-to-governors.",
    "What the chair_email actually is: 'direct', 'office (chair email not published)', 'clerk to governors', 'trust governance inbox', etc.",
    "Anything unusual: co-chairs, vacancy, interim arrangements, academy/trust context, data-freshness caveats.",
    "URL where the information was sourced (school site governance page where possible)."
  )
)

write_xlsx(list(contacts = contacts, README = readme), path = xlsx_path)

cat("Updated", xlsx_path, "- now", nrow(contacts), "rows\n")
cat("Direct-email updates applied:", length(email_updates), "\n")
cat("Added sixth-form colleges: BHASVIC, Varndean College\n")
