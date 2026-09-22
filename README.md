# HangmanneR

Hangman played with CRAN package names. You guess one letter at a time against
a package sampled from a snapshot of CRAN metadata that ships with the package,
19,838 of them. It started as a [TidyTuesday](https://github.com/rfordatascience/tidytuesday)
entry for 2023 week 38.

Play it at <https://matias-andina.shinyapps.io/HangmanneR/>. If that link does
nothing the app is asleep, so run it locally.

## Install

```r
# install.packages("remotes")
remotes::install_github("matiasandina/HangmanneR")
```

## Run

```r
library(HangmanneR)
run_app()
```

`run_app()` passes `...` to `shiny::shinyApp()`, so `run_app(options = list(port = 1234))`
and friends work.

## How it plays

Type a letter and the guess registers on its own, or click Guess Letter. Digits
and the dot count as guesses, because package names use them. Six wrong guesses
end the round, and the hearts under the controls are what is left of your
budget.

Difficulty filters the pool by name length: Easy is 2 to 7 characters, Normal
is 8 to 15, Hard is 16 and up. The Posit checkbox keeps only packages with
Posit Software, PBC in the author field. Changing either one deals a new
package. Hint shows the package description with the name blanked out, and that
description comes up anyway once the round is over, next to a link to CRAN.

## Layout

```
R/                     app_ui, app_server, run_app, hangman_data
inst/app/www/          style.css, about_footer.html
inst/extdata/          pkgdata.csv
app.R                  loads the package and calls run_app(), for shinyapps.io
quarto/                source for the docs site
docs/                  the rendered site
```

To rebuild the site, run `quarto render` from `quarto/`.

## Credits

Data from TidyTuesday 2023 week 38, derived from the
[CRAN Collaboration Graph](https://github.com/schochastics/CRAN_collaboration).
App by Matias Andina, MIT licensed. See `inst/app/www/about_footer.html` for
background and support links.
