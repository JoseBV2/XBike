//
//  OnboardingData.swift
//  XBike
//
//  Created by Jóse Bustamante on 10/08/22.
//

import UIKit

class OnboardingData: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var bikeImageView: UIImageView!
    var currentText: String?
    var index: Int?
    var currentImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        descriptionLabel.textColor = .black
        descriptionLabel.text = currentText
        bikeImageView.image = UIImage(named: currentImage!)
    }


}

