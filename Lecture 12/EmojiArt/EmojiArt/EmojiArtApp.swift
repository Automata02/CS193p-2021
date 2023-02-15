//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by roberts.kursitis on 10/02/2023.
//

import SwiftUI

@main
struct EmojiArtApp: App {
	@StateObject var document = EmojiArtDocument()
	@StateObject var paletteStore = PaletteStore(named: "Default palette store")
	
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
				.environmentObject(paletteStore)
        }
    }
}
