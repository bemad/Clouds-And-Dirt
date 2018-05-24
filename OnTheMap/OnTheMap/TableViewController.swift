//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Bhavya Madan on 13/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
import UIKit
class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell")!
        return infoCell
    }
    
    var indicator = Indicator()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
   /* @IBOutlet var tableView: UITableView!

    @IBAction func refreshButton(_ sender: Any) {
        
        indicator.loadingView(true)
        loadTableView()
    }
    @IBAction func addLocation(_ sender: Any) {
        
        UN.sharedInstance().addLocation(self)
    }
    @IBAction func logoutButton(_ sender: Any) {
        
        UN.sharedInstance().logoutID(controller: self)
        
    }
    
    override func viewDidLoad() {
        
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        indicator.loadingView(true)
        loadTableView()
        print(tableView(tableView, numberOfRowsInSection: 100))
    }
    
    func loadTableView() {
        
        UN.sharedInstance().getUsersData {(success, error) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.indicator.loadingView(false)
                }
                
            } else {
                
                self.indicator.stopAnimating()
                
                UN.sharedInstance().alertError(self, error: self.appDelegate.errorMessage.DataError)
            }
        }
    }
    
    //Table View Data Info
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if UsersInfo.UsersArray.count<100 {
            return UsersInfo.UsersArray.count
        }
        else {
            
            return 100
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell")!
        let user = UsersInfo.UsersArray[indexPath.row]
        
        
        infoCell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        infoCell.imageView?.image = UIImage(named: "pin")
        infoCell.detailTextLabel?.text = user.mediaURL
        
        return infoCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = UsersInfo.UsersArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        let app = UIApplication.shared
        if UN.sharedInstance().checkURL(user.mediaURL){
            app.openURL(URL(string: user.mediaURL)!)
        } else {
            UN.sharedInstance().alertError(self, error: self.appDelegate.errorMessage.InvalidLink)
        }
        
        
    }
    
    
*/
    
}
