import Cocoa

final class MenuController {

    private let statusItem: NSStatusItem
    private let clipboard: ClipboardManager
    private let loginItem: LoginItemManager
    private let quickLook: QuickLookController

    init(
        clipboard: ClipboardManager,
        loginItem: LoginItemManager,
        quickLook: QuickLookController
    ) {
        self.clipboard = clipboard
        self.loginItem = loginItem
        self.quickLook = quickLook

        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem.button?.title = "📋"
    }

    // MARK: - Menu rebuild

    func rebuildMenu() {
        let menu = NSMenu()

        // 📌 Pinned
        let pinnedMenu = NSMenu()
        if clipboard.pinned.isEmpty {
            let empty = NSMenuItem(title: "No pinned items", action: nil, keyEquivalent: "")
            empty.isEnabled = false
            pinnedMenu.addItem(empty)
        } else {
            for item in clipboard.pinned {
                let m = NSMenuItem(title: item.preview,
                                   action: #selector(paste(_:)),
                                   keyEquivalent: "")
                m.representedObject = item
                m.target = self
                pinnedMenu.addItem(m)
            }
        }

        let pinnedParent = NSMenuItem(title: "📌 Pinned", action: nil, keyEquivalent: "")
        menu.addItem(pinnedParent)
        menu.setSubmenu(pinnedMenu, for: pinnedParent)

        menu.addItem(NSMenuItem.separator())

        // 📋 History
        for item in clipboard.history {
            let menuItem = NSMenuItem(title: item.preview,
                                      action: #selector(paste(_:)),
                                      keyEquivalent: "")
            menuItem.representedObject = item
            menuItem.target = self

            let actionMenu = NSMenu()

            let previewItem = NSMenuItem(
                title: "Quick Look",
                action: #selector(preview(_:)),
                keyEquivalent: " "
            )
            previewItem.representedObject = item
            previewItem.target = self
            actionMenu.addItem(previewItem)

            let pinItem = NSMenuItem(
                title: clipboard.pinned.contains(where: { $0.id == item.id }) ? "Unpin" : "Pin",
                action: #selector(togglePin(_:)),
                keyEquivalent: ""
            )
            pinItem.representedObject = item
            pinItem.target = self
            actionMenu.addItem(pinItem)

            menuItem.submenu = actionMenu
            menu.addItem(menuItem)
        }

        menu.addItem(NSMenuItem.separator())

        // 📏 History size submenu
        let historyMenu = NSMenu()
        [10, 20, 50].forEach { size in
            let item = NSMenuItem(
                title: "\(size)",
                action: #selector(setHistorySize(_:)),
                keyEquivalent: ""
            )
            item.representedObject = size
            item.state = clipboard.maxHistory == size ? .on : .off
            item.target = self
            historyMenu.addItem(item)
        }

        let historyParent = NSMenuItem(title: "History Size", action: nil, keyEquivalent: "")
        menu.addItem(historyParent)
        menu.setSubmenu(historyMenu, for: historyParent)

        menu.addItem(NSMenuItem.separator())

        // ⏸ Pause / Resume
        let pauseItem = NSMenuItem(
            title: clipboard.isPaused ? "▶ Resume Clipboard" : "⏸ Pause Clipboard",
            action: #selector(togglePause),
            keyEquivalent: ""
        )
        pauseItem.target = self
        menu.addItem(pauseItem)

        // 🧹 Clear history
        let clearItem = NSMenuItem(
            title: "Clear History",
            action: #selector(clearHistory),
            keyEquivalent: "c"
        )
        clearItem.target = self
        menu.addItem(clearItem)

        menu.addItem(NSMenuItem.separator())

        // ℹ️ Launch at login status (read-only)
        let loginStatus = NSMenuItem(
            title: loginItem.statusText,
            action: nil,
            keyEquivalent: ""
        )
        loginStatus.isEnabled = false
        menu.addItem(loginStatus)

        menu.addItem(NSMenuItem.separator())

        // ❌ Quit
        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(quit),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    // MARK: - Actions

    @objc private func paste(_ sender: NSMenuItem) {
        guard let item = sender.representedObject as? ClipboardItem else { return }
        clipboard.paste(item)
    }

    @objc private func preview(_ sender: NSMenuItem) {
        guard let item = sender.representedObject as? ClipboardItem else { return }
        quickLook.preview(item)
    }

    @objc private func togglePin(_ sender: NSMenuItem) {
        guard let item = sender.representedObject as? ClipboardItem else { return }
        clipboard.pinned.contains(where: { $0.id == item.id })
            ? clipboard.unpin(item)
            : clipboard.pin(item)
    }

    @objc private func setHistorySize(_ sender: NSMenuItem) {
        guard let size = sender.representedObject as? Int else { return }
        clipboard.maxHistory = size
        rebuildMenu()
    }

    @objc private func togglePause() {
        clipboard.isPaused.toggle()
        rebuildMenu()
    }

    @objc private func clearHistory() {
        clipboard.clear()
        rebuildMenu()
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
