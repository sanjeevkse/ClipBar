//
//  LoginItemManager.swift
//  ClipBar
//
//  Created by Sanjeev on 30/12/25.
//


import ServiceManagement
import Cocoa

final class LoginItemManager {

    func enableIfNeeded() {
        let service = SMAppService.mainApp
        if service.status == .notRegistered {
            try? service.register()
        }
    }

    var statusText: String {
        switch SMAppService.mainApp.status {
        case .enabled:
            return "Launch at Login: On"
        default:
            return "Launch at Login: Off"
        }
    }

    var isLoginLaunch: Bool {
        let event = NSAppleEventManager.shared().currentAppleEvent
        return event?.eventID == kAEOpenApplication &&
               event?.paramDescriptor(forKeyword: keyAEPropData)?
                    .enumCodeValue == keyAELaunchedAsLogInItem
    }
}
