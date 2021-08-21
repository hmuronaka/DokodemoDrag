//
//  SettingService.swift
//  MouseHookSample
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
    
    private init() {
    }
    
    public func setEnableLaunchOnLogin(enabled: Bool) {
        let smLoginSuccess = SMLoginItemSetEnabled(AppDelegate.launcherAppId as CFString, enabled)
        if !smLoginSuccess {
            Logger.log("Unable to set launch at login preference. Attempting one more time.")
            SMLoginItemSetEnabled(AppDelegate.launcherAppId as CFString, enabled)
        }
    }
    
    public func toggleLaunchOnLogin() -> Bool {
        let newSetting: Bool = !Defaults[.isLaunchOnLogin]
        setEnableLaunchOnLogin(enabled: newSetting)
        Defaults[.isLaunchOnLogin] = newSetting
        return newSetting
    }
    
}

fileprivate extension Defaults.Keys {
    static let isLaunchOnLogin = Key<Bool>("isLaunchOnLogin", default: false)
}
