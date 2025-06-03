//
//  HistoryView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/31.
//
import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \Recording.timestamp, order: .reverse) var recordings: [Recording]

    var body: some View {
        NavigationStack {
            Text("Total recordings: \(recordings.count)")

            List(recordings) { recording in
                VStack(alignment: .leading) {
                    Text(recording.birdName)
                        .font(.headline)
                    Text(recording.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Recording History")
            
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Recording.self, configurations: config)

    // Insert mock data for preview
    let context = container.mainContext
    context.insert(Recording(birdID: "1", birdName: "Mock Bird A"))
    context.insert(Recording(birdID: "2", birdName: "Mock Bird B"))

    return HistoryView()
        .modelContainer(container)
}
