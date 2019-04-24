//
//  StewardSelectViewController.swift
//  Qqw
//
//  Created by zagger on 16/9/19.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

import UIKit

class StewardSelectViewController: UIViewController {
    var dataArray: [JSON] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "选择管家"
        self.view.backgroundColor = kDefaultBackgroundColor

        self.view.addSubview(self.collectionView)
        self.collectionView.mas_makeConstraints { (make) in
            _ = make?.edges.equalTo()(self.view)
        }
        
        Utils.addHud(on: self.view)
        self.listApi.refresh()
    }
    
    //MARK: - Events
    func selectedSteward(_ model: JSON?) {
        if model != nil {
            Utils.addHud(on: self.view)
            self.selectApi.selectSteward(identifier: model?[Steward.butlerId].stringValue)
        }
    }

    //MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView.init(frame: CGRect(), collectionViewLayout: StewardCollectionViewLayout())
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = kDefaultBackgroundColor
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.register(StewardSelectCell.self, forCellWithReuseIdentifier: NSStringFromClass(StewardSelectCell.self))
        return view
    }()
    
    lazy var selectApi: SelectStewardApi = {
        let api = SelectStewardApi.init(delegate: self)
        return api
    }()
    
    lazy var listApi: StewardListApi = {
        let api = StewardListApi.init(delegate: self)
        return api
    }()
}

//MARK: - UICollectionViewDelegate
extension StewardSelectViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(StewardSelectCell.self), for: indexPath) as! StewardSelectCell
        
        let model = self.dataArray[indexPath.row]
        cell.refresh(steward: model)
        
        cell.nextAction = {
            [unowned self] in
            if indexPath.row < self.dataArray.count - 1 {
                self.collectionView.scrollToItem(at: IndexPath.init(row: indexPath.row + 1, section: indexPath.section), at: .centeredHorizontally, animated: true)
            } else {
                Utils.postMessage("已是最后一个", on: self.view)
            }
        }
        
        cell.selectAction = {
            [unowned self] (model: JSON?) -> Void in
            self.selectedSteward(model)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: - api请求回调
extension StewardSelectViewController: ApiListRequestDelegate {
    func requestSuccess(_ api: BaseApi, command: ApiCommand, responseObject: Any?) {
        Utils.removeHud(from: self.view)
        
        if api === self.listApi {
            if let json = responseObject as? JSON {
                self.dataArray = json.arrayValue
            }
            self.collectionView.reloadData()
        } else if api === self.selectApi {
            
            //设置需要刷新用户信息，在下次进入个人中心时进行刷新
            User.local().shouldRefreshUserInfo = true
            
            Utils.postMessage(command.commonResponse?.msg, on: nil)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func requestFailed(_ api: BaseApi, command: ApiCommand, error: Error?) {
        Utils.removeHud(from: self.view)
        Utils.postMessage(command.commonResponse?.msg, on: self.view)
        
        if api === self.listApi {
            EmptyManager.showNetError(on: self.view, apiResponse: command.commonResponse, operationAction: { 
                [unowned self] in
                Utils.addHud(on: self.view)
                self.listApi.refresh()
            })
        } else if api === self.selectApi {
            
        }
    }
    
    func loadMoreSuccess(_ api: BaseApi, command: ApiCommand, responseObject: Any?) {
        
    }
    
    func loadMoreFailed(_ api: BaseApi, command: ApiCommand, error: Error?) {
        
    }
    
    func loadMoreEnd(_ api: BaseApi, command: ApiCommand) {
        
    }
}


class StewardCollectionViewLayout: UICollectionViewFlowLayout {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.sectionInset = UIEdgeInsets()
        self.scrollDirection = .horizontal
    }
}
