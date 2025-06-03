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
        VStack(spacing: 20) {
            if !bird.imageName.isEmpty, let image = UIImage(named: bird.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxHeight: 200)
                    .overlay(Text("No Image").foregroundColor(.gray))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(bird.name)
                    .font(.title)
                    .bold()
                
                Text("\(bird.scientific)")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text(bird.description)
                    .font(.body)

                if let url = URL(string: bird.info) {
                    Button(action: {
                        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == nil {
                            UIApplication.shared.open(url)
                        } else {
                            print("Preview: would open \(url.absoluteString)")
                        }
                    }) {
                        Label("Learn more", systemImage: "arrow.up.right.square")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.top, 8)
                    }
                }
            }

            Spacer()
        }
        .padding(40)
    }
}

#Preview {
    BirdInfoView(bird: Bird(
        id: "XC794296",
        name: "Oak Titmouse",
        scientific: "Baeolophus inornatus",
        imageName: "OakTitmouse",
        habitat: "Open woodlands",
        description: "Common resident throughout campus, nesting in natural cavities and old woodpecker holes. Territories often adjoin those of the Chestnut-backed Chickadee, which see. Oak titmice are usually found in or near oak-dominated areas, being more strictly tied to oaks than the Chestnut-backed Chickadee.",
        info: "https://www.allaboutbirds.org/guide/Oak_Titmouse"
    ))
}
