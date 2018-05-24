//
//  TechCollectionViewController.swift
//  TechWishList
//
//  Created by Bhavya Madan on 20/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class TechCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {    
    @IBOutlet var emptyLabel: UILabel!
    lazy var FetchedResultsController: NSFetchedResultsController<Tech> = { () -> NSFetchedResultsController<Tech> in
        let TechFetchRequest = NSFetchRequest<Tech>(entityName: "Tech")
        TechFetchRequest.sortDescriptors = []
        let TechFetchedResultsController = NSFetchedResultsController(fetchRequest: TechFetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        TechFetchedResultsController.delegate = self
        return TechFetchedResultsController
    }()
    var deletedCellIndexPaths: [IndexPath]!
    var sharedContext = CoreDataStack.sharedInstance().managedObjectContext
    var insertedCellIndexPaths: [IndexPath]!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        performFetch(FetchedResultsController)
        if(FetchedResultsController.fetchedObjects?.count != 0){
            emptyLabel.text=""
        }
        collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetch(FetchedResultsController)
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let fetchedTechs = FetchedResultsController.fetchedObjects {
            return fetchedTechs.count
        } else {
            return 0
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            insertedCellIndexPaths.append(newIndexPath!)
            break
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TechCollectionViewCell", for: indexPath) as! TechCollectionViewCell
        cell.collectionCellImageView?.image = #imageLiteral(resourceName: "collectionCellPlaceholder")
        if let fetchedTechs = FetchedResultsController.fetchedObjects {
            let TechForCell = fetchedTechs[(indexPath as NSIndexPath).item]
            if let TechPhotoForCell = TechForCell.photo {
                cell.collectionCellImageView?.image = UIImage(data: TechPhotoForCell as Data)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let fetchedTechs = FetchedResultsController.fetchedObjects {
            let selectedTech = fetchedTechs[(indexPath as NSIndexPath).item]
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "TechDetailViewController") as! TechDetailViewController
            controller.tech = selectedTech
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedCellIndexPaths = [IndexPath]()
        deletedCellIndexPaths = [IndexPath]()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({() -> Void in
            for indexPath in self.insertedCellIndexPaths {
                self.collectionView.insertItems(at: [indexPath])
            }
            for indexPath in self.deletedCellIndexPaths {
                self.collectionView.deleteItems(at: [indexPath])
            }
        }, completion: nil)
    }
    func performFetch(_ TechFetchedResultsController: NSFetchedResultsController<Tech>?) {
        if let TechFetchedResultsController = TechFetchedResultsController {
            var error: NSError?
            do {
                try TechFetchedResultsController.performFetch()
            } catch let TechFetchError as NSError {
                error = TechFetchError
            }
            if error != nil {
                print("Error while performing fetch")
            }
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}
extension TechCollectionViewController: TechDetailsViewControllerDelegate {
    func refresh(editedTech: Tech) {
        performFetch(FetchedResultsController)
        if let index = FetchedResultsController.fetchedObjects?.index(of: editedTech){
            performUIUpdatesOnMain {
                self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
}
