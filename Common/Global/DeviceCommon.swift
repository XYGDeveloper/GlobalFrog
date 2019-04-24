//
//  DeviceCommon.swift
//  SwiftDemo
//
//  Created by zagger on 16/9/14.
//  Copyright © 2016年 zagger. All rights reserved.
//

import Foundation
import UIKit

//MARK: - app相关
/** app名称 */
let kAppName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    
/** app版本 */
let kAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
/** app,build版本号 */
let kAppBuildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String


//MARK: - 设备相关
/** 当前设备屏幕宽度，单位为pt */
let kScreenWidth = UIScreen.main.bounds.width

/** 当前设备屏幕高度，单位为pt */
let kScreenHeight = UIScreen.main.bounds.height

/** 屏幕分辨率，单位为px */
let kScreenResolution = UIScreen.main.currentMode?.size

/** 当前设备系统版本号 */
let kSystemVersion = UIDevice.current.systemVersion

/** 当前设备名称 */
func CurrentDeviceName() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    
    var identifier: String = ""
    for element in machineMirror.children {
        if let value = element.value as? Int8 {
            if value > 0 {
                identifier += String(UnicodeScalar(UInt8(value)))
            }
        }
    }
    
    var deviceName = ""
    
    switch identifier {
        //iPhone
    case "iPhone1,1":
        deviceName = "iPhone 2G"
    case "iPhone1,2":
        deviceName = "iPhone 3G"
    case "iPhone2,1":
        deviceName = "iPhone 3GS"
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":
        deviceName = "iPhone 4"
    case "iPhone4,1":
        deviceName = "iPhone 4s"
    case "iPhone5,1", "iPhone5,2":
        deviceName = "iPhone 5"
    case "iPhone5,3", "iPhone5,4":
        deviceName = "iPhone 5c"
    case "iPhone6,1", "iPhone6,2":
        deviceName = "iPhone 5s"
    case "iPhone7,2":
        deviceName = "iPhone 6"
    case "iPhone7,1":
        deviceName = "iPhone 6Plus"
    case "iPhone8,1":
        deviceName = "iPhone 6s"
    case "iPhone8,2":
        deviceName = "iPhone 6s Plus"
    case "iPhone8,4":
        deviceName = "iPhone SE"
    case "iPhone9,1", "iPhone9,3":
        deviceName = "iPhone 7"
    case "iPhone9,2", "iPhone9,4":
        deviceName = "iPhone 7Plus"
        
        //iPad
    case "iPad1,1":
        deviceName = "iPad"
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
        deviceName = "iPad 2"
    case "iPad3,1", "iPad3,2", "iPad3,3", "iPad3,4":
        deviceName = "iPad 3"
    case "iPad3,5", "iPad3,6":
        deviceName = "iPad 4"
        
        //iPad Air
    case "iPad4,1", "iPad4,2", "iPad4,3":
        deviceName = "iPad Air"
    case "iPad5,3", "iPad5,4":
        deviceName = "iPad Air 2"
        
        //iPad mini
    case "iPad2,5", "iPad2,6", "iPad2,7":
        deviceName = "iPad mini"
    case "iPad4,4", "iPad4,5", "iPad4,6":
        deviceName = "iPad mini 2"
    case "iPad4,7", "iPad4,8", "iPad4,9":
        deviceName = "iPad mini 3"
    case "iPad5,1", "iPad5,2":
        deviceName = "iPad mini 4"
        
        //iPad Pro
    case "iPad6,7", "iPad6,8":
        deviceName = "iPad Pro (12.9 inch)"
    case "iPad6,3", "iPad6,4":
        deviceName = "iPad Pro (9.7 inch)"
        
        //iPod
    case "iPod1,1":
        deviceName = "iPod Touch"
    case "iPod2,1":
        deviceName = "iPod Touch 2G"
    case "iPod3,1":
        deviceName = "iPod Touch 3G"
    case "iPod4,1":
        deviceName = "iPod Touch 4G"
    case "iPod5,1":
        deviceName = "iPod Touch 5G"
    case "iPod7,1":
        deviceName = "iPod Touch 6G"
        
        //simulator
    case "i386", "x86_64":
        deviceName = "Simulator"

    default:
        deviceName = identifier
    }
    
    return deviceName
}
