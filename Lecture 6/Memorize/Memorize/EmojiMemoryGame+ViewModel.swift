//
//  EmojiMemoryGame+ViewModel.swift
//  Memorize
//
//  Created by roberts.kursitis on 31/01/2023.
//

import SwiftUI

#warning("TODO: Allow switching emojis with intent.")

class EmojiMemoryGame: ObservableObject {
	typealias Card = MemoryGame<String>.Card
	
	//MARK: Theme code
	init() {
		let theme = EmojiMemoryGame.themes.randomElement()!
		currentTheme = theme
		let color = theme.color
		selectedColor = color
	}
	
	struct Theme {
		var title: String
		var emojis: [String]
		var numberOfPairs: Int
		var color: Color
		
		init(title: String, emojis: [String], numberOfPairs: Int, color: Color) {
			self.title = title
			self.emojis = emojis
			self.numberOfPairs = numberOfPairs
			self.color = color
		}
	}
	private static let themes: [Theme] = [
		Theme(title: "vehicles", emojis: ["🚗", "🚙", "🚌", "🏎️", "🚑", "🚓", "🛵", "✈️", "🚃", "🚢", "🚁", "⛵️", "🚂", "🛶"], numberOfPairs: 4, color: .gray),
		Theme(title: "numbers", emojis: ["0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣", "🔟", "#️⃣", "*️⃣"], numberOfPairs: 6, color: .purple),
		Theme(title: "hands", emojis: ["👏", "🤝", "👍", "👎", "✊", "✌️", "✌️", "🤟", "👌", "🤌", "🤏", "🤙"], numberOfPairs: 8, color: .yellow),
		Theme(title: "smileys", emojis: ["💀", "🥰", "😅", "😔", "🥶", "🥵", "😭", "😎", "🤮", "😳", "🤯", "😡", "😟", "🤩", "🤓"], numberOfPairs: 8, color: .blue),
		Theme(title: "ghosts", emojis: ["0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣", "🔟", "#️⃣", "*️⃣"], numberOfPairs: 6, color: .pink),
		//As per task 4 of Lecture 4 Fresh theme has fewer emojis than possible pairs
		Theme(title: "fresh", emojis: ["🍏", "🥝", "🥑", "🥦"].shuffled(), numberOfPairs: 5, color: .green)
	]
	
	static let titles = ["smileys": "face.smiling.inverse",
				  "vehicles": "car.fill",
				  "numbers": "number.circle.fill",
				  "hands": "hand.raised.fill"]
	
	enum Themes: String, CaseIterable {
		case smileys, vehicles, numbers, hands
	}
	
	static let colors: [Color] = [.red, .orange, .green, .pink, .blue, .cyan, .purple, .yellow]
	
	@Published private(set) var currentTheme: Theme
	@Published var selectedTheme = Themes.allCases.randomElement()
	@Published var selectedColor: Color
	
	//MARK: MemoryGame creation function
	
	static func createMemoryGame(with theme: Theme) -> MemoryGame<String> {
		MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
			var emojis = theme.emojis.shuffled()
//			temp fix for index out of range
			if emojis.count < theme.numberOfPairs {
				for _ in emojis {
					emojis.append("🟤")
				}
			}

			return emojis[pairIndex]
		}
	}
	
	@Published private var model = createMemoryGame(with: themes.randomElement()!)
	
	
	var cards: Array<Card> {
		return model.cards
	}
	
	func fetchScore() -> Int {
		return model.score
	}
	
	//MARK: Intent(s)
	func choose(_ card: Card) {
		model.choose(card)
	}
	
	func changeThemeColor(_ color: Color) {
		selectedColor = color
		print("Color \(color) was tapped!")
	}
	
	func restartGame() {
		currentTheme = EmojiMemoryGame.themes.randomElement()!
		model = EmojiMemoryGame.createMemoryGame(with: currentTheme)
		changeThemeColor(currentTheme.color)
	}
}

