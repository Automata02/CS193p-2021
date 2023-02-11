//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by roberts.kursitis on 10/02/2023.
//

import SwiftUI

@main
struct EmojiArtApp: App {
	let document = EmojiArtDocument()
	
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
