//
//  ChatContentTextView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/13.
//

import SwiftUI


struct ChatBox_Text_View: View {
    @EnvironmentObject var user: User
    var chatRole: chat_role
    var chatString: String
    var promptString: String = ""
    var chatDate: Date
    var regenerateAnswer: (api_type, String) -> Void
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
                    Text(chatString)
                        .foregroundColor(.white)
                        .padding(boxPaddingLength)
                        .background {
                            RoundedRectangle(cornerRadius: boxRadius)
                                .fill(Color.blue)
                        }
                        .contextMenu {
                            Button("Copy") {
                                copy2pasteboard(chatString)
                                
                            }
                            Button("Regenerate Answer") {
                                promptText = promptString
                                regenerateAnswer(.chat, promptString)
                            }
                            Button("More...") {
                                user.unselectAllChats()
                                withAnimation {
                                    status = .select
                                }
                            }
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
                    Text(chatString)
                        .padding(boxPaddingLength)
                        .background {
                            RoundedRectangle(cornerRadius: boxRadius)
                                .fill(Color("secondarySystemBackground"))
                        }
                        .contextMenu {
                            Button("Copy") {
                                copy2pasteboard(chatString)
                                
                            }
                            Button("Regenerate Answer") {
                                promptText = promptString
                                regenerateAnswer(.chat, promptString)
                            }
                            Button("More...") {
                                user.unselectAllChats()
                                withAnimation {
                                    status = .select
                                }
                            }
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


struct ChatContent_Text_View: View {
    
    @Binding var promptText: String
    @Binding var status: ChatView_status
    @ObservedObject var user: User
    var generateText: (api_type, String) -> Void
    @State var isHideUnselectChats: Bool = false
    
    var body: some View {
            VStack {
                ForEach(user.chats.indices, id: \.self) { index in
                    if user.chats[index].answers != "" {
                        if !isHideUnselectChats || user.chats[index].isPromptSelected {
                            ChatBox_Text_View(chatRole: .user, chatString: user.chats[index].messsages["content"] as! String, chatDate: user.chats[index].date, regenerateAnswer: self.generateText, chatIndex: index, promptText: $promptText, status: $status, isHideUnselectChats: isHideUnselectChats)
                        }
                        if !isHideUnselectChats || user.chats[index].isAnswerSelected {
                            ChatBox_Text_View(chatRole: .assistant, chatString: user.chats[index].answers, chatDate: user.chats[index].date, regenerateAnswer: self.generateText, chatIndex: index, promptText: $promptText, status: $status, isHideUnselectChats: isHideUnselectChats)
                        }
                    }
                }
            }
    }
}
