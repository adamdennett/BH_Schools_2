## Build a contacts spreadsheet for Brighton & Hove primary headteachers and
## chairs of governing boards.
##
## Sources: public school websites and Department for Education
## "Get Information About Schools" entries, gathered May 2026.
## Where a chair's personal email is not publicly listed, the school office
## (or clerk-to-governors) email is substituted and the chair_email_source
## column flags the substitution.

if (!requireNamespace("writexl", quietly = TRUE)) install.packages("writexl", repos = "https://cloud.r-project.org")
if (!requireNamespace("tibble",  quietly = TRUE)) install.packages("tibble",  repos = "https://cloud.r-project.org")

library(tibble)

contacts <- tibble::tribble(
  ~school, ~phase, ~URN, ~head_name, ~head_email, ~chair_name, ~chair_email, ~chair_email_source, ~notes, ~source,

  ## ---- Secondary ----

  "Blatchington Mill", "Secondary", 114606L,
  "Kate Claydon",                  "office@blatchingtonmill.org.uk",
  "James Tulley",                  "office@blatchingtonmill.org.uk", "office (chair email not published)",
  "Clerk: David Harvey.",
  "https://www.blatchingtonmill.org.uk/our-vision-and-values/governors/",

  "Brighton Aldridge Community Academy", "Secondary", 136164L,
  "Jack Davies",                   "info@baca-uk.org.uk",
  "Jim May",                       "info@baca-uk.org.uk", "academy office (chair email not published)",
  "Aldridge Education academy. Verify general inbox before sending.",
  "https://aldridgeeducation.org/Brighton-Aldridge-Community-Academy/Jack-Davies-Principal/",

  "Cardinal Newman", "Secondary", 114611L,
  "Claire Jarman",                 "office@cncs.co.uk",
  "Christina Bamin & Mel Fane (co-chairs)", "mgilmartin@stcat.co.uk", "clerk to governors (Maxine Gilmartin)",
  "St Catherine's Catholic Multi-Academy Trust school. Co-chairs.",
  "https://www.cncs.school/about-us/governors",

  "Dorothy Stringer", "Secondary", 114580L,
  "Matt Hillier",                  "office@dorothy-stringer.co.uk",
  "Bridget Taylor (term ends 7 Nov 2025; Sarah Bakhtiari noted as likely successor)", "clerk@dorothy-stringer.co.uk", "clerk to governors",
  "Chair transition; verify current incumbent before contacting.",
  "https://dorothy-stringer.co.uk/governors/",

  "Hove Park", "Secondary", 114607L,
  "Jim Roberts",                   "office@hovepark.org.uk",
  "Paul Williams",                 "pwilliams@hovepark.org.uk", "direct",
  "Senior Clerk: Chelle McCann (mmccann@hovepark.org.uk).",
  "https://www.hovepark.org.uk/governors",

  "Kings School", "Secondary", 139409L,
  "Sarah Price",                   "info@kingsschoolhove.org.uk",
  "(verify - Katherine Laux from 2015 records)", "info@kingsschoolhove.org.uk", "office (chair name uncertain)",
  "Free school (Russell Education Trust). No recent public chair listing - verify.",
  "https://en.wikipedia.org/wiki/King's_School,_Hove",

  "Longhill High", "Secondary", 114581L,
  "Rachelle Otulakowski",          "office@longhill.org.uk",
  "Sean Burke",                    "office@longhill.org.uk", "office (chair email not published)",
  "Chair in post since 17 Dec 2023.",
  "https://longhill.org.uk/about-us/governance/",

  "Patcham High", "Secondary", 114608L,
  "John McKee",                    "office@patchamhigh.org.uk",
  "Andrew Saunders",               "ASaunders@patchamhigh.org.uk", "direct",
  "Clerk: jjohnson@patchamhigh.org.uk.",
  "https://www.patchamhigh.brighton-hove.sch.uk/schoolinformation/governors/meet-the-chair/",

  "Portslade Aldridge Community Academy", "Secondary", 137063L,
  "Mark Poston",                   "Mark.Poston@paca.aldridgeeducation.org",
  "",                              "ChairOfGovernors@paca.aldridgeeducation.org", "dedicated chair inbox (name not currently published)",
  "Aldridge Education academy. PACA publishes a routing inbox for the chair.",
  "https://www.paca.uk.com/Local-Governing-Committee/",

  "Varndean", "Secondary", 114579L,
  "Shelley Baker",                 "office@varndean.co.uk",
  "",                              "teresadee@varndean.co.uk", "clerk to governors (Teresa Dee)",
  "Chair not publicly named; route via clerk.",
  "https://www.varndean.co.uk/about-us/governing-body",

  ## ---- Primary (open) ----

  "Aldrington CE Primary", "Primary", 114555L,
  "Verity Coates",                 "admin@aldrington.brighton-hove.sch.uk",
  "Susannah Kendrick",             "admin@aldrington.brighton-hove.sch.uk", "office (chair email not published)",
  "",
  "https://www.aldrington.brighton-hove.sch.uk/",

  "Balfour Primary", "Primary", 114382L,
  "Alan Gunn",                     "head@balfour.brighton-hove.sch.uk",
  "",                              "balfour.governor@balfour.brighton-hove.sch.uk", "governor inbox (chair name not published)",
  "Chair routed via governors@ inbox; clerk via school office (01273 507722).",
  "https://balfourprimary.co.uk/page/?pid=12&title=Governors",

  "Benfield Primary", "Primary", 151063L,
  "Drew Dower (Head of School); Clara Daly (Executive Head)", "Drewdower@ekotrust.org.uk",
  "Mark Goodson",                  "governance@ekotrust.org.uk", "trust governance inbox",
  "Joined EKO Trust as academy converter 31 Aug 2024 (URN changed). Chair also chairs Hangleton.",
  "https://benfield.brighton-hove.sch.uk/brighton-hove/primary/benfield/site/pages/ourschool/governors/meetthegovernors",

  "Bevendean Primary", "Primary", 114485L,
  "Mark Dally",                    "admin@bevendean.brighton-hove.sch.uk",
  "Lydia Majic & Adrian Strange (co-chairs)", "andrewthomas@bevendean.brighton-hove.sch.uk", "clerk to governors",
  "Co-chairs; route via clerk Andrew Thomas.",
  "https://www.bevendeanprimaryschoolandnursery.co.uk/about-1",

  "Bilingual Primary", "Primary", 138261L,
  "Simon King",                    "info@bilingualprimaryschool.org.uk",
  "Emma Creed & Mickey Sandall (co-chairs)", "info@bilingualprimaryschool.org.uk", "office (chair email not published)",
  "Co-chairs. Clerk: Helen Haskew.",
  "https://bilingualprimaryschool.org.uk/brighton-hove/primary/bilingualprimaryschool/site/pages/schoolinformation/bpsgoverningbody",

  "Brackenbury Primary", "Primary", 114413L,
  "Lizzie Mullarky",               "office@brackenbury.brighton-hove.sch.uk",
  "",                              "office@brackenbury.brighton-hove.sch.uk", "office (chair name not published)",
  "Current chair not publicly named; Dr Charlotte Vidal-Hall now vice-chair (5y previously chair).",
  "https://www.brackenburyprimary.co.uk/brighton-hove/primary/portslade/site/pages/aboutus/ourstaffteam",

  "Brunswick Primary", "Primary", 114446L,
  "Amanda Easton",                 "admin@brunswick.brighton-hove.sch.uk",
  "Helen Johnson",                 "helenjohnson@brunswick.brighton-hove.sch.uk", "direct",
  "Clerk: clerk@brunswick.brighton-hove.sch.uk",
  "https://brunswickprimary.schooljotter2.com/about-us/governors",

  "Carden Primary", "Primary", 131789L,
  "Laura Sibley",                  "admin@carden.brighton-hove.sch.uk",
  "Alistair McNair",               "alistairmcnair@carden.brighton-hove.sch.uk", "direct",
  "Clerk: zoeheaton@carden.brighton-hove.sch.uk",
  "https://www.carden.brighton-hove.sch.uk/about-us/governors/",

  "Carlton Hill Primary", "Primary", 114381L,
  "Tamsen Beer",                   "admin@carltonhill.brighton-hove.sch.uk",
  "Chris McNeill",                 "chrismcneill@carltonhill.brighton-hove.sch.uk", "direct",
  "",
  "https://www.carltonhill.brighton-hove.sch.uk/brighton-hove/primary/carltonhill/site/pages/governors",

  "City Academy Whitehawk", "Primary", 139677L,
  "Russell Wood",                  "admin@cawhitehawk.org.uk",
  "Janis Taylor",                  "admin@cawhitehawk.org.uk", "academy office (chair email not published)",
  "Academy: chair sits on local academy board.",
  "https://www.caw.brighton-hove.sch.uk/governance-1/",

  "Coldean Primary", "Primary", 114384L,
  "Stuart McConnachie",            "office@coldean.brighton-hove.sch.uk",
  "",                              "office@coldean.brighton-hove.sch.uk", "office (chair name not published)",
  "",
  "https://www.coldean.brighton-hove.sch.uk/adding-pages/governors",

  "Coombe Road Primary", "Primary", 114365L,
  "Stuart Scrase",                 "admin@coomberoad.brighton-hove.sch.uk",
  "",                              "admin@coomberoad.brighton-hove.sch.uk", "office (chair name not published)",
  "",
  "https://www.coomberoad.brighton-hove.sch.uk/contact-us",

  "Cottesmore St Mary Catholic Primary", "Primary", 114567L,
  "Rachel Breen",                  "rachelbreen@cottesmore.brighton-hove.sch.uk",
  "",                              "office@cottesmore.brighton-hove.sch.uk", "office (chair name not published)",
  "",
  "https://www.cottesmore.brighton-hove.sch.uk/page/governors/",

  "Downs Infant", "Primary", 114367L,
  "Lisa Walker",                   "admin@downsinf.brighton-hove.sch.uk",
  "Susan Campbell",                "admin@downsinf.brighton-hove.sch.uk", "office (chair email not published)",
  "",
  "https://downsinf.brighton-hove.sch.uk/governors",

  "Elm Grove Primary", "Primary", 114477L,
  "Ben Massey",                    "benmassey@elmgrove.brighton-hove.sch.uk",
  "Chris Adams",                   "chrisadams@elmgrove.brighton-hove.sch.uk", "direct",
  "",
  "https://www.elmgrove.brighton-hove.sch.uk/key-info/governors",

  "Fairlight Primary", "Primary", 114487L,
  "Damien Jordan",                 "admin@fairlight.brighton-hove.sch.uk",
  "Nicola Yuill & Michelle McCann (co-chairs)", "admin@fairlight.brighton-hove.sch.uk", "office (chair email not published)",
  "Co-chairs.",
  "https://www.fairlight.brighton-hove.sch.uk/aboutus/governors",

  "Goldstone Primary", "Primary", 114398L,
  "Anne Gibbs",                    "admin@goldstone.brighton-hove.sch.uk",
  "Jeremy Kempton",                "admin@goldstone.brighton-hove.sch.uk", "office (chair email not published)",
  "Clerk: Emma Lynn.",
  "https://goldstoneprimary.co.uk/brighton-hove/primary/goldstone/site/pages/governance/governorshome/governors",

  "Hangleton Primary", "Primary", 151062L,
  "Emma Lake",                     "hangletoninfo@ekotrust.org.uk",
  "Mark Goodson",                  "governance@ekotrust.org.uk", "trust governance inbox",
  "EKO Trust academy; shares governance with Benfield. Verify head email.",
  "https://www.hangleton.brighton-hove.sch.uk/brighton-hove/primary/hangleton/site/pages/ourschool/govsnew/ourgoverningbody",

  "Hertford Primary", "Primary", 114368L,
  "Rachael Durneen",               "admin@hertford.brighton-hove.sch.uk",
  "Jenny Perrin",                  "jennyperrin@hertford.brighton-hove.sch.uk", "direct",
  "Single Hertford site (formerly Infant + Junior).",
  "https://www.hertfordinf.brighton-hove.sch.uk/brighton-hove/primary/hertfordinf/site/pages/ourschool/governors",

  "Middle Street Primary", "Primary", 114369L,
  "Rob Cooper (departed; interim arrangements)", "admin@middlestreet.brighton-hove.sch.uk",
  "Ashley Seymour-Williams (interim)", "admin@middlestreet.brighton-hove.sch.uk", "office (interim governance)",
  "School is being closed (announced Jan 2026); IEB in place of standard governing body. Verify current arrangements before contacting.",
  "https://middlestreet.brighton-hove.sch.uk/board-of-governors-1",

  "Mile Oak Primary", "Primary", 114430L,
  "Luke Lording",                  "office@mileoak.brighton-hove.sch.uk",
  "Rosalind Turner",               "office@mileoak.brighton-hove.sch.uk", "office (chair email not published)",
  "Clerk: Helen Haskew (sarahinchliffe@mileoak.brighton-hove.sch.uk listed as clerk admin).",
  "https://www.mileoakschool.co.uk/about-us/governors/",

  "Moulsecoomb Primary", "Primary", 147680L,
  "Amy Myers",                     "admin@moulsecoomb.brighton-hove.sch.uk",
  "(vacant - recruiting)",         "admin@moulsecoomb.brighton-hove.sch.uk", "office (chair vacancy)",
  "Chair vacancy advertised via Governors for Schools mid-2025.",
  "https://www.moulsecoomb.brighton-hove.sch.uk/brighton-hove/primary/moulsecoomb/site/pages/ourschool/whoswho",

  "Our Lady of Lourdes Catholic Primary", "Primary", 114544L,
  "Darren McCann",                 "office@ololcatholicprimary.org",
  "",                              "office@ololcatholicprimary.org", "office (chair name not published)",
  "DfE record still shows previous head Anita Philbrook; school site lists Darren McCann (in post Sept 2021). Verify.",
  "https://ololcatholicprimary.org/Governors/",

  "Patcham Infant", "Primary", 114373L,
  "C Taylor",                      "admin@patchaminf.brighton-hove.sch.uk",
  "",                              "admin@patchaminf.brighton-hove.sch.uk", "office (chair name not published)",
  "Marie Buss listed as Vice Chair from 1.9.23; chair not publicly named.",
  "https://www.patchaminf.brighton-hove.sch.uk/governors/who-are-we",

  "Peter Gladwin Primary", "Primary", 114443L,
  "Vicki Strange",                 "admin@gladwin.brighton-hove.sch.uk",
  "Mark Claydon",                  "ninapickering@gladwin.brighton-hove.sch.uk", "clerk to governors",
  "",
  "https://www.gladwin.brighton-hove.sch.uk/the-governing-body",

  "Queens Park Primary", "Primary", 114478L,
  "Emma Gale",                     "admin@queenspark.brighton-hove.sch.uk",
  "Ingrid Laycock (Acting Chair)", "ingridlaycock@queenspark.brighton-hove.sch.uk", "direct",
  "Acting chair; co-chair arrangement may apply (Claire recently joined as Co-Chair).",
  "https://www.queenspark.brighton-hove.sch.uk/school-info/governors/",

  "Rudyard Kipling Primary", "Primary", 114486L,
  "Euan Hanington",                "admin@kipling.brighton-hove.sch.uk",
  "Alex Brewer & Craig Munro (co-chairs)", "admin@kipling.brighton-hove.sch.uk", "office (chair email not published)",
  "Co-chairs.",
  "https://www.rudyardkiplingprimary.co.uk/",

  "Saltdean Primary", "Primary", 114479L,
  "John Maxwell",                  "enq@saltdean.brighton-hove.sch.uk",
  "Carole McIver-Wren",            "spsclerk@saltdean.brighton-hove.sch.uk", "clerk to governors",
  "",
  "https://www.saltdeanprimary.org.uk/Our-School/Our-Governors/",

  "St Andrew's CE Primary", "Primary", 114556L,
  "Sophie Thomas",                 "admin@st-andrews.brighton-hove.sch.uk",
  "",                              "admin@st-andrews.brighton-hove.sch.uk", "office (chair name not published)",
  "",
  "https://www.st-andrews.brighton-hove.sch.uk/",

  "St Bernadette's Catholic Primary", "Primary", 114546L,
  "Claire Smith",                  "office@stberns.brighton-hove.sch.uk",
  "",                              "office@stberns.brighton-hove.sch.uk", "office (chair name not published)",
  "",
  "https://stberns.com/brighton-hove/primary/stberns/site/pages/stat/governors",

  "St John The Baptist Catholic Primary", "Primary", 114540L,
  "Carly Carden",                  "admin@stjohn.brighton-hove.sch.uk",
  "",                              "admin@stjohn.brighton-hove.sch.uk", "office (chair name not published)",
  "",
  "https://www.stjohn.brighton-hove.sch.uk/",

  "St Joseph's Catholic Primary", "Primary", 114542L,
  "Gillian Foan",                  "admin@st-josephs.brighton-hove.sch.uk",
  "",                              "admin@st-josephs.brighton-hove.sch.uk", "office (chair name not published)",
  "Clerk: Kristy Braswell-Ralston.",
  "https://www.st-josephs.brighton-hove.sch.uk/about-us/governors",

  "St Luke's Primary", "Primary", 114374L,
  "Simon Wattam",                  "admin@stlukes.brighton-hove.sch.uk",
  "",                              "susanowen@stlukes.brighton-hove.sch.uk", "clerk to governors",
  "Chair name not published; route via clerk Susan Owen.",
  "https://www.stlukes.brighton-hove.sch.uk/school-info/governors/",

  "St Margaret's CE Primary", "Primary", 114537L,
  "Rachel Kershaw",                "admin@stmargarets.brighton-hove.sch.uk",
  "(co-chairs - names not published)", "admin@stmargarets.brighton-hove.sch.uk", "office (chair names not published)",
  "",
  "https://www.stmargarets.brighton-hove.sch.uk/",

  "St Mark's CE Primary", "Primary", 114545L,
  "Claire Roberts",                "admin@stmarks.brighton-hove.sch.uk",
  "Amanda Healey & Allistare Smedley (co-chairs)", "admin@stmarks.brighton-hove.sch.uk", "office (chair email not published)",
  "Co-chairs (Foundation Governors).",
  "https://www.stmarks.brighton-hove.sch.uk/About-the-Governors/",

  "St Martin's CE Primary", "Primary", 114539L,
  "Jane Joshi",                    "office@stmartinsschool.org.uk",
  "",                              "office@stmartinsschool.org.uk", "office (chair name not published)",
  "",
  "https://www.stmartins.brighton-hove.sch.uk/About-Us/Our-Governors/",

  "St Mary Magdalen Catholic Primary", "Primary", 114541L,
  "Gemma Nunes (Head of School); Sarah Clayton (Executive Head)", "office@stmarymags.brighton-hove.sch.uk",
  "",                              "michellemccann@stmarymags.brighton-hove.sch.uk", "clerk to governors",
  "Shares Executive Head with St Mary's Catholic, Portslade.",
  "https://stberns.com/brighton-hove/primary/stmarymags/site/pages/aboutus/governors",

  "St Mary's Catholic Primary", "Primary", 114570L,
  "Sarah Clayton (Executive Head)", "office@stmarys.brighton-hove.sch.uk",
  "",                              "office@stmarys.brighton-hove.sch.uk", "office (chair name not published)",
  "Shares Executive Head with St Mary Magdalen.",
  "https://www.stmarys.brighton-hove.sch.uk/governors/",

  "St Nicolas CE Primary", "Primary", 114560L,
  "Andy Richbell",                 "admin@stnicolas.brighton-hove.sch.uk",
  "",                              "admin@stnicolas.brighton-hove.sch.uk", "office (chair name not published)",
  "Rev David Swyer named as Vice Chair (Foundation Governor).",
  "https://www.stnicolas.brighton-hove.sch.uk/about-us/governors",

  "St Paul's CE Primary", "Primary", 114543L,
  "Michelle Lord",                 "MichelleLord@stpauls.brighton-hove.sch.uk",
  "Susannah Main",                 "office@stpauls.brighton-hove.sch.uk", "office (chair email not published)",
  "",
  "https://www.stpaulsbrighton.co.uk/Governors/",

  "Stanford Infant", "Primary", 114377L,
  "Jenny Stratton",                "office@stanford-inf.brighton-hove.sch.uk",
  "Tess Gill & Catrin Pinheiro Torres (co-chairs)", "office@stanford-inf.brighton-hove.sch.uk", "office (chair email not published)",
  "Co-chairs from 2022 Ofsted record; verify still current.",
  "https://www.stanfordinfants.co.uk/Our-Governors/",

  "West Blatchington Primary", "Primary", 149963L,
  "Russell Brentnall",             "admin@wblatch.brighton-hove.sch.uk",
  "(verify - Michael Jennings 2015 record; may be outdated)", "admin@wblatch.brighton-hove.sch.uk", "office (chair name uncertain)",
  "No recent public listing of chair; recommend ringing school office.",
  "http://www.westblatchingtonprimary.co.uk/leadership",

  "West Hove Infant, Holland Road", "Primary", 114428L,
  "Maddie Southern",               "admin@westhove-inf.brighton-hove.sch.uk",
  "",                              "clerk@hovelearningfederation.brighton-hove.sch.uk", "clerk to governors (Hove Learning Federation)",
  "Same school as Portland Road site (Hove Learning Federation). Louise Wilkinson listed as Co-Vice Chair.",
  "http://www.westhoveinfants.co.uk/community/governors-2/",

  "West Hove Infant, Portland Road", "Primary", 114428L,
  "Maddie Southern",               "admin@westhove-inf.brighton-hove.sch.uk",
  "",                              "clerk@hovelearningfederation.brighton-hove.sch.uk", "clerk to governors (Hove Learning Federation)",
  "Same school as Holland Road site (two sites, one URN).",
  "http://www.westhoveinfants.co.uk/community/governors-2/",

  "Westdene Primary", "Primary", 114380L,
  "Ian Lopatin",                   "admin@westdene.brighton-hove.sch.uk",
  "Charles Haywood",               "sarahswales@westdene.brighton-hove.sch.uk", "clerk to governors",
  "",
  "https://www.westdeneprimary.co.uk/school-info/governors",

  "Woodingdean Primary", "Primary", 114480L,
  "G Chumnansin",                  "admin@woodingdean.brighton-hove.sch.uk",
  "",                              "chellemccann@woodingdean.brighton-hove.sch.uk", "clerk to governors (Chelle McCann)",
  "Chair name not publicly listed.",
  "https://www.woodingdean.brighton-hove.sch.uk/Who-s-Who-07122017164854/"
)

## --- Derive first/last name columns for mail-merge ---
## Rules:
##  * If the cell starts with "(" (e.g. "(vacant)", "(verify - ...)"), treat
##    as no nameable person -> blank first + last.
##  * Strip parenthetical annotations such as "(co-chairs)", "(Head of School)".
##  * If multiple people are listed (separated by ";" or "&"), take the first.
##  * Strip leading titles (Mr, Mrs, Ms, Miss, Dr, Rev, Prof).
##  * If the remaining first token is a single letter / initial (e.g. "C Taylor"),
##    leave the first_name blank and use the rest as surname.

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

## Reorder so first/last sit next to the originals (handy for mail-merge column-picking)
contacts <- contacts[, c(
  "school", "phase", "URN",
  "head_name", "head_first", "head_last", "head_email",
  "chair_name", "chair_first", "chair_last", "chair_email", "chair_email_source",
  "notes", "source"
)]

readme <- tibble::tibble(
  field = c("school", "phase", "URN",
            "head_name", "head_first", "head_last", "head_email",
            "chair_name", "chair_first", "chair_last", "chair_email",
            "chair_email_source", "notes", "source"),
  meaning = c(
    "School name as used in school_locs tibble.",
    "'Primary' or 'Secondary'.",
    "DfE Unique Reference Number.",
    "Full head-teacher entry as published (may include title, role qualifier, or co-/exec head).",
    "Head's first name, parsed from head_name. Blank where the head is published with an initial only or where multiple heads are listed (then takes the first person's first name).",
    "Head's surname, parsed from head_name.",
    "Best published direct email for the head. Falls back to school office (admin@... / office@...) if no personal email is published.",
    "Chair of the governing board / local academy board (full entry). Co-chairs listed together. Blank where the school does not publish a name.",
    "Chair's first name, parsed from chair_name. For co-chairs, takes the first person listed (most natural for mail merge salutation).",
    "Chair's surname, parsed from chair_name.",
    "Best email to reach the chair. Personal where published; otherwise office or clerk-to-governors.",
    "What the chair_email actually is: 'direct' (personal), 'office (chair email not published)', 'clerk to governors', 'trust governance inbox', etc.",
    "Anything unusual: co-chairs, vacancy, interim arrangements, academy/trust context, data-freshness caveats.",
    "URL where the information was sourced (school site governance page where possible)."
  )
)

out_path <- "E:/BH_Schools_2/bh_school_contacts.xlsx"
writexl::write_xlsx(
  list(contacts = contacts, README = readme),
  path = out_path
)

cat("Wrote", nrow(contacts), "rows to", out_path, "\n")
