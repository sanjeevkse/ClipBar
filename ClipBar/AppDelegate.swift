//
//  AppDelegate.swift
//  ClipBar
//

import Cocoa
import SwiftUI
import ServiceManagement

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    let clipboard = ClipboardManager()

    private var rebuildPending = false
    private let onboardingKey = "hasShownOnboarding"

    // MARK: - App Launch

    func applicationDidFinishLaunching(_ notification: Notification) {

        // 1️⃣ Launch at login (respect user choice)
        handleLaunchAtLogin()

        // 2️⃣ Show onboarding only on FIRST login launch
        if isLoginLaunch() {
            showOnboardingIfNeeded()
        }

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "📋"

        clipboard.onChange = { [weak self] in
            self?.scheduleRebuildMenu()
        }

        clipboard.start()
        rebuildMenu()
    }

    // MARK: - Launch at Login (Detection + Respect)

    private func handleLaunchAtLogin() {
        let service = SMAppService.mainApp

        switch service.status {
        case .notRegistered:
            do {
                try service.register()
            } catch {
                NSLog("Failed to register launch at login: \(error)")
            }

        case .enabled:
            // Already enabled — do nothing
            break

        case .requiresApproval:
            // User explicitly disabled it — respect that
            break

        @unknown default:
            break
        }
    }

    // MARK: - Detect Login Launch (Apple-approved)

    private func isLoginLaunch() -> Bool {
        let sharedEventManager = NSAppleEventManager.shared()
        let event = sharedEventManager.currentAppleEvent
        return event?.eventID == kAEOpenApplication &&
               event?.paramDescriptor(forKeyword: keyAEPropData)?
                    .enumCodeValue == keyAELaunchedAsLogInItem
    }

    // MARK: - One-Time Onboarding (with checkbox)

    private func showOnboardingIfNeeded() {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: onboardingKey) else { return }

        let alert = NSAlert()
        alert.messageText = "Welcome to ClipBar"
        alert.informativeText = """
ClipBar runs in the menu bar and starts automatically when you log in.

You can disable this anytime in:
System Settings → General → Login Items
"""
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Got it")

        // ✅ Apple-style checkbox (checked by default)
        let checkbox = NSButton(
            checkboxWithTitle: "Don’t show again",
            target: nil,
            action: nil
        )
        checkbox.state = .on
        alert.accessoryView = checkbox

        alert.runModal()

        if checkbox.state == .on {
            defaults.set(true, forKey: onboardingKey)
        }
    }

    // MARK: - Safe Menu Rebuild

    func scheduleRebuildMenu() {
        guard !rebuildPending else { return }
        rebuildPending = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let self else { return }
            self.rebuildPending = false
            self.rebuildMenu()
        }
    }

    // MARK: - Menu

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
                pinnedMenu.addItem(m)
            }
        }

        let pinnedParent = NSMenuItem(title: "📌 Pinned", action: nil, keyEquivalent: "")
        menu.addItem(pinnedParent)
        menu.setSubmenu(pinnedMenu, for: pinnedParent)

        menu.addItem(NSMenuItem.separator())

        // 📋 History
        if clipboard.history.isEmpty {
            let empty = NSMenuItem(title: "No history", action: nil, keyEquivalent: "")
            empty.isEnabled = false
            menu.addItem(empty)
        } else {
            for item in clipboard.history {
                let menuItem = NSMenuItem(title: item.preview,
                                          action: #selector(paste(_:)),
                                          keyEquivalent: "")
                menuItem.representedObject = item

                let actionMenu = NSMenu()
                let pinItem = NSMenuItem(
                    title: clipboard.pinned.contains(where: { $0.id == item.id }) ? "Unpin" : "Pin",
                    action: #selector(togglePin(_:)),
                    keyEquivalent: ""
                )
                pinItem.representedObject = item
                actionMenu.addItem(pinItem)

                menuItem.submenu = actionMenu
                menu.addItem(menuItem)
            }
        }

        menu.addItem(NSMenuItem.separator())

        // History size
        let historyMenu = NSMenu()
        [10, 20, 50].forEach { size in
            let item = NSMenuItem(title: "\(size)",
                                  action: #selector(setHistorySize(_:)),
                                  keyEquivalent: "")
            item.state = clipboard.maxHistory == size ? .on : .off
            item.representedObject = size
            historyMenu.addItem(item)
        }

        let historyParent = NSMenuItem(title: "History Size", action: nil, keyEquivalent: "")
        menu.addItem(historyParent)
        menu.setSubmenu(historyMenu, for: historyParent)

        menu.addItem(NSMenuItem.separator())

        let pauseItem = NSMenuItem(
            title: clipboard.isPaused ? "▶ Resume Clipboard" : "⏸ Pause Clipboard",
            action: #selector(togglePause),
            keyEquivalent: ""
        )
        menu.addItem(pauseItem)

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: "Clear History",
                                action: #selector(clearClipboard),
                                keyEquivalent: "c"))
        menu.addItem(NSMenuItem(title: "Quit",
                                action: #selector(quit),
                                keyEquivalent: "q"))

        statusItem.menu = menu
    }

    // MARK: - Actions

    @objc func paste(_ sender: NSMenuItem) {
        guard let item = sender.representedObject as? ClipboardItem else { return }
        clipboard.paste(item)
    }

    @objc func togglePin(_ sender: NSMenuItem) {
        guard let item = sender.representedObject as? ClipboardItem else { return }
        clipboard.pinned.contains(where: { $0.id == item.id })
            ? clipboard.unpin(item)
            : clipboard.pin(item)
    }

    @objc func setHistorySize(_ sender: NSMenuItem) {
        guard let size = sender.representedObject as? Int else { return }
        clipboard.maxHistory = size
        scheduleRebuildMenu()
    }

    @objc func togglePause() {
        clipboard.isPaused.toggle()
        scheduleRebuildMenu()
    }

    @objc func clearClipboard() {
        clipboard.clear()
    }

    @objc func quit() {
        NSApp.terminate(nil)
    }
}
