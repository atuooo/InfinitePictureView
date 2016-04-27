//
//  InfinitePictureViewCell.swift
//  InfinitePictureView
//
//  Created by Atuooo on 4/27/16.
//  Copyright © 2016 oOatuo. All rights reserved.
//

import UIKit

class InfinitePictureViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .ScaleAspectFill
        
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
