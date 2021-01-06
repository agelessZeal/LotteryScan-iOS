//
//  WelcomeViewController.swift
//  LoveInASnap
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON
import JSSAlertView



class WelcomeViewController: BaseViewController {
  
  
  @IBOutlet var contentView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Language.language = Language.english
    
    if (!BaseViewController.is_first_open&&InfoSetViewController.is_first) {
          getLotodatefromLocal()
           
    }
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func StartAct(_ sender: Any) {
    //loadWinners()

  }
  fileprivate func loadWinners() {
    showLoadingHUD()
    print("after showLoadingHUD")
    AF.request(
      "http://173.212.199.191:100/api/loto",
      method: .get)
      .responseJSON { response in
        self.hideLoadingHUD()
        print("after hide Loading Hud")
        
        print(response)

        
       
        _ = JSSAlertView().show(self,
                                            title: "Connected Failed".localized,
                                            text: "Please check the connection to Internet.".localized,
                                            buttonText: "OK".localized)
        
        return
            
        
        print("get JSON data get ")
        if let winnwerjson = try?  JSON(response){
          print("JSON format is correct")
          self.saveWinners(winners: winnwerjson)
        }
        else
        {
          let ac = UIAlertController(title: "JSON".localized, message: "Invaild json format.".localized, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK".localized, style: .default))
          self.present(ac, animated: true)
        }
    }
  }
  private func getLotodatefromLocal(){
    if let path = Bundle.main.path(forResource: "loto", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        
        print("get JSON data get ")
        if let winnwerjson = try?  JSON(jsonResult){
          print("JSON format is correct")
          self.saveWinners(winners: winnwerjson)
        }
        else
        {
          let ac = UIAlertController(title: "JSON".localized, message: "Invaild json format.".localized, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK".localized, style: .default))
          self.present(ac, animated: true)
        }
      } catch {
        // handle error
      }
    }
  }
  
  private func showLoadingHUD() {
    let hud = MBProgressHUD.showAdded(to: contentView, animated: true)
    hud.label.text = "Connecting...".localized
  }
  
  private func hideLoadingHUD() {
    MBProgressHUD.hide(for: contentView, animated: true)
  }
  
  private func getLotoType(name:String)->LotoTypeSwift
  {
    if name.contains("Sayısal") {
      return LotoTypeSwift.Sayisal
    }
    else if name.contains("Süper") {
      return LotoTypeSwift.Super
    }
    else if name.contains("Numara") {
      return LotoTypeSwift.Numara
    }
    else if name.contains("Şans") {
      return LotoTypeSwift.Sans
    }
    return LotoTypeSwift.Unknown
  }
  private func saveWinners(winners:JSON) {
    Category.remove(filter:"id>0" ,force :true)
    
    for item in winners["Response"].arrayValue {
      print("Response array value")
      let LotoTypeName  = item["LotoType"]["Name"].stringValue
      let Type :LotoTypeSwift = getLotoType(name: LotoTypeName)
      print(LotoTypeName)
      let winarray = item["LotoType"]["ResultList"].arrayValue
      for indiwin in winarray
      {
        let datestr = indiwin["Date"].stringValue
        print(datestr)
        let date = stringToDate(string: datestr)
        let winners = indiwin["Result"].stringValue
        let prizes   = indiwin["WinnerInfo"].stringValue
        
        self.saveToDBWinners(name: LotoTypeName, winners: winners,prize: prizes, type: Type,date:date)
        print(winners)
      }
    }
  }
  
  private func saveToDBWinners(name:String,winners:String,prize:String,type:LotoTypeSwift,date:Date) {
    
    let cat = Category()
    let dayvalue = getCurrentDayStampWO(dateToConvert: date)
    
    print(dayvalue)
    cat.mycusid = dayvalue
    cat.myid = getCurrentDayStampWOInt(dateToConvert: date)
    cat.name = name
    cat.winners = winners
    
    cat.prize = prize
    
    cat.lototype = type.rawValue
    if cat.save() != 0 {
      
    }
    else
    {
      print("Save Error")
      
      _ = JSSAlertView().show(self,
                              title: "Save Error".localized,
                              text: "Not Saved Winner Numbers in DB!".localized,
                              buttonText: "OK".localized)
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
