//
//  Network.swift
//  OnTheMap
//
//  Created by Bhavya Madan on 10/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
import UIKit

class UN{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func getUData(un: String, pw: String, completionHandlerForAuth: @escaping (_ success: Bool,_ errormsg: String?, _ error: NSError?) -> Void) {
        
        let req = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = "{\"udacity\": {\"username\": \"\(un)\", \"password\": \"\(pw)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let work = session.dataTask(with: req as URLRequest) { data, response, error in
            func handleError(error: String, errormsg: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForAuth(false, errormsg, NSError(domain: "getUdacityData", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                handleError(error: "Error(req)>> \(error)", errormsg: self.appDelegate.errorMessage.CantLogin)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                handleError(error: "Request returned a status code other than 2xx!", errormsg: self.appDelegate.errorMessage.InvalidEmail)
                return
            }
            guard let data = data else {
                handleError(error: "No Data ", errormsg: self.appDelegate.errorMessage.CantLogin)
                return
            }
            let stringData = String(data: data, encoding: String.Encoding.utf8)
            print(stringData ?? "Done!")
            
            let newData = data.subdata(in: Range(uncheckedBounds: (5, data.count)))
            let stringnewData = String(data: newData, encoding: String.Encoding.utf8)
            
            print(stringnewData ?? "Done!")
            let parsedResult = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments)
            guard let dictionary = parsedResult as? [String: Any] else {
                handleError(error: "dictionary err", errormsg: self.appDelegate.errorMessage.CantLogin)
                return
            }
            guard let account = dictionary["account"] as? [String:Any] else {
                handleError(error: "Cannot Find Key 'Account' In \(parsedResult)", errormsg: self.appDelegate.errorMessage.CantLogin)
                return
            }
            guard let userID = account["key"] as? String else {
                handleError(error: "Cannot Find Key 'Key' In \(account)", errormsg: self.appDelegate.errorMessage.CantLogin)
                return
            }
            self.appDelegate.userID = userID
            
            
            completionHandlerForAuth(true, nil, nil)
        }
        work.resume()
    }
    func getUserData(userID: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        let req = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/users/\(userID)")! as URL)
        let session = URLSession.shared
        let work = session.dataTask(with: req as URLRequest) { data, response, error in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForAuth(false, NSError(domain: "getUserData", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError(error: "Error (req)>> \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your Request Returned A Status Code Other Than 2xx!")
                return
            }
            guard let data = data else {
                sendError(error: "No Data ")
                return
            }
            let newData = data.subdata(in: Range(5..<data.count))
            let parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments)
            } catch {
                sendError(error: "Could Not Parse The Data As JSON: '\(data)'")
                return
            }
            guard let dictionary = parsedResult as? [String: Any] else {
                sendError(error: "Cannot Parse")
                return
            }
            guard let user = dictionary["user"] as? [String: Any] else {
                sendError(error: "Cannot Find Key 'user' In \(parsedResult)")
                return
            }
            guard let ln = user["last_name"] as? String else {
                sendError(error: "Cannot Find lastName In \(user)")
                return
            }
            guard let fn = user["first_name"] as? String else {
                sendError(error: "Cannot Find FirstName In \(user)")
                return
            }
            self.appDelegate.lNAD = ln
            self.appDelegate.fNAD = fn
            completionHandlerForAuth(true, nil)
        }
        work.resume()
    }
    
    func getUsersData(completionHandlerForData: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        let req = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt&limit=100")! as URL)
        req.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        req.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let work = session.dataTask(with: req as URLRequest) { data, response, error in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForData(false, NSError(domain: "getStudentData", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError(error: "error (Req)>> \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your Request Returned A Status Code Other Than 2xx!")
                return
            }
            guard let data = data else {
                sendError(error: "No Data ")
                return
            }
            let parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch {
                sendError(error: "Could Not Parse The Data As JSON: '\(data)'")
                return
            }
            if let results = parsedResult as? [String: Any] {
                if let resultSet = results["results"] as? [[String: Any]]{
                    UsersInfo.UsersArray = UsersInfo.UsersDataResults(resultSet)
                    print("yolo? \(UsersInfo.UsersArray)")
                    completionHandlerForData(true, nil)
                }
            } else {
                sendError(error: "Some Error :/")
            }
        }
        work.resume()
    }
    func isExisting(uniqueKey: String) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(uniqueKey)%22%7D"
        let url = NSURL(string: urlString)
        let req = NSMutableURLRequest(url: url! as URL)
        req.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        req.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let work = session.dataTask(with: req as URLRequest) { data, response, error in
            guard (error == nil) else {
                self.appDelegate.willOverwrite = false
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                self.appDelegate.willOverwrite = false
                return
            }
            guard let data = data else {
                self.appDelegate.willOverwrite = false
                return
            }
            let parsedResult: Any!
            do {
                print(String(data: data, encoding: .utf8)!)
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            var usersList = [UsersInfo]()
            if let results = parsedResult as? [String: Any] {
                if let resultSet = results["results"] as? [[String: Any]]{
                    for result in resultSet {
                        if let UsersInfo = UsersInfo(dictionary: result) {
                            usersList.append(UsersInfo)
                        }
                    }
                    let user =  UsersInfo.UsersDataResults(resultSet)[0]
                    self.appDelegate.willOverwrite = true
                    self.appDelegate.fNAD = user.firstName
                    self.appDelegate.lNAD = user.lastName
                    self.appDelegate.objectId = user.objectId
                    self.appDelegate.uniqueKey = user.uniqueKey
                }
            }
        }
        work.resume()
    }
    func logoutID(controller: UIViewController) {
        let req = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
        req.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            req.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let work = session.dataTask(with: req as URLRequest) { data, response, error in
            guard (error == nil) else {
                print("error(Req)>> \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your Request Returned A Status Code Other Than 2xx!")
                return
            }
            guard data != nil else {
                print("No Data")
                return
            }
            print("Bye-Bye User")
        }
        work.resume()
    }
    func postNew(student: UsersInfo, location: String, completionHandlerForPost: @escaping (_ success: Bool, _ error: NSError?)->Void) {
        let req = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")! as URL)
        req.httpMethod = "POST"
        req.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        req.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.lat), \"longitude\": \(student.long)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let work = session.dataTask(with: req as URLRequest) { data, response, error in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPost(false, NSError(domain: "postNew", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError(error: "error(Req)>> \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your Request Returned A Status Code Other Than 2xx!")
                return
            }
            guard data != nil else {
                sendError(error: "No Data")
                return
            }
            completionHandlerForPost(true, nil)
        }
        work.resume()
    }
    func updateUserData(student: UsersInfo, location: String, completionHandlerForPut: @escaping (_ success: Bool, _ error: NSError?)->Void) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(student.objectId)"
        let url = NSURL(string: urlString)
        let req = NSMutableURLRequest(url: url! as URL)
        //upload type thing?
        req.httpMethod = "PUT"
        req.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        req.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.lat), \"longitude\": \(student.long)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let work = session.dataTask(with: req as URLRequest) { data, response, error in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPut(false, NSError(domain: "updateStudentData", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError(error: "error(req) \(error)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your Request Returned A Status Code Other Than 2xx!")
                return
            }
            guard data != nil else {
                sendError(error: "No Data")
                return
            }
            completionHandlerForPut(true, nil)
        }
        work.resume()
    }
    class func sharedInstance() -> UN {
        struct Singleton {
            static var sharedInstance = UN()
        }
        return Singleton.sharedInstance
    }
    
    func alertError(_ controller: UIViewController, error: String) {
        let AlertController = UIAlertController(title: "", message: error, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) {
            action in AlertController.dismiss(animated: true, completion: nil)
        }
        AlertController.addAction(cancelAction)
        controller.present(AlertController, animated: true, completion: nil)
    }
    //stuff
    
    //yahan crash hoga
    func navigateTabBar(_ controller: UIViewController) {
        let TabBarController = controller.storyboard!.instantiateViewController(withIdentifier: "TabBarMapController") as! UITabBarController
        controller.present(TabBarController, animated: true, completion: nil)
    }
    func addLocation(_ controller: UIViewController) {
        let AlertController = UIAlertController(title: "", message: "User \(appDelegate.fNAD) \(appDelegate.lNAD) Already Posted A Student Location. Would You Like To Overwrite Their Location?", preferredStyle: .alert)
        let InfoViewController = controller.storyboard!.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        let willOverwriteAlert = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) {
            action in controller.present(InfoViewController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            action in AlertController.dismiss(animated: true, completion: nil)
        }
        
        AlertController.addAction(willOverwriteAlert)
        AlertController.addAction(cancelAction)
        
        
        if (UIApplication.shared.delegate as! AppDelegate).willOverwrite {
            controller.present(AlertController, animated:true, completion: nil)
        } else {
            controller.present(InfoViewController, animated: true, completion: nil)
        }
    }
    
    func logout(_ controller: UIViewController) {
        
        controller.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    func checkURL(_ url: String) -> Bool {
        if let url = URL(string: url) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }

    
}
class Indicator: UIActivityIndicatorView {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    required init(coder aDecoder: NSCoder){
        fatalError("use init(")
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    }
    
    func loadingView(_ isloading: Bool) {
        if isloading {
            self.startAnimating()
        } else {
            self.stopAnimating()
            self.hidesWhenStopped = true
            
        }
    }
}
class addLocationDelegate: NSObject, UITextFieldDelegate {
    
    override init() {
        
        super.init()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
}

