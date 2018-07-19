//
//  LoginViewController.swift
//  MobileDevTest
//
//  Created by SEPL MAC on 17/07/18.
//  Copyright © 2018 nik MAC. All rights reserved.
//https://api.panya.me/v1/test/login

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let path = UIBezierPath(roundedRect:self.registerButton.bounds,
                                byRoundingCorners:[.topRight, .bottomLeft,.topLeft,.bottomRight],
                                cornerRadii: CGSize(width: 20, height:  20))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.registerButton.layer.mask = maskLayer
        self.registerButton.backgroundColor =  UIColor(patternImage: UIImage(named: "bg_streak_info_pink")!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerAcction(_ sender: UIButton) {
        
        let urlString = "https://api.panya.me/v1/test/login"
     
        
//        {
//            "email": "candidate@panya.me",
//            "password": "becoolatpanya"
//        }

        let params: [String: Any] = ["email": userNameTxt.text!, "password": passwordTxt.text!]
        
        Alamofire.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                let responseDictionary = response.result.value as! NSDictionary
                //print("responseDictionary=",responseDictionary)

                if let dataDictionary = responseDictionary.object(forKey: "data")
                {
                //print("response=",dataDictionary)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "RoundStreakViewController") as! RoundStreakViewController
                controller.dataDictionary = dataDictionary as! NSDictionary
                self.present(controller, animated: true, completion: nil)
                }
                else
                {
                    let errorDictionary = responseDictionary.object(forKey: "error") as! NSDictionary
                    let alert = UIAlertController(title: "Alert", message: errorDictionary.value(forKey: "message") as! String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
