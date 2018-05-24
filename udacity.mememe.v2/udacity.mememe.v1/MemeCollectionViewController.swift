//
//  MemeCollectionViewController.swift
//  udacity.mememe.v1
//
//  Created by Bhavya Madan on 30/07/17.
//  Copyright © 2017 Bhavya Madan. All rights reserved.
//

import UIKit
class MemeCollectionViewController : UICollectionViewController{
    var memesz: [Meme]!
    let cellIdentifier="MyCollectionCellIdentifier"
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 4.0
        let cellWidth = (view.frame.size.width - (3 * space)) / 4.0
        let cellHeight = (view.frame.size.height - (3 * space)) / 4.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        //self.collectionView.delegate=self
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memesz = appDelegate.maymay
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memesz.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! cellForCollection
        let meme = memesz[indexPath.item].memedImage
        cell.sentMemesCellImage.image = meme
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let object: AnyObject = storyboard!.instantiateViewController(withIdentifier: "MemeDetail")
        let detailVC = object as! MemeDetailViewController
        //Populate view controller with data from the selected item
        detailVC.meme = memesz[indexPath.row] as Meme
        navigationController!.pushViewController(detailVC, animated: true)
    }


}


