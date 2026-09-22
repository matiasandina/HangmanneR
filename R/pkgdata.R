# Cache for the CRAN snapshot so the CSV is parsed once per session rather
# than once per Shiny session.
pkgdata_cache <- new.env(parent = emptyenv())

#' CRAN package data used by the game
#'
#' Reads the CRAN snapshot that ships with the package and adds a `n_char`
#' column with the length of each package name, which is what the difficulty
#' setting filters on. The result is cached for the rest of the R session.
#'
#' @return A data frame with columns `Package`, `Author`, `Description` and
#'   `n_char`.
#' @export
#' @examples
#' head(hangman_data()[, c("Package", "n_char")])
hangman_data <- function() {
  if (is.null(pkgdata_cache$pkgdata)) {
    path <- system.file("extdata", "pkgdata.csv", package = "HangmanneR")
    pkgdata <- read.csv(path, stringsAsFactors = FALSE)
    pkgdata$n_char <- nchar(pkgdata$Package)
    pkgdata_cache$pkgdata <- pkgdata
  }
  pkgdata_cache$pkgdata
}
