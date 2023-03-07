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
            ZStack {
                ChatView()
                settingButton()
            }
        }
        #endif
    }
}

struct settingButton: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                NavigationLink(destination: SettingView()) {
                    Image(systemName: "gear")
                        .padding()
                }
                Spacer()
            }
        }
    }
}
