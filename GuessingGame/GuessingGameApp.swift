//
//  GuessingGameApp.swift
//  GuessingGame
//
//  This file starts the app and shows the game screen.
//  You do not need to change anything here.
//

import SwiftUI

@main
struct GuessingGameApp: App {

    // MARK: - Computed properties

    var body: some Scene {
        WindowGroup {
            GuessingGameView()
        }
        // Open the window at the size the game asks for.
        .windowResizability(.contentSize)
    }
}
