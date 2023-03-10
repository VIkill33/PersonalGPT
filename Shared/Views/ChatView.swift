//
//  ChatView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI
import MarkdownUI
import Combine
#if os(iOS)
import Toast
#endif

struct ChatView: View {
    @EnvironmentObject var user: User
    @EnvironmentObject var settings: Settings
    private enum Field: Int, CaseIterable {
        case promptText
    }
    @FocusState private var focusedField: Field?
    @State var scrollOffset = CGFloat.zero
    @State var promptText = ""
    @State var generatedText = ""
    @State var isLoading = false
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                focusedField = nil
            }
    }
    
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let lastVersion = UserDefaults.standard.string(forKey: "lastVersion") ?? "unknown"
    
    var body: some View {
        VStack {
            ZStack {
                if generatedText != "" {
                    ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                        ForEach(user.chats) { chat in
                            if chat.answers != "" {
                                ChatBoxView(chatRole: .user, chatString: chat.messsages["content"] as! String, regenerateAnswer: self.generateText, promptText: $promptText)
                                ChatBoxView(chatRole: .assistant, chatString: chat.answers, promptString: chat.messsages["content"] as! String, regenerateAnswer: self.generateText, promptText: $promptText)
                            }
                        }
                    }
                    .onChange(of: scrollOffset, perform: { [scrollOffset] newOffset in
                        if newOffset > scrollOffset {
                            // scroll down
                        } else {
                            // scroll up
                        }
                    })
                }
                else {
                    Spacer()
                }
            }
            .onTapGesture {
                focusedField = nil
            }
            .gesture(simpleDrag)
            Divider()
            HStack {
                TextField("Enter prompt", text: $promptText)
                    .focused($focusedField, equals: .promptText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        if !isLoading {
                            generateText(prompt_text: promptText)
                        }
                    }
                if isLoading {
                    ProgressView()
                        .padding(.horizontal)
                } else {
                    Button(action: {
                        focusedField = nil
                        generateText(prompt_text: promptText)
                    }) {
                        Image(systemName: "paperplane.fill")
                    }
                    .padding()
                }
            }
            .disabled(isLoading)
            .padding()
        }
        
        .sheet(isPresented: $settings.isFirstLauch) {
            WelcomeView(isFirstLauch: $settings.isFirstLauch)
        }
        .onAppear {
            // check if app has been updated
            print("old version: \(lastVersion)")
            print("current version: \(currentVersion)")
            settings.hasAppBeenUpdated = lastVersion != currentVersion
            if settings.hasAppBeenUpdated && !settings.hasCheckedAppBeenUpdated {
                settings.isFirstLauch = true
                settings.hasCheckedAppBeenUpdated = true
            }
            UserDefaults.standard.set(currentVersion, forKey: "lastVersion")
        }
    }
    
}


struct ChatViewPreviews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
