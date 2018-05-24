//
//  memeDetailViewController.swift
//  udacity.mememe.v1
//
//  Created by Bhavya Madan on 14/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
import UIKit
class MemeDetailViewController: UIViewController {
    var meme: Meme!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController!.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
    }
}



