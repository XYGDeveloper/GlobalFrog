//
//  StartUpViewController.swift
//  Qqw
//
//  Created by zagger on 16/9/22.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

import Foundation

/** 启动页 */
class StartUpViewController: WebViewController {
    lazy var backImageView: UIImageView = {
        if kScreenResolution?.width == 640 && kScreenResolution?.height == 960 {
            return UIImageView.init(image: UIImage.init(named: "launch4s"))
        } else if kScreenResolution?.width == 640 && kScreenResolution?.height == 1136 {
            return UIImageView.init(image: UIImage.init(named: "launch5"))
        }  else if kScreenResolution?.width == 750 && kScreenResolution?.height == 1334 {
            return UIImageView.init(image: UIImage.init(named: "launch6"))
        } else if kScreenResolution?.width == 1242 && kScreenResolution?.height == 2208 {
            return UIImageView.init(image: UIImage.init(named: "launch6p"))
        }
        return UIImageView.init(image: UIImage.init(named: "launch6"))
    }()
    
    init() {
        super.init(urlString: WebViewController.urlString(withRelativePath: "/static/startup.htm"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myWebView.scrollView.isScrollEnabled = false
        
        self.backImageView.backgroundColor = UIColor.clear
        self.backImageView.frame = self.view.bounds
        self.view.addSubview(self.backImageView)
    }
}

class GuideViewController: WebViewController {
    init() {
        super.init(urlString: WebViewController.urlString(withRelativePath: "/static/qqw_guide.htm"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myWebView.scrollView.isScrollEnabled = false
    }
}




