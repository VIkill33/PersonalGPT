//
//  ChatBoxView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/10.
//

import SwiftUI
import MarkdownUI
#if os(iOS)
import Toast
#endif

enum chat_role {
    case user
    case assistant
}

struct ChatBoxView: View {
    var chatRole: chat_role
    var chatString: String
    var promptString: String = ""
    var regenerateAnswer: (api_type, String) -> Void
    @Binding var promptText: String
    let boxRadius = 10.0
    let boxPaddingLength = 10.0
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
                    .contextMenu {
                        Button("Copy") {
                            copy2pasteboard(chatString)
#if os(iOS)
                            let toast = Toast.text("Copy to clipborad successfully")
                            toast.show()
#endif
                        }
                        Button("Regenerate Answer") {
                            promptText = promptString
                            regenerateAnswer(.chat, promptString)
                        }
                        Button("More...") {
                            
                        }
                    }
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
                    .contextMenu {
                        Button("Copy") {
                            copy2pasteboard(chatString)
#if os(iOS)
                            let toast = Toast.text("Copy to clipborad successfully")
                            toast.show()
#endif
                        }
                        Button("Regenerate Answer") {
                            promptText = promptString
                            regenerateAnswer(.chat, promptString)
                        }
                    }
                Spacer()
            }
            .padding([.top, .horizontal])
        }
    }
}

public func copy2pasteboard(_ copy_string: String) {
#if os(iOS)
    UIPasteboard.general.string = copy_string
#endif
#if os(macOS)
    let pasteBoard = NSPasteboard.general
    pasteBoard.clearContents()
    pasteBoard.setString(copy_string, forType: .string)
#endif
}