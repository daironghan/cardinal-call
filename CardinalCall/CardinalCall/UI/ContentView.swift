//
//  ContentView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var matcher = BirdMatcher()
    @State private var isListening = false

    var matchedBird: Bird? {
        BirdDatabase.shared.bird(for: matcher.matchResult?.shazamID)
    }

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(isListening ? "Listening..." : "")
                    .font(.title2)

                Button(action: {
                    isListening ? matcher.stopListening() : matcher.startListening()
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
                    Text("No match yet.")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .navigationTitle("CardinalCall")
        }
    }

}


#Preview {
    ContentView()
}
