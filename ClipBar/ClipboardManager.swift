import Cocoa

class ClipboardManager {

    private let historyKey = "clipbar.history"
    private let pinnedKey  = "clipbar.pinned"

    private var changeCount = NSPasteboard.general.changeCount
    private var ignoreNextChange = false

    private(set) var history: [ClipboardItem] = []
    private(set) var pinned: [ClipboardItem] = []

    var maxHistory = 20
    var isPaused = false

    var onChange: (() -> Void)?

    init() {
        history = load(key: historyKey)
        pinned  = load(key: pinnedKey)
    }

    // MARK: - Persistence

    private func save() {
        save(history, key: historyKey)
        save(pinned, key: pinnedKey)
    }

    private func save(_ items: [ClipboardItem], key: String) {
        let data = try? JSONEncoder().encode(items)
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load(key: String) -> [ClipboardItem] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let items = try? JSONDecoder().decode([ClipboardItem].self, from: data)
        else { return [] }
        return items
    }

    // MARK: - Start watching

    func start() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }

    // MARK: - Clipboard detection

    private func checkClipboard() {
        guard !isPaused else { return }

        let pb = NSPasteboard.general
        if pb.changeCount == changeCount { return }
        changeCount = pb.changeCount
        
        // Skip this change if it was triggered by our own paste operation
        if ignoreNextChange {
            ignoreNextChange = false
            return
        }

        // TEXT
        if let text = pb.string(forType: .string), !text.isEmpty {
            add(.text, value: text)
            return
        }

        // FILE
        if let files = pb.readObjects(forClasses: [NSURL.self]) as? [URL],
           let file = files.first {
            add(.file, value: file.path)
            return
        }

        // IMAGE
        if let image = NSImage(pasteboard: pb),
           let data = image.tiffRepresentation {
            let b64 = data.base64EncodedString()
            add(.image, value: b64)
            return
        }
    }

    private func add(_ type: ClipboardItemType, value: String) {
        if history.first?.value == value { return }

        let item = ClipboardItem(type: type, value: value)

        history.insert(item, at: 0)
        history = Array(history.prefix(maxHistory))
        save()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.onChange?()
        }
    }

    // MARK: - Actions

    func clear() {
        history.removeAll()
        save()
        onChange?()
    }

    func pin(_ item: ClipboardItem) {
        if !pinned.contains(item) {
            pinned.insert(item, at: 0)
            save()
            onChange?()
        }
    }

    func unpin(_ item: ClipboardItem) {
        pinned.removeAll { $0.id == item.id }
        save()
        onChange?()
    }

    // MARK: - Paste back

    func paste(_ item: ClipboardItem) {
        // Mark that we should ignore the next clipboard change
        // to prevent re-adding this item to history
        ignoreNextChange = true
        
        let pb = NSPasteboard.general
        pb.clearContents()

        switch item.type {
        case .text:
            pb.setString(item.value, forType: .string)

        case .file:
            let url = URL(fileURLWithPath: item.value)
            pb.writeObjects([url as NSURL])

        case .image:
            if let data = Data(base64Encoded: item.value),
               let image = NSImage(data: data) {
                pb.writeObjects([image])
            }
        }
    }
}

