//
//  ChatView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI
import MarkdownUI
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
    @State var promptText = ""
    @State var promptText_shown = ""
    @State var generatedText = ""
    @State var isLoading = false
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                focusedField = nil
            }
    }
    
    var body: some View {
        VStack {
            ZStack {
                if generatedText != "" {
                    ScrollView {
                        ForEach(user.chats) { chat in
                            TextField("", text: .constant(chat.messsages["content"] as! String))
                                .messageStyle()
                            Divider()
                            if settings.isMarkdown {
                                Markdown(chat.answers)
                                    .padding([.horizontal, .bottom])
                            } else {
                                TextEditor(text: .constant(chat.answers))
                                    .answerStyle()
                            }
                        }
                    }
                    VStack {
                        Spacer()
                        ZStack {
                            HStack {
                                Button(action: {
#if os(iOS)
                                    UIPasteboard.general.string = generatedText
                                    let toast = Toast.text("Copy to clipborad successfully")
                                    toast.show()
#endif
#if os(macOS)
                                    let pasteBoard = NSPasteboard.general
                                    pasteBoard.clearContents()
                                    pasteBoard.setString(generatedText, forType: .string)
#endif
                                }, label: {
                                    Image(systemName: "doc.on.clipboard.fill")
                                })
                                .buttonStyle(.borderless)
                                .padding()
                                Spacer()
                                Button(action: {
                                    settings.isMarkdown.toggle()
                                }, label: {
                                    if settings.isMarkdown {
                                        Image(systemName: "t.square.fill")
                                    } else {
                                        Image(systemName: "m.square.fill")
                                    }
                                })
                                .buttonStyle(.borderless)
                                .padding()
                            }
                            Button(action: {
                                promptText = promptText_shown
                                //user.chat.answers.remove(at: user.chat.answers.count - 1)
                                generateText()
                            }, label: {
                                Text("Regenerate Answer")
                            })
                            .buttonStyle(.borderless)
                            .padding()
                        }
                    }
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
                            generateText()
                        }
                    }
                if isLoading {
                    ProgressView()
                        .padding(.horizontal)
                } else {
                    Button(action: {
                        focusedField = nil
                        generateText()
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
    }
    
}


struct ChatViewPreviews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
