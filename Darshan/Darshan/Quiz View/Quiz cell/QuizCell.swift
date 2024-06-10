//
//  QuizCell.swift
//  Darshan
//
//  Created by Darshan on 10/06/24.
//

import UIKit
import M13Checkbox

class QuizCell: UICollectionViewCell {
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblWellDone: UILabel!
    @IBOutlet weak var lblQue: UILabel!
    @IBOutlet weak var opt1: M13Checkbox!
    @IBOutlet weak var lblOpt1: UILabel!
    @IBOutlet weak var opt2: M13Checkbox!
    @IBOutlet weak var lblOpt2: UILabel!
    @IBOutlet weak var opt3: M13Checkbox!
    @IBOutlet weak var lblOpt3: UILabel!
    @IBOutlet weak var opt4: M13Checkbox!
    @IBOutlet weak var lblOpt4: UILabel!
    @IBOutlet weak var lblResponse: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnReplay: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    
    @IBOutlet weak var viewResult: UIView!
    @IBOutlet weak var lblRighAns: UILabel!
    @IBOutlet weak var lblWrongAns: UILabel!
    @IBOutlet weak var lblSkipAns: UILabel!
    
    var onSubmit: (() -> (Void))?
    var onReplay: (() -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
    }
    
    func setData(data: Question, correct : Int, wrong: Int){
        lblQue.text = data.question
        lblOpt1.text = data.ans1
        lblOpt2.text = data.ans2
        lblOpt3.text = data.ans3
        lblOpt4.text = data.ans4
        lblRighAns.text = "Your right ans is: \(correct)"
        lblWrongAns.text = "Your wrong ans is: \(wrong)"
        let skip = 10 - (correct + wrong)
        lblSkipAns.text = "Your skip ans is: \(skip)"
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        self.onSubmit?()
    }
    
    
    @IBAction func btnRepplay(_ sender: UIButton) {
        self.onReplay?()
    }
    
    @IBAction func btnHome(_ sender: UIButton) {
        if let vc = topVC{
            vc.navigationController?.popViewController(animated: true)
        }
    }
    
}
    
    

extension QuizCell{
    func configureView(){
        self.lblWellDone.isHidden = true
        self.lblResponse.isHidden = true
        self.btnSubmit.layer.cornerRadius = 8
        self.btnReplay.layer.cornerRadius = 8
        self.btnHome.layer.cornerRadius = 8
        self.btnSubmit.isHidden = true
        self.btnHome.isHidden = true
        self.btnReplay.isHidden = true
        self.viewResult.isHidden = true
        self.opt1.changesCheckStatus = { [weak self] changedStatus in
            guard let self = self else {return}
            if changedStatus == .checked{
                self.opt2.checkState = .unchecked
                self.opt3.checkState = .unchecked
                self.opt4.checkState = .unchecked
            }
        }
        self.opt2.changesCheckStatus = { [weak self] changedStatus in
            guard let self = self else {return}
            if changedStatus == .checked{
                self.opt1.checkState = .unchecked
                self.opt3.checkState = .unchecked
                self.opt4.checkState = .unchecked
            }
        }
        self.opt3.changesCheckStatus = { [weak self] changedStatus in
            guard let self = self else {return}
            if changedStatus == .checked{
                self.opt2.checkState = .unchecked
                self.opt1.checkState = .unchecked
                self.opt4.checkState = .unchecked
            }
        }
        self.opt4.changesCheckStatus = { [weak self] changedStatus in
            guard let self = self else {return}
            if changedStatus == .checked{
                self.opt2.checkState = .unchecked
                self.opt3.checkState = .unchecked
                self.opt1.checkState = .unchecked
            }
        }
    }
}


