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
- distance(from:to:) -> Int takes the guess and secret number as parameters and returns the distance between them. I used a function with parameters instead of repeating the subtraction in the hot, warm, and cold checks. One function can calculate the distance for any guess and secret number, and checkGuess() can use that one result for its decisions. saveBestScore(_:) takes a score as a parameter and stores it for the selected level.
- startNewGame() chooses a new random number from the selected range, resets the guess and counters, and restores the starting message. The four guess-adjustment functions keep the selected guess within that range.

## Testing

For repeatable checks, I temporarily used Easy = 6, Medium = 42, and Hard = 500. I marked the initial secret and the fixed values in `startNewGame()` with `// FOR TESTING ONLY`. After testing, I restored both random-number assignments.

| Test | Chosen input | Should happen | Did happen |
|---|---|---|---|
| Difficulty ranges | Fixed secrets: Easy 6, Medium 42, Hard 500. Select each level. | The picker shows 1–10, 1–100, and 1–1,000; the starting guess is 5, 50, and 500. Changing levels starts a new round. | Passed — all three ranges and midpoint guesses appeared, and the round reset when the level changed. |
| Midpoint hint | Easy secret 6; Medium 42; Hard 500. Request one hint on each level, then use three hints in one round. | The messages say above 5, below 50, and exactly 500. Each hint uses one attempt; after three, the hint button is disabled. | Passed — all three messages appeared; the counter dropped by one per hint, and the button disabled after the third. |
| Hot, warm, and cold boundaries | Easy secret 6: guess 5/4/3. Medium secret 42: 37/27/26. Hard secret 500: 450/350/349. Start a new round between guesses. | The distances at each level's hot and warm limits show hot/warm; one farther shows cold. | Passed — each level showed hot, warm, and cold at the stated distances. |
| Low attempts and final loss | Medium secret 42. Make seven wrong guesses, checking after guesses 4, 5, 6, and 7. | At 3 left the counter is grey; at 2 and 1 left it is red with a warning icon; the seventh wrong guess ends the game and reveals 42. | Passed — 3 left stayed grey; 2 and 1 left were red; the last guess revealed 42 and turned the warning off. |
| Win on the last attempt | Medium secret 42. Make six wrong guesses, then guess 42. | The seventh guess wins; the best score updates only if this beats the current record. | Passed — the seventh guess won and showed “Yes! My number is 42.” because the existing record was already 1. |
| Best scores by level | Win in one guess on Easy (6), Medium (42), and Hard (500); switch levels; stop and restart the app. | Each level shows its own score. Scores reset after the app closes. | Passed — each level showed its own one-guess record; after restart no score was displayed. |
| Just past hot on Medium (edge) | Medium secret fixed at 42. Guess 48 (distance 6). | “48 is warmer (coming closer)” | Passed — the game showed “48 is warmer (coming closer)”. |
| A win that is not a record | Medium secret 42. Win in 1 guess, click Play Again, make one wrong guess, then win in 2. | The second win says “Yes!” and leaves the 1-guess record unchanged. | Passed — the first win showed “New record!”; the second showed “Yes! My number is 42.” and kept the record at 1. |
| Three guesses left (edge) | Medium secret fixed at 42. Make four wrong guesses. | The counter shows 3 of 7 in grey without the warning icon. | Passed — the counter showed 3 of 7 in grey with the normal list icon. |
## Credits

Starter game: Mr. Gordon, ICS3U at Lakefield College School.

I used ChatGPT (an AI tool) to help adapt and structure the information in this README.
