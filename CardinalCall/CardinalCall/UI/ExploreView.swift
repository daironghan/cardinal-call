//
//  ExploreView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/31.
//

import SwiftUI

struct ExploreView: View {
    let birds = BirdDatabase.shared
    @Namespace private var imageNamespace


    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Explore birds around Stanford")
                    .font(.title3)
                    .bold()
            }
            // Top divider line
            Rectangle()
                .frame(maxHeight: 0.5)
                .foregroundColor(Color(UIColor.separator))
  
            List {
              ForEach(birds.allBirds.sorted(by: { $0.name < $1.name }), id: \.id) { bird in
                    NavigationLink(destination: BirdInfoView(bird: bird)) {
                        HStack {
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

                    }
                }
                
            }
            .listStyle(.plain)
        }
        .padding()
        
    }
}


#Preview {
    ExploreView()
}
