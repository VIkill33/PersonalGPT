//
//  PersonalGPTApp.swift
//  PersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI

@main
struct PersonalGPTApp: App {
    @StateObject private var user = User()
    @StateObject private var settings = Settings()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(settings)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
