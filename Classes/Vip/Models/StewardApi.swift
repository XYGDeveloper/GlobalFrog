//
//  StewardApi.swift
//  Qqw
//
//  Created by zagger on 16/9/22.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

import Foundation

class StewardListApi: BaseListApi {
    override func buildCommand() -> ApiCommand {
        var command = ApiCommand()
        command.method = .get
        command.relativeURLString = "/butler-main/butlerChooseList"
        return command
    }
    
    override func reforData(responseObject: JSON?) -> Any? {
        let jsonArray = responseObject?["list"]
        return jsonArray
    }
}


class SelectStewardApi: BaseApi {
    func selectSteward(identifier: String?) {
        if let steId = identifier {
            self .startRequest(params: ["butler_id": steId])
        }
    }
    
    override func buildCommand() -> ApiCommand {
        var command = ApiCommand()
        command.relativeURLString = "/butler-main/bindButler"
        return command
    }
}

struct Steward {
    static let butlerId = "butler_id"
    static let nickname = "nickname"
    static let picture = "picture"
    static let butlerDesc = "butler_desc"
    static let sex = "sex"
    static let createTime = "create_time"
}
