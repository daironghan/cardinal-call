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
                        Text(bird.name)
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreView()
}
