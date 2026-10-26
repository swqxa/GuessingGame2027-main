# Guessing Game

## Description

Guess the secret whole number before you use all seven attempts. At the start of a round, choose a difficulty:

- **Easy:** 1–10
- **Medium:** 1–100
- **Hard:** 1–1,000

The game starts with a guess at the middle of the selected range. Use **−10**, **−1**, **+1**, and **+10** to choose a number, then click **Guess**. The game responds with a hot, warm, or cold message and a matching colour and symbol. The distance thresholds change with the difficulty: Easy uses 1/2, Medium 5/15, and Hard 50/150 for hot/warm.

You can request up to three hints in a round. Each hint tells you whether the secret number is above, below, or exactly at the range midpoint (5, 50, or 500), and each hint uses one attempt. When two or fewer attempts remain, the counter turns red and its warning icon pulses. The game keeps a separate best score for each difficulty while the app is open; scores reset when the app closes. Changing difficulty or selecting **Play Again** starts a new round.

## How to run the game

1. Open GuessingGame.xcodeproj in Xcode.
2. Select **My Mac** as the run destination.
3. Press **Command-R** or click the **Run** button.

The main game code is in GuessingGame/GuessingGameView.swift.

## How it works

- **let** defines values that do not change during play, such as lowestNumber, maximumGuesses, and maximumHints. **var** is used for values or computed properties that can change or depend on the selected difficulty.
- GameDifficulty is an enum with easy, medium, and hard cases. Its highestNumber, hotDistance, and warmDistance properties return the range and hint thresholds for the selected level.
- **@State** stores values that change as the player plays, including difficulty, secretNumber, guess, guessCount, hintCount, and the three best scores. SwiftUI redraws the screen when those values change. The best scores are kept in memory for the current app session, so they reset after the app closes.
- bestScore selects the score for the current level. hintMidpoint calculates the middle of that level's range. guessesLeft subtracts the number of used guesses from the limit.
- checkGuess() uses **if** and **else if** to compare the guess with the secret number and choose the hot, warm, or cold response. giveHint() uses **if**, **else if**, and **else** to report whether the secret number is above, below, or equal to the midpoint.
- The **<=** operator checks whether a distance is within a hot or warm threshold. The **&&** operator in lowGuesses requires both conditions to be true: two or fewer guesses remain **and** the game is still active. This prevents the warning from showing after the round ends. The hint button uses **||** so it is disabled if the round is over or all hints have been used.
- distance(from:to:) -> Int takes the guess and secret number as parameters and returns the distance between them. Keeping that calculation in one function lets checkGuess() use the same result to choose its feedback. saveBestScore(_:) takes a score as a parameter and stores it for the selected level.
- startNewGame() chooses a new random number from the selected range, resets the guess and counters, and restores the starting message. The four guess-adjustment functions keep the selected guess within that range.

## Testing

For repeatable checks, temporarily replace **both** random-number assignments for secretNumber in GuessingGameView.swift—the initial value and the assignment in startNewGame()—with the fixed number listed for that check. Use a number inside the selected level's range. Restore both random assignments after testing.

| Check | Fixed number and steps | Expected result |
|---|---|---|
| Difficulty ranges | Select Easy, Medium, then Hard. | The picker shows 1–10, 1–100, and 1–1,000. Each level starts a new round with the guess at its midpoint. |
| Midpoint hint | Test Easy with 6, Medium with 42, and Hard with 500. Use a hint at each level. | The messages say above 5, below 50, and exactly 500. Each hint uses one attempt. After three hints the button is disabled. |
| Hot/warm/cold boundaries | Easy: secret 5, guess 4/3/2. Medium: secret 42, guess 37/27/26. Hard: secret 500, guess 450/350/349. Start a fresh round between guesses. | Easy distances 1/2/3, Medium 5/15/16, and Hard 50/150/151 produce hot/warm/cold feedback respectively. |
| Low attempts and final loss | Medium: secret 42. Make five incorrect guesses, then a sixth, then a seventh. | At five guesses used, the counter shows 2 left in red with a pulsing warning. At six guesses it shows 1 left. The seventh incorrect guess ends the game and reveals 42. |
| Win on the last attempt | Medium: secret 42. Make six incorrect guesses, then guess 42. | The seventh attempt wins the game and updates the Medium best score if it is a new record. |
| Best scores by level | Win once on each difficulty, then switch between levels while the app remains open. Close and reopen the app. | Each level displays its own score during the session. After reopening, the scores reset. |

## Credits

Starter game: Mr. Gordon, ICS3U at Lakefield College School.

I used ChatGPT (an AI tool) to help adapt and structure the information in this README.
