//
//  Menus.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/8.
//

import SwiftUI

struct Menus: Commands {
    @ObservedObject var user: User
    var body: some Commands {
        EmptyCommands()
        CommandGroup(after: .textEditing) {
            Button("Clear History", action: {
                while !user.chats.isEmpty {
                    user.chats.remove(at: 0)
                }
            })
            .keyboardShortcut("d", modifiers: .command)
        }
    }
}
