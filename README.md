# ClipBar

A lightweight macOS menu bar clipboard manager that keeps your copy history accessible and organized.

ClipBar is designed for developers and power users who want a simple, local-first clipboard manager.

---

## Features

- Clipboard History – Automatically captures and stores your copy history (configurable limit: 10, 20, or 50 items)
- Pin & Unpin – Mark frequently used items to keep them at the top of your clipboard menu
- Pause Capture – Temporarily stop recording clipboard changes without quitting the app
- Quick Look – Preview clipboard items (text, images, files) directly from the menu
- Menu Bar Integration – Always available, minimal footprint (📋 icon in the menu bar)
- Local Storage – All clipboard data is stored locally; nothing is sent online
- Launch on Login – Option to start ClipBar automatically when you log in

---

## Supported macOS Versions

macOS 14 (Sonoma) and later.

---

## Installation

ClipBar is distributed outside the Mac App Store.  
Choose the installation method that best fits you.

---

### Option 1: Prebuilt App (Recommended)

Download the latest unsigned build:

https://sanjeevkse.github.io/ClipBar/downloads/ClipBar-1.0.1-unsigned.zip

Steps:

1. Download the ZIP file
2. Unzip the archive
3. Drag `ClipBar.app` to the Applications folder
4. Open ClipBar from Applications or Spotlight

macOS will show a security warning on first launch. This is expected.

---

### Option 2: Homebrew (Developers)

```bash
brew tap sanjeevkse/clipbar
brew install --cask clipbar
```

macOS may still show a security warning on first launch.

---

### Option 3: Build from Source (Advanced)

1. Clone the repository:
   ```bash
   git clone https://github.com/sanjeevkse/ClipBar.git
   ```
2. Open `ClipBar.xcodeproj` in Xcode
3. Select your Mac as the run destination
4. Click Run

Build Requirements:

- macOS 14+
- Xcode 15+
- A free Apple ID (for code signing)

---

## Important: First Launch (Gatekeeper)

ClipBar is not notarized by Apple.

On first launch, macOS may show:
"ClipBar" cannot be opened because the developer cannot be verified.

System Settings method:

1. Open System Settings → Privacy & Security
2. Scroll to the security message about ClipBar
3. Click Open Anyway
4. Confirm by clicking Open

Terminal method (advanced):

```bash
xattr -d com.apple.quarantine /Applications/ClipBar.app
```

---

## Updates

ClipBar does not auto-update.

- On launch, ClipBar checks for a newer version (once every 24 hours)
- If an update is available, the menu bar shows: Update Available (vX.Y.Z)
- Click the menu item to open the download page
- Download and install the new version manually

To get notified:

- Visit the GitHub repository
- Click Watch → Releases

---

## Privacy & Security

- Clipboard history is stored only on your Mac
- No data is sent to external servers
- Preferences are stored in ~/Library/Preferences/
- Clipboard capture can be paused at any time

---

## License

MIT License
