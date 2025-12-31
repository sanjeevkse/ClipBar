# ClipBar

A lightweight macOS menu bar clipboard manager that keeps your copy history accessible and organized.

## Features

- **Clipboard History** – Automatically captures and stores your copy history (configurable limit: 10, 20, or 50 items)
- **Pin & Unpin** – Mark frequently used items to keep them at the top of your clipboard menu
- **Pause Capture** – Temporarily stop recording clipboard changes without quitting the app
- **Quick Look** – Preview clipboard items (text, images, files) directly from the menu
- **Menu Bar Integration** – Always available, minimal footprint (📋 icon in the menu bar)
- **Local Storage** – All clipboard data is stored locally; nothing is sent online
- **Launch on Login** – Option to start ClipBar automatically when you log in

## Supported macOS Versions

macOS 14 (Sonoma) and later.

## Installation

### Build from Source

Clone the repository and open the project in Xcode:

```bash
git clone https://github.com/sanjeevkse/ClipBar.git
cd ClipBar/ClipBar
open ClipBar.xcodeproj
```

Build and run:

1. Select **Product > Run** (or press `Cmd+R`)
2. Or build and archive for distribution: **Product > Archive**

**System Requirements:**

- macOS 14+
- Xcode 15+ (for building from source)
- A free Apple ID (for code signing)

## ⚠️ Important: Gatekeeper Warning

**This app is not notarized.** On your first launch, macOS may display a security warning:

```
"ClipBar" cannot be opened because the developer cannot be verified.
```

This is normal for unsigned, open-source applications. To proceed:

1. Open **System Settings > Privacy & Security**
2. Scroll down and find the message about ClipBar
3. Click **Open Anyway**
4. Confirm by clicking **Open** in the dialog

Alternatively, you can allow in Terminal using:

```bash
xattr -d com.apple.quarantine /Applications/ClipBar.app
```

## Usage

### Basic Operations

- **Copy as usual** – ClipBar monitors your clipboard and saves each item automatically
- **Access history** – Click the 📋 icon in the menu bar to see your clipboard history
- **Paste an item** – Click any item in the menu to copy it back to your clipboard
- **View item details** – Hover over an item and click **Quick Look** to preview it

### Managing Items

- **Pin important items** – Click an item's submenu and select **Pin** to keep it at the top
- **Unpin items** – Select **Unpin** from an item's submenu
- **Change history size** – Use the **History Size** menu to keep 10, 20, or 50 items

### Controls

- **Pause clipboard capture** – Click **Pause** in the main menu to temporarily stop recording (useful when handling sensitive data)
- **Resume capture** – Click **Resume** to start recording again
- **Launch on login** – Enable **Launch on Login** in the menu to auto-start ClipBar
- **Quit** – Click **Quit ClipBar** to exit the app

## License

This project is licensed under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to report issues, suggest features, and submit pull requests.

## Privacy & Security

- Your clipboard history is stored **only on your Mac** in `~/Library/Preferences/`
- No data is transmitted to external servers
- ClipBar requires the `NSPasteboardUsageDescription` permission to monitor your clipboard
- You can pause capture at any time, and all history can be cleared by deleting the app's preferences

## Troubleshooting

### ClipBar doesn't start on login

Make sure the app is added to **System Settings > General > Login Items**. You can also enable this from ClipBar's menu.

### History is empty

ClipBar only captures clipboard changes that occur **after** it starts. It does not have access to historical clipboard data from before the app was launched.

### macOS says the app is damaged

This can occur with unsigned apps. See the [Gatekeeper Warning](#-important-gatekeeper-warning) section above.

## Updates

**ClipBar does not auto-update.** Instead:

- On launch, ClipBar checks GitHub for a newer version (once per 24 hours)
- If an update is available, the menu bar shows: **⬆️ Update Available (vX.Y.Z)**
- Click the menu item to open the release page in your browser
- Download and run the latest version from **GitHub Releases**

To stay informed of new releases:

1. Visit the [ClipBar GitHub repository](https://github.com/sanjeevkse/ClipBar)
2. Click **Watch** → **Releases** at the top-right
3. GitHub will notify you by email when a new version is released

**Manual checks:** Click **⬆️ Check for Updates…** in the menu to force an immediate check.

---

**Questions or issues?** Please open an issue on GitHub or reach out to the maintainer.
