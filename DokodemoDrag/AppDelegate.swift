//
//  AppDelegate.swift
//  DokodemoDrag
//
//  Created by Hiroaki Muronaka on 2021/08/19.
//  Copyright © 2021 Muronaka Hiroaki. All rights reserved.
//

import Cocoa
import ServiceManagement

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    static let launcherAppId = "hmu.DokodemoDragLauncher"
    @IBOutlet var authorizedMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let isProcessTrusted = AXIsProcessTrusted()
        NSLog("applicationDidFinishLaunching. AXIsProcessTrusted: \(isProcessTrusted)")

        if !isProcessTrusted {
            showWelcomeWindowWhenUnauthorized()
            return
        }
        
        if SettingService.shared.isShowWelcomeWindow {
            showWelcomeWindow()
        }
        
        StatusBarItem.instance.statusMenu = authorizedMenu
        StatusBarItem.instance.refreshVisibility()
        checkLaunchOnLogin()
        MouseHookService.shared.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        NSLog("applicationWillTerminate")
        MouseHookService.shared.stop()
    }
}

/// メニュー対する処理など
// TODO: 適切なクラスへ処理を移動させる
extension AppDelegate {
    
    /// ログイン時に自動起動のメニュー操作
    /// - Parameter item:
    @IBAction func toggleIsLaunchOnLogin(_ item: NSMenuItem) {
        SettingService.shared.toggleLaunchOnLogin()
    }
    
    /// 有効・無効のメニュー操作
    /// - Parameter item:
    @IBAction func toggleIsEnable(_ item: NSMenuItem) {
        SettingService.shared.toggleIsEnable()
    }
    
    
    /// 自動起動時の処理
    // NOTE: Rectangleより.
    private func checkLaunchOnLogin() {
        let running = NSWorkspace.shared.runningApplications
        let isRunning = !running.filter({$0.bundleIdentifier == AppDelegate.launcherAppId}).isEmpty
        if isRunning {
            let killNotification = Notification.Name("killLauncher")
            DistributedNotificationCenter.default().post(name: killNotification, object: Bundle.main.bundleIdentifier!)
        }
        
        // 以下のコメントはRectangleのまま
        // Even if we are already set up to launch on login, setting it again since macOS can be buggy with this type of launch on login.
        if SettingService.shared.isLaunchOnLogin {
            SettingService.shared.setEnableLaunchOnLogin(enabled: true)
        }
    }

    private func showWelcomeWindowWhenUnauthorized() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "WelcomWindowWhenUnauthorized") as? NSWindowController
        windowController?.showWindow(self)
    }

    private func showWelcomeWindow() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "WelcomWindow") as? NSWindowController
        windowController?.showWindow(self)
        
        // Windowが他のアプリに隠れるのを回避するために必要。
        // https://stackoverflow.com/questions/1740412/how-to-bring-nswindow-to-front-and-to-the-current-space
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
}

