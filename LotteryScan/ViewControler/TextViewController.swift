//
//  TextViewController.swift
//  LoveInASnap
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class TextViewController: BaseViewController
{
    @IBOutlet weak var RecoTextView: UITextView!
    
    @IBOutlet weak var RecoLabel: UILabel!
    
    @IBOutlet weak var WinLabel1: UILabel!
    @IBOutlet weak var LotoTypeLabel: UILabel!
    @IBOutlet weak var Line1_label: UILabel!
    
    @IBOutlet weak var Line2_label: UILabel!
    @IBOutlet weak var Line3_label: UILabel!
    
    @IBOutlet weak var Line4_label: UILabel!
    @IBOutlet weak var Line5_label: UILabel!
    @IBOutlet weak var Line6_label: UILabel!
    
    @IBOutlet weak var Line8_label: UILabel!
    @IBOutlet weak var Line7_label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
   
      
      if ViewController.week_win_number_str1.isEmpty {
        self.RecoLabel.text = ViewController.week_win_number_str
        self.WinLabel1.text = ViewController.week_win_number_str1
      }
      else
      {
        self.RecoLabel.text = ViewController.week_win_number_str
        self.WinLabel1.text = ViewController.week_win_number_str1
      }
  
        self.LotoTypeLabel.text = ViewController.loto_type_str

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
