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
    @StateObject var user = User()
    @StateObject var settings = Settings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(user)
                .environmentObject(settings)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .commands {
            Menus(user: self.user)
        }
        SwiftUI.Settings {
            SettingView()
                .environmentObject(user)
                .environmentObject(settings)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
