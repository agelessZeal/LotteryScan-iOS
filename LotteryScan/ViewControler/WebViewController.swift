//
//  WebViewController.swift
//  LoveInASnap
//
//  Created by JACK on 9/8/19.
//  Copyright © 2019 Ray Wenderlich. All rights reserved.
//

import UIKit
import KVNProgress
class WebViewController: UIViewController, UIWebViewDelegate{
  
  var webUrl: String!
  
  // @IBOutlet weak var WebView: WKWebView!
  @IBOutlet weak var btnExit: UIButton!
  
  @IBOutlet weak var WebView: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    WebView.delegate = self
    load()
  }
  
  func load(){
    
    let myURL = URL(string: webUrl)
    let myRequest = URLRequest(url: myURL!)
    WebView.loadRequest(myRequest)
    
  }
  
  func webViewDidStartLoad(_ : UIWebView) {
    
    KVNProgress.show(withStatus: "", on: view)
  }
  
  func webViewDidFinishLoad(_ : UIWebView) {
    KVNProgress.dismiss()
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
