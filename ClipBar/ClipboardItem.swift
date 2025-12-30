//
//  ClipboardItem.swift
//  ClipBar
//

import Foundation

struct ClipboardItem: Identifiable, Codable, Equatable {

    let id: UUID
    let type: ClipboardItemType
    let value: String
    let createdAt: Date

    init(type: ClipboardItemType, value: String) {
        self.id = UUID()
        self.type = type
        self.value = value
        self.createdAt = Date()
    }

    // Text shown in menu
    var preview: String {
        switch type {
        case .file:
            return URL(fileURLWithPath: value).lastPathComponent

        case .text:
            return value.count > 60
                ? String(value.prefix(60)) + "…"
                : value

        case .image:
            return "Image"
        }
    }

    // Used by Quick Look
    var quickLookURL: URL {
        switch type {
        case .file:
            return URL(fileURLWithPath: value)

        case .text:
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(id.uuidString + ".txt")
            try? value.write(to: tempURL, atomically: true, encoding: .utf8)
            return tempURL

        case .image:
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(id.uuidString + ".png")
            if let data = Data(base64Encoded: value) {
                try? data.write(to: tempURL)
            }
            return tempURL
        }
    }
}
