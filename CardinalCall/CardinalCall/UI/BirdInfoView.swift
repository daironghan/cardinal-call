//
//  BirdInfoView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/30.
//

import SwiftUI

struct BirdInfoView: View {
    let bird: Bird

    var body: some View {
        VStack(spacing: 16) {
            if !bird.imageName.isEmpty, let image = UIImage(named: bird.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 200, maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay(Text("No Image").foregroundColor(.gray))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }

            Text(bird.name)
                .font(.largeTitle)
                .bold()

            Text("Habitat: \(bird.habitat)")
                .font(.headline)
                .foregroundColor(.secondary)

            Text(bird.description)
                .font(.body)
                .padding(.horizontal)

            if let url = URL(string: bird.info) {
                Button(action: {
                    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == nil {
                        UIApplication.shared.open(url)
                    } else {
                        print("Preview: would open \(url.absoluteString)")
                    }
                }) {
                    Text("Learn more")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .underline()
                        .padding(.top, 8)
                }
            }


            Spacer()
        }
        .padding()
        .navigationTitle(bird.name)
    }
}

#Preview {
    BirdInfoView(bird: Bird(
        id: "XC794296",
        name: "Oak Titmouse",
        scientific: "sada",
        imageName: "OakTitmouse", // Add actual image asset name if available
        habitat: "Open woodlands",
        description: "The Oak Titmouse is a small songbird of western oak woodlands.",
        info: "https://www.allaboutbirds.org/guide/Oak_Titmouse"
    ))
}
