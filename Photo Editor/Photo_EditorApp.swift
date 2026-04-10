//
//  Photo_EditorApp.swift
//  Photo Editor
//
//  Created by 刘明浩 on 2026/4/8.
//

import SwiftUI

@main
struct Photo_EditorApp: App {
    @StateObject private var dataManager = DataManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager)
        }
    }
}
