//
//  TableViewController.swift
//  udacity.mememe.v1
//
//  Created by Bhavya Madan on 01/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
import UIKit
class TableViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var allMemes: [Meme]!
    let cellReuseIdentifier = "MyCellReuseIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100.0
        self.tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.allMemes = appDelegate.maymay
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMemes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! cellForTable
        cell.sentMemesCellLabel2.text = allMemes[indexPath.row].topText+"..."+allMemes[indexPath.row].bottomText
//        cell.sentMemesCellLabel2.text = allMemes[indexPath.row].bottomText
        cell.sentMemesCellImage.image = allMemes[indexPath.row].memedImage
        //cell.label?.text = meme.topText! + "..." + meme.bottomText!

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object: AnyObject = storyboard!.instantiateViewController(withIdentifier: "MemeDetail")
        let detailVC = object as! MemeDetailViewController
        //Populate view controller with data from the selected item
        detailVC.meme = allMemes[indexPath.row] as Meme
        navigationController!.pushViewController(detailVC, animated: true)
  }

}
