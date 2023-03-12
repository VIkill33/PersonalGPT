//
//  SnapshotView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/11.
//

import SwiftUI
import MarkdownUI

struct snapshotView: View {
    @ObservedObject var user: User
    @Binding var isSnapshot: Bool
    @State var isCapture: Bool = false
    var body: some View {
        GeometryReader { geo_proxy in
            VStack {
                captureView(user: user, isCapture: $isCapture)
                HStack {
                    Button("Done", action: {
                        isSnapshot = false
                    })
                    .padding()
                    Button(action: {
                        isCapture = true
                        if #available(macOS 13.0, *) {
    #if os(macOS)
                            let capture = captureView(user: user, isCapture: $isCapture).snapshot(origin: .zero, targetSize: CGSize(width: 300, height: 400))
                            if let url = showSavePanel() {
                                savePNG(image: capture!, path: url)
                            }
    #endif
                        } else {
                            // Fallback on earlier versions
                        }
                    }, label: {
                        Text("\(Image(systemName: "square.and.arrow.up.on.square.fill")) Snapshot")
                    })
                    .padding()
                }
            }
        }
    }
}

struct captureView: View {
    @ObservedObject var user: User
    @Binding var isCapture: Bool
    @State var isShowSelectCircle = false
    @State var promptText = ""
    @State private var contentHeight: CGFloat = 0
    let boxRadius = 10.0
    let boxPaddingLength = 10.0
    let minSpacerWidth = 20.0
    var body: some View {
        let content =
        VStack {
            ForEach(user.chats.indices, id: \.self) { index in
                if user.chats[index].answers != "" {
                    if user.chats[index].isPromptSelected {
                        captureChatBoxView(chatRole: .user, chatString: user.chats[index].messsages["content"] as! String)
                    }
                    if user.chats[index].isAnswerSelected {
                        captureChatBoxView(chatRole: .assistant, chatString: user.chats[index].answers)
                    }
                }
            }
        }
        .padding()
        .disabled(true)
        return GeometryReader { capture_proxy in
            ScrollView {
                content
            }
            .onAppear {
                print("capture width = \(capture_proxy.size.width)")
                print("capture height = \(capture_proxy.size.height)")
            }
            .onChange(of: isCapture) { newValue in
                if newValue {
                }
            }
        }
    }
}

struct captureChatBoxView: View {
    var chatRole: chat_role
    var chatString: String
    let boxRadius = 10.0
    let boxPaddingLength = 10.0
    let minSpacerWidth = 20.0
    var body: some View {
        switch chatRole {
        case .user:
            HStack {
                Spacer(minLength: minSpacerWidth)
                Markdown(chatString)
                    .markdownTextStyle {
                        ForegroundColor(.white)
                    }
                    .padding(boxPaddingLength)
                    .background {
                        RoundedRectangle(cornerRadius: boxRadius)
                            .fill(Color.blue)
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
                Spacer(minLength: minSpacerWidth)
            }
            .padding([.top, .horizontal])
        }
    }
}

extension captureView {
    func blankFunc(apiType: api_type, str: String) {
        return
    }
}
