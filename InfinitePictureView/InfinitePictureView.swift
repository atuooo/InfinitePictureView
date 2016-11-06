//
//  InfinitePictureView.swift
//  GuttlerPageControl
//
//  Created by Atuooo on 4/27/16.
//  Copyright © 2016 oOatuo. All rights reserved.
//

import UIKit    

private let cellID = "InfiniteCellID"

class InfinitePictureView: UIView {
    fileprivate var images: [String]!
    fileprivate var collectionView: UICollectionView!
    fileprivate var pageControl: UIPageControl!

    fileprivate var timer: Timer?
    fileprivate var timerDuration: TimeInterval = 3.0
    
    fileprivate var currentIndex = 1
    fileprivate var pictureCount = 0
    
    init(frame: CGRect, imageNames: [String]) {
        super.init(frame: frame)
        
        // handle dataSource 
        images = imageNames
        images.append(imageNames.first!)
        images.insert(imageNames.last!, at: 0)
        pictureCount = imageNames.count
        
        // set collection view
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width, height: frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(InfinitePictureViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: UICollectionViewScrollPosition(), animated: false)
        addSubview(collectionView)
        
        // set page control
        pageControl = UIPageControl(frame: CGRect(x: 0, y: frame.height - 20, width: frame.width, height: 20))
        pageControl.numberOfPages = pictureCount
        pageControl.currentPage = 0
        addSubview(pageControl)
        
        // set timer
        setTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        invalidateTimer()
    }
    
// MARK: - Timer function
    func updatePictureView() {
        if !collectionView.isTracking && !collectionView.isDecelerating {
            currentIndex += 1
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: UICollectionViewScrollPosition(), animated: true)
        }
    }
    
    func setTimer() {
        guard let _ = timer else {
            
            timer = Timer(timeInterval: timerDuration, target: self, selector: #selector(updatePictureView), userInfo: nil, repeats: true)
            timer?.tolerance = timerDuration * 0.1
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)

            return
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - UICollectionView Delegate
extension InfinitePictureView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! InfinitePictureViewCell
        cell.imageView.image = UIImage(named: "\(images[indexPath.item])")
        return cell
    }
}

// MARK: - UIScrollView Delegate 
extension InfinitePictureView {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if currentIndex == images.count - 1 {
            collectionView.contentOffset = CGPoint(x: frame.width, y: 0)
            currentIndex = 1
        }
        pageControl.currentPage = currentIndex - 1
    }
}
