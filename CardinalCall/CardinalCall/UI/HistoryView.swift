//
//  HistoryView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/31.
//
import SwiftUI
import SwiftData
import MapKit

struct HistoryView: View {
    @Query(sort: \Recording.timestamp, order: .reverse) var recordings: [Recording]
    @State private var selectedRecording: Recording?

    var body: some View {
        NavigationStack {
            VStack {
                Text("Total recordings: \(recordings.count)")
                    .padding(.top)

                List(recordings) { recording in
                    Button {
                        selectedRecording = recording
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(recording.birdName)
                                .font(.headline)
                            Text(recording.timestamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if let lat = recording.latitude, let lon = recording.longitude {
                                Text(String(format: "Location: %.4f, %.4f", lat, lon))
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            } else {
                                Text("Location: Unknown")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recording History")
            .sheet(item: $selectedRecording) { recording in
                if let lat = recording.latitude, let lon = recording.longitude {
                    RecordingMapView(
                        coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                        birdName: recording.birdName
                    )
                } else {
                    Text("No location available for this recording.")
                        .padding()
                }
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

    return HistoryView().modelContainer(container)
}
