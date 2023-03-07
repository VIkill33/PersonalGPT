//
//  Settings.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/8.
//

import SwiftUI

class Settings: ObservableObject {
    @AppStorage("isMarkdown") var isMarkdown: Bool = true
    @AppStorage("isFirstLauch") var isFirstLauch: Bool = true
    @AppStorage("temperature") var temperature: Double = 1.0
    @AppStorage("api_key") var api_key: String = ""
}
