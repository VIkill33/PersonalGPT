//
//  MacPersonalGPTApp.swift
//  MacPersonalGPT
//
//  Created by Vikill Blacks on 2023/3/3.
//

import SwiftUI

@main
struct MacPersonalGPTApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var user = User()
    @StateObject private var settings = Settings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(settings)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
#if os(macOS)
        SwiftUI.Settings {
            SettingView()
                .environmentObject(user)
                .environmentObject(settings)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
#endif
    }
}
