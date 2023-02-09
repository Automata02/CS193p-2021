//
//  MemorizeApp.swift
//  Memorize
//
//  Created by roberts.kursitis on 30/01/2023.
//

import SwiftUI

@main
struct MemorizeApp: App {
	//can be a constant because it's just a pointer
	private let game = EmojiMemoryGame()
	
    var body: some Scene {
        WindowGroup {
			EmojiMemoryGameView(game: game)
        }
    }
}
