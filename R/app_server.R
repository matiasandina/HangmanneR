#' Server logic for the HangmanneR app
#'
#' @param input,output,session Objects supplied by Shiny.
#' @return Called for its side effects on `output`.
#' @export
app_server <- function(input, output, session) {
  pkgdata <- hangman_data()
  max_nchar <- max(pkgdata$n_char)
  reactive_pkgdata <- reactive({
    data <- pkgdata
    if (input$positFilter) {
      data <- dplyr::filter(data, stringr::str_detect(Author, "Posit Software, PBC"))
    }
    
    # Define difficulty levels with appropriate character length ranges
    difficulty_mapping <- list(
      Easy = 2:7, 
      Normal = 8:15, 
      Hard = 16:max_nchar 
    )
    selected_difficulty <- difficulty_mapping[[input$difficulty]]
    
    data <- dplyr::filter(data, dplyr::between(n_char,
                                              min(selected_difficulty),
                                              max(selected_difficulty)))
    data
  })  
  # Initialize game state
  game_state <- reactiveValues(
    selected_package = NULL,
    selected_author = NULL,
    selected_desc = NULL,
    guessed_letters = character(0),
    remaining_attempts = 6,
    current_display = "",
    feedback = "Welcome to HangmanneR! Guess a letter of the CRAN package."
  )
  
  # Function to initialize or reinitialize game state
  initializeGameState <- function() {
    sampled_data <- reactive_pkgdata()
    if (nrow(sampled_data) == 0) {
      game_state$feedback <- "No packages for this difficulty level. Try playing all CRAN packages."
      return()
    }
    sampled_idx <- sample(1:nrow(sampled_data), size = 1)
    game_state$selected_package <- sampled_data$Package[sampled_idx]
    game_state$selected_author <- sampled_data$Author[sampled_idx]
    game_state$selected_desc <- sampled_data$Description[sampled_idx]
    game_state$guessed_letters <- character(0)
    game_state$remaining_attempts <- 6
    game_state$current_display <- ""
    game_state$feedback <- "Welcome to HangmanneR! Guess a letter of the CRAN package."
    # Add a reactive value to track hint button press
    game_state$hint_requested <- FALSE
  }
  
  # Function to process guess
  processGuess <- function(guessed_letter) {
    # Check if the guessed letter is a permissible character (letter, number, or dot)
    if(!grepl("[A-Za-z0-9.]", guessed_letter)) {
      game_state$feedback <- "Please guess a letter, number, or dot."
      return()
    }
    
    if(!(guessed_letter %in% game_state$guessed_letters)) {
      game_state$guessed_letters <- c(game_state$guessed_letters, guessed_letter)
      
      # we need to do tolower() on the selected package
      # we cannot use ignore.case, since we need fixed = TRUE for the '.'
      if(grepl(guessed_letter, tolower(game_state$selected_package), 
               # . should be guessed as '.' not 'anything'
               fixed = TRUE)) {
        game_state$feedback <- "Great guess!"
      } else {
        game_state$remaining_attempts <- game_state$remaining_attempts - 1
        game_state$feedback <- "Not quite, keep trying!"
      }
    }
    
    updateTextInput(session, "letterInput", value = "")
  }
  
  # Reinitialize the game when difficulty or Posit filter changes
  observeEvent(c(input$positFilter, input$difficulty), {
    initializeGameState()
  }, ignoreNULL = FALSE)
  
  # Update the display of the word
  output$wordDisplay <- renderText({
    word <- gsub("[^ ]", "_ ", game_state$selected_package)
    if(length(game_state$guessed_letters) > 0) {
      pattern <- paste0("[^", paste(game_state$guessed_letters, collapse = ""), " ]")
      word <- gsub(pattern, "_ ", game_state$selected_package)
    }
    game_state$current_display <- gsub(" ", "", word)
    word
  })
  
  # Display remaining attempts
  output$attempts <- renderText({
    paste(rep("\u2764", game_state$remaining_attempts), collapse = " ")
  })
  
  # Display feedback
  output$feedback <- renderText({
    game_state$feedback
  })
  
  output$hintDisplay <- renderUI({
    if (isTRUE(game_state$hint_requested)) {
      desc <- game_state$selected_desc
      pkg_name <- game_state$selected_package
      
      if (nchar(pkg_name) > 0) {
        # Replace package name with block characters
        safe_desc <- gsub(pkg_name, strrep("\u2588", nchar(pkg_name)), desc, ignore.case = TRUE)
      } else {
        safe_desc <- desc
      }
      safe_desc <-gsub("\n",replacement = "", safe_desc)
      HTML(safe_desc)
    }
  })
  
  # Process Hint Button
  observeEvent(input$hintButton, {
    game_state$hint_requested <- TRUE
  })
  
  
  # Process guesses
  observeEvent(input$guessButton, {
    req(input$letterInput)
    processGuess(tolower(input$letterInput))
  })
  
  observeEvent(input$letterInput, {
    if(nchar(input$letterInput) > 0) {
      processGuess(tolower(input$letterInput))
    }
  }, ignoreInit = TRUE)
  
  # Check for win or loss based on the display string
  observe({
    if(game_state$current_display == game_state$selected_package) {  # Player wins
      cran_url <- paste0("https://cran.r-project.org/web/packages/", game_state$selected_package, "/index.html")
      win_message <- paste("Congratulations! You guessed <a href='", cran_url, "'>", game_state$selected_package, "</a> correctly!")
      output$result <- renderUI({ HTML(win_message) })
      
      # Trigger confetti celebration
      session$sendCustomMessage(type = "confetti", message = "start")
      # Display hint
      game_state$hint_requested <- TRUE
    } else if(game_state$remaining_attempts <= 0) {  # Player loses
      cran_url <- paste0("https://cran.r-project.org/web/packages/", game_state$selected_package, "/index.html")
      lose_message <- paste("Game Over! The package was: <a href='", cran_url, "'>", game_state$selected_package, "</a>")
      output$result <- renderUI({ HTML(lose_message) })
      game_state$hint_requested <- TRUE
    }
  })
  # Reset the game when 'Play Again' is pressed
  observeEvent(input$playagainButton, {
    initializeGameState()
    output$result <- renderUI({})  # Clear the result message
  })
  
  observeEvent(input$keys, {
    print("pressing enter")
  })
  
  
  # All characters to display
  all_chars <- c(letters, 0:9, ".")
  
  output$characterDisplay <- renderUI({
    used_chars <- game_state$guessed_letters
    displayed_chars <- lapply(all_chars, function(char) {
      class <- if (char %in% used_chars) "guessed" else ""
      tags$span(class = class, toupper(char), " ")
    })
    do.call(tags$div, displayed_chars)
  })
  
}
