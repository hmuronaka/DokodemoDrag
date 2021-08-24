//
//  StatusBarItem.swift
//  DokodemoDrag
//
//  Created by MuronakaHiroaki on 2021/08/20.
//

import Cocoa
import Defaults

enum StatusBarMenuItemTag: Int {
    case isLaunchOnLogin = 10
    case enableOrDisable = 20
}


/// MacOSのメニューバーに表示するMenuに対応するクラス
class StatusBarItem {
    static let instance = StatusBarItem()
    
    /// MacOSの右上に配置するMenuに対するインスタンス
    private var nsStatusItem: NSStatusItem?
    private var added: Bool = false
    
    private var observer: Any?
    

    public var statusMenu: NSMenu? {
        didSet {
            nsStatusItem?.menu = statusMenu
            refreshMenu()
        }
    }
    
    private init() {
        self.observer = SettingService.shared.observe() { [unowned self] in
            self.refreshMenu()
        }
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
    
    private func refreshMenu() {
        guard let menu = self.statusMenu else {
            return
        }
        if let isLaunchOnLoginMenuItem = menu.item(withTag: StatusBarMenuItemTag.isLaunchOnLogin.rawValue) {
            isLaunchOnLoginMenuItem.state = SettingService.shared.isLaunchOnLogin ? .on : .off
        }
        
        if let isEnableMenuItem = menu.item(withTag: StatusBarMenuItemTag.enableOrDisable.rawValue) {
            isEnableMenuItem.title = SettingService.shared.isEnable ? NSLocalizedString("Disable", comment: "") : NSLocalizedString("Enable", comment: "")
        }
    }
}
