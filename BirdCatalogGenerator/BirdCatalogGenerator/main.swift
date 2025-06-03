//
//  main.swift
//  BirdCatalogGenerator
//
//  Created by ChatGPT4 on 2025/5/23.
//  Prompt1: "How to "Generate the .shazamcatalog file using your 15+ bird call audio clips with the shazam signaturegenerator CLI tool (we can walk through that if needed).""
//  Prompt2: "Maybe this will help? I saw it on GitHub, https://gist.github.com/jazzychad/43e1331ece5332a4b0e709faf1d5c4a6#file-shazamkitcataloggeneration-swift"

import Foundation
import AVFoundation
import ShazamKit

let birdCallsDir = URL(fileURLWithPath: "/Users/dairong/Documents/Stanford/2025Spring/CS193P/final-project-daironghan/BirdCalls", isDirectory: true)
let outputCatalogURL = birdCallsDir.appendingPathComponent("BirdCalls.shazamcatalog")

func loadAudioBuffer(from url: URL) throws -> AVAudioPCMBuffer {
    let file = try AVAudioFile(forReading: url)
    let newFormat = AVAudioFormat(standardFormatWithSampleRate: 48000, channels: 1)!
    let converter = AVAudioConverter(from: file.processingFormat, to: newFormat)!

    guard let inputBuffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length)) else {
        throw NSError(domain: "BufferError", code: -1, userInfo: nil)
    }
    try file.read(into: inputBuffer)

    guard let outputBuffer = AVAudioPCMBuffer(pcmFormat: newFormat, frameCapacity: AVAudioFrameCount(file.length)) else {
        throw NSError(domain: "BufferError", code: -1, userInfo: nil)
    }

    var error: NSError?
    let inputBlock: AVAudioConverterInputBlock = { inNumPackets, outStatus in
        outStatus.pointee = .haveData
        return inputBuffer
    }

    converter.convert(to: outputBuffer, error: &error, withInputFrom: inputBlock)

    if let error = error {
        throw error
    }

    return outputBuffer
}

func splitCamelCase(_ text: String) -> String {
    return text.replacingOccurrences(
        of: "([a-z])([A-Z])",
        with: "$1 $2",
        options: .regularExpression
    )
}

func extractMetadata(from filename: String) -> (title: String, id: String) {
    let base = filename
        .replacingOccurrences(of: ".wav", with: "")
        .replacingOccurrences(of: ".mp3", with: "")
    
    let parts = base.split(separator: "_")
    
    guard parts.count >= 4 else {
        return ("Unknown Title", "UnknownID")
    }
    
    let id = String(parts[0]) // e.g., "XC941857"
    let commonRaw = String(parts[1]) // e.g., "White-crownedSparrow"
    let title = splitCamelCase(commonRaw.replacingOccurrences(of: "-", with: " "))
    
    return (title, id)
}

func generateCatalog() throws {
    let fileManager = FileManager.default
    let audioFiles = try fileManager.contentsOfDirectory(at: birdCallsDir, includingPropertiesForKeys: nil)
        .filter { ["mp3", "wav"].contains($0.pathExtension.lowercased()) }

    let catalog = SHCustomCatalog()

    for fileURL in audioFiles {
        print("Processing \(fileURL.lastPathComponent)")
        let buffer = try loadAudioBuffer(from: fileURL)
        let signatureGenerator = SHSignatureGenerator()
        try signatureGenerator.append(buffer, at: nil)
        let signature = signatureGenerator.signature()

        let (title, id) = extractMetadata(from: fileURL.lastPathComponent)

        let mediaItem = SHMediaItem(properties: [
            .title: title,
            .shazamID: id
        ])

        try catalog.addReferenceSignature(signature, representing: [mediaItem])
        print("Added \(title) [\(id)]")
    }

    try catalog.write(to: outputCatalogURL)
    print("Catalog saved to \(outputCatalogURL.path)")
}

do {
    print("Current directory: \(FileManager.default.currentDirectoryPath)")
    try generateCatalog()
} catch {
    print("Error: \(error.localizedDescription)")
}



