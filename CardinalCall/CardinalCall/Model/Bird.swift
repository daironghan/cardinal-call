//
//  Bird.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/30.
//
import Foundation

struct Bird: Identifiable, Codable {
    var id: String // Matches the ShazamID
    var name: String
    var scientific: String
    var imageName: String
    var habitat: String
    var description: String
}
