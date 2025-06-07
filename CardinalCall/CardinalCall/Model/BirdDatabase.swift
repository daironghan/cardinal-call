//
//  BirdDatabase.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/30.
//
import Foundation

class BirdDatabase: ObservableObject {
    static let shared = BirdDatabase()

    private var birds: [String: Bird] = [:]

    init() {
        loadBirds()
    }

    private func loadBirds() {
        guard let url = Bundle.main.url(forResource: "Birds", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Bird].self, from: data) else {
            print("Failed to load Birds.json")
            return
        }

        self.birds = Dictionary(uniqueKeysWithValues: decoded.map { ($0.id, $0) })
    }

    func bird(for id: String?) -> Bird? {
        guard let id else { return nil }
        return birds[id]
    }
    
    var allBirds: [Bird] {
        Array(birds.values)
    }
}
