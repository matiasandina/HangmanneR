#' Run the HangmanneR game
#'
#' Starts the Shiny app. Anything passed through `...` goes to
#' [shiny::shinyApp()], so the usual options such as `options = list(port =
#' 1234)` still work.
#'
#' @param ... Passed to [shiny::shinyApp()].
#' @return A Shiny app object, which starts the app when printed.
#' @export
#' @examples
#' if (interactive()) {
#'   run_app()
#' }
run_app <- function(...) {
  addResourcePath("www", system.file("app/www", package = "HangmanneR"))
  shinyApp(ui = app_ui(), server = app_server, ...)
}
