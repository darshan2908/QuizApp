//
//  QuizVC.swift
//  Darshan
//
//  Created by Darshan on 10/06/24.
//

import UIKit

class QuizVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    private var arrQue = [Question](){
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var index = 0
    private var correctCount : Int = 0
    private var wrongCount : Int = 0
    private var answer : String = ""
    
    class func instance() -> QuizVC{
        let sMain = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = sMain.instantiateViewController(withIdentifier: "QuizVC") as! QuizVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView(){
        self.navigationController?.navigationBar.isHidden = false
        self.title = "TRIVIA for success"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.registernib()
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowlayout
        collectionView.decelerationRate = .normal
        self.btnPrev.layer.cornerRadius = 8
        self.btnNext.layer.cornerRadius = 8
        self.btnPrev.isHidden = index == 0 ? true : false
        self.btnNext.isHidden = index == 9 ? true : false
        self.fetchQuestions()
    }
    
    @IBAction func btnPrev(_ sender: UIButton) {
        if !arrQue.isEmpty{
            if index == 0{
                return
            }
            if index <= self.arrQue.count{
                self.index -= 1
                self.btnPrev.isHidden = index == 0 ? true : false
                self.btnNext.isHidden = index == 9 ? true : false
                self.collectionView.scrollToItem(at:IndexPath(item: self.index, section: 0), at: .left, animated: true)
            }
        }
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        if !arrQue.isEmpty{
            if let cell = collectionView.cellForItem(at: IndexPath(item: self.index, section: 0)) as? QuizCell{
                let data = arrQue[index]
                answer = data.correct
                print("Correct ans is: ",answer)
                if cell.opt1.checkState == .checked{
                    if answer == "ans1"{
                        self.correctCount += 1
                    }else{
                        self.wrongCount += 1
                    }
                } else if cell.opt2.checkState == .checked  {
                    if answer == "ans2"{
                        self.correctCount += 1
                    }else{
                        self.wrongCount += 1
                    }
                } else if cell.opt3.checkState == .checked {
                    if answer == "ans3"{
                        self.correctCount += 1
                    }else{
                        self.wrongCount += 1
                    }
                } else if cell.opt4.checkState == .checked {
                    if answer == "ans4"{
                        self.correctCount += 1
                    }else{
                        self.wrongCount += 1
                    }
                }
                print("Total correct: ",correctCount)
                print("Total wrong: ",wrongCount)
                let skip = arrQue.count - (correctCount + wrongCount)
                print("Total Skip: ",skip)
            }
            if index < self.arrQue.count{
                self.index += 1
                self.btnPrev.isHidden = index == 0 ? true : false
                self.btnNext.isHidden = index == 9 ? true : false
                if index == arrQue.count{
                    return
                }else{
                    self.collectionView.scrollToItem(at:IndexPath(item: self.index, section: 0), at: .right, animated: true)
                }
            }
        }
    }
}



extension QuizVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func registernib(){
        collectionView.register(UINib(nibName:"QuizCell", bundle: nil), forCellWithReuseIdentifier: "QuizCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.arrQue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizCell", for: indexPath) as! QuizCell
        if arrQue.count > indexPath.row{
            let que = arrQue[indexPath.row]
            cell.opt1.checkState = .unchecked
            cell.opt2.checkState = .unchecked
            cell.opt3.checkState = .unchecked
            cell.opt4.checkState = .unchecked
            cell.viewResult.isHidden = true
            cell.btnHome.isHidden = true
            cell.lblWellDone.isHidden = true
            cell.btnReplay.isHidden = true
            cell.btnSubmit.isHidden = true
            cell.lblCount.text = "Question \(indexPath.row + 1) of \(arrQue.count)"
            cell.setData(data: que, correct: self.correctCount, wrong: self.wrongCount)
            
            if indexPath.row == 9{
                cell.btnSubmit.isHidden = false
            }else{
                cell.btnSubmit.isHidden = true
            }
            
            cell.onSubmit = { [weak self] in
                guard let self = self else {return}
                cell.lblCount.text = "\(correctCount) out of \(arrQue.count)"
                cell.lblWellDone.isHidden = false
                cell.btnSubmit.isHidden = true
                cell.viewResult.isHidden = false
                cell.btnHome.isHidden = false
                cell.btnReplay.isHidden = false
                self.btnPrev.isHidden = true
                self.btnNext.isHidden = true
            }
            
            cell.onReplay = { [weak self] in
                guard let self = self else {return}
                self.arrQue.removeAll()
                self.index = 0
                self.correctCount = 0
                self.wrongCount = 0
                self.answer = ""
                self.btnPrev.isHidden = self.index == 0 ? true : false
                self.btnNext.isHidden = self.index == 9 ? true : false
                self.fetchQuestions()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size  = collectionView.frame
        return CGSize(width: size.width, height: size.height)
    }
}

//MARK: Fetch Questions
extension QuizVC{
    func fetchQuestions() {
        //progress start
        guard let url = URL(string: "https://dev.my-company.app/demo.json") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            do {
                let decoder = JSONDecoder()
                let questions = try decoder.decode([Question].self, from: data)
                let random = self.getRandom(from: questions)
                self.arrQue = random
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
            //progress stop
        }
        task.resume()
    }
    
    //get random 10 from API
    func getRandom(from questions: [Question]) -> [Question] {
        return Array(questions.shuffled().prefix(10))
    }
}
