//
//  SettingService.swift
//  DokodemoDrag
//
//  Created by MuronakaHiroaki on 2021/08/21.
//

import Foundation
import Defaults
import ServiceManagement

class SettingService {
    
    static let shared = SettingService()
    
    public var isLaunchOnLogin: Bool {
        return Defaults[.isLaunchOnLogin]
    }
    
    public var isEnable: Bool {
        return Defaults[.isEnable]
    }
    
    private init() {
    }
    
    public func setEnableLaunchOnLogin(enabled: Bool) {
        let smLoginSuccess = SMLoginItemSetEnabled(AppDelegate.launcherAppId as CFString, enabled)
        if !smLoginSuccess {
            NSLog("Unable to set launch at login preference. Attempting one more time.")
            SMLoginItemSetEnabled(AppDelegate.launcherAppId as CFString, enabled)
        }
    }
    
    @discardableResult
    public func toggleLaunchOnLogin() -> Bool {
        let newSetting: Bool = !Defaults[.isLaunchOnLogin]
        setEnableLaunchOnLogin(enabled: newSetting)
        Defaults[.isLaunchOnLogin] = newSetting
        return newSetting
    }
    
    @discardableResult
    public func toggleIsEnable() -> Bool {
        let newSetting = !self.isEnable
        if newSetting {
            MouseHookService.shared.start()
        } else {
            MouseHookService.shared.stop()
        }
        Defaults[.isEnable] = newSetting
        return newSetting
    }
    
    public func observe(handler: @escaping () -> ()) -> Any {
        return Defaults.observe(keys: .isEnable, .isLaunchOnLogin, handler: handler)
    }
}

fileprivate extension Defaults.Keys {
    static let isLaunchOnLogin = Key<Bool>("isLaunchOnLogin", default: false)
    static let isEnable = Key<Bool>("isEnable", default: true)
}
