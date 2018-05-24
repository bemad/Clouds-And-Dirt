//
//  YTsearchResultsTableViewController.swift
//  TechWishList
//
//  Created by Bhavya Madan on 20/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
import UIKit

class YTsearchResultsTableViewController: UIViewController {
    let session = URLSession.shared
    var youtubeVideoArray = [YoutubeVideo]()
    var searchTask: URLSessionDataTask?
    var overlay: UIView?
    var selectedYoutubeVideo: YoutubeVideo?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func displayActivityIndicator() {
        let overlayArea = view.frame
        overlay = UIView(frame: overlayArea)
        overlay?.alpha = 0.5
        overlay?.backgroundColor = UIColor.black
        if let overlay = overlay {
            tableView.addSubview(overlay)
        }
        indicator.startAnimating()
    }
    func hideActivityIndicator() {
        if let overlay = overlay {
            overlay.removeFromSuperview()
        }
        indicator.stopAnimating()
    }
    func displayAlert(errorMessage: String?) {
        print(errorMessage!)
        let alert = UIAlertController(title: "Connection Error", message: "Unable to retrive results from YouTube.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .`default`, handler: { _ in
            print("The \"Connection Error\" alert occured.")
        }))
        self.present(alert, animated: true, completion: {
            self.hideActivityIndicator()
        })
    }
    func getYoutubeVideos(searchQuery: String, completionHandlerForGetYoutubeVideos: @escaping (_ youtubeVideoArray: [YoutubeVideo]?, _ success: Bool, _ errorMessage: String?) -> Void) {
        let methodParameters =
            [
                Constants.YoutubeParameterKeys.APIKey: Constants.YoutubeParameterValues.APIKey,
                Constants.YoutubeParameterKeys.ResultType: Constants.YoutubeParameterValues.ResultType,
                Constants.YoutubeParameterKeys.SearchQuery: searchQuery,
                Constants.YoutubeParameterKeys.NumberOfResults: Constants.YoutubeParameterValues.NumberOfResults,
                Constants.YoutubeParameterKeys.SearchResourceProperty: Constants.YoutubeParameterValues.SearchResourceProperty
        ]
        getYoutubeSearchResultsDictionary(searchQuery: searchQuery, methodParameters: methodParameters) { (searchResultsDictionary, success, errorMessage) in
            if success {
                self.convertToYoutubeVideoArray(searchResultsDictionary: searchResultsDictionary!) { (youtubeVideoArray, success, errorMessage) in
                    if success {
                        completionHandlerForGetYoutubeVideos(youtubeVideoArray, true, nil)
                    } else {
                        completionHandlerForGetYoutubeVideos(nil, false, errorMessage)
                    }
                }
            } else {
                completionHandlerForGetYoutubeVideos(nil, false, errorMessage)
            }
        }
    }
}
//MARK: YouTube Helper methods
extension YTsearchResultsTableViewController{
    private func getYoutubeSearchResultsDictionary(searchQuery: String, methodParameters: [String:String], completionHandlerForGetYoutubeSearchResultsDictionary: @escaping (_ searchResultsDictionary: [String: AnyObject]?, _ success: Bool, _ errorMessage: String?) -> Void) {
        let request = URLRequest(url: youtubeUrlFromParameters(methodParameters))
        let task = session.dataTask(with: request) { (data, response, error) in
            self.youtubeTaskAndDataParsingHelper(data: data, response: response, error: error) { (searchResultsDictionary, success, errorString) in
                if success {
                    completionHandlerForGetYoutubeSearchResultsDictionary(searchResultsDictionary, true, nil)
                } else {
                    completionHandlerForGetYoutubeSearchResultsDictionary(nil, false, errorString)
                }
            }
        }
        task.resume()
    }
    private func convertToYoutubeVideoArray(searchResultsDictionary: [String:AnyObject], completionHandlerForConvertToYoutubeVideoArray: @escaping (_ youtubeVideoArray: [YoutubeVideo]?, _ success: Bool, _ errorMessage: String?) -> Void) {
        var youtubeVideoArray = [YoutubeVideo]()
        func displayError(_ errorString: String) {
            completionHandlerForConvertToYoutubeVideoArray(nil, false, errorString)
        }
        guard let videoResultsArray = searchResultsDictionary[Constants.YoutubeResponseKeys.SearchResultItems] as? [[String: AnyObject]] else {
            displayError("Cannot find key \"\(Constants.YoutubeResponseKeys.SearchResultItems)\" in the results from YouTube.")
            return
        }
        for result in videoResultsArray {
            if let youtubeVideo = convertResultEntryToYoutubeVideoObject(resultEntry: result) {
                youtubeVideoArray.append(youtubeVideo)
            }
        }
        guard youtubeVideoArray.count > 0 else {
            displayError("Cannot find any video information in the results from YouTube.")
            return
        }
        completionHandlerForConvertToYoutubeVideoArray(youtubeVideoArray, true, nil)
    }
    private func convertResultEntryToYoutubeVideoObject(resultEntry: [String:AnyObject]) -> YoutubeVideo? {
        guard let resultIdDictionary = resultEntry[Constants.YoutubeResponseKeys.ResultId] as? [String:AnyObject] else {
            print("Cannot find key \"\(Constants.YoutubeResponseKeys.ResultId)\" in \(resultEntry)")
            return nil
        }
        guard let videoId = resultIdDictionary[Constants.YoutubeResponseKeys.VideoId] as? String else {
            print("Cannot find key \"\(Constants.YoutubeResponseKeys.VideoId)\" in \(resultIdDictionary)")
            return nil
        }
        guard let snippetDictionary = resultEntry[Constants.YoutubeResponseKeys.Snippet] as? [String:AnyObject] else {
            print("Cannot find key \"\(Constants.YoutubeResponseKeys.Snippet)\" in \(resultEntry)")
            return nil
        }
        guard let title = snippetDictionary[Constants.YoutubeResponseKeys.VideoTitle] as? String else {
            print("Cannot find key \"\(Constants.YoutubeResponseKeys.VideoTitle)\" in \(snippetDictionary)")
            return nil
        }
        guard let description = snippetDictionary[Constants.YoutubeResponseKeys.VideoDescription] as? String else {
            print("Cannot find key \"\(Constants.YoutubeResponseKeys.VideoDescription)\" in \(snippetDictionary)")
            return nil
        }
        guard let thumbnailsDictionary = snippetDictionary[Constants.YoutubeResponseKeys.VideoThumbnails] as? [String:AnyObject] else {
            print("Cannot find key \"\(Constants.YoutubeResponseKeys.VideoThumbnails)\" in \(snippetDictionary)")
            return nil
        }
        guard let defaultQualityThumbnailDictionary = thumbnailsDictionary[Constants.YoutubeResponseKeys.DefaultQualityThumbnail] as? [String:AnyObject] else {
            print("Cannot find key \"\(Constants.YoutubeResponseKeys.DefaultQualityThumbnail)\" in \(thumbnailsDictionary)")
            return nil
        }
        guard let highQualityThumbnailDictionary = thumbnailsDictionary[Constants.YoutubeResponseKeys.HighQualityThumbnail] as? [String:AnyObject] else {
            print("Cannot find key \"\(Constants.YoutubeResponseKeys.HighQualityThumbnail)\" in \(thumbnailsDictionary)")
            return nil
        }
        guard let defaultQualityThumbnailUrl = defaultQualityThumbnailDictionary[Constants.YoutubeResponseKeys.ThumbnailUrl] as? String else {
            print("Cannot find key \"\(Constants.YoutubeResponseKeys.ThumbnailUrl)\" in \(defaultQualityThumbnailDictionary)")
            return nil
        }
        guard let highQualityThumbnailUrl = highQualityThumbnailDictionary[Constants.YoutubeResponseKeys.ThumbnailUrl] as? String else {
            print("Cannot find key \"\(Constants.YoutubeResponseKeys.ThumbnailUrl)\" in \(highQualityThumbnailDictionary)")
            return nil
        }
        let youtubeVideo = YoutubeVideo(title: title, videoId: videoId, description: description, defaultQualityThumbnailUrl: defaultQualityThumbnailUrl, highQualityThumbnailUrl: highQualityThumbnailUrl)
        return youtubeVideo
    }
    private func youtubeUrlFromParameters(_ parameters: [String:String]) -> URL {
        var components = URLComponents()
        components.scheme = Constants.Youtube.APIScheme
        components.host = Constants.Youtube.APIHost
        components.path = Constants.Youtube.APIPath
        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    private func youtubeTaskAndDataParsingHelper(data: Data?, response: URLResponse?, error: Error?, completionHandlerForYoutubeTaskAndDataParsingHelper: @escaping (_ searchResultsDictionary: [String:AnyObject]?, _ success: Bool, _ errorString: String?) -> Void) {
        guard (error == nil) else {
            let errorString = "There was an error with your request: \(String(describing: error))"
            completionHandlerForYoutubeTaskAndDataParsingHelper(nil, false, errorString)
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            let errorString = "Your request returned a status code other than 2xx!"
            completionHandlerForYoutubeTaskAndDataParsingHelper(nil, false, errorString)
            return
        }
        guard let data = data else {
            let errorString = "No data was returned by the request!"
            completionHandlerForYoutubeTaskAndDataParsingHelper(nil, false, errorString)
            return
        }
        let parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        } catch {
            let errorString = "Could not parse the data as JSON: '\(data)'"
            completionHandlerForYoutubeTaskAndDataParsingHelper(nil, false, errorString)
            return
        }
        completionHandlerForYoutubeTaskAndDataParsingHelper(parsedResult, true, nil)
    }
}
extension YTsearchResultsTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return searchBar.isFirstResponder
    }
}
extension YTsearchResultsTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youtubeVideoArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeResultTableCell", for: indexPath) as! YouTubeSearchResultsTableViewCell
        let youtubeVideo = youtubeVideoArray[indexPath.row]
        cell.textLabel?.text = youtubeVideo.title
        let imageUrl = URL(string: youtubeVideo.defaultQualityThumbnailUrl)
        DispatchQueue.global(qos: .background).async {
            if let imageData = try? Data(contentsOf: imageUrl!) {
                performUIUpdatesOnMain {
                    cell.tableCellImageView?.image = UIImage(data: imageData)
                }
            } else {
                print("Unable to download default quality thumbnail image for video \"\(youtubeVideo.title)\" from URL: \(imageUrl!)")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedYoutubeVideo = youtubeVideoArray[indexPath.row]
        let destinationController = self.storyboard!.instantiateViewController(withIdentifier: "YTVideoViewController") as! YTVideoViewController
        destinationController.youtubeVideo = selectedYoutubeVideo
        navigationController?.pushViewController(destinationController, animated: true)
    }
}

extension YTsearchResultsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let task = searchTask {
            task.cancel()
            hideActivityIndicator()
        }
        if let searchQuery = searchBar.text {
            performUIUpdatesOnMain {
                self.displayActivityIndicator()
            }
            getYoutubeVideos(searchQuery: searchQuery) { (youtubeVideoArray, success, errorMessage) in
                if success {
                    self.youtubeVideoArray = youtubeVideoArray!
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                        self.hideActivityIndicator()
                    }
                    
                } else {
                    performUIUpdatesOnMain {
                        self.displayAlert(errorMessage: errorMessage!)
                    }
                }
            }
        }
        searchBar.resignFirstResponder()
    }
}

