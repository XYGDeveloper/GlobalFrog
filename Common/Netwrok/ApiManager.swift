//
//  ApiManager.swift
//  Qqw
//
//  Created by zagger on 16/9/18.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

import Foundation

class ApiManager {
    static let sharedManager = ApiManager()//单例
    
    /** 发送一个api请求 */
    @discardableResult func request(command: ApiCommand,
                                    completionHandler:@escaping (Bool, ApiCommand, JSON?, Error?) -> Void) -> URLSessionDataTask? {
        return self.request(command: command, multipartFormData: nil, completionHandler: completionHandler)
    }
    
    /** 发送一个带上传数据的请求 */
    @discardableResult func request(command: ApiCommand,
                                    multipartFormData: ((AFMultipartFormData) -> Void)?,
                                    completionHandler: @escaping (Bool, ApiCommand, JSON?, Error?) -> Void) -> URLSessionDataTask? {
        var params = command.parameters ?? [String: Any]()
        for (key, value) in self.commonParameters {
            let _ = params.updateValue(value, forKey: key)
        }
        
        let successAction = { (task: URLSessionDataTask, responseObject: Any?) -> Void in
            var cmd = command
            let json = JSON.init(responseObject)
            cmd.task = task
            cmd.commonResponse = ApiCommonResponse(task: task, response: json)
            completionHandler(true, cmd, json, nil)
            
            LogResponse(command: cmd, task: task, responseObject: json, error: nil)
        }
        
        let failedAction = { (task: URLSessionDataTask?, error: Error) -> Void in
            var cmd = command
            cmd.task = task
            cmd.commonResponse = ApiCommonResponse(task: task, response: nil)
            completionHandler(false, cmd, nil, error)
            
            LogResponse(command: cmd, task: task , responseObject: nil, error: error)
        }
        
        //添加cookies
        Utils.addCookies(for: URL.init(string: command.requsetURLString))
        
        var dataTask: URLSessionDataTask?
        if command.method == .get {
            dataTask = self.sessionManager.get(command.requsetURLString, parameters: params, progress: nil
                , success: successAction, failure: failedAction)
        } else if command.method == .post {
            if multipartFormData == nil {
                dataTask = self.sessionManager.post(command.requsetURLString, parameters: params, progress: nil, success: successAction, failure: failedAction)
            } else {
                dataTask = self.sessionManager.post(command.requsetURLString, parameters: params, constructingBodyWith: multipartFormData, progress: nil, success: successAction, failure: failedAction)
            }
        }
        
        LogRequest(command: command, task: dataTask)
        
        return dataTask
    }
    
    //MARK: - Properties
    private lazy var sessionManager: AFHTTPSessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        
        let manager = AFHTTPSessionManager.init(sessionConfiguration: config)
        let responseSerializer = manager.responseSerializer as? AFJSONResponseSerializer
        responseSerializer?.removesKeysWithNullValues = true
        
        var acceptSet = manager.responseSerializer.acceptableContentTypes
        let _ = acceptSet?.update(with: "text/html")
        let _ = acceptSet?.update(with: "charset=utf-8")
        manager.responseSerializer.acceptableContentTypes = acceptSet
        
        return manager
    }()
    
    private lazy var commonParameters: [String: String] = {
        return [:]
    }()
}


fileprivate func LogRequest(command: ApiCommand, task: URLSessionDataTask?) {
    #if DEBUG
        var logString = "\n\n**************************************************************\n*                          请求开始                           *\n**************************************************************\n"
        
        logString += "请求方式：\(command.method.rawValue)\n"
        logString += "超时时间：\(command.timeoutInterval)\n"
        logString += "请求地址：\(command.requsetURLString)\n"
        logString += "请求参数：\n\(JSON.init(command.parameters))\n"
        
        logString += "**************************************************************\n\n"
        
        print(logString)

    #endif
}

fileprivate func LogResponse(command: ApiCommand, task: URLSessionDataTask?, responseObject: JSON?, error: Error?) {
    #if DEBUG
        var logString = "\n\n==============================================================\n=                           请求返回                          =\n==============================================================\n"
        
        logString += "请求方式：\(command.method.rawValue)\n"
        logString += "超时时间：\(command.timeoutInterval)\n"
        logString += "请求地址：\(command.requsetURLString)\n"
        logString += "请求参数：\n\(JSON.init(command.parameters))\n"
        logString += "返回数据：\n\(responseObject ?? "")\n"
        
        if let err = error {
            logString += "Error Domain:\t\t\t\t\t\t\t\(err.localizedDescription)\n"
        }
        
        logString += "==============================================================\n\n"
        
        print(logString)
        
    #endif
}
