//
//  SplashViewController.swift
//  LoveInASnap
//
//  Created by JACK on 9/8/19.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import UIKit
import Alamofire

class Connectivity {
  class func isConnectedToInternet() ->Bool {
    return NetworkReachabilityManager()!.isReachable
  }
}

class SplashViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  override func viewDidAppear(_ animated: Bool) {
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        nextViewController.modalPresentationStyle =  .fullScreen
    self.present(nextViewController, animated:true, completion:nil)
  }
  

  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
