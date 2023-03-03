//
//  ChatView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI
#if os(iOS)
import Toast
#endif

struct ChatView: View {
    @EnvironmentObject var user: User
    @AppStorage("isFirstLauch") var isFirstLauch = true
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
            if generatedText != "" {
                HStack {
                    TextField("", text: .constant(promptText_shown))
                        .textFieldStyle(.plain)
                        .font(.callout.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    .padding()
                }
                .onTapGesture {
                    focusedField = nil
                }
                .gesture(simpleDrag)
                Divider()
                    .padding(.horizontal)
                    .onTapGesture {
                        focusedField = nil
                    }
                    .gesture(simpleDrag)
            }
            ZStack {
                //ScrollView {
                if generatedText != "" {
                    VStack {
                        TextEditor(text: .constant(generatedText ))
                            .textFieldStyle(.plain)
                            .lineLimit(nil)
                            .frame(maxHeight: .infinity, alignment: .leading)
                            .padding()
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
                            }
                            Button(action: {
                                promptText = promptText_shown
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
                //}
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
