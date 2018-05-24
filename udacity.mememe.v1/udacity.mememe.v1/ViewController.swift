//
//  ViewController.swift
//  udacity.mememe.v1
//
//  Created by Bhavya Madan on 06/06/17.
//  Copyright © 2017 Bhavya Madan. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextViewDelegate {
    @IBOutlet weak var shareButon: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UIToolbar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var BOTTOMtextField: UITextField!
    @IBOutlet weak var TOPtextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    let textFieldDelegate = TextFieldDelegate()
    @IBOutlet weak var imagePickerView: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName:UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 38)!,
        NSStrokeWidthAttributeName: -3.0,
        ]
    func defaults(TF: UITextField){
        TF.delegate = textFieldDelegate
        TF.defaultTextAttributes = memeTextAttributes
        TF.textAlignment = NSTextAlignment.center
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults(TF: self.TOPtextField)
        defaults(TF: self.BOTTOMtextField)
        shareButon.isEnabled = false
    }
    @IBAction func pickFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    @IBAction func pickAnImage(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success{
                self.save() // call save- which is in progress.
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func cancelButton(_ sender: Any) {
  /*      imagePickerView.image = nil
        TOPtextField.text = "TOP"
        BOTTOMtextField.text = "BOTTOM"
        shareButon.isEnabled = false
*/
//        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = selectedImage
        }
        dismiss(animated: true, completion: { () -> Void in
            self.shareButon.isEnabled = true
        })
        
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func keyboardWillShow(_ notification:Notification) {
        shareButon.isEnabled = true
     //   view.frame.origin.y = -getKeyboardHeight(notification)
        if BOTTOMtextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    
    
    func generateMemedImage() -> UIImage {
        hideTopAndBottomBars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideTopAndBottomBars(false)
        return memedImage
    }
    func hideTopAndBottomBars(_ hide: Bool) {
        toolbar.isHidden = hide
        navigationBar.isHidden = hide
    }
    func save() {
        if((TOPtextField.text != nil)&&(BOTTOMtextField.text != nil)&&(imagePickerView.image != nil)){
            let tmeme = Meme(topText: TOPtextField.text!, bottomText: BOTTOMtextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.maymay.append(tmeme)
        }
    }
    
    
}





