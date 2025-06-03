//
//  RecordView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/31.
//

import SwiftUI
import SwiftData

struct RecordView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var matcher = BirdMatcher()
    @StateObject private var locationManager = LocationManager()

    @State private var isListening = false
    @State private var didMatch = false

    var matchedBird: Bird? {
        BirdDatabase.shared.bird(for: matcher.matchResult?.shazamID)
    }

    private func startRecording() {
        matcher.startListening()
        isListening = true
        didMatch = false
    }

    private func stopRecording() {
        matcher.stopListening()
        isListening = false

        if matchedBird != nil {
            saveMatchIfNeeded()
            didMatch = true
        } else {
            matcher.matchResult = nil
        }
    }

    private func saveMatchIfNeeded() {
        if let bird = matchedBird {
            let latitude = locationManager.location?.coordinate.latitude
            let longitude = locationManager.location?.coordinate.longitude

            let record = Recording(
                birdID: bird.id,
                birdName: bird.name,
                latitude: latitude,
                longitude: longitude
            )
            modelContext.insert(record)
            print("Saved record \(bird.name) @ \(latitude ?? 0), \(longitude ?? 0)")
        } else {
            print("No match to save")
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text(isListening ? "Listening…" :
                     didMatch ? "Match found! Saved to history." :
                     "Ready to record")
                    .font(.title2)
                    .foregroundColor(.secondary)

                if let bird = matchedBird, didMatch {
                    NavigationLink(destination: BirdInfoView(bird: bird)) {
                        VStack {
                            Text("Matched Bird:")
                                .font(.headline)
                            Text(bird.name)
                                .font(.title)
                                .bold()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Button("New Recording") {
                        matcher.matchResult = nil
                        didMatch = false
                        isListening = false
                    }
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.top)
                } else {
                    Button(action: {
                        isListening ? stopRecording() : startRecording()
                    }) {
                        Text(isListening ? "Stop" : "Start")
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isListening ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding()
        }
        .onChange(of: matcher.matchResult) {
            if matchedBird != nil && isListening {
                stopRecording()
            }
        }
    }
}

#Preview {
    RecordView()
}

