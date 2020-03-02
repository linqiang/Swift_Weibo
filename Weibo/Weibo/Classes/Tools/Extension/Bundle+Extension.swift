//
//  Bundle+Extension.swift
//  Weibo
//
//  Created by claude on 2018/7/2.
//  Copyright © 2018年 ZS. All rights reserved.
//

import Foundation
extension Bundle {
    
    var nameSpace: String{
        return infoDictionary?["CFBundleName"] as? String ?? ""
        
    }
    
}
