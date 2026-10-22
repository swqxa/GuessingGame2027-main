//
//  GuessingGameView.swift
//  GuessingGame
//
//  WHAT THIS GAME DOES NOW
//  The app picks a secret whole number from 1 to 100.
//  You choose a guess with the buttons and click Guess.
//  The app tells you if your guess is right or not right,
//  and it counts your guesses. When you find the number,
//  you can play again.
//
//  WHAT IT DOES NOT DO YET
//  It does not tell you if your guess is too high or too low.
//  That part is up to you.
//

import SwiftUI

// The game's settings. They sit up here, outside the game,
// so that every part of the game below can use them.
// TRY: Change highestNumber to 10 for an easy game, or to 1000 for a hard one.
let lowestNumber: Int = 1
let highestNumber: Int = 100

let maximumGuesses: Int = 7

// The game itself: what it remembers, what it shows on the screen,
// and what it does when you click a button.
struct GuessingGameView: View {

    // MARK: - Stored properties

    // Each @State variable is something the game remembers.
    // When one of them changes, the screen updates by itself.

    // The number the player is trying to find. The app picks it at random.
    @State var secretNumber: Int = Int.random(in: lowestNumber...highestNumber)

    // The guess the player is about to make. It starts in the middle.
    @State var guess: Int = (lowestNumber + highestNumber) / 2

    // How many guesses the player has made in this game.
    @State var guessCount: Int = 0

    // The message shown to the player, with a symbol and a colour to match it.
    @State var message: String = "I'm thinking of a number from \(lowestNumber) to \(highestNumber)."
    @State var messageSymbol: String = "questionmark.circle.fill"
    @State var messageColor: Color = Color.indigo

    // Becomes true when the player finds the secret number.
    @State var gameIsOver: Bool = false

    // MARK: - Computed properties

    var body: some View {
        VStack(spacing: 20) {

            // The title at the top of the screen.
            HStack {
                Image(systemName: "text.book.closed")
                Text("Guessing Game")
            }
            .font(.largeTitle)
            .bold()
            .foregroundStyle(Color.indigo)
            // Shrink the title a little if it does not fit on one line.
            .lineLimit(1)
            .minimumScaleFactor(0.5)

            Spacer()

            // The message card: what the game has to say to you.
            VStack(spacing: 12) {
                Image(systemName: messageSymbol)
                    .font(.system(size: 60))
                    .foregroundStyle(messageColor)
                Text(message)
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 180)
            .background(messageColor.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 24))

            Spacer()

            // The guess you are about to make, shown nice and big.
            // TRY: Change the size of this number from 96 to something else.
            Text("\(guess)")
                .font(.system(size: 96, weight: .bold))
                .monospacedDigit()

            // Four buttons to change the guess.
            // The code inside the braces runs when that button is clicked.
            HStack(spacing: 8) {
                Button("-10") {
                    lowerGuessByTen()
                }
                Button("-1") {
                    lowerGuessByOne()
                }
                Button("+1") {
                    raiseGuessByOne()
                }
                Button("+10") {
                    raiseGuessByTen()
                }
            }
            .buttonStyle(.bordered)
            .font(.title3)
            .bold()
            .monospacedDigit()
            .disabled(gameIsOver)

            // Show the Guess button while the game is on,
            // and the Play Again button once the number is found.
            if gameIsOver {
                Button("Play Again", systemImage: "arrow.clockwise") {
                    startNewGame()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.green)
            } else {
                Button("Guess", systemImage: "hand.tap.fill") {
                    checkGuess()
                }
                .buttonStyle(.borderedProminent)
            }

            HStack {
                Image(systemName: "list.number")
                Text("Guesses so far: \(guessCount) of \(maximumGuesses)")
            }
            .font(.headline)
            .foregroundStyle(Color.secondary)
        }
        .padding(32)
        .font(.title2)
        .fontDesign(.rounded)
        .controlSize(.large)
        // TRY: Change indigo to another colour, such as teal, pink or orange.
        .tint(Color.indigo)
        // How big the game's window is on the Mac. It can be made taller or wider.
        .frame(minWidth: 420, minHeight: 640)
    }

    // MARK: - Functions
    // Calculates the distance between the current guess and the secret number
    func distance(from currentGuess: Int, to targetSecret: Int) -> Int {
        if currentGuess > targetSecret {
            return currentGuess - targetSecret
        } else {
            return targetSecret - currentGuess
        }
    }
    // Checks the player's guess against the secret number.
    func checkGuess() {
        guessCount += 1

        if guess == secretNumber {
            message = "Yes! \(secretNumber) is my number."
            messageSymbol = "star.circle.fill"
            messageColor = Color.green
            gameIsOver = true
        } else {
            // Calculate distance using our helper function
            let howFarAway: Int = distance(from: guess, to: secretNumber)
            
            if howFarAway <= 5 {
                message = "\(guess) is hot! (very close)"
                messageSymbol = "flame.fill"
                messageColor = Color.red
            } else if howFarAway <= 15 {
                message = "\(guess) is warmer (coming closer)"
                messageSymbol = "thermometer.medium"
                messageColor = Color.orange
            } else {
                message = "\(guess) is cold (far away)"
                messageSymbol = "snowflake"
                messageColor = Color.blue
            }
        }
        
        if guess != secretNumber && guessCount >= maximumGuesses {
            message = "out of guesses! my number was \(secretNumber)."
            messageSymbol = "xmark.octagon.fill"
            messageColor = Color.gray
            gameIsOver = true
        }
    }
    

    // Makes the guess 10 smaller, but never smaller than the lowest number.
    func lowerGuessByTen() {
        guess -= 10
        if guess < lowestNumber {
            guess = lowestNumber
        }
    }

    // Makes the guess 1 smaller, but never smaller than the lowest number.
    func lowerGuessByOne() {
        guess -= 1
        if guess < lowestNumber {
            guess = lowestNumber
        }
    }

    // Makes the guess 1 bigger, but never bigger than the highest number.
    func raiseGuessByOne() {
        guess += 1
        if guess > highestNumber {
            guess = highestNumber
        }
    }

    // Makes the guess 10 bigger, but never bigger than the highest number.
    func raiseGuessByTen() {
        guess += 10
        if guess > highestNumber {
            guess = highestNumber
        }
    }

    // Picks a new secret number and resets everything else.
    func startNewGame() {
        secretNumber = Int.random(in: lowestNumber...highestNumber)
        guess = (lowestNumber + highestNumber) / 2
        guessCount = 0
        message = "I'm thinking of a new number from \(lowestNumber) to \(highestNumber)."
        messageSymbol = "questionmark.circle.fill"
        messageColor = Color.indigo
        gameIsOver = false
    }
}

#Preview {
    GuessingGameView()
}
