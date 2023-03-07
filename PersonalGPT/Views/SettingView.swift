//
//  SettingView.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/5.
//

import SwiftUI
#if os(iOS)
import Toast
#endif

struct SettingView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var user: User
    let values = stride(from: 0.0, to: 2.0, by: 0.1).map{String(format: "%.1f", $0)}
    let step: Double = 0.1
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section(footer: Text("What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.")) {
                    HStack {
                        Text("Markdown")
                        Spacer()
                        Toggle("", isOn: $settings.isMarkdown)
                    }
                    HStack {
                        Text("Temperature")
                        Picker("", selection: $settings.temperature) {
                            ForEach(0...20, id: \.self) {
                                Text(String(Double($0)/10)).tag(Double($0)/10)
                            }
                        }
                    }
                }
                Section(header: Text("Roles (Not availible yet)")) {
                    Text("System")
                    Text("User")
                    Text("Assistant")
                }
                .disabled(true)
                Section(header: Text("API Key"), footer: Text("You can paste your own API key here, or use author's for free :)")) {
                    SecureField("API key", text: $settings.api_key)
                    Button(action: {
                        settings.api_key = "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"
                    }, label: {
                        Text("Reset API key")
                    })
                }
                Section {
                    Button(action: {
                        user.chats = []
                        #if os(iOS)
                        let toast = Toast.text("Clear all chats successfully")
                        toast.show()
                        #endif
                    }, label: {
                        Text("Clear History")
                    })
                }
            }
            #if os(macOS)
            .padding()
            .formStyle(.grouped)
            .frame(minWidth: 300.0, minHeight: 700.0)
            #endif
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
