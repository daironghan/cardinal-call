//
//  ContentView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "binoculars.fill")
                }
            RecordView()
                .tabItem {
                    Label("Record", systemImage: "mic.fill")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
        }
    }
}


#Preview {
    ContentView()
}
