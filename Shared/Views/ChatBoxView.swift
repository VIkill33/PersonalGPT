//
//  ChatBoxView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/10.
//

import SwiftUI
import MarkdownUI

enum chat_role {
    case user
    case assistant
}

struct ChatBoxView: View {
    var chatRole: chat_role
    var chatString: String
    var regenerateAnswer: (api_type) -> Void
    var shouldShowMenu = true
    let boxRadius = 10.0
    let boxPaddingLength = 10.0
    let
    var body: some View {
        switch chatRole {
        case .user:
            HStack {
                Spacer()
                Markdown(chatString)
                    .markdownTextStyle {
                        ForegroundColor(.white)
                    }
                    .padding(boxPaddingLength)
                    .background {
                        RoundedRectangle(cornerRadius: boxRadius)
                            .fill(Color.blue)
                    }
                    .contextMenu(shouldShowMenu ? menuItems : nil)
            }
            .padding([.top, .horizontal])
        case .assistant:
            HStack {
                Markdown(chatString)
                    .padding(boxPaddingLength)
                    .background {
                        RoundedRectangle(cornerRadius: boxRadius)
                            .fill(Color("secondarySystemBackground"))
                    }
                    .contextMenu(shouldShowMenu ? menuItems : nil)
                Spacer()
            }
            .padding([.top, .horizontal])
        }
    }
}



func selectHearts() {
    // Act on hearts selection.
}
func selectClubs() { }
func selectSpades() { }
func selectDiamonds() { }

let menuItems = ContextMenu {
    Button("Copy", action: selectHearts)
    Button("♣️ - Clubs", action: selectClubs)
    Button("♠️ - Spades", action: selectSpades)
    Button("♦️ - Diamonds", action: selectDiamonds)
}
