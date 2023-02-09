//
//  Cardify.swift
//  Memorize
//
//  Created by roberts.kursitis on 09/02/2023.
//

import SwiftUI

struct Cardify: ViewModifier {
	init(isFaceUp: Bool) {
		rotation = isFaceUp ? 0 : 180
	}
	
	var rotation: Double
	
	func body(content: Content) -> some View {
		ZStack {
			let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
	
			if rotation < 90 {
				shape.fill().foregroundColor(.white)
				shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
			} else {
				shape.fill()
			}
			content
				.opacity(rotation < 90 ? 1 : 0)
		}
		.padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
		.rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
	}
	
	private struct DrawingConstants {
		static let cornerRadius: CGFloat = 10
		static let lineWidth: CGFloat = 3
		static let fontScale: CGFloat = 0.65
	}
}

extension View {
	func cardify(isFaceUp: Bool) -> some View {
		self.modifier(Cardify(isFaceUp: isFaceUp))
	}
}
