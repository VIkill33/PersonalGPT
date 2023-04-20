//
//  WelcomeView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI
import MarkdownUI

struct WelcomeView: View {
    @Binding var isFirstLauch: Bool
    var body: some View {
        VStack {
            #if os(macOS)
            HStack {
                Spacer()
                Button(action: {
                    isFirstLauch = false
                }, label: {
                    Image(systemName: "xmark")
                        .font(.footnote)
                })
                .buttonStyle(.plain)
            }
            #endif
            Spacer()
            Text("Welcome to ChatBOT")
                .font(.title.bold())
            Spacer()
            Text("Created By Vikill & ChatGPT")
            Text("powered by ChatGPT-3.5-Turbo")
                .font(.footnote)
                .foregroundColor(.secondary)
            Text("This app is for learning and communication purposes only.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 200.0, minHeight: 200.0)
        .padding()
    }
}

struct WhatsNewView: View {
    @EnvironmentObject var settings: Settings
    var body: some View {
        ScrollView {
#if os(macOS)
            HStack {
                Spacer()
                Button(action: {
                    settings.hasAppBeenUpdated = false
                }, label: {
                    Image(systemName: "xmark")
                        .font(.footnote)
                })
                .buttonStyle(.plain)
            }
#endif
            Spacer()
            Text("What's New")
                .font(.title.bold())
            Spacer()
            Markdown(NSLocalizedString("""
2023-4-20
- Support stream Response
- Automatically scroll down after chat

2023-3-30
- Support API2D

2023-3-16
- Support editing questions
- Add alert toast when submit/reset API keys

2023-3-15
- Support choosing GPT models
- Support error alert toast
- Support alert toast on macOS

2023-3-14
- Support Snapshot of chats

2023-3-10
- Adjust UI to iMessage-like
""", comment: ""))
        }
        .frame(minWidth: 300.0, minHeight: 500.0)
        .padding()
    }
}

struct WhatsNewView_Previews: PreviewProvider {
    static var previews: some View {
        WhatsNewView()
    }
}

