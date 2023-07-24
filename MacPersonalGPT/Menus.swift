//
//  Menus.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/8.
//

import SwiftUI

struct Menus: Commands {
    @ObservedObject var user: User
    @ObservedObject var settings: Settings
    var body: some Commands {
        EmptyCommands()
        CommandGroup(after: .textEditing) {
            Button("Clear History", action: {
                while !user.chats.isEmpty {
                    user.chats.remove(at: 0)
                }
            })
            .keyboardShortcut("d", modifiers: .command)
            Button("Zoom out", action: {
                if settings.fontSize < 100 {
                    settings.fontSize += 1
                }
            })
            .keyboardShortcut("+", modifiers: .command)
            Button("Zoom in", action: {
                if settings.fontSize > 1 {
                    settings.fontSize -= 1
                }
            })
            .keyboardShortcut("-", modifiers: .command)
        }
        CommandGroup(after:.appVisibility) {
            
        }
    }
}
