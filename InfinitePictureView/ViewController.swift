//
//  ViewController.swift
//  InfinitePictureView
//
//  Created by Atuooo on 4/27/16.
//  Copyright © 2016 oOatuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let images = ["a", "b", "c", "d"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        let collectionView = InfinitePictureView(frame: frame, imageNames: images)
        collectionView.tag = 10
        collectionView.center = view.center
        view.addSubview(collectionView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

