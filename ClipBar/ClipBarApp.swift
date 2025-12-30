//
//  ClipBarApp.swift
//  ClipBar
//
//  Created by Sanjeev on 30/12/25.
//

import SwiftUI

@main
struct ClipBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
