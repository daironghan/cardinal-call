//
//  HistoryView.swift
//  CardinalCall
//
//  Created by 韓岱融 on 2025/5/31.
//
import SwiftUI
import SwiftData
import MapKit

struct HistoryView: View {
    @Query(sort: \Recording.timestamp, order: .reverse) var recordings: [Recording]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedRecording: Recording?
    @State private var searchText: String = ""
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = Date()
    @State private var showDatePicker: Bool = false
    @State private var recordingToDelete: Recording?
    @State private var showDeleteConfirmation: Bool = false

    var filteredRecordings: [Recording] {
        guard startDate <= endDate else { return [] }

        let adjustedEndDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: endDate) ?? endDate

        return recordings.filter { recording in
            let matchesName = searchText.isEmpty || recording.birdName.localizedCaseInsensitiveContains(searchText)
            let matchesDate = (startDate...adjustedEndDate).contains(recording.timestamp)
            return matchesName && matchesDate
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("History")
                    .font(.title3)
                    .bold()

                HStack(spacing: 8) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search bird name...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    Button {
                        withAnimation {
                            showDatePicker.toggle()
                        }
                    } label: {
                        Image(systemName: "calendar")
                            .font(.title3)
                            .padding(8)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .accessibilityLabel("Filter by date")
                }

                if showDatePicker {
                    HStack {
//                        DatePicker("From", selection: $startDate, displayedComponents: .date)
//                        DatePicker("To", selection: $endDate, in: startDate..., displayedComponents: .date)
                        DatePicker("From", selection: Binding(
                            get: { startDate },
                            set: { newValue in
                                withAnimation {
                                    startDate = newValue
                                }
                            }), displayedComponents: .date
                        )

                        DatePicker("To", selection: Binding(
                            get: { endDate },
                            set: { newValue in
                                withAnimation {
                                    endDate = newValue
                                }
                            }), in: startDate..., displayedComponents: .date
                        )

                    }
                    .font(.caption)
                    .padding(.horizontal, 4)
                }

                if filteredRecordings.isEmpty {
                    Spacer()
                    Text("No recordings found.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    List {
                        ForEach(filteredRecordings) { recording in
                            HStack{
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(recording.birdName)
                                        .font(.headline)
                                    Text(recording.timestamp.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    if let lat = recording.latitude, let lon = recording.longitude {
                                        Text(String(format: "Location: %.4f, %.4f", lat, lon))
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text("Location: Unknown")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                            }
                            .onTapGesture {
                                selectedRecording = recording
                            }
                            .onLongPressGesture {
                                recordingToDelete = recording
                                showDeleteConfirmation = true
                            }
                        }
                    }
                    .listStyle(.plain)
                    .animation(.easeInOut(duration: 0.3), value: filteredRecordings)
                }
            }
            .padding()
            .sheet(item: $selectedRecording) { recording in
                NavigationStack {
                    if let lat = recording.latitude, let lon = recording.longitude {
                        RecordingMapView(
                            coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                            birdName: recording.birdName
                        )
                        .navigationTitle(recording.birdName)
                        .navigationBarTitleDisplayMode(.inline)
                    } else {
                        Text("No location available for this recording.")
                            .padding()
                    }
                }
            }
            .alert("Delete Recording?", isPresented: $showDeleteConfirmation, presenting: recordingToDelete) { item in
                Button("Delete", role: .destructive) {
                    modelContext.delete(item)
                }
                Button("Cancel", role: .cancel) { }
            } message: { _ in
                Text("Are you sure you want to delete this recording?")
            }

        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Recording.self, configurations: config)

    let context = container.mainContext
    let mock = Recording(birdID: "1", birdName: "Mock Bird A")
    mock.latitude = 37.4
    mock.longitude = -128.1
    
    let mock2 = Recording(birdID: "1", birdName: "Mock Bird Cat")
    mock2.latitude = 37.4
    mock2.longitude = -122.1
    
    let mock3 = Recording(birdID: "2", birdName: "Mock Bird A")
    mock3.latitude = 38.4
    mock3.longitude = -122.1

    
    context.insert(mock)
    context.insert(mock2)
    context.insert(mock3)

    return HistoryView().modelContainer(container)
}
