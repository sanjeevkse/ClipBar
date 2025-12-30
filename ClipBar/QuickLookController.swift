//
//  QuickLookController.swift
//  ClipBar
//
//  Created by Sanjeev on 30/12/25.
//


import Cocoa
import Quartz


final class QuickLookController:
    NSObject,
    QLPreviewPanelDataSource,
    QLPreviewPanelDelegate {

    private var previewItem: ClipboardItem?

    func preview(_ item: ClipboardItem) {
        previewItem = item

        if let panel = QLPreviewPanel.shared() {
            panel.makeKeyAndOrderFront(nil)
            panel.reloadData()
        }
    }

    // MARK: - Required hooks

    override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
        true
    }

    override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
        panel.dataSource = self
        panel.delegate = self
    }

    override func endPreviewPanelControl(_ panel: QLPreviewPanel!) {
        panel.dataSource = nil
        panel.delegate = nil
    }

    // MARK: - Data Source

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        previewItem == nil ? 0 : 1
    }

    func previewPanel(_ panel: QLPreviewPanel!,
                      previewItemAt index: Int) -> QLPreviewItem {
        previewItem!.quickLookURL as NSURL
    }
}
