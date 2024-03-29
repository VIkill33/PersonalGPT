//
//  ChatView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI
import MarkdownUI
import Combine
import AlertToast

struct ChatView: View {
    let generatedTextQueue = DispatchQueue(label: "com.example.app.generatedTextQueue")
    enum Field: Int, CaseIterable {
        case promptText
    }
    
    @Namespace var bottomID
    @EnvironmentObject var user: User
    @EnvironmentObject var settings: Settings
    @FocusState var focusedField: Field?
    @State var scrollOffset = CGFloat.zero
    @State var promptText = ""
    @State var generatedText = ""
    @State var isLoading = false
    @State var toastTitle = ""
    @State var toastSubtitle = ""
    @State var status: ChatView_status = .chat
    @State var snapshot_proxy: [GeometryProxy] = []
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                settings.isFocused = false
            }
    }
    
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let lastVersion = UserDefaults.standard.string(forKey: "lastVersion") ?? "unknown"
    
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack {
                        ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                            ChatContentView(promptText: $promptText, status: $status, user: user, generateText: self.generateText(prompt_text:))
                                .background(
                                    ZStack {
                                        GeometryReader {geo in
                                            Color.clear
                                                .onChange(of: status) { _ in
                                                    snapshot_proxy = []
                                                    snapshot_proxy.append(geo)
                                                    print(status)
                                                    print("chat height = \(geo.size.height)")
                                                }
                                        }
                                    }
                                )
                            Text("")
                                .id(bottomID)
                                .onChange(of: generatedText) { _ in
                                    proxy.scrollTo(bottomID)
                                }
                                .task(id: generatedText, priority: .background) {
                                    DispatchQueue.main.async {
                                        if isLoading {
                                            proxy.scrollTo(bottomID, anchor: .bottom)
                                        }
                                        settings.isFocused = true
                                    }
                                }
                        }
                        
                }
                .onTapGesture {
                    settings.isFocused = false
                }
                .gesture(simpleDrag)
                #if os(iOS)
                Divider()
                #endif
                BottomBar(status: $status, promptText: $promptText,focusedField: $focusedField, isLoading: $isLoading, snapshot_proxy: $snapshot_proxy, scrollOffset: $scrollOffset, user: user, generateText: self.generateText(prompt_text:))
                #if os(macOS)
                    .background {
                        Color.secondary.colorInvert()
                    }
                #endif
            }
            .toast(isPresenting: $settings.isShowErrorToast) {
                AlertToast(displayMode: .hud, type: .error(.red), title: toastTitle, subTitle: toastSubtitle)
            }
            .toast(isPresenting: $settings.isShowCopyToast) {
                AlertToast(displayMode: .hud, type: .regular, title: "Copy To Clipborad Successfully")
            }
            
            .sheet(isPresented: $settings.isFirstLauch) {
                WelcomeView(isFirstLauch: $settings.isFirstLauch)
            }
            .sheet(isPresented: $settings.hasAppBeenUpdated) {
                WhatsNewView()
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
    
    func handleChangeOfGeneratedText() async {
        
    }
    
}

struct ChatContentView: View {
    
    @Binding var promptText: String
    @Binding var status: ChatView_status
    @ObservedObject var user: User
    var generateText: (String) async -> Void
    @State var isHideUnselectChats: Bool = false
    
    var body: some View {
            VStack {
                ForEach(user.chats.indices, id: \.self) { index in
                    if user.chats[index].answers != "" {
                        if !isHideUnselectChats || user.chats[index].isPromptSelected {
                            ChatBoxView(chatRole: .user, chatString: user.chats[index].messsages["content"] as! String, chatDate: user.chats[index].date, regenerateAnswer: self.generateText, chatIndex: index, promptText: $promptText, status: $status, isHideUnselectChats: isHideUnselectChats)
                        }
                        if !isHideUnselectChats || user.chats[index].isAnswerSelected {
                            ChatBoxView(chatRole: .assistant, chatString: user.chats[index].answers, chatDate: user.chats[index].date, regenerateAnswer: self.generateText, chatIndex: index, promptText: $promptText, status: $status, isHideUnselectChats: isHideUnselectChats)
                        }
                    }
                }
            }
    }
}


enum ChatView_status {
    case chat
    case select
    case snapshot_preview // useless
}





struct ChatViewPreviews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
