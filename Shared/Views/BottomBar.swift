//
//  BottomBar.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/13.
//

import SwiftUI
import MarkdownUI
import OmenTextField
#if os(iOS)
import UIKit
#endif

struct BottomBar: View {
    @Binding var status: ChatView_status
    @Binding var promptText: String
    var focusedField: FocusState<ChatView.Field?>.Binding
    @Binding var isLoading: Bool
    @Binding var snapshot_proxy: [GeometryProxy]
    @Binding var scrollOffset: CGFloat
    @StateObject var user: User
    @State private var isShowCopyTosat = false
    @EnvironmentObject var settings: Settings
    
    var generateText: (String) async -> Void
    var body: some View {
        switch status {
        case .chat:
            HStack {
                OmenTextField("Enter Prompt", text: $promptText, isFocused: $settings.isFocused, onCommit: {
                if !isLoading {
                    Task(priority: .high) {
                        await generateText(promptText)
                    }
                }
            })
            }
            .disabled(isLoading)
            .padding()
        case .select:
            HStack(alignment: .center) {
                Button(action: {
                    user.unselectAllChats()
                    withAnimation {
                        status = .chat
                    }
                }, label: {
                    Text("Cancel")
                })
                Spacer()
                #if os(macOS)
                Button(action: {
                    // take snapshot
                    take_snapshot()
                }, label: {
                    HStack {
                        Text("\(Image(systemName: "square.and.arrow.up.on.square.fill"))")
                        Text("Snapshot")
                    }
                })
                #endif
                #if os(iOS)
                ShareLink(item: take_snapshot(), preview: SharePreview("chat", image: take_snapshot())) {
                    Label("Share", systemImage: "square.and.arrow.up.on.square.fill")
                }
                #endif
            }
            .padding()
        case .snapshot_preview:
            EmptyView()
        }
    }
}


extension BottomBar {
#if os(macOS)
    func take_snapshot() {
        if #available(macOS 13.0, *) {
            var capture_point = snapshot_proxy[0].frame(in: .global).origin
            // var capture_point = CGPoint.zero
            let capture_size = snapshot_proxy[0].size
            let qrcode_width = capture_size.width / 8
            
            let content = ZStack {
                Color.primary.colorInvert().edgesIgnoringSafeArea(.all)
                VStack {
                    ChatContentView(promptText: $promptText, status: $status, user: user, generateText: self.generateText, isHideUnselectChats: true).frame(width: capture_size.width)
                    HStack {
                        Spacer()
                        VStack {
                            Image("github_qrcode")
                                .resizable()
                                .frame(width: qrcode_width, height: qrcode_width)
                            Text("ChatBot3.5 by Vikill")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Text("Powered by \(settings.model.rawValue.uppercased())")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                }
            }
            let renderer = ImageRenderer(content: content)
            renderer.scale = 2.0
            let capture = renderer.nsImage
            
            if let url = showSavePanel() {
                savePNG(image: capture ?? NSImage(), path: url)
            }
        }
    }
#endif
#if os(iOS)
    func take_snapshot() -> Image {
        //var capture_point = snapshot_proxy[0].frame(in: .global).origin
        var capture_point = CGPoint.zero
        // var capture_size = snapshot_proxy[0].size
        let screen_width = UIScreen.main.bounds.width
        let qrcode_width = screen_width / 8
        
        let content = ZStack {
            Color.primary.colorInvert().edgesIgnoringSafeArea(.all)
            VStack {
                ChatContent_Text_View(promptText: $promptText, status: $status, user: user, generateText: self.generateText, isHideUnselectChats: true)
                HStack {
                    Spacer()
                    VStack {
                        Image("github_qrcode")
                            .resizable()
                            .frame(width: qrcode_width, height: qrcode_width)
                        Text("ChatBot3.5 by Vikill")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Text("Powered by \(settings.model.rawValue.uppercased())")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
        }
            .frame(width: screen_width)
        let renderer = ImageRenderer(content: content)
        renderer.scale = 2.0
        let image = renderer.uiImage ?? UIImage()
        return Image(uiImage: image)
    }
#endif
}
