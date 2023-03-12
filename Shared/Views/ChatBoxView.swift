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
    @EnvironmentObject var user: User
    var chatRole: chat_role
    var chatString: String
    var promptString: String = ""
    var chatDate: Date
    var regenerateAnswer: (api_type, String) -> Void
    var chatIndex: Int
    @Binding var promptText: String
    @Binding var isShowSelectCircle: Bool
    @State var isSelected: Bool = false
    let boxRadius = 10.0
    let boxPaddingLength = 10.0
    let minSpacerWidth = 20.0
    let appearDate = Date()
    var body: some View {
        switch chatRole {
        case .user:
            HStack {
                Spacer(minLength: minSpacerWidth)
                Group {
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
                                user.unselectAllChats()
                                withAnimation {
                                    isShowSelectCircle = true
                                }
                            }
                        }
                    if isShowSelectCircle {
                        if isSelected {
                            Text("\(Image(systemName: "checkmark.circle.fill"))")
                                .foregroundColor(.blue)
                        } else {
                            Text("\(Image(systemName: "circle"))")
                                .foregroundColor(Color("secondarySystemBackground"))
                        }
                    }
                }
                .onTapGesture {
                    if isShowSelectCircle {
                        user.chats[chatIndex].isPromptSelected.toggle()
                        isSelected.toggle()
                    }
                }
            }
            .padding([.top, .horizontal])
            .onChange(of: isShowSelectCircle) { _ in
                isSelected = false
            }
        case .assistant:
            HStack {
                Group {
                    if isShowSelectCircle {
                        if isSelected {
                            Text("\(Image(systemName: "checkmark.circle.fill"))")
                                .foregroundColor(.blue)
                        } else {
                            Text("\(Image(systemName: "circle"))")
                                .foregroundColor(Color("secondarySystemBackground"))
                        }
                    }
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
                            Button("More...") {
                                user.unselectAllChats()
                                withAnimation {
                                    isShowSelectCircle = true
                                }
                            }
                        }
                }
                .onTapGesture {
                    if isShowSelectCircle {
                        user.chats[chatIndex].isAnswerSelected.toggle()
                        isSelected.toggle()
                    }
                }
                Spacer(minLength: minSpacerWidth)
            }
            .padding([.top, .horizontal])
            .onChange(of: isShowSelectCircle) { _ in
                isSelected = false
            }
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
