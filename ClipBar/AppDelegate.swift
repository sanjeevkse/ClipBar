import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {

    private let clipboard = ClipboardManager()
    private let loginItem = LoginItemManager()
    private let onboarding = OnboardingManager()
    private let quickLook = QuickLookController()
    private let updateChecker = UpdateChecker()
    private var menuController: MenuController!

    func applicationDidFinishLaunching(_ notification: Notification) {

        loginItem.enableIfNeeded()

        if loginItem.isLoginLaunch {
            onboarding.showIfNeeded()
        }

        menuController = MenuController(
            clipboard: clipboard,
            loginItem: loginItem,
            quickLook: quickLook,
            updateChecker: updateChecker
        )

        clipboard.onChange = { [weak self] in
            self?.menuController.rebuildMenu()
        }

        clipboard.start()
        
        // Check for updates on launch (respects 24-hour cache)
        updateChecker.checkForUpdates()
        
        menuController.rebuildMenu()
    }
}

