//
//  UICommon.swift
//  Qqw
//
//  Created by zagger on 16/9/19.
//  Copyright © 2016年 quanqiuwa. All rights reserved.
//

import Foundation

//MARK: - color
let kAppStyleColor = Color(hex:0x5cb531) //主题绿色
let kGrayDividerColor = Color(hex:0xe1e1e1) //灰色分隔线颜色
let kDardGrayDividerColor = Color(hex:0xd6d7dc) //深灰色分隔线
let kDefaultBackgroundColor = Color(hex:0xf3f3f3)  //默认背景色

let kTextColor1 = Color(hex:0x323232) //（导航栏文字（苹方中等）/子导航文字--选中状态（苹方中等）/头像旁边的用户名/文章标题/重点文字）
let kTextColor2 = Color(hex:0x666666) //（次级文字/子导航文字--未选中状态）
let kTextColor3 = Color(hex:0x909090) // (再次级文字/输入框内提示文字/注明类文字）
let kTextColor4 = Color(hex:0xd63d3e) //（警示文字/标示价钱的文字）

let kTextColor5 = Color(hex:0xcdcdcd) //消息中心的时间文本框颜色

let kTextColor6 = Color(hex:0xffffff) //消息中心的时间文本框颜色


func Color(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return Color(r: r, g: g, b: b, a: 1.0)
}

func Color(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

func Color(hex: Int) -> UIColor {
    return Color(hex: hex, alpha: 1)
}

func Color(hex: Int, alpha: CGFloat) -> UIColor {
    return UIColor.init(red: (CGFloat)((hex & 0xFF0000) >> 16) / 255.0,
                        green: (CGFloat)((hex & 0xFF00) >> 8) / 255.0,
                        blue: (CGFloat)(hex & 0xFF) / 255.0,
                        alpha: alpha)
}

//MARK: - image
let kBigPlaceholder = UIImage(named: "placeholder_big.jpg")!
let kSmallPlaceholder = UIImage(named: "placeholder_small.jpg")!

//MARK: - font
func Font(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize)
}

func BoldFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: fontSize)
}

//MARK: - label
func GeneralLabel(_ font: UIFont, _ textcolor: UIColor) -> UILabel {
    return GeneralLabel(font, textcolor, .left)
}

func GeneralLabel(_ font: UIFont, _ textcolor: UIColor, _ textAlignment: NSTextAlignment) -> UILabel {
    let label = UILabel()
    label.font = font
    label.textColor = textcolor
    label.textAlignment = textAlignment
    label.backgroundColor = UIColor.clear
    return label
}

//MARK: - button
/** 主题绿色背景、直角、白色文字的按钮 */
func GeneralButtonWithTitle(_ title: String) -> UIButton {
    return GeneralButton(title: title, titleColor: UIColor.white, titleFont: Font(14), backgroudColor: kAppStyleColor, cornerRadius: nil, borderWidth: nil, borderColor: nil)
}

/** 主题绿色背景、小圆角、白色文字的按钮 */
func GeneralRaundCornerButtonWithTitle(_ title: String) -> UIButton {
    return GeneralButton(title: title, titleColor: UIColor.white, titleFont: Font(14), backgroudColor: kAppStyleColor, cornerRadius: 2.0, borderWidth: nil, borderColor: nil)
}

/** 边框颜色、文字颜色和主题相同的白底圆角按钮*/
func AppstyleBorderButtonWithTitle(_ title: String) -> UIButton {
    return GeneralButton(title: title, titleColor: kAppStyleColor, titleFont: Font(14), backgroudColor: UIColor.white, cornerRadius: 2.0, borderWidth: 1.0, borderColor: kAppStyleColor)
}

/** 边框颜色为灰色，文字颜色为黑色的白底圆角按钮 */
func GrayBorderButtonWithTitle(_ title: String) -> UIButton {
    return GeneralButton(title: title, titleColor: kTextColor2, titleFont: Font(14), backgroudColor: UIColor.white, cornerRadius: 2.0, borderWidth: 1.0, borderColor: kTextColor3)
}

func GeneralButton(title: String, titleColor: UIColor, titleFont: UIFont, backgroudColor: UIColor?, cornerRadius: CGFloat?, borderWidth: CGFloat?, borderColor: UIColor?) -> UIButton {
    let button = UIButton.init(type: .custom)
    
    button.setTitle(title, for: .normal)
    button.setTitleColor(titleColor, for: .normal)
    button.titleLabel?.font = titleFont
    
    if backgroudColor != nil {
        button.setBackgroundImage(UIImage.init(color: backgroudColor!), for: .normal)
    }
    if cornerRadius != nil {
        button.layer.cornerRadius = cornerRadius!
        button.layer.masksToBounds = true
    }
    if borderWidth != nil {
        button.layer.borderWidth = borderWidth!
    }
    if borderColor != nil {
        button.layer.borderColor = borderColor!.cgColor
    }
    
    return button
}




//将时间戳转化为时间

func changeTimeStampToTimeString(timeInterval:TimeInterval) -> String {

    let date = NSDate(timeIntervalSince1970: timeInterval)
    
    let dformatter = DateFormatter()
    
    dformatter.dateFormat = "yy-M-d HH:mm"
    
    return  dformatter.string(from: date as Date)
    
}


