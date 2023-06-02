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

public extension View {
    func focused(_ condition: FocusState<Bool>.Binding, key: KeyEquivalent, modifiers: EventModifiers = .command) -> some View {
        focused(condition)
            .background(Button("") {
                condition.wrappedValue = true
            }
            .keyboardShortcut(key, modifiers: modifiers)
            .hidden()
            )
    }

    func focused<Value>(_ binding: FocusState<Value>.Binding, equals value: Value, key: KeyEquivalent, modifiers: EventModifiers = .command) -> some View where Value: Hashable {
        focused(binding, equals: value)
            .background(Button("") {
                binding.wrappedValue = value
            }
            .keyboardShortcut(key, modifiers: modifiers)
            .hidden()
            )
    }
}
