//
//  CollectionViewController.swift
//  fifthApp
//
//  Created by Bhavya Madan on 01/03/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class CollectionViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var flayout: UICollectionViewFlowLayout!
    //MARK: Variables
    var pin: Pin!
    var photos = [Photo]()
    var photosToDelete = [Photo]()
    //To download or not to download
    func fetchPhotos() -> [Photo]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        let predicate = NSPredicate(format: "pin == %@", argumentArray: [pin])
        fetchRequest.predicate = predicate
        do {
            if let result = try CoreDataObject.shared.context.fetch(fetchRequest) as? [Photo] {
                if(result.count>0){
                    return result
                }
                else{
                    return nil
                }
            }
        }
        catch {
            print("Error getting data")
        }
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: MiniMap Configuration
        let pointAnnotation = MKPointAnnotation()
        let latti=pin.lat
        let longi=pin.lon
        //Changing this variable changes the zoom level
        let dist: Double=1500
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(latti, longi)
        map.addAnnotation(pointAnnotation)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(pointAnnotation.coordinate, dist, dist)
        map.setRegion(coordinateRegion, animated: true)
        //MARK: CollectionView Configuration
        //meme-meV2.
        let space: CGFloat = 3.0
        flayout.minimumInteritemSpacing = space
        flayout.minimumLineSpacing = space
        let dim = (view.frame.size.width - (2 * space)) / 3.0
        flayout.itemSize = CGSize(width: dim, height: dim)
        //Get Photos
        if let fetchResult = fetchPhotos() {
            photos = fetchResult
        } else {
            getDataAgain()
        }
    }
    //this function was taken from forums but i am unable to find the link now
    //it looks ugly but if it works it is cool
    func detRangeLonLat(lat: Double, lon: Double) -> String {
        var minLon,maxLon,minLat,maxLat: Double;
        minLon = -180.0
        minLat = -90.0
        maxLat = 90.0
        maxLon = 180.0
        if(lon-1 > -180.0){
            minLon = lon - 1
        }
        if(lat-1 > -90.0){
            minLat = lat-1
        }
        if(lat+1 < 90){
            maxLat = lat+1
        }
        if(lon+1 < 180.0){
            maxLon = lon+1
        }
        return "\(minLon),\(minLat),\(maxLon),\(maxLat)"
    }
    func getDataAgain(){
        for photo in photos {
            CoreDataObject.shared.context.delete(photo)
        }
        CoreDataObject.shared.save()
        photos = [Photo]()
        collectionView.reloadData()
        if let fetchResult = fetchPhotos() {
            photos = fetchResult
        } else {
            //MARK: Network Request using hardcoded URL
            let rane=detRangeLonLat(lat: pin.lat, lon: pin.lon)
            let urllink="https://api.flickr.com/services/rest?method=flickr.photos.search&format=json&api_key=1f65d26c317820f3e3ef308b227aef6a&bbox={bbox}&per_page=21&page={page}&extras=url_m&nojsoncallback=1"
            var url = urllink.replacingOccurrences(of: "{bbox}", with: String(rane))
            url = url.replacingOccurrences(of: "{page}", with: "\(arc4random_uniform(10) + 1)")
            let request = NSMutableURLRequest(url: URL(string: url)!)
            let work = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                guard (error == nil) else {
                    print("Request Error")
                    return
                }
                guard let data = data else {
                    print("No data!")
                    return
                }
                guard let code = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(code) else {
                    print("Bad http code status code")
                    return
                }
                var parsedResult: AnyObject! = nil
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                } catch {
                    print("Error parsing json")
                }
                
                var photoUrls=[String]()
                if let dict = parsedResult!["photos"] as? [String : AnyObject] {
                    if let photos = dict["photo"] as? [[String:AnyObject]] {
                        for photo in photos {
                            if let photoUrl = photo["url_m"] as? String {
                                photoUrls.append(photoUrl)
                            }
                        }
                    }
                    for url in photoUrls{
                        let localPhoto = Photo(context: CoreDataObject.shared.context)
                        localPhoto.url = url
                        localPhoto.pin = self.pin
                        self.photos.append(localPhoto)
                    }
                    CoreDataObject.shared.save()
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
            work.resume()
        }
    }
    @IBAction func collectionButtonPressed(_ sender: Any) {
        getDataAgain()
    }
}
extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    //Collection View Config
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        CoreDataObject.shared.context.delete(photo)
        photos.remove(at: photos.index(of: photo)!)
        photosToDelete = [Photo]()
        CoreDataObject.shared.save()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        let cellImage = photos[indexPath.row]
        colCell.imageView.image = nil
        colCell.activityIndicator.isHidden = false
        if let imgData = cellImage.image {
            let image = UIImage(data: imgData as Data)
            colCell.imageView.image = image
            colCell.activityIndicator.isHidden = true
        }
        else
        {
            colCell.activityIndicator.startAnimating()
            //MARK: Netowrk Req for imageData
            let request = NSMutableURLRequest(url: URL(string: cellImage.url!)!)
            let work = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                guard (error == nil) else {
                    print("Request Error")
                    return
                }
                guard let data = data else {
                    print("No data!")
                    return
                }
                guard let code = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(code) else {
                    print("Bad http code status code")
                    return
                }
                let downloadedImage = UIImage(data: data)
                cellImage.image = data as NSData? as Data?
                DispatchQueue.main.async {
                    colCell.activityIndicator.stopAnimating()
                    colCell.imageView.image = downloadedImage
                    colCell.activityIndicator.isHidden = true
                }
                CoreDataObject.shared.save()
            }
            work.resume()
        }
        return colCell
    }
}
