#' @keywords internal
"_PACKAGE"

#' @import shiny
#' @importFrom dplyr %>% between filter
#' @importFrom stringr str_detect
#' @importFrom utils read.csv
NULL

# Columns referenced inside dplyr verbs.
utils::globalVariables(c("Author", "n_char"))
