//
//  OnboardingManager.swift
//  ClipBar
//
//  Created by Sanjeev on 30/12/25.
//


import Cocoa

final class OnboardingManager {

    private let onboardingMajorKey = "onboardingMajorVersion"

    func showIfNeeded() {
        let defaults = UserDefaults.standard

        let currentMajor =
            (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)?
                .split(separator: ".")
                .first
                .map(String.init) ?? "0"

        let lastMajor = defaults.string(forKey: onboardingMajorKey)
        guard lastMajor != currentMajor else { return }

        let alert = NSAlert()
        alert.messageText = "Welcome to ClipBar"
        alert.informativeText = """
ClipBar runs in the menu bar and starts automatically when you log in.

You can manage this in:
System Settings → General → Login Items
"""
        alert.addButton(withTitle: "Got it")

        let checkbox = NSButton(
            checkboxWithTitle: "Don’t show again for this version",
            target: nil,
            action: nil
        )
        checkbox.state = .on
        alert.accessoryView = checkbox

        alert.runModal()

        if checkbox.state == .on {
            defaults.set(currentMajor, forKey: onboardingMajorKey)
        }
    }
}
