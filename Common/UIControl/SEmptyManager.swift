//
//  File.swift
//  Qqw
//
//  Created by zagger on 16/9/23.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

import Foundation
import UIKit

class EmptyManager {
    /** 数据为空时的页面，如购物车为空，订单列表为空等 */
    static func showEmpty(on parentView: UIView, image: UIImage?, explain: String?, operationText: String?, operationAction: (() -> Void)?) {
        
        self.removeEmpty(from: parentView)
        
        let emptyView = SEmptyView.init(frame: CGRect(x: 0, y: 0, width: parentView.width, height: parentView.height))
        emptyView.refreshWith(image: image, explain: explain, operationText: operationText, operationAction: operationAction)
        
        parentView.addSubview(emptyView)
    }
    
    /** 网络请求失败时的页面 */
    static func showNetError(on parentView: UIView, apiResponse: ApiCommonResponse?, operationAction: (() -> Void)?) {
        self.removeEmpty(from: parentView)
        
        let emptyView = SEmptyView.init(frame: CGRect(x: 0, y: 0, width: parentView.width, height: parentView.height))
        emptyView.netErrorLayout()
        
        emptyView.refreshWith(image: UIImage.init(named: "global_netError"), explain: "抱歉：~~~~网络迷路了", operationText: "重试") {
            self.removeEmpty(from: parentView)
            operationAction?()
        }
        
        parentView.addSubview(emptyView)
    }
    
    static func removeEmpty(from parentView: UIView) {
        for subview in parentView.subviews {
            if subview.isKind(of: SEmptyView.self) {
                subview.removeFromSuperview()
            }
        }
    }
}

fileprivate class SEmptyView: UIView {
    let operationButton = GeneralRaundCornerButtonWithTitle("")
    var operationAction: (() -> Void)?
    
    let emptyLabel = GeneralLabel(Font(14), kTextColor2, .center)
    
    lazy var emptyImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kDefaultBackgroundColor
        self.operationButton.addTarget(self, action: #selector(operationButtonClicked(sender:)), for: .touchUpInside)
        self.configLayout()
    }
    
    func refreshWith(image: UIImage?, explain: String?, operationText: String?, operationAction: (() -> Void)?) {
        self.emptyImgView.image = image
        self.emptyImgView.size = image?.size ?? CGSize()
        self.emptyLabel.text = explain
        
        self.operationAction = operationAction
        if let opText = operationText {
            self.operationButton.isHidden = false
            self.operationButton.setTitle(opText, for: .normal)
        } else {
            self.operationButton.isHidden = true
        }
    }
    
    //MARK: - Events
    func operationButtonClicked(sender: UIButton) {
        self.operationAction?()
    }
    
    //MARK: - Layout
    func configLayout() {
        self.addSubview(self.emptyImgView)
        self.addSubview(self.emptyLabel)
        self.addSubview(self.operationButton)
        
        self.emptyImgView.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(100)
            _ = make?.centerX.equalTo()(self)
        }
        
        self.emptyLabel.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.emptyImgView.mas_bottom)?.offset()(43)
            _ = make?.left.right().equalTo()(0)
        }
        
        self.operationButton.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.emptyLabel.mas_bottom)?.offset()(14)
            _ = make?.centerX.equalTo()(self)
            _ = make?.width.equalTo()(141)
            _ = make?.height.equalTo()(44)
        }
    }
    
    func netErrorLayout() {
        self.emptyImgView.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(50)
            _ = make?.centerX.equalTo()(self)
        }
    }
}
