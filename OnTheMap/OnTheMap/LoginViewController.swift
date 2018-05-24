//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Bhavya Madan on 05/02/18.
//  Copyright ©  2018 Bhavya Madan. All rights reserved.
//

import UIKit
class LoginViewController : UIViewController,UITextViewDelegate{
    var appDelegate: AppDelegate!
    var indicator = Indicator()
    @IBOutlet var un: UITextField!
    @IBOutlet var pw: UITextField!
    @IBOutlet var errmsg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    @IBAction func loginButton(_ sender: Any) {
        dismissKeyboard()
        self.view.endEditing(true)
        loginwithUdacity()
        indicator.loadingView(true)
        print("Click hua")
    }
    func loginwithUdacity() {
        UN.sharedInstance().getUData(un: un.text!, pw: pw.text!) { (success, errorMessage, error) in
            if success {
                UN.sharedInstance().getUserData(userID: self.appDelegate.userID) { (success, error) in
                    DispatchQueue.main.async {
                        if success {
                            
                            self.completeLogin()
                        } else {
                            UN.sharedInstance().alertError(self, error: self.appDelegate.errorMessage.CantLogin)
                            self.indicator.loadingView(false)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    UN.sharedInstance().alertError(self, error: errorMessage!)
                    self.indicator.loadingView(false)
                }
            }
        }
    }
    fileprivate func completeLogin() {
        UN.sharedInstance().isExisting(uniqueKey: self.appDelegate.userID)
        UN.sharedInstance().navigateTabBar(self)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        self.view.frame.origin.y = -getKeyboardHeight(notification)
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }

}
