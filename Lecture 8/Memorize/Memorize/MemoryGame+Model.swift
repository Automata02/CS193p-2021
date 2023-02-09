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
		   !cards[chosenIndex].isMatched
		{
			if let potentialMatchIndex = indexOfOnlyFaceUpCard {
				if cards[chosenIndex].content == cards[potentialMatchIndex].content {
					cards[chosenIndex].isMatched = true
					cards[potentialMatchIndex].isMatched = true
				}
				cards[chosenIndex].isFaceUp = true
			} else {
				indexOfOnlyFaceUpCard = chosenIndex
			}
		}
	}
	
	mutating func shuffle() {
		cards.shuffle()
	}
	
	init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
		cards = []
		for pairIndex in 0..<numberOfPairsOfCards {
			let content = createCardContent(pairIndex)
			cards.append(Card(content: content, id: pairIndex * 2))
			cards.append(Card(content: content, id: pairIndex * 2 + 1))
		}
		cards.shuffle()
	}
	
	struct Card: Identifiable {
		var isFaceUp = false {
			didSet {
				if isFaceUp {
					startUsingBonusTime()
				} else {
					stopUsingBonusTime()
				}
			}
		}
		var isMatched = false {
			didSet {
				stopUsingBonusTime()
			}
		}
		let content: CardContent
		let id: Int
		
		var bonusTimeLimit: TimeInterval = 6
		
		private var faceUpTime: TimeInterval {
			if let lastFaceUpDate = self.lastFaceUpDate {
				return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
			} else {
				return pastFaceUpTime
			}
		}
		
		var lastFaceUpDate: Date?
		
		var pastFaceUpTime: TimeInterval = 0
		
		var bonusTimeRemaining: TimeInterval {
			max(0, bonusTimeLimit - faceUpTime)
		}
		
		var bonusRemaining: Double {
			(bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit: 0
		}
		
		var hasEarnedBonus: Bool {
			isMatched && bonusTimeRemaining > 0
		}
		
		var isConsumingBonusTime: Bool {
			isFaceUp && !isMatched && bonusTimeRemaining > 0
		}
		
		private mutating func startUsingBonusTime() {
			if isConsumingBonusTime, lastFaceUpDate == nil {
				lastFaceUpDate = Date()
			}
		}
		
		private mutating func stopUsingBonusTime() {
			pastFaceUpTime = faceUpTime
			self.lastFaceUpDate = nil
		}
	}
}

extension Array {
	var oneAndOnly: Element? {
		return count == 1 ? first : nil
	}
}
