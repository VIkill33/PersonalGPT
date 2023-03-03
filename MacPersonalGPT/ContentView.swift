//
//  ContentView.swift
//  MacPersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var user = User()
    var body: some View {
        ChatView()
            .environmentObject(user)
    }
}
