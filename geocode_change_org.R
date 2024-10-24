# load ggmap
library(ggmap)
library(chattr)
library(here)
library(janitor)

source(here("api_key.R"))


change.org <- read_delim(here("data", "petition_signatures_jobs_490251836_20241022201128.csv"), 
                         delim = "\t", locale = locale(encoding = "UTF-16")) %>%
  clean_names()


change.org <- mutate_geocode(change.org, location = "postal_code", source = "google", output = "latlon")
