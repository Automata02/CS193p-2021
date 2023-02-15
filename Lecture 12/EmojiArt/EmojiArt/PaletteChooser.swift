//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by roberts.kursitis on 15/02/2023.
//

import SwiftUI

struct PaletteChooser: View {
	var emojiFontSize: CGFloat = 40
	var emojiFont: Font { .system(size: emojiFontSize) }
	
	@EnvironmentObject var store: PaletteStore
	
	@State private var chosenPaletteIndex = 0
	@State private var isEditing = false
	@State private var isManaging = false
	
    var body: some View {
		HStack {
			paletteControlButton
			body(for: store.palette(at: chosenPaletteIndex))
		}
		.clipped()
    }
	
	@ViewBuilder
	var contextMenu: some View {
		AnimatedActionButton(title: "Edit", systemImage: "pencil") {
			isEditing = true
		}
		AnimatedActionButton(title: "New", systemImage: "plus") {
			store.insertPalette(named: "New", emojis: "", at: chosenPaletteIndex)
			isEditing = true
		}
		AnimatedActionButton(title: "Delete", systemImage: "minus.circle") {
			chosenPaletteIndex = store.removePalette(at: chosenPaletteIndex)
		}
		AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3") {
			isManaging = true
		}
		goToMenu
	}
	
	var goToMenu: some View {
		Menu {
			ForEach(store.palettes) { palette in
				AnimatedActionButton(title: palette.name) {
					if let index = store.palettes.firstIndex(where: { $0.id == palette.id }) {
						chosenPaletteIndex = index
					}
				}
			}
		} label: {
			Label("Go To", systemImage: "text.insert")
		}
	}
	
	var paletteControlButton: some View {
		Button {
			withAnimation {
				chosenPaletteIndex = (chosenPaletteIndex + 1) % store.palettes.count
			}
		} label: {
			Image(systemName: "paintpalette")
		}
		.font(emojiFont)
		.contextMenu { contextMenu }
	}
	
	var rollTransition: AnyTransition {
		AnyTransition.asymmetric(insertion: .offset(x: 0, y: emojiFontSize), removal: .offset(x: 0, y: -emojiFontSize))
	}
	
	func body(for palette: Palette) -> some View {
		HStack {
			Text(palette.name)
			ScrollingEmojisView(emojis: palette.emojis)
				.font(emojiFont)
		}
		.id(palette.id)
		.transition(rollTransition)
		.popover(isPresented: $isEditing) {
			PaletteEditor(palette: $store.palettes[chosenPaletteIndex])
		}
		.sheet(isPresented: $isManaging) {
			PaletteManager()
		}
	}
}

struct ScrollingEmojisView: View {
	let emojis: String
	
	var body: some View {
		ScrollView(.horizontal) {
			HStack {
				ForEach(emojis.removingDuplicateCharacters.map { String($0) }, id: \.self ) { emoji in
					Text(emoji)
						.onDrag { NSItemProvider(object: emoji as NSString) }
				}
			}
		}
	}
}
