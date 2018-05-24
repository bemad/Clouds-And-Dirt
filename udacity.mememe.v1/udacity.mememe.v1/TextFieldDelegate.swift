//
//  TextFieldDelegate.swift
//  udacity.mememe.v1
//
//  Created by Bhavya Madan on 12/06/17.
//  Copyright © 2017 Bhavya Madan. All rights reserved.
//

import Foundation
import UIKit
class TextFieldDelegate: NSObject, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
