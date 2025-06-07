//
//  RecordingMapView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/6/2.
//
import SwiftUI
import MapKit

struct RecordingMapView: View {
    // MARK: Data In
    let coordinate: CLLocationCoordinate2D
    let birdName: String
    @Environment(\.dismiss) private var dismiss
    
    // MARK: Body
    var body: some View {
        NavigationStack {
            Map(initialPosition: .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )) {
                Marker(birdName, coordinate: coordinate)
            }
            .mapControls {
                MapCompass()
                MapUserLocationButton()
            }
            .navigationTitle(birdName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RecordingMapView(
        coordinate: CLLocationCoordinate2D(latitude: 37.4275, longitude: -122.1697), 
        birdName: "Oak Titmouse"
    )
}

