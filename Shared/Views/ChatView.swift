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
    @State var isShowSelectCircle = false
    @State var isSnapShot = false
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                focusedField = nil
            }
    }
    
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let lastVersion = UserDefaults.standard.string(forKey: "lastVersion") ?? "unknown"
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ZStack {
                    if generatedText != "" {
                        ObservableScrollView(scrollOffset: $scrollOffset) { proxy in
                            ForEach(user.chats.indices, id: \.self) { index in
                                if user.chats[index].answers != "" {
                                    ChatBoxView(chatRole: .user, chatString: user.chats[index].messsages["content"] as! String, chatDate: user.chats[index].date, regenerateAnswer: self.generateText, chatIndex: index, promptText: $promptText, isShowSelectCircle: $isShowSelectCircle)
                                    ChatBoxView(chatRole: .assistant, chatString: user.chats[index].answers, chatDate: user.chats[index].date, regenerateAnswer: self.generateText, chatIndex: index, promptText: $promptText, isShowSelectCircle: $isShowSelectCircle)
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
                if isShowSelectCircle {
                    HStack(alignment: .center) {
                        Button(action: {
                            user.unselectAllChats()
                            withAnimation {
                                isShowSelectCircle = false
                            }
                        }, label: {
                            Text("Cancel")
                        })
                        Button(action: {
                            isSnapShot.toggle()
                        }, label: {
                            Text("\(Image(systemName: "square.and.arrow.up.on.square.fill")) Snapshot")
                        })
                        NavigationLink("preview") {
                            //snapshotView(user: user)
                        }
                    }
                    .padding()
                } else {
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
            }
            
            .sheet(isPresented: $settings.isFirstLauch) {
                WelcomeView(isFirstLauch: $settings.isFirstLauch)
            }
            .sheet(isPresented: $isSnapShot) {
                VStack {
                    snapshotView(user: user, isSnapshot: $isSnapShot)
                        .frame(minWidth: 300.0, minHeight: 400.0)
                }
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
    
}

extension ChatView {
    func take_snapshot() {
        return
    }
}


struct ChatViewPreviews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
