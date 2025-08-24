//
//  CardinalCallApp.swift
//  CardinalCall
//
//  Created by dairong on 2025/5/23.
//

import SwiftUI
import SwiftData

@main
struct CardinalCallApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Recording.self)
    }
}
