//
//  InfoSetViewController.swift
//  LoveInASnap
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class InfoSetViewController: BaseViewController {

    @IBOutlet weak var help_lbl: UILabel!

    static var is_first = true
    override func viewDidLoad() {
         super.viewDidLoad()
   
        //help_lbl.font = UIFont(name: "Bebas Neue", size: 9)
         InfoSetViewController.is_first =  false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       if ( segue.identifier == "segue_welcome_back")
      {
       //(nextController as! ViewController).NumberMutary = self.sansMutary1
        BaseViewController.is_first_open = true
       }
    }
 

}
