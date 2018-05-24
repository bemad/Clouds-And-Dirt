//
//  AddTechViewController.swift
//  TechWishList
//
//  Created by Bhavya Madan on 20/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//
//
import CoreData
import Foundation
import UIKit
protocol AddTechViewControllerDelegate: class {
    func dismissAndRefresh(editedTech: Tech)
}
class AddTechViewController: UIViewController, NSFetchedResultsControllerDelegate {
    lazy var techFetchedResultsController: NSFetchedResultsController<Tech> = { () -> NSFetchedResultsController<Tech> in
        let techFetchRequest = NSFetchRequest<Tech>(entityName: "Tech")
        techFetchRequest.sortDescriptors = []
        if let title = tech2?.title {
            let predicate = NSPredicate(format: "title == %@", title)
            techFetchRequest.predicate = predicate
        } else if let title = techTitleTextField.text {
            let predicate = NSPredicate(format: "title == %@", title)
            techFetchRequest.predicate = predicate
        }
        let techFetchedResultsController = NSFetchedResultsController(fetchRequest: techFetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        techFetchedResultsController.delegate = self
        return techFetchedResultsController
    }()
    
    var sharedContext = CoreDataStack.sharedInstance().managedObjectContext
    var photoAddTapGesture: UIGestureRecognizer!
    var keyboardDismissTapGesture: UIGestureRecognizer?
    var keyboardHeight: CGFloat?
    var tech2: Tech?
    weak var delegate: AddTechViewControllerDelegate? = nil
    var youtubeVideo: YoutubeVideo?
    @IBOutlet weak var addTechIV: UIImageView!
    @IBOutlet weak var prefrTV: UITextView!
    @IBOutlet weak var specsTV: UITextView!
    @IBOutlet weak var button: UIBarButtonItem!
    @IBOutlet weak var techTitleTextField: UITextField!
    @IBOutlet weak var titleUpper: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        photoAddTapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhoto(tapGestureRecognizer:)))
        addTechIV.isUserInteractionEnabled = true
        addTechIV.addGestureRecognizer(photoAddTapGesture)
        //dont kill me for this xD
        if let tech33 = tech2 {
            performFetch(techFetchedResultsController)
            //EditTech(tech33: tech)
            titleUpper.title = "Edit Tech"
            if let techTitle = tech33.title {
                techTitleTextField.text = techTitle
            }
            if let techPrefr = tech33.prefr {
                prefrTV.text = techPrefr
            }
            if let techSpecs = tech33.specs {
                specsTV.text = techSpecs
            }
            if let techPhoto = tech33.photo {
                addTechIV.image = UIImage.init(data: techPhoto as Data)
            }
            
        }
        if let youtubeVideo = youtubeVideo {
            configureUIForAddTechFromYoutube(youtubeVideo: youtubeVideo)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        techTitleTextField.addTarget(self, action: #selector(textFieldHasText), for: .editingChanged)
        //https://stackoverflow.com/a/30775879/8689882
        subscribeToKeyboardNotifications()
    }
   
    @IBAction func dismissWithoutSaving(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @objc func addPhoto(tapGestureRecognizer: UITapGestureRecognizer) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            self.presentImagePicker(sourceType: .photoLibrary)
        } else {
            let toDisplay = UIAlertController(title: "Add a Photo ", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let takePicture = UIAlertAction(title: "Take a Picture ", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.presentImagePicker(sourceType: .camera)
            })
            let chooseFromExisting = UIAlertAction(title: "Choose from Album ", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                self.presentImagePicker(sourceType: .photoLibrary)
            })
            let cancel = UIAlertAction(title: " Cancel ", style: UIAlertActionStyle.cancel, handler: nil)
            toDisplay.addAction(takePicture)
            toDisplay.addAction(chooseFromExisting)
            toDisplay.addAction(cancel)
            present(toDisplay, animated: true, completion: nil)
        }
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        keyboardHeight = getKeyboardHeight(notification)
        if !techTitleTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:)))
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
        self.addTechIV.removeGestureRecognizer(photoAddTapGesture)
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if !techTitleTextField.isFirstResponder {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
        if keyboardDismissTapGesture != nil {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
        self.addTechIV.addGestureRecognizer(photoAddTapGesture)
    }
    
    @objc func dismissKeyboard(sender: AnyObject) {
        specsTV.resignFirstResponder()
        prefrTV.resignFirstResponder()
        techTitleTextField.resignFirstResponder()
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    @IBAction func saveTech(_ sender: Any) {
        techTitleTextField.resignFirstResponder()
        if tech2 == nil || youtubeVideo != nil {
            performFetch(techFetchedResultsController)
            if let previouslySavedTechList = techFetchedResultsController.fetchedObjects, previouslySavedTechList.count > 0 {
                //https://stackoverflow.com/a/37992026/8689882
                let errorMessage = "Already a saved tech with this title."
                let alert = UIAlertController(title: "Duplicate Tech", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    print("The \"Duplicate Tech\" alert occured.")
                }))
                self.present(alert, animated: true, completion: {
                    self.techTitleTextField.text = ""
                })
                return
            }
            self.sharedContext.performAndWait {
                let techToSave = Tech(context: self.sharedContext)
                saveTechAttributes(techToUpdate: techToSave)
                CoreDataStack.sharedInstance().saveContext()
            }
            dismiss(animated: true, completion: nil)
        } else {
            if let fetchedTechList = techFetchedResultsController.fetchedObjects {
                let editedTech = fetchedTechList[0]
                self.sharedContext.performAndWait {
                    saveTechAttributes(techToUpdate: editedTech)
                    CoreDataStack.sharedInstance().saveContext()
                }
                delegate?.dismissAndRefresh(editedTech: editedTech)
            }
        }
    }
    func saveTechAttributes(techToUpdate: Tech) {
        if let techPhoto = addTechIV.image {
            let techPhotoData = UIImagePNGRepresentation(techPhoto) as NSData?
            techToUpdate.photo = techPhotoData
        }
        if let techSpecs = specsTV.text {
            techToUpdate.specs = techSpecs
        }
        if let techTitle = techTitleTextField.text {
            techToUpdate.title = techTitle
        }
        if let techPrefr = prefrTV.text {
            techToUpdate.prefr = techPrefr
        }
    }
    func configureUIForAddTechFromYoutube(youtubeVideo: YoutubeVideo) {
        techTitleTextField.text = youtubeVideo.title
        let imageUrl = URL(string: youtubeVideo.highQualityThumbnailUrl)
        DispatchQueue.global(qos: .background).async {
            if let imageData = try? Data(contentsOf: imageUrl!) {
                performUIUpdatesOnMain {
                    self.addTechIV.image = UIImage(data: imageData)
                }
            } else {
                print("Unable to download thumbnail image for video")
            }
        }
    }
    func performFetch(_ techFetchedResultsController: NSFetchedResultsController<Tech>?) {
        if let techFetchedResultsController = techFetchedResultsController {
            var error2: NSError?
            do {
                try techFetchedResultsController.performFetch()
            } catch let techFetchError as NSError {
                error2 = techFetchError
            }
            if error2 != nil {
                print("Error performing fetch")
            }
        }
    }
    
}
extension AddTechViewController: UITextFieldDelegate {
    @objc func textFieldHasText(_ textBox: UITextField) {
        if textBox.text?.count == 1 {
            if textBox.text?.first == " " {
                textBox.text = ""
                return
            }
        }
        guard
            let techTitleText = techTitleTextField.text, !techTitleText.isEmpty
            else {
                return
        }
        button.isEnabled = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
extension AddTechViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let UIIPC = UIImagePickerController()
        UIIPC.allowsEditing = true
        UIIPC.delegate = self
        UIIPC.sourceType = sourceType
        present(UIIPC, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addTechIV.image = image
        }
        dismiss(animated: true, completion: {
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension AddTechViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if view.frame.origin.y >= 0 {
            if let keyboardHeight = keyboardHeight {
                view.frame.origin.y -= keyboardHeight
            }
        }
    }
    func textViewDidChange(_ textView: UITextView) {
    }
}

