//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by roberts.kursitis on 30/01/2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
	@ObservedObject var game: EmojiMemoryGame
	@State private var isShowingSettings = false
	
	var body: some View {
		NavigationView {
			VStack {
				gameBody
				shuffle
//				if isShowingSettings {
//					VStack {
//						Text("Pick a theme!")
//							.font(.title)
//						Picker("", selection: $game.selectedTheme) {
//							ForEach(EmojiMemoryGame.Themes.allCases, id: \.self) { theme in
//								Label(theme.rawValue.capitalized, systemImage: EmojiMemoryGame.titles[theme.rawValue] ?? "")
//							}
//						}
//						HStack {
//							ForEach(EmojiMemoryGame.colors, id: \.self) { color in
//								Image(systemName: "circle.fill")
//									.foregroundColor(color)
//									.onTapGesture {
//										game.changeThemeColor(color)
//									}
//							}
//						}
//						.font(.largeTitle)
//						.padding()
//					}
//				} else {
//					Text("Score: \(game.fetchScore())")
//				}
//			}
//			.navigationTitle(game.currentTheme.title.capitalized)
//			.toolbar {
//				ToolbarItem(placement: .navigationBarLeading) {
//					Button {
//						game.restartGame()
//					} label: {
//						Image(systemName: "arrow.clockwise.circle.fill")
//							.foregroundColor(.primary)
//					}
//				}
//				ToolbarItem(placement: .navigationBarTrailing) {
//					Button {
//						isShowingSettings.toggle()
//					} label: {
//						Image(systemName: "gearshape.fill")
//							.foregroundColor(.primary)
//					}
//				}
			}
		}
	}
	
	var gameBody: some View {
		AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
			if card.isMatched && card.isFaceUp {
				Color.clear
			} else {
				CardView(card, game.selectedColor)
					.padding(4)
					.onTapGesture {
						game.choose(card)
					}
			}
		}
	}
	var shuffle: some View {
		Button("Shuffle") {
			withAnimation {
				game.shuffle()
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		let game = EmojiMemoryGame()
//		game.choose(game.cards.first!)
		return EmojiMemoryGameView(game: game)
    }
}

struct CardView: View {
	private let card: MemoryGame<String>.Card
	var color: Color
	
	init(_ card: EmojiMemoryGame.Card, _ color: Color) {
		self.card = card
		self.color = color
	}
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90)).padding(5).opacity(0.5)
				Text(card.content)
					.animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
					.rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
					.font(Font.system(size: DrawingConstants.fontSize))
					.scaleEffect(scale(thatFits: geometry.size))
			}
			.cardify(isFaceUp: card.isFaceUp)
		}
	}
	
	private func scale(thatFits size: CGSize) -> CGFloat {
		min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
	}
	
	private func font(in size: CGSize) -> Font {
		Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
	}
	
	private struct DrawingConstants {
		static let fontSize: CGFloat = 32
		static let fontScale: CGFloat = 0.65
	}
}
