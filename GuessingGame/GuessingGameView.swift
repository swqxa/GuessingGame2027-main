//
//  GuessingGameView.swift
//  GuessingGame
//
//  Choose Easy (1–10), Medium (1–100), or Hard (1–1000).
//  The game changes its number range and hot/warm distances by level.
//  Each difficulty keeps its own best score while the app is open.
//  The attempt counter warns the player when only two guesses remain.
//

import SwiftUI

// The game's settings. They sit up here, outside the game,
// so that every part of the game below can use them.
let lowestNumber: Int = 1
let maximumGuesses: Int = 7
let maximumHints: Int = 3

enum GameDifficulty: String, CaseIterable, Identifiable {
    case easy
    case medium
    case hard

    var id: Self { self }

    var title: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }

    var highestNumber: Int {
        switch self {
        case .easy: return 10
        case .medium: return 100
        case .hard: return 1000
        }
    }

    var hotDistance: Int {
        switch self {
        case .easy: return 1
        case .medium: return 5
        case .hard: return 50
        }
    }

    var warmDistance: Int {
        switch self {
        case .easy: return 2
        case .medium: return 15
        case .hard: return 150
        }
    }
}

// The game itself: what it remembers, what it shows on the screen,
// and what it does when you click a button.
// Remembers the lowest guess count to win
struct GuessingGameView: View {
    
    // MARK: - Stored properties
    
    // Each @State variable is something the game remembers.
    // When one of them changes, the screen updates by itself.
    
    // The selected difficulty controls the number range and hint distances.
    @State var difficulty: GameDifficulty = .medium

    // The secret number is randomly selected from the chosen range.
    @State var secretNumber: Int = Int.random(in: lowestNumber...GameDifficulty.medium.highestNumber)
    
    // The guess the player is about to make. It starts in the middle.
    @State var guess: Int = 50
    
    // How many guesses and hints the player has used in this game.
    @State var guessCount: Int = 0
    @State var hintCount: Int = 0

    // Keep a separate best score for each difficulty during this app session.
    @State private var bestEasyScore: Int = 0
    @State private var bestMediumScore: Int = 0
    @State private var bestHardScore: Int = 0

    // The best score for the currently selected difficulty.
    var bestScore: Int {
        switch difficulty {
        case .easy: return bestEasyScore
        case .medium: return bestMediumScore
        case .hard: return bestHardScore
        }
    }
    
    // The message shown to the player, with a symbol and a colour to match it.
    @State var message: String = "I'm thinking of a number from 1 to 100."
    @State var messageSymbol: String = "questionmark.circle.fill"
    @State var messageColor: Color = Color.indigo
    
    // Becomes true when the player finds the secret number.
    @State var gameIsOver: Bool = false
    
    // MARK: - Computed properties

    // The midpoint of the selected range, used for hints and the starting guess.
    var hintMidpoint: Int {
        (lowestNumber + difficulty.highestNumber) / 2
    }

    // The number of guesses the player can still make.
    var guessesLeft: Int {
        max(0, maximumGuesses - guessCount)
    }

    // True while two or fewer guesses remain and the game is still active.
    var lowGuesses: Bool {
        guessesLeft <= 2 && !gameIsOver
    }
    
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

            Picker("Difficulty", selection: $difficulty) {
                ForEach(GameDifficulty.allCases) { level in
                    Text("\(level.title) (1–\(level.highestNumber))")
                        .tag(level)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: difficulty) { _, _ in
                startNewGame()
            }
            
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

            Button("Hint: above or below \(hintMidpoint)", systemImage: "lightbulb.fill") {
                giveHint()
            }
            .buttonStyle(.bordered)
            .tint(.purple)
            .disabled(gameIsOver || hintCount >= maximumHints)
            
            VStack(spacing: 4) {
                HStack {
                    Image(systemName: lowGuesses ? "exclamationmark.triangle.fill" : "list.number")
                        .scaleEffect(lowGuesses ? 1.15 : 1.0)
                        .animation(
                            lowGuesses
                                ? .easeInOut(duration: 0.6).repeatForever(autoreverses: true)
                                : .default,
                            value: lowGuesses
                        )
                    Text("Guesses left: \(guessesLeft) of \(maximumGuesses)")
                }
                .foregroundStyle(lowGuesses ? Color.red : Color.secondary)
                
                if bestScore > 0 {
                    HStack {
                        Image(systemName: "trophy.fill")
                        Text("Best Score (\(difficulty.title)): \(bestScore) guesses")
                    }
                    .foregroundStyle(Color.orange)
                }
            }
            .font(.headline)
            .foregroundStyle(Color.secondary)
        }
        .padding(32)
        .font(.title2)
        .fontDesign(.rounded)
        .controlSize(.large)
        .tint(Color.indigo)
        .frame(minWidth: 420, minHeight: 640)
    }
    
    // MARK: - Functions

    // A midpoint hint costs one guess and can be used at most three times.
    func giveHint() {
        guessCount += 1
        hintCount += 1

        if secretNumber > hintMidpoint {
            message = "My number is above \(hintMidpoint)."
        } else if secretNumber < hintMidpoint {
            message = "My number is below \(hintMidpoint)."
        } else {
            message = "My number is exactly \(hintMidpoint)."
        }

        messageSymbol = "lightbulb.max.fill"
        messageColor = Color.purple

        if guessCount >= maximumGuesses {
            message = "Out of guesses! My number was \(secretNumber)."
            messageSymbol = "xmark.octagon.fill"
            messageColor = Color.gray
            gameIsOver = true
        }
    }

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
            messageSymbol = "star.circle.fill"
            messageColor = Color.green
            gameIsOver = true

            if bestScore == 0 || guessCount < bestScore {
                saveBestScore(guessCount)
                message = "New record! You found \(secretNumber) in \(guessCount) guesses."
            } else {
                message = "Yes! My number is \(secretNumber)."
            }
        } else {
            // Calculate distance using our helper function
            let howFarAway: Int = distance(from: guess, to: secretNumber)
            
            if howFarAway <= difficulty.hotDistance {
                message = "\(guess) is hot! (very close)"
                messageSymbol = "flame.fill"
                messageColor = Color.red
            } else if howFarAway <= difficulty.warmDistance {
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
            message = "Out of guesses! My number was \(secretNumber)."
            messageSymbol = "xmark.octagon.fill"
            messageColor = Color.gray
            gameIsOver = true
        }
    }

    // Saves the score for the currently selected difficulty.
    func saveBestScore(_ score: Int) {
        switch difficulty {
        case .easy: bestEasyScore = score
        case .medium: bestMediumScore = score
        case .hard: bestHardScore = score
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
        if guess > difficulty.highestNumber {
            guess = difficulty.highestNumber
        }
    }
    
    // Makes the guess 10 bigger, but never bigger than the highest number.
    func raiseGuessByTen() {
        guess += 10
        if guess > difficulty.highestNumber {
            guess = difficulty.highestNumber
        }
    }
    
    // Picks a new secret number and resets everything else.
    func startNewGame() {
        secretNumber = Int.random(in: lowestNumber...difficulty.highestNumber)
        guess = hintMidpoint
        guessCount = 0
        hintCount = 0
        message = "I'm thinking of a new number from \(lowestNumber) to \(difficulty.highestNumber)."
        messageSymbol = "questionmark.circle.fill"
        messageColor = Color.indigo
        gameIsOver = false
    }
}

#Preview {
    GuessingGameView()
}

