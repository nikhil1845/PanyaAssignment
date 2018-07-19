//
//  RoundStreakViewController.swift
//  MobileDevTest
//
//  Created by SEPL MAC on 17/07/18.
//  Copyright © 2018 nik MAC. All rights reserved.
//

import UIKit
import Alamofire

class RoundStreakViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var dataDictionary = NSDictionary()
    var dataArray = [Int]()
    var consecutive_round_count = 0
    @IBOutlet weak var RSTabelView: UITableView!
    
    @IBOutlet weak var consecutiveLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("response=",dataDictionary)
        // Do any additional setup after loading the view.
        consecutive_round_count = dataDictionary.value(forKey: "consecutive_round_count") as! Int
        let text = "You have consecutively played: \(consecutive_round_count) rounds"
        let linkTextWithColor = "\(consecutive_round_count)"
        //print("consecutive_round_count",consecutive_round_count)
        let range = (text as NSString).range(of: linkTextWithColor)
        
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.yellow , range: range)

        self.consecutiveLabel.attributedText = attributedString
        
        doRequestWithHeaders()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doRequestWithHeaders() {

        if let token = dataDictionary.value(forKey: "access_token")
        {

            print(token)
            let headers: HTTPHeaders =
            [
                "access-token": token as! String,
            ]
            Alamofire.request("https://api.panya.me/v1/test/streak-bonus", headers: headers)
            .responseJSON
                {
                    response in
                    switch response.result {
                        case .success:
                        let responseDictionary = response.result.value as! NSDictionary
                        //print("responseDictionary=",responseDictionary)
                        
                        let dataDictionary = responseDictionary.object(forKey: "data") as! NSDictionary
                        
                        var streak_bonus = dataDictionary.object(forKey: "streak_bonus") as! [Int]
//
//                        print("response=",streak_bonus)
//                        print("sorted response = ",self.distinctAndSort(&streak_bonus))
                        
                        self.dataArray = self.distinctAndSort(&streak_bonus)
                        DispatchQueue.main.async(execute: {
                            self.RSTabelView.reloadData()
                        })
                        break
                        case .failure(let error):
                        
                        print(error)
                    }
                }
          
        }
    }
    
    public func distinctAndSort(_ A : inout [Int]) -> [Int]
    {
        if(A.count == 0)
        {
            return []
        }
        A.sort()
        print(A)
    
        var resultArray = Array<Int>()
        resultArray.append(A[0])
        for var i in (1..<A.count)
        {
            // Beware of overflow
            if (A[i] != A[i-1])
            {
               
                resultArray.append(A[i])

            }
        }
        
        return resultArray
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customcell = tableView.dequeueReusableCell(withIdentifier: "CustomRoundCell", for: indexPath as IndexPath) as! CustomRoundCell
        customcell.backgroundColor = UIColor.clear
        customcell.roundHolderView.subviews.forEach({ $0.removeFromSuperview() })
        
        let startRound = indexPath.row  * 5 + 1
        let endRound = startRound + 4
        
        
        var x = 0;
        let countCellWidth = Int((tableView.frame.size.width - 95) / 5)
        let countCellHeight = 68
        var rounds = 0
        for index in startRound...endRound {
           
            let customView = UIView(frame: CGRect(x: x, y: 0, width: countCellWidth, height: countCellHeight))
            
            let roundlabel = UILabel(frame: CGRect(x: 0, y: 15, width: countCellWidth, height: 10))
            roundlabel.textAlignment = .center
            roundlabel.text = "Round"
            roundlabel.font = UIFont.boldSystemFont(ofSize: 12.0)

            let roundCount = UILabel(frame: CGRect(x: 0, y: 20, width: countCellWidth, height: 50))
            roundCount.textAlignment = .center
            roundCount.text = String(index)
            roundCount.font = UIFont.boldSystemFont(ofSize: 22.0)

            customView.addSubview(roundlabel)
            customView.addSubview(roundCount)
            x += countCellWidth + 1
            
            if(index <= consecutive_round_count)
            {
                customView.backgroundColor = UIColor(patternImage: UIImage(named: "bg_streak_info_pink")!)
                roundCount.textColor = UIColor.yellow
                rounds += 1
                
                if(rounds == 1 || rounds == 5)
                {

                    let path = UIBezierPath(roundedRect:customView.bounds,
                                            byRoundingCorners:[(rounds == 1 ? .topLeft : .topRight), (rounds == 1 ? .bottomLeft : .bottomRight)],
                                            cornerRadii: CGSize(width: 30, height:  30))
                    
                    let maskLayer = CAShapeLayer()
                    
                    maskLayer.path = path.cgPath
                    customView.layer.mask = maskLayer
                    
                    
                }
                
            }
            else
            {
                roundlabel.textColor =  UIColor.white
                roundCount.textColor  =  UIColor.white

             }
            customcell.roundHolderView.addSubview(customView)
           // index + customcell.roundHolderView.frame.size.width / 5
        }
        
        if(rounds == 5)
        {
            customcell.recivedmark.isHidden = false
            customcell.bonusButton.setImage(UIImage(imageLiteralResourceName: "ic_streak_heart_l_50"), for: .normal)
            customcell.bonusButton.setTitle("", for: .normal)
            
        }else if(indexPath.row + 1 == dataArray.count)
        {
            customcell.recivedmark.isHidden = true
            
            customcell.bonusButton.setImage(UIImage(imageLiteralResourceName: "ic_streak_chest"), for: .normal)
            customcell.bonusButton.setTitle("", for: .normal)
            
        }else
        {
            customcell.recivedmark.isHidden = true
            
            let titleLabel = "+\(indexPath.row + 1)"
            customcell.bonusButton.setTitle(titleLabel, for: .normal)
            customcell.bonusButton.titleEdgeInsets = UIEdgeInsets(top: 18.0, left: -22.0, bottom: 0.0, right: 0.0)
            customcell.bonusButton.setImage(UIImage(imageLiteralResourceName: "ic_streak_heart_l"), for: .normal)
            
        }
        
        
        
        return customcell
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)

    }
}
