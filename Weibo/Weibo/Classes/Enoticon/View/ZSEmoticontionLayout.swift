//
//  ZSEmoticontionLayout.swift
//  Weibo
//
//  Created by zhi on 2020/2/26.
//  Copyright © 2020 ZS. All rights reserved.
//

import UIKit

//表情集合视图布局
class ZSEmoticontionLayout: UICollectionViewFlowLayout {
 // prepare OC 中的preparelayout
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        itemSize = collectionView.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        //设置滚动方向
        scrollDirection = .horizontal
    }
}
