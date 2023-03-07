//
//  extensions.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/5.
//

import SwiftUI

struct messagedStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .font(.callout.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .padding([.horizontal, .top])
    }
}

struct answerStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .lineLimit(nil)
            .frame(minHeight: 50.0, maxHeight: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .padding([.horizontal, .bottom])
    }
}

extension View {
    
    func messageStyle() -> some View {
        self.modifier(messagedStyleModifier())
    }
    
    func answerStyle() -> some View {
        self.modifier(answerStyleModifier())
    }
    
}
