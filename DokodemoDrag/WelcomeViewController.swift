//
//  WelcomeViewController.swift
//  DokodemoDrag
//
//  Created by MuronakaHiroaki on 2021/08/25.
//

import Cocoa


/// WelcomeWindow共通のViewController
/// Storyboardに疎いため、無理矢理な実装となっている。
class WelcomeViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func enableLaunchOnLogin(_ sender: NSButton) {
        setLaunchOnLogin(value: true)
    }
    
    @IBAction func disableLaunchOnLogin(_ sender: NSButton) {
        setLaunchOnLogin(value: false)
    }
    
    /// WelcomeWindowを閉じる
    /// - Parameter sender: 
    @IBAction func close(_ sender: NSButton) {
        self.view.window?.close()
        SettingService.shared.isShowWelcomeWindow = false
    }
    
    
    private func setLaunchOnLogin(value: Bool) {
        SettingService.shared.setEnableLaunchOnLogin(enabled: value)
        showViewController(identifier: "WelcomeWindowHowToUse")
    }
    
    private func showViewController(identifier: String) {
        let vc = self.storyboard?.instantiateController(withIdentifier: identifier) as? NSViewController
        self.view.window?.contentViewController = vc

    }
}
