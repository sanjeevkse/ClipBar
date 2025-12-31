import Foundation
import Cocoa

class UpdateChecker {
    
    // Configuration
    private let owner = "sanjeevkse"
    private let repo = "ClipBar"
    private let checkIntervalSeconds = 86400  // 24 hours
    
    // UserDefaults keys
    private let lastCheckKey = "clipbar.lastUpdateCheck"
    
    // State
    private(set) var isChecking = false
    private(set) var updateAvailable: (version: String, url: URL)? = nil
    
    var onUpdateStatusChanged: (() -> Void)?
    
    // MARK: - Public API
    
    /// Check for updates with caching (24-hour minimum between auto-checks)
    func checkForUpdates(force: Bool = false) {
        guard !isChecking else { return }
        
        // Honor cache unless forced
        if !force && !shouldCheckNow() {
            return
        }
        
        isChecking = true
        fetchLatestRelease()
    }
    
    /// Current local version
    var localVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    }
    
    // MARK: - Private Implementation
    
    private func shouldCheckNow() -> Bool {
        let lastCheck = UserDefaults.standard.double(forKey: lastCheckKey)
        let now = Date().timeIntervalSince1970
        return (now - lastCheck) > Double(checkIntervalSeconds)
    }
    
    private func fetchLatestRelease() {
        let urlString = "https://api.github.com/repos/\(owner)/\(repo)/releases/latest"
        guard let url = URL(string: urlString) else {
            finishCheck(error: "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 5  // 5-second timeout
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.handleResponse(data: data, response: response, error: error)
        }.resume()
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        defer {
            DispatchQueue.main.async { [weak self] in
                self?.isChecking = false
            }
        }
        
        // Fail silently on any error
        guard let data = data else {
            finishCheck(error: "No data")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            // Rate limited
            if httpResponse.statusCode == 403 {
                finishCheck(error: "Rate limited")
                return
            }
            // Not found
            if httpResponse.statusCode == 404 {
                finishCheck(error: "Repository not found")
                return
            }
        }
        
        do {
            let json = try JSONDecoder().decode(ReleaseInfo.self, from: data)
            let remoteVersion = json.tag_name.trimmingCharacters(in: CharacterSet(charactersIn: "v"))
            
            DispatchQueue.main.async { [weak self] in
                self?.compareVersions(local: self?.localVersion ?? "", remote: remoteVersion, releaseUrl: json.html_url)
            }
        } catch {
            finishCheck(error: "Parse error")
        }
    }
    
    private func compareVersions(local: String, remote: String, releaseUrl: String) {
        let localParts = local.split(separator: ".").compactMap { Int($0) }
        let remoteParts = remote.split(separator: ".").compactMap { Int($0) }
        
        var localNormalized = localParts + Array(repeating: 0, count: max(0, 3 - localParts.count))
        var remoteNormalized = remoteParts + Array(repeating: 0, count: max(0, 3 - remoteParts.count))
        
        // Compare major.minor.patch
        for i in 0..<3 {
            if remoteNormalized[i] > localNormalized[i] {
                if let url = URL(string: releaseUrl) {
                    updateAvailable = (version: remote, url: url)
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastCheckKey)
                    DispatchQueue.main.async { [weak self] in
                        self?.onUpdateStatusChanged?()
                    }
                }
                return
            } else if remoteNormalized[i] < localNormalized[i] {
                break
            }
        }
        
        // No update available
        updateAvailable = nil
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastCheckKey)
        DispatchQueue.main.async { [weak self] in
            self?.onUpdateStatusChanged?()
        }
    }
    
    private func finishCheck(error: String) {
        isChecking = false
        updateAvailable = nil
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastCheckKey)
        DispatchQueue.main.async { [weak self] in
            self?.onUpdateStatusChanged?()
        }
    }
}

// MARK: - GitHub API Response Model

private struct ReleaseInfo: Decodable {
    let tag_name: String
    let html_url: String
}
