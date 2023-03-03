//
//  WelcomeView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI

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
            Text("Welcome to PersonalGPT")
                .font(.title.bold())
            Spacer()
            Text("Created By Vikill & ChatGPT")
            Text("This app is for learning and communication purposes only.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .frame(minHeight: 200.0)
        .padding()
    }
}
