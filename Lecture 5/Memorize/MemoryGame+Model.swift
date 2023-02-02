//
//  MemoryGame+Model.swift
//  Memorize
//
//  Created by roberts.kursitis on 31/01/2023.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
	private(set) var cards: Array<Card>
	
	private var indexOfOnlyFaceUpCard: Int? {
		//We take all indices and filter them looking for cards that are face up and returning the only one that is face up.
		get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
		//Taking all indices and for each we set the isFaceUp value depending on if the index matches newValue.
		set { cards.indices.forEach{ cards[$0].isFaceUp = ($0 == newValue) } }
	}
	
	private(set) var seenCardArray: [Int] = []
	
	private(set) var score: Int = 0
	
	mutating func choose(_ card: Card) {
		if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
		   !cards[chosenIndex].isFaceUp,
		   !cards[chosenIndex].isMatched {
			if let potentialMatchIndex = indexOfOnlyFaceUpCard {
				if cards[chosenIndex].content == cards[potentialMatchIndex].content {
					cards[chosenIndex].isMatched = true
					cards[potentialMatchIndex].isMatched = true
					score += 2
				} else {
					if seenCardArray.contains(chosenIndex) {
						score -= 1
					} else {
						seenCardArray.append(chosenIndex)
					}
					if seenCardArray.contains(potentialMatchIndex) {
						score -= 1
					} else {
						seenCardArray.append(potentialMatchIndex)
					}
				}
				cards[chosenIndex].isFaceUp = true
			} else {
				indexOfOnlyFaceUpCard = chosenIndex
			}
		}
		
		print("\(cards)")
	}
	
	init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
		cards = []
		//add numberOfPairsOfCards x 2 cards to cards array
		for pairIndex in 0..<numberOfPairsOfCards {
			let content = createCardContent(pairIndex)
			cards.append(Card(content: content, id: pairIndex*2))
			cards.append(Card(content: content, id: pairIndex*2+1))
		}
		
		cards = cards.shuffled()
		score = 0
	}
	
	struct Card: Identifiable {
		var isFaceUp = false
		var isMatched = false
		let content: CardContent
		let id: Int
	}
}

extension Array {
	var oneAndOnly: Element? {
		if self.count == 1 {
			return self.first
		} else {
			return nil
		}
	}
}
