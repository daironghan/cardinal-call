//
//  ExploreView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/31.
//

import SwiftUI

struct ExploreView: View {
    let birds = BirdDatabase.shared

    var body: some View {
        NavigationStack {
            List {
                ForEach(birds.allBirds.sorted(by: { $0.name < $1.name }), id: \.id) { bird in
                    NavigationLink(destination: BirdInfoView(bird: bird)) {
                        HStack(spacing: 12) {
                            if !bird.imageName.isEmpty, let uiImage = UIImage(named: bird.imageName) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .overlay(Text("No Image").font(.caption2).foregroundColor(.gray))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }

                            Text(bird.name)
                                .font(.headline)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Explore birds around Stanford")
        }
        
    }
}


#Preview {
    ExploreView()
}
