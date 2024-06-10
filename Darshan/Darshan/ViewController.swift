//
//  ViewController.swift
//  Darshan
//
//  Created by Darshan on 10/06/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnStart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnStart.layer.cornerRadius = 8
    }

    @IBAction func btnStart(_ sender: UIButton) {
        let vc = QuizVC.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

