//
//  GlobalManager.swift
//  Qqw
//
//  Created by zagger on 16/9/21.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

import UIKit

class GlobalManager: NSObject {
    static let sharedManager = GlobalManager()
    
    /** app启动后的基础操作 */
    func startSetup() {
        //app启动后更新当前用户信息
        if User.hasLogin() {
          
            User.requestInfoWithuperView(nil, finshBlock: { ( user: User?, error:Error?) in
                if (error != nil) {
                    User.local().shouldRefreshUserInfo = true
                }
            })
//            User.updateInfo(completion: { (success) in
//                if success == false {
//                    User.local().shouldRefreshUserInfo = true
//                }
//            })
        }
//        //开启网络状态监测
//        AFNetworkReachabilityManager.shared().startMonitoring()
//        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
//            
//        }
    }

}
