//
//  MapView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/6/3.
//

import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @Query(sort: \Recording.timestamp, order: .reverse) var recordings: [Recording]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.4275, longitude: -122.1697),
        span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    )

    /// Cache of unique colors per species
    private var speciesColors: [String: Color] {
        var colorMap: [String: Color] = [:]
        let baseColors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .brown, .teal, .mint, .indigo, .cyan]

        for recording in validRecordings {
            if colorMap[recording.birdName] == nil {
                colorMap[recording.birdName] = baseColors[colorMap.count % baseColors.count]
            }
        }
        return colorMap
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Map(coordinateRegion: $region, annotationItems: validRecordings) { recording in
                    MapAnnotation(coordinate: recording.coordinate!) {
                        Circle()
                            .fill(speciesColors[recording.birdName, default: .accentColor])
                            .frame(width: 10, height: 10)
                    }
                }
                .mapStyle(.standard)

                // Legend View
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(speciesColors.keys.sorted()), id: \.self) { species in
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(speciesColors[species]!)
                                    .frame(width: 12, height: 12)
                                Text(species)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("History Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var validRecordings: [Recording] {
        recordings.filter { $0.coordinate != nil }
    }
}

private extension Recording {
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}



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

    return MapView().modelContainer(container)
}


