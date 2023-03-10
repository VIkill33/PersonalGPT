//
//  ContentView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        #if os(macOS)
        ChatView()
        #endif
        #if os(iOS)
        NavigationView {
            VStack {
                settingButton()
                ChatView()
            }
        }
        #endif
    }
}

struct settingButton: View {
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text("ChatBOT-3.5")
                    .bold()
                Spacer()
            }
            HStack {
                Spacer()
                NavigationLink(destination: SettingView()) {
                    Image(systemName: "gear")
                        .padding()
                }
            }
        }
    }
}
