//
//  ApiCommand.swift
//  Qqw
//
//  Created by zagger on 16/9/18.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

import Foundation

enum HttpRequestMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HttpResponseCode: String {
    case success = "0"
    case notVip = "1102"//不是会员
}

/** api请求命令 */
struct ApiCommand {
    /** url相对地址 */
    var relativeURLString: String?
    
    /** url请求完整地址 */
    var requsetURLString: String {
        if let url = self.relativeURLString {
            if url.hasPrefix("/") {
                return kApiDomain + url
            } else {
                return kApiDomain + "/" + url
            }
        } else {
            return kApiDomain
        }
    }
    
    /** 请求方式，默认为post */
    var method: HttpRequestMethod = .post
    
    /** 和请求对应的task对象 */
    var task: URLSessionTask?
    
    /** 设置请求超时时间 */
    var timeoutInterval: TimeInterval = 30.0
    
    /** 请求参数 */
    var parameters: [String: Any]?
    
    /** api请求返回的公共字段信息 */
    var commonResponse: ApiCommonResponse?
}


/** api请求返回的公共字段信息 */
struct ApiCommonResponse {
    /** api返回的状态码 */
    let code: String?
    
    /** http状态码 */
    let httpCode: Int?
    
    /** api返回的文案 */
    let msg: String?
    
    /** 根据请求的task及请求返回的数据进行初始化 */
    init(task: URLSessionTask?, response: JSON?) {
        self.code = response?["ret"].stringValue
        self.msg = response?["msg"].stringValue
        
        if let httpResponse = task?.response as? HTTPURLResponse {
            self.httpCode = httpResponse.statusCode
        } else {
            self.httpCode = 0
        }
    }
}
