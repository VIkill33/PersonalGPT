//
//  Settings.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/8.
//

import SwiftUI

class Settings: ObservableObject {
    @AppStorage("isFirstLauch") var isFirstLauch: Bool = true
    @Published var hasAppBeenUpdated: Bool = false
    @Published var hasCheckedAppBeenUpdated: Bool = false
    @AppStorage("temperature") var temperature: Double = 1.0
    @AppStorage("api_key") var api_key: String = "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"
    @AppStorage("isSystemPrompt") var isSystemPrompt: Bool = false
    @AppStorage("isAssistantPrompt") var isAssistantPrompt: Bool = false
    @AppStorage("systemPrompt") var systemPrompt: String = ""
    @AppStorage("assistantPrompt") var assistantPrompt: String = ""
}
