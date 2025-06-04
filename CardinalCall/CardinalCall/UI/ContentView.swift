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
                    Label("Listen", systemImage: "mic.fill")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Recording.self, configurations: config)

    let context = container.mainContext
    let mock1 = Recording(birdID: "1", birdName: "Hello World")
    mock1.latitude = 37.4275
    mock1.longitude = -122.1697

    let mock2 = Recording(birdID: "2", birdName: "DDD")
    mock2.latitude = 37.45
    mock2.longitude = -122.18

    let mock3 = Recording(birdID: "3", birdName: "CCC")
    mock3.latitude = 37.44
    mock3.longitude = -122.16
    
    let mock4 = Recording(birdID: "2", birdName: "DDD")
    mock4.latitude = 37.44
    mock4.longitude = -122.161

    context.insert(mock1)
    context.insert(mock2)
    context.insert(mock3)
    context.insert(mock4)

    return ContentView()
        .modelContainer(container)
}
