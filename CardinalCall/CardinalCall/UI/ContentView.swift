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

//  Created by ChatGPT on 2025/6/3.
//  Prompt: "Create a preview for this view using the format from the Birds.json file"
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Recording.self, configurations: config)

    let context = container.mainContext
    let birds: [(id: String, name: String, lat: Double, lon: Double)] = [
        ("1", "American Robin", 37.4275, -122.1697),
        ("2", "Chestnut-backed Chickadee", 37.45, -122.18),
        ("3", "White-crowned Sparrow", 37.44, -122.16),
        ("4", "California Scrub Jay", 37.443, -122.165),
        ("5", "Oak Titmouse", 37.435, -122.162),
        ("6", "Acorn Woodpecker", 37.438, -122.17),
        ("7", "Dark-eyed Junco", 37.431, -122.175),
        ("8", "California Towhee", 37.429, -122.168)
    ]

    for bird in birds {
        let recording = Recording(birdID: bird.id, birdName: bird.name)
        recording.latitude = bird.lat
        recording.longitude = bird.lon
        context.insert(recording)
    }

    return ContentView()
        .modelContainer(container)
}
