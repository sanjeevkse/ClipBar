import Cocoa

enum ClipboardItemType: String, Codable {
    case text
    case file
    case image
    case url
    case rtf
}

struct ClipboardItem: Codable, Equatable {
    let id: UUID
    let type: ClipboardItemType
    let value: String
    let preview: String
    let createdAt: Date

    init(type: ClipboardItemType, value: String, preview: String) {
        self.id = UUID()
        self.type = type
        self.value = value
        self.preview = preview
        self.createdAt = Date()
    }
}
