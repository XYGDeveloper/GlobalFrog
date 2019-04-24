//
//  StewardSelectCell.swift
//  Qqw
//
//  Created by zagger on 16/9/19.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

import UIKit

class StewardSelectCell: BaseCollectionViewCell {
    
    var nextAction: ((Void) -> Void)?
    var selectAction: ((JSON?) -> Void)?
    var model: JSON?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.configLayout()
    }
    
    func refresh(steward model: JSON?) {
        self.model = model;
        
        if let modelJson = model {
            self.avatarView.sd_setImage(with: URL.init(string: modelJson[Steward.picture].stringValue), placeholderImage:kSmallPlaceholder)
            self.nameLabel.text = modelJson[Steward.nickname].stringValue
            
            let desString = modelJson[Steward.butlerDesc].stringValue
            let attribteString = NSMutableAttributedString.init(string: desString)
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 10.0
            paragraph.alignment = .center
            attribteString.addAttribute(NSParagraphStyleAttributeName, value: paragraph, range: NSMakeRange(0, desString.characters.count))
            
            self.desLabel.attributedText = attribteString
        }
    }
    
    //MARK: - Events
    func nextButtonClicked(sender: Any) {
        self.nextAction?()
    }
    
    func selectButtonClicked(sender: Any) {
        self.selectAction?(self.model)
    }
    
    //MARK: - Layout
    func configLayout() {
        self.contentView.addSubview(self.fixLabel)
        self.contentView.addSubview(self.avatarView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.desLabel)
        self.contentView.addSubview(self.nextButton)
        self.contentView.addSubview(self.selectButton)
        
        var topPadding: CGFloat = 29.0
        var avatarPadding: CGFloat = 68.0
        if kScreenHeight < 667 {
            topPadding = 20.0
            avatarPadding = 30.0
        }
        
        self.fixLabel.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(topPadding)
            _ = make?.centerX.equalTo()(self.contentView)
        }
        
        self.avatarView.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.fixLabel.mas_bottom)?.offset()(avatarPadding)
            _ = make?.centerX.equalTo()(self.contentView)
            _ = make?.width.height().equalTo()(110)
        }
        
        self.nameLabel.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.avatarView.mas_bottom)?.offset()(50)
            _ = make?.centerX.equalTo()(self.contentView)
        }
        
        self.desLabel.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.nameLabel.mas_bottom)?.offset()(14)
            _ = make?.centerX.equalTo()(self.contentView)
            _ = make?.left.equalTo()(10)
            _ = make?.right.equalTo()(-10)
        }
        
        self.nextButton.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(10)
            _ = make?.bottom.equalTo()(-40)
            _ = make?.height.equalTo()(44)
        }
        
        self.selectButton.mas_makeConstraints { (make) in
            _ = make?.right.equalTo()(-10)
            _ = make?.left.equalTo()(self.nextButton.mas_right)?.offset()(15)
            _ = make?.bottom.equalTo()(self.nextButton)
            _ = make?.width.equalTo()(self.nextButton)
            _ = make?.height.equalTo()(self.nextButton)
        }
    }
    
    //MARK: - Properties
    lazy var fixLabel: UILabel = {
        let label = GeneralLabel(Font(15), kTextColor1)
        label.text = "比商品更优质的是我们的管家服务"
        return label
    }()
    
    lazy var avatarView: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 55.0
        imgView.layer.masksToBounds = true
        imgView.layer.borderColor = UIColor.init(white: 0, alpha: 0.28).cgColor
        imgView.layer.borderWidth = 0.5
        return imgView
    }()
    
    lazy var nameLabel: UILabel = {
        return GeneralLabel(BoldFont(17), kTextColor1, .center)
    }()
    
    lazy var desLabel: UILabel = {
        let label = GeneralLabel(Font(15), kTextColor1, .center)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nextButton: UIButton = {
        let button = GeneralButton(title: "下一个", titleColor: kAppStyleColor, titleFont: Font(14), backgroudColor: Color(hex: 0xe4f3dd), cornerRadius: 2.0, borderWidth: 1.0, borderColor: kAppStyleColor)
        button.addTarget(self, action: #selector(nextButtonClicked(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var selectButton: UIButton = {
        let button = GeneralRaundCornerButtonWithTitle("选TA")
        button.addTarget(self, action: #selector(selectButtonClicked(sender:)), for: .touchUpInside)
        return button
    }()
}
