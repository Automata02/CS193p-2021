//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by roberts.kursitis on 10/02/2023.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
	@Published private(set) var emojiArt: EmojiArtModel {
		didSet {
			if emojiArt.background != oldValue.background {
				fetchBackgroundImageDataIfNecessary()
			}
		}
	}
	
	init() {
		emojiArt = EmojiArtModel()
		emojiArt.addEmoji("💀", at: (-200, -100), size: 80)
		emojiArt.addEmoji("🤡", at: (50, 100), size: 40)
	}
	
	var emojis: [EmojiArtModel.Emoji] { emojiArt.emojis }
	var background: EmojiArtModel.Background { emojiArt.background }
	
	@Published var backgroundImage: UIImage?
	@Published var backgroundImageFetchStatus = BackgroundImageFetchStatus.idle
	
	enum BackgroundImageFetchStatus {
		case idle
		case fetching
	}
	
	private func fetchBackgroundImageDataIfNecessary() {
		backgroundImage = nil
		switch emojiArt.background {
		case .blank:
			break
		case .url(let url):
			//Updated to Task as GCD has been depracated.
			backgroundImageFetchStatus = .fetching
			Task.detached { [self] in
				let imageData = try? Data(contentsOf: url)
				if imageData != nil {
					Task { @MainActor in
						backgroundImageFetchStatus = .idle
						backgroundImage = UIImage(data: imageData!)
					}
				}
			}
		case .imageData(let data):
			backgroundImage = UIImage(data: data)
		}
	}
	
	//MARK: Intents
	func setBackground(_ background: EmojiArtModel.Background) {
		emojiArt.background = background
		print("background est to \(background)")
	}
	
	func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
		emojiArt.addEmoji(emoji, at: location, size: Int(size))
	}
	
	func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
		if let index = emojiArt.emojis.index(matching: emoji) {
			emojiArt.emojis[index].x += Int(offset.width)
			emojiArt.emojis[index].y += Int(offset.height)
		}
	}
	
	func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
		if let index = emojiArt.emojis.index(matching: emoji) {
			emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(FloatingPointRoundingRule.toNearestOrAwayFromZero))
		}
	}
}
