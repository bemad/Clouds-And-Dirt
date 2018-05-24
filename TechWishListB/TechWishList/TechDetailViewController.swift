//
//  TechDetailViewController.swift
//  TechWishList
//
//  Created by Bhavya Madan on 20/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
import UIKit
protocol TechDetailsViewControllerDelegate: class {
    func refresh(editedTech: Tech)
}
class TechDetailViewController: UIViewController {
    var tech: Tech?
    weak var delegate: TechDetailsViewControllerDelegate? = nil
    @IBOutlet weak var ttitle: UINavigationItem!
    @IBOutlet weak var techIV: UIImageView!
    @IBOutlet weak var PrefrsTV: UITextView!
    @IBOutlet weak var SpecsTV: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tech = tech {
            displayTechAttributes(tech: tech)
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddTechViewController" {
            let destinationController = segue.destination as! AddTechViewController
            destinationController.tech2 = tech
            destinationController.delegate = self
        }
    }
    func displayTechAttributes(tech: Tech) {
        if let techSpecs = tech.specs {
            SpecsTV.text = techSpecs
        }
        if let techTitle = tech.title {
            ttitle.title = techTitle
        }
        if let techPhoto = tech.photo {
            techIV.image = UIImage.init(data: techPhoto as Data)
        }
        if let techPrefrs = tech.prefr {
            PrefrsTV.text = techPrefrs
        }
    }
}
extension TechDetailViewController: AddTechViewControllerDelegate {
    func dismissAndRefresh(editedTech: Tech) {
        dismiss(animated: true, completion: nil)
        displayTechAttributes(tech: editedTech)
        delegate?.refresh(editedTech: editedTech)
    }
}
