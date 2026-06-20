 # HangmanneR

HangmanneR is a Shiny-powered spin on the classic hangman game that challenges you to guess CRAN package names. The app was originally built for the [TidyTuesday](https://github.com/rfordatascience/tidytuesday) challenge (2023, Week 38) using data derived from the CRAN Collaboration Graph, and it doubles as a playful way to explore new R packages.

> Currently working on demo and R package bundle


## Features

- **Playful package discovery** – Guess letters to reveal real CRAN package names sourced from the bundled dataset.
- **Difficulty levels** – Choose between Easy, Normal, and Hard modes to filter package names by character length. This keeps quick rounds approachable and longer names challenging.
- **Posit-authored filter** – Toggle the option to restrict the game to packages authored by Posit Software, PBC.
- **Helpful hints** – Reveal the package description at any time (with the package name redacted) to keep the game moving.
- **Celebratory finish** – Win a round to trigger an animated confetti burst along with a link to the package’s CRAN page.

## Getting Started

You can play HangmanneR online at <https://matias-andina.shinyapps.io/HangmanneR/>. 

> If the link is broken, it's possible the app is sleeping. You can file issues or run locally (see below!)

To run it locally:

1. Install the required packages if you don’t already have them:
   ```r
   install.packages(c("shiny", "dplyr", "keys", "fontawesome"))
   ```
2. Clone this repository and open the project in R (or set the working directory to the repo root).
3. Launch the app:
   ```r
   shiny::runApp()
   ```

The app reads the bundled `pkgdata.csv` file at startup, so no external downloads are required.

## Gameplay Tips

- Start typing a letter to submit a guess automatically, or click **Guess Letter** to lock it in manually.
- Keep an eye on the hearts underneath the controls—they show how many incorrect guesses you have left.
- Stuck? Click **Hint** to reveal the package description. If you win or lose, the description appears automatically longside a link to the package on CRAN.
- Use the **Play Again** button anytime to start a fresh round with a new package.

## License and Credits

- Data: TidyTuesday (2023, Week 38) derived from the [CRAN Collaboration Graph](https://github.com/schochastics/CRAN_collaboration).
- App design and development: Matias Andina. See `about_footer.html` for more background and support links.

Enjoy the game, learn a new package, and share it with fellow R enthusiasts!
