# TODO on the main machine: make the repo runnable on a fresh clone

Written 2026-09-28 from the laptop (repos in `C:\GitHubRepos`). Delete this
file, and the pointer in `CLAUDE.md`, once everything below is done.

## Why

`BH_Pupil_Destinations` and `bh-school-system` read files from this repo's
`data/` folder, but `data/` is git-ignored, so a fresh clone has none of them.

## Steps

### 1. Make these files available

```
data/Yr7_admissions.csv
data/ONSPD_FEB_2024_UK_BN.csv
data/edubasealldata20241003.xlsx
data/BrightonSecondaryCatchments.geojson
data/gtfs.zip
```

Also check what else `bh-school-system/R/01_assemble.R` reads from
`BH_Schools_2/data`.

### How to get ignored data onto GitHub

Check sizes first:

```r
f <- c(...)  # the list above
data.frame(f, MB = round(file.size(f) / 1e6, 1))
```

Then, for each file:
- **Small (under ~50 MB), licence allows it, not embargoed:** commit it. Add a
  `!path/to/file` rule to `.gitignore`. Git can't re-include a file whose
  parent folder is ignored, so change a folder rule like `data/` to `data/*`
  first.
- **Large:** upload as a GitHub Release asset (e.g. `piggyback::pb_upload()`)
  and add a small fetch script that downloads whatever is missing.
- **Restricted / embargoed / personal data:** leave it out, and say in the
  README where it comes from.

Check whether the repo is public before committing anything.

### Check it

Pull on the laptop and run `BH_Pupil_Destinations/public/run_public.R`.
