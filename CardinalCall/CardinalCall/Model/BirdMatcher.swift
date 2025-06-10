//
//  BirdMatcher.swift
//  CardinalCall
//
//  Created by ChatGPT on 2025/5/23.
//  Prompt: "I have a custom BirdCalls.shazamcatalog. How do I make the app to record and match to it?"
import Foundation
import AVFoundation
import ShazamKit

class BirdMatcher: NSObject, ObservableObject, SHSessionDelegate {
    private let audioEngine = AVAudioEngine()
    private var session: SHSession?
    private var catalog: SHCustomCatalog?

    @Published var matchResult: SHMatchedMediaItem?

    override init() {
        super.init()
        loadCatalog()
    }

    private func loadCatalog() {
        guard let catalogURL = Bundle.main.url(forResource: "BirdCalls", withExtension: "shazamcatalog") else {
            print("Catalog file not found in bundle.")
            return
        }

        do {
            let customCatalog = SHCustomCatalog()
            try customCatalog.add(from: catalogURL)
            self.catalog = customCatalog
            self.session = SHSession(catalog: customCatalog)
            self.session?.delegate = self
            print("Custom catalog loaded and session created.")
        } catch {
            print("Failed to load catalog: \(error)")
        }
    }
    
    func startListening() {
        print("Start Listening")

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to configure audio session: \(error)")
            return
        }

        guard audioSession.isInputAvailable else {
            print("Microphone input not available.")
            return
        }

        let inputNode = audioEngine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)

        inputNode.removeTap(onBus: 0) // Prevent duplicate taps
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { [weak self] buffer, _ in
            self?.session?.matchStreamingBuffer(buffer, at: nil)
        }

        do {
            audioEngine.prepare()
            try audioEngine.start()
            print("Audio engine started. Format: \(inputFormat)")
        } catch {
            print("Audio engine failed to start: \(error)")
        }
    }

    func stopListening() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
    }

    func session(_ session: SHSession, didFind match: SHMatch) {
        if let firstItem = match.mediaItems.first {
            DispatchQueue.main.async {
                self.matchResult = firstItem
            }
            print("Match found: \(firstItem.title ?? "Unknown")")
        }
    }

    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        DispatchQueue.main.async {
            self.matchResult = nil
        }
        print("No match found.")
    }
}
