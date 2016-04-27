//
//  InfinitePictureView.swift
//  GuttlerPageControl
//
//  Created by Atuooo on 4/27/16.
//  Copyright © 2016 oOatuo. All rights reserved.
//

import UIKit

private let cellID = "InfiniteCell"

class InfinitePictureView: UIView {
    private var images: [String]!
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!

    private var timer: NSTimer!
    private var timerDuration: NSTimeInterval = 3.0
    
    private var currentIndex = 1
    private var pictureCount = 0
    
    init(frame: CGRect, imageNames: [String]) {
        super.init(frame: frame)
        
        // handle dataSource 
        images = imageNames
        images.append(imageNames.first!)
        images.insert(imageNames.last!, atIndex: 0)
        pictureCount = imageNames.count
        
        // set collection view
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width, height: frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.pagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.registerClass(InfinitePictureViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0), atScrollPosition: .None, animated: false)
        addSubview(collectionView)
        
        // set page control
        pageControl = UIPageControl(frame: CGRect(x: 0, y: frame.height - 20, width: frame.width, height: 20))
        pageControl.numberOfPages = pictureCount
        pageControl.currentPage = 0
        addSubview(pageControl)
        
        // set timer
        timer = NSTimer(timeInterval: timerDuration, target: self, selector: #selector(updatePictureView), userInfo: nil, repeats: true)
        timer.tolerance = timerDuration * 0.1
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - timer function
    func updatePictureView() {
        if !collectionView.tracking && !collectionView.decelerating {
            currentIndex += 1
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: currentIndex, inSection: 0), atScrollPosition: .None, animated: true)
        }
    }
}

// MARK: - UICollectionView Delegate
extension InfinitePictureView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! InfinitePictureViewCell
        cell.imageView.image = UIImage(named: "\(images[indexPath.item])")
        return cell
    }
}

// MARK: - UIScrollView Delegate 
extension InfinitePictureView {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let lastItemOffsetX = collectionView.contentSize.width - collectionView.frame.width
        let firstItemOffsetX = collectionView.frame.width
        
        if scrollView.contentOffset.x >= lastItemOffsetX {
            scrollView.contentOffset = CGPoint(x: frame.width, y: 0)
            currentIndex = 1
        } else if scrollView.contentOffset.x < firstItemOffsetX {
            scrollView.contentOffset = CGPoint(x: lastItemOffsetX - frame.width, y: 0)
            currentIndex = pictureCount
        } else {
            currentIndex = Int(collectionView.contentOffset.x / frame.width)
        }
        pageControl.currentPage = currentIndex - 1
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if currentIndex == images.count - 1 {
            collectionView.contentOffset = CGPoint(x: frame.width, y: 0)
            currentIndex = 1
        }
        pageControl.currentPage = currentIndex - 1
    }
}
