//
//  SuccessPopupViewController.swift
//  SwiftTaxi
//
//  Created by Priya Gnaneshwaran on 18/04/25.
//

import UIKit

class SuccessPopupViewController: UIViewController {

    @IBOutlet weak var baseView: UIView!
    
    var updateCallBack: ((Bool) -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionDone(_ sender: UIButton) {
        self.updateCallBack?(true)
        self.dismiss(animated: true)
    }
}
