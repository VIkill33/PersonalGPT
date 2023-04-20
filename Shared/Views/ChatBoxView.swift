//
//  ChatBoxView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/10.
//

import SwiftUI
import MarkdownUI
import AlertToast

enum chat_role {
    case user
    case assistant
}

struct ChatBoxView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var settings: Settings
    var chatRole: chat_role
    var chatString: String
    @State var promptString: String = ""
    var chatDate: Date
    var regenerateAnswer: (String) async -> Void
    var chatIndex: Int
    @Binding var promptText: String
    @Binding var status: ChatView_status
    var isHideUnselectChats: Bool = false
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
                            Button(action: {
                                copy2pasteboard(chatString)
                                settings.isShowCopyToast = true
                            }, label: {
                                HStack {
                                    Text("Copy")
                                    Image(systemName: "doc.on.doc.fill")
                                }
                            })
                            Button(action: {
                                promptText = user.chats[chatIndex].messsages["content"] as! String
                            }, label: {
                                Text("Edit")
                                Image(systemName: "square.and.pencil")
                            })
                            Button(action: {
                                promptText = user.chats[chatIndex].messsages["content"] as! String
                                Task {
                                    await regenerateAnswer(promptText)
                                }
                            }, label: {
                                Text("Regenerate Answer")
                                Image(systemName: "arrow.clockwise")
                            })
                            Button(action: {
                                user.unselectAllChats()
                                withAnimation {
                                    status = .select
                                }
                            }, label: {
                                Text("More...")
                                Image(systemName: "ellipsis.circle")
                            })
                        }
                    if status == .select && !isHideUnselectChats {
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
                    if status == .select {
                        user.chats[chatIndex].isPromptSelected.toggle()
                        isSelected.toggle()
                    }
                }
            }
            .padding([.top, .horizontal])
            .onChange(of: status) { newStatus in
                if newStatus == .chat {
                    // Exit snapshot mode, unselect all chatbox
                    isSelected = false
                }
            }
        case .assistant:
            HStack {
                Group {
                    if status == .select && !isHideUnselectChats {
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
                            Button(action: {
                                copy2pasteboard(chatString)
                                settings.isShowCopyToast = true
                            }, label: {
                                HStack {
                                    Text("Copy")
                                    Image(systemName: "doc.on.doc.fill")
                                }
                            })
                            Button(action: {
                                promptText = user.chats[chatIndex].messsages["content"] as! String
                                Task {
                                    await regenerateAnswer(promptText)
                                }
                            }, label: {
                                Text("Regenerate Answer")
                                Image(systemName: "arrow.clockwise")
                            })
                            Button(action: {
                                user.unselectAllChats()
                                withAnimation {
                                    status = .select
                                }
                            }, label: {
                                Text("More...")
                                Image(systemName: "ellipsis.circle")
                            })
                        }
                }
                .onTapGesture {
                    if status == .select {
                        user.chats[chatIndex].isAnswerSelected.toggle()
                        isSelected.toggle()
                    }
                }
                Spacer(minLength: minSpacerWidth)
            }
            .padding([.top, .horizontal])
            .onChange(of: status) { newStatus in
                if newStatus == .chat {
                    // Exit snapshot mode, unselect all chatbox
                    isSelected = false
                }
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
