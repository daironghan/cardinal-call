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

    @AppStorage("pinnedBirdIDs") private var pinnedBirdIDsRaw: String = ""

    private var pinnedBirdIDs: Set<String> {
        Set(pinnedBirdIDsRaw.split(separator: ",").map { String($0) })
    }

    private func updatePinnedBirdIDs(_ newSet: Set<String>) {
        pinnedBirdIDsRaw = newSet.joined(separator: ",")
    }

    var sortedBirds: [Bird] {
        birds.allBirds.sorted {
            let aPinned = pinnedBirdIDs.contains($0.id)
            let bPinned = pinnedBirdIDs.contains($1.id)
            if aPinned != bPinned {
                return aPinned && !bPinned
            } else {
                return $0.name < $1.name
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Explore birds around Stanford")
                    .font(.title3)
                    .bold()

                Rectangle()
                    .frame(maxHeight: 0.5)
                    .foregroundColor(Color(UIColor.separator))

                List {
                    ForEach(sortedBirds, id: \.id) { bird in
                        HStack {
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    togglePin(for: bird)
                                }
                            } label: {
                                Image(systemName: pinnedBirdIDs.contains(bird.id) ? "pin.fill" : "pin")
                                    .foregroundColor(.accentColor)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(pinnedBirdIDs.contains(bird.id) ? "Unpin \(bird.name)" : "Pin \(bird.name)")
                            
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

                            Spacer()
                        }

                    }
                }
                .listStyle(.plain)
                .animation(.easeInOut(duration: 0.3), value: pinnedBirdIDsRaw)
            }
            .padding()
        }
    }

    private func togglePin(for bird: Bird) {
        var newSet = pinnedBirdIDs
        if newSet.contains(bird.id) {
            newSet.remove(bird.id)
        } else {
            newSet.insert(bird.id)
        }
        updatePinnedBirdIDs(newSet)
    }
}





#Preview {
    ExploreView()
}
