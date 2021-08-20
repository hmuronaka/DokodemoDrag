//
//  StatusBarItem.swift
//  MouseHookSample
//
//  Created by MuronakaHiroaki on 2021/08/20.
//

import Cocoa

class StatusBarItem {
    static let instance = StatusBarItem()
    private var nsStatusItem: NSStatusItem?
    private var added: Bool = false
    public var statusMenu: NSMenu? {
        didSet {
            nsStatusItem?.menu = statusMenu
        }
    }
    
    private init() {
    }
    
    public func refreshVisibility() {
        add()
    }
    
    public func openMenu() {
        if !added {
            add()
        }
        nsStatusItem?.button?.performClick(self)
        refreshVisibility()
    }
    
    private func add() {
        added = true
        nsStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        nsStatusItem?.menu = self.statusMenu
        nsStatusItem?.button?.image = NSImage(named: "StatusTemplate")
        if #available(OSX 10.12, *) {
            nsStatusItem?.behavior = .removalAllowed
        }
    }
    
    private func remove() {
        added = false
        guard let nsStatusItem = nsStatusItem else { return }
        NSStatusBar.system.removeStatusItem(nsStatusItem)
    }
}