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
        var usedColors: [Color] = []
        let baseColors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .brown, .teal, .mint, .indigo, .cyan]

        for recording in validRecordings {
            let species = recording.birdName
            if colorMap[species] == nil {
                let color = baseColors[colorMap.count % baseColors.count]
                colorMap[species] = color
                usedColors.append(color)
            }
        }
        return colorMap
    }
    
    var body: some View {
        NavigationStack {
            Map(coordinateRegion: $region, annotationItems: validRecordings) { recording in
                MapAnnotation(coordinate: recording.coordinate!) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(speciesColors[recording.birdName, default: .accentColor])
                        Text(recording.birdName)
                            .font(.caption2)
                            .padding(4)
                            .background(Color.white.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
            }
            .mapStyle(.standard)
            .navigationTitle("Recording Map")
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

    return MapView().modelContainer(container)
}

