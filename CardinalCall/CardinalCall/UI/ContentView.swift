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

    var body: some View {
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

            if let match = matcher.matchResult {
                VStack {
                    Text("Matched Bird:")
                        .font(.headline)
                    Text(match.title ?? "Unknown")
                        .font(.title)
                        .bold()
                    Text("ID: \(match.shazamID ?? "N/A")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            } else if !isListening {
                Text("No match yet.")
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
