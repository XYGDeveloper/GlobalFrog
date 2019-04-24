//
//  Api.swift
//  SwiftDemo
//
//  Created by zagger on 16/9/21.
//  Copyright © 2016年 zagger. All rights reserved.
//

import Foundation

class BaseApi {
    weak var delegate: ApiRequsetDelete?
    var tasks = [URLSessionTask]()
    
    deinit {//释放时，取消请求
        for task in self.tasks {
            task.cancel()
        }
    }
    
    init(delegate: ApiRequsetDelete?) {
        self.delegate = delegate
    }
    
    //MARK: - 请求
    func startRequest(params: [String: Any]?) {
        
        var command = self.buildCommand()
        command.parameters = params
        
        let task = ApiManager.sharedManager.request(command: command) {
            [weak self = self] (success, cmd, responseObject, error) in
            
            self?.unCacheTask(command.task)
            
            if success {
                let reformedData = self?.reforData(responseObject: responseObject?["data"])
                self?.delegateSuccess(command: cmd, reformedData: reformedData)
            } else {
                self?.delegateFailed(command: cmd, error: error)
            }
            
        }
        
        self.cacheTask(task)
    }
    
    func delegateSuccess(command: ApiCommand, reformedData: Any?) {
        if self.isSuccessRequest(command: command, reformedData: reformedData) {
            self.delegate?.requestSuccess(self, command: command, responseObject: reformedData)
        } else {
            self.delegate?.requestFailed(self, command: command, error: nil)
        }
    }
    
    func delegateFailed(command: ApiCommand, error: Error?) {
        self.delegate?.requestFailed(self, command: command, error: error)
    }
    
    //MARK: - 子类重写
    func buildCommand() -> ApiCommand {
        return ApiCommand()
    }
    
    func isSuccessRequest(command: ApiCommand, reformedData: Any?) -> Bool {
        return command.commonResponse?.code == HttpResponseCode.success.rawValue
    }
    
    func reforData(responseObject: JSON?) -> Any? {
        return responseObject
    }
    
    //MARK: - Private
    func cacheTask(_ task: URLSessionTask?) {
        if let cTask = task {
            objc_sync_enter(self)
            self.tasks.append(cTask)
            objc_sync_exit(self)
        }
    }
    
    func unCacheTask(_ task: URLSessionTask?) {
        if let cTask = task {
            objc_sync_enter(self)
            if let index = self.tasks.index(of: cTask) {
                self.tasks.remove(at: index)
            }
            objc_sync_exit(self)
        }
    }
}


//MARK: - 分页请求基类，管理页码
let kStartPage = 1
class BaseListApi: BaseApi {
    var page = kStartPage
    var pageSize = 10
    
    //配置除了页码外的其他参数
    var parameter: [String: Any]?
    
    var listDelete: ApiListRequestDelegate? {
        return self.delegate as? ApiListRequestDelegate
    }
    
    final func refresh() {
        var params = self.parameter ?? [String: Any]()
        params.updateValue(kStartPage, forKey: "p")
        params.updateValue(self.pageSize, forKey: "ps")
        self.startRequest(params: params)
    }
    
    final func loadNextPage() {
        var params = self.parameter ?? [String: Any]()
        params.updateValue(self.page + 1, forKey: "p")
        params.updateValue(self.pageSize, forKey: "ps")
        self.startRequest(params: params)
    }
    
    final override func delegateSuccess(command: ApiCommand, reformedData: Any?) {
        let reqPage = command.parameters?["p"] as? Int ?? kStartPage
        
        if self.isSuccessRequest(command: command, reformedData: reformedData) {
            if reqPage == kStartPage {
                self.page = kStartPage
                self.listDelete?.requestSuccess(self, command: command, responseObject: reformedData)
            } else if reqPage > kStartPage {
                self.page = reqPage
                self.listDelete?.loadMoreSuccess(self, command: command, responseObject: reformedData)
            }
            
            if !self.hasMore(reformedData: reformedData) {
                self.listDelete?.loadMoreEnd(self, command: command)
            }
        } else {
            self.delegateFailed(command: command, error: nil)
        }
    }
    
    final override func delegateFailed(command: ApiCommand, error: Error?) {
        let reqPage = command.parameters?["p"] as? Int ?? kStartPage
        if reqPage == kStartPage {
            self.listDelete?.requestFailed(self, command: command, error: error)
        } else if reqPage > kStartPage {
            self.listDelete?.loadMoreFailed(self, command: command, error: error)
        }
    }
    
    //MARK: - 子类重写
    func hasMore(reformedData: Any?) -> Bool {
        if let array = reformedData as? [Any] {
            return array.count > 0
        }
        return true
    }
}


//MARK: - 请求回调
protocol ApiRequsetDelete: class {
    /**
     *  请求成功后，提供给业务方的回调方法
     *
     *  @param api           请求的api对象
     *  @param command       请求的相关信息，包括入参、地址等
     *  @param responsObject 对应api类处理后的返回数据，可以直接提供给业务类使用
     */
    func requestSuccess(_ api: BaseApi, command: ApiCommand, responseObject: Any?)
    /**
     *  请求失败后提供给业务方的回调方法
     *
     *  @param api     请求的api对象
     *  @param command 请求的相关信息，包括入参、地址等
     *  @param error   错误信息
     */
    func requestFailed(_ api: BaseApi, command: ApiCommand, error: Error?)
    
    
}

//MARK: - 分页请求回调
protocol ApiListRequestDelegate: ApiRequsetDelete {
    /**
     *  分页请求，上拉加载更多请求成功
     *
     *  @param api           请求的api对象
     *  @param command       请求的相关信息，包括入参、地址等
     *  @param responsObject 对应api类处理后的返回数据，可以直接提供给业务类使用
     */
    func loadMoreSuccess(_ api: BaseApi, command: ApiCommand, responseObject: Any?)
    /**
     *  分页请求，上拉加载更多时请求失败
     *
     *  @param api     请求的api对象
     *  @param command 请求的相关信息，包括入参、地址等
     *  @param error   错误信息
     */
    func loadMoreFailed(_ api: BaseApi, command: ApiCommand, error: Error?)
    /**
     *  分页请求，上拉加载时，已没有更多数据
     *
     *  @param api     请求的api对象
     *  @param command 请求的相关信息，包括入参、地址等
     */
    func loadMoreEnd(_ api: BaseApi, command: ApiCommand)
}
