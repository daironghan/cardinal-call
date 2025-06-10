//
//  RecordView.swift
//  CardinalCall
//
//  Created by 韓岱融 && ChatGPT on 2025/5/31.
//  Prompt: "I have a custom BirdCalls.shazamcatalog. How do I make the app to record and match to it?"
import SwiftUI
import SwiftData

struct RecordView: View {
    // MARK: Data In
    @Environment(\.modelContext) private var modelContext
    
    // MARK: Data Shared With Me
    @StateObject private var matcher = BirdMatcher()
    @StateObject private var locationManager = LocationManager()
    
    // MARK: Data I Own
    @State private var isListening = false
    @State private var didMatch = false
    @Namespace private var imageNamespace

    var matchedBird: Bird? {
        BirdDatabase.shared.bird(for: matcher.matchResult?.shazamID)
    }
    
    // MARK: Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text(isListening ? "Listening..." :
                     didMatch ? "Match found and saved!" :
                     "Ready to listen")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .animation(.easeInOut, value: isListening || didMatch)

                if let bird = matchedBird, didMatch {
                    VStack(spacing: 16) {
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
                            .foregroundStyle(.primary)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        Button {
                            withAnimation {
                                matcher.matchResult = nil
                                didMatch = false
                                isListening = false
                            }
                        } label: {
                            Label("New Recording", systemImage: "arrow.counterclockwise")
                                .font(.subheadline)
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.secondary)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
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
                            .clipShape(RoundedRectangle(cornerRadius: 16))
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
            withAnimation(.spring()) {
                didMatch = true
            }
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
}


#Preview {
    RecordView()
}

