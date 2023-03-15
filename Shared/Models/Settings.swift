//
//  Settings.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/8.
//

import SwiftUI

class Settings: ObservableObject {
    @Published var hasAppBeenUpdated: Bool = false
    @Published var hasCheckedAppBeenUpdated: Bool = false
    @Published var isShowErrorToast: Bool = false
    @Published var isShowCopyToast: Bool = false
    @Published var isShowClearToast: Bool = false
    @AppStorage("isFirstLauch") var isFirstLauch: Bool = true
    @AppStorage("modelIndex") var model: Models = .gpt35turbo
    @AppStorage("temperature") var temperature: Double = 1.0
    @AppStorage("api_key") var api_key: String = ""
    @AppStorage("isSystemPrompt") var isSystemPrompt: Bool = false
    @AppStorage("isAssistantPrompt") var isAssistantPrompt: Bool = false
    @AppStorage("systemPrompt") var systemPrompt: String = ""
    @AppStorage("assistantPrompt") var assistantPrompt: String = ""
}
