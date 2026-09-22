#' User interface for the HangmanneR app
#'
#' @return A [shiny::fluidPage()] with the game, settings and about tabs.
#' @export
app_ui <- function() fluidPage(
  keys::useKeys(),
  keys::keysInput("keys", c("enter")),
  includeCSS(system.file("app/www/style.css", package = "HangmanneR")),
  tags$head(
    # make links external
    tags$script(HTML("
            $(document).ready(function() {
                $('a').each(function() {
                    var href = $(this).attr('href');
                    if (href && (href.startsWith('http://') || href.startsWith('https://'))) {
                        $(this).attr('target', '_blank');
                    }
                });
            });
        ")),
    tags$script(src = "https://cdn.jsdelivr.net/npm/canvas-confetti@1.4.0/dist/confetti.browser.min.js"),
    tags$script(HTML("
        Shiny.addCustomMessageHandler('confetti', function(message) {
            confetti();
        });
    ")),
    tags$script(HTML("
  $(document).ready(function() {
    $('#guessButton').click(function() {
      setTimeout(function() {
        $('#letterInput').focus();
      }, 100); // Set focus back to the input field after a short delay
    });

    $('#letterInput').on('keydown', function(e) {
      if(e.keyCode == 13 && $(this).val() != '') {
        $('#guessButton').click();
        e.preventDefault(); // Prevent the default action
      }
    });
  });
")),
    tags$link(rel = "stylesheet", type = "text/css", href = "www/style.css")
  ),
  navbarPage("HangmanneR",
             tabPanel("Game",
                      fluidRow(
                        column(12, align="center",
                               textOutput("feedback"),
                               textOutput("wordDisplay"),
                               textInput("letterInput", NULL, placeholder = "Enter a letter"),
                               actionButton("guessButton", "Guess Letter"),
                               actionButton("hintButton", "Hint"),
                               actionButton('playagainButton', "Play Again"),
                               textOutput("attempts"),
                               uiOutput("characterDisplay"),
                               uiOutput("result"),
                               uiOutput("hintDisplay")
                        )
                      )
             ),
             tabPanel("Settings",
                      div(class = "settings-container",
                          fluidRow(
                            column(8, offset = 2,
                                   div(class = "settings-section",
                                       h4("Choose Difficulty"),
                                       div(class = "custom-radio",
                                           radioButtons("difficulty", "Difficulty",
                                                        choices = c("Easy", "Normal", "Hard"),
                                                        selected = "Normal",
                                                        inline = FALSE)
                                       ),
                                       hr(),
                                       h4("Additional Options"),
                                       div(class = "custom-checkbox",
                                           checkboxInput("positFilter", "Play only with Posit Authored Packages")
                                       )
                                   )
                            )
                          )
                      )
             ),
             tabPanel("About",
                      fluidRow(align="center",
                        column(6, offset = 3,
                               div(class = "about-content",
                                   includeHTML(system.file("app/www/about_footer.html", package = "HangmanneR"))
                               )
                        )
                      )
             )
            ),
  tags$footer(
    div(class = "footer-content", 
        p("Share the game:"),
        a(href = "https://twitter.com/intent/tweet?text=Check%20out%20this%20cool%20Shiny%20App&url=https://matias-andina.shinyapps.io/HangmanneR/",
          fontawesome::fa("twitter"), 
          title = "Share on Twitter"
        ),
        a(href = "https://www.facebook.com/sharer/sharer.php?u=https://matias-andina.shinyapps.io/HangmanneR/",
          fontawesome::fa("facebook"), 
          title = "Share on Facebook"
        ),
        a(href = "https://www.linkedin.com/shareArticle?mini=true&url=https://matias-andina.shinyapps.io/HangmanneR/",
          fontawesome::fa("linkedin"),
          title = "Share on LinkedIn"
        ),
        a(href = "https://reddit.com/submit?url=https://matias-andina.shinyapps.io/HangmanneR/&title=Check%20out%20this%20cool%20Shiny%20App",
          fontawesome::fa("reddit"), 
          title = "Share on Reddit"
        ),
        p(a(href = "https://www.buymeacoffee.com/matiasandina", "Buy me a coffee"))
        )
  )
)
