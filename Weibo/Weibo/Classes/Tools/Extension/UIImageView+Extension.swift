//
//  UIImageView+Extension.swift
//  Weibo
//
//  Created by zhi on 2020/2/18.
//  Copyright © 2020 ZS. All rights reserved.
//

import SDWebImage
extension UIImageView{
    func cz_setImage(urlString: String?,placeholderImage: UIImage?, isAvatar: Bool = false){
        
        //处理image
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        
        //可选项 只是用在Swift中，OC中有时候使用! 同样可以传入nil
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { (image, _, _, _) in
            // 完成回调 - 判断是否有头像
            if isAvatar {
                self.image = image?.cz_avatarImage(self.bounds.size)
            }
        }
    }
}
