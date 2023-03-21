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
        VStack {
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
            Markdown("2023-3-16\n- Support editing questions\n- Add alert toast when submit/reset API keys\n\n2023-3-15\n- Support choosing GPT models\n- Support error alert toast\n- Support alert toast on macOS\n\n2023-3-14\n- Support Snapshot of chats\n\n2023-3-10\n- Adjust UI to iMessage-like")
        }
        .frame(minWidth: 200.0, minHeight: 400.0)
        .padding()
    }
}
