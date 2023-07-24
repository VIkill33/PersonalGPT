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
                .background(VisualEffect())
                .ignoresSafeArea(.all)
                .environmentObject(user)
                .environmentObject(settings)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            Menus(user: self.user, settings: self.settings)
        }
        SwiftUI.Settings {
            SettingView()
                .environmentObject(user)
                .environmentObject(settings)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


struct VisualEffect: NSViewRepresentable {
    func makeNSView(context: Self.Context) -> NSView {
        let VEView = NSVisualEffectView()
        VEView.material = .mediumLight
        // or VEView.appearance = NSAppearance(named: .aqua)
        return VEView
        
    }
  func updateNSView(_ nsView: NSView, context: Context) { }
}
