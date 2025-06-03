//
//  Recording.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/6/2.
//

import Foundation
import SwiftData

@Model
class Recording: Identifiable {
    var id: UUID
    var birdID: String
    var birdName: String
    var timestamp: Date

    init(birdID: String, birdName: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.birdID = birdID
        self.birdName = birdName
        self.timestamp = timestamp
    }
}
