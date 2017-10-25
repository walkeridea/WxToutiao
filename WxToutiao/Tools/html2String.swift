//
//  html2String.swift
//  WxToutiao
//
//  Created by yons on 2017/6/2.
//  Copyright © 2017年 yons. All rights reserved.
//
import UIKit


// MARK: - html 转化成 普通不带标签的文本
extension String {
    var html2AttributedString: NSAttributedString? {
        return try? NSAttributedString(data: Data(utf8), options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html,NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
    
    var html2String:String {
        return html2AttributedString?.string ?? ""
    }
}
