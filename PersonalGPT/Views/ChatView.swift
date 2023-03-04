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
    @AppStorage("isFirstLauch") var isFirstLauch = true
    @AppStorage("isShowMarkdown") var isShowMarkdown = true
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
                                .textFieldStyle(.plain)
                                .font(.callout.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .padding([.horizontal, .top])
                            Divider()
                            if isShowMarkdown {
                                Markdown(chat.answers)
                                    .padding([.horizontal, .bottom])
                            } else {
                                TextEditor(text: .constant(chat.answers))
                                    .textFieldStyle(.plain)
                                    .lineLimit(nil)
                                    .frame(minHeight: 50.0, maxHeight: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .padding([.horizontal, .bottom])
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
                                    isShowMarkdown.toggle()
                                }, label: {
                                    if isShowMarkdown {
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
        .sheet(isPresented: $isFirstLauch) {
            WelcomeView(isFirstLauch: $isFirstLauch)
        }
    }
    
}


struct ChatViewPreviews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
