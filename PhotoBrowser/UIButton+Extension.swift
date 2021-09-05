//
//  UIButton+Extension.swift
//  PhotoBrowser
//
//  Created by chenzhen on 2019/7/9.
//  Copyright © 2019 LYW. All rights reserved.
//

import UIKit

extension UIButton{
    
    convenience init(bgColor:UIColor,font:CGFloat,title:String) {
        self.init()
        
        self.setTitle(title, for: .normal)
        self.backgroundColor = bgColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: font)
    }
}
