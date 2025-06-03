//
//  ContentView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "binoculars.fill")
                }
            RecordView()
                .tabItem {
                    Label("Record", systemImage: "mic.fill")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Recording.self, configurations: config)

    let context = container.mainContext
    let mock = Recording(birdID: "1", birdName: "Mock Bird A")
    mock.latitude = 37.4
    mock.longitude = -122.1
    context.insert(mock)

    return ContentView()
        .modelContainer(container)
}
