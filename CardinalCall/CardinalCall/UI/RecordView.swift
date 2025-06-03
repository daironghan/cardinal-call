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
    @State private var isListening = false
    @State private var stopTimer: Timer?

    var matchedBird: Bird? {
        BirdDatabase.shared.bird(for: matcher.matchResult?.shazamID)
    }

    private func saveMatchIfNeeded() {
        if let bird = matchedBird {
            
            let record = Recording(birdID: bird.id, birdName: bird.name)
            modelContext.insert(record)
            print("save record \(bird.name)")
        }
        print("not save record")
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(isListening ? "Listening..." : "")
                    .font(.title2)

                Button(action: {
                    if isListening {
                        matcher.stopListening()
                        stopTimer?.invalidate()
                        stopTimer = nil
                        saveMatchIfNeeded()       // Save when stopping
                        matcher.matchResult = nil
                    } else {
                        matcher.startListening()
                        stopTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
                            matcher.stopListening()
                            saveMatchIfNeeded()   // Save when auto-stopping
                            isListening = false
                            matcher.matchResult = nil
                        }
                    }
                    isListening.toggle()
                }) {
                    Text(isListening ? "Stop" : "Start")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isListening ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()

                if let bird = matchedBird {
                    NavigationLink(destination: BirdInfoView(bird: bird)) {
                        VStack {
                            Text("Matched Bird:")
                                .font(.headline)
                            Text(bird.name)
                                .font(.title)
                                .bold()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                } else if !isListening {
                    Text("Start recording.")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }

}


#Preview {
    RecordView()
}
