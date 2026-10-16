# Guessing Game

The app thinks of a secret whole number from 1 to 100. Use the **-10**, **-1**, **+1** and **+10** buttons to pick a guess, then click **Guess**. The app tells you if you are right, and it counts how many guesses you have made.

That's all it does for now. It does not tell you if your guess is too high or too low. You will teach it to do that soon.

## How to run the game

1. Open the game's folder and double-click **GuessingGame.xcodeproj**. Xcode opens.
2. At the top of the Xcode window, find the menu that names a device. Make sure it says **My Mac**.
3. Press **Command-R**, or click the triangle-shaped **Run** button.

The first run takes a minute while Xcode builds the app. After that, the game opens in its own window on your Mac and you can play.

To read the code, click **GuessingGameView.swift** in the list of files on the left. Most of the game lives in that one file.

## Three things to try

Look for comments that start with `// TRY:`. They mark safe places to experiment. Here are three to start with.

1. **Change the range.** Find `let highestNumber: Int = 100` near the top of the file. Change 100 to 10, and run the game again. Is it easier? Now try 1000.
2. **Change the colour.** Find `.tint(Color.indigo)` near the end of the screen code. Change `indigo` to `teal`, `pink` or `orange`. What changes on the screen, and what does not?
3. **Change what the game says.** Find the message `"\(guess) is not my number. Try again."` and write your own. Keep the `\(guess)` part and see what it does.

If something stops working, don't panic. Press **Command-Z** to undo, or ask a classmate or me. Every programmer breaks things. It's how we learn.

## Credits

I wrote this starter game for my ICS3U course at Lakefield College School.

When you make the game your own, add to this list. Name any AI tool you used and what you used it for. Name any code, images or sounds that came from somewhere else, and say where they came from.

- Starter game: Mr. Gordon, ICS3U
