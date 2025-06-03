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
    var latitude: Double?
    var longitude: Double?

    init(birdID: String, birdName: String, timestamp: Date = Date(), latitude: Double? = nil, longitude: Double? = nil) {
        self.id = UUID()
        self.birdID = birdID
        self.birdName = birdName
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
    }
}

