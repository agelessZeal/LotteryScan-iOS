//
//  RectItem.swift
//  LoveInASnap
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
enum LotoTypeSwift:Int {
  
  case Sayisal = 1
  case Super = 2
  case Numara = 3
  case Sans = 4
  case Unknown = 5
  
}
class RectItem {
  var index : Int = 0;
  var integervalue : Int = 0;
  var string: String = "";
  var is_same :Bool  = false;
  var numara_noone :Bool  = false;
  var rect : CGRect = CGRect.init(x: 0, y: 0, width: 0, height: 0);
  init() {
    index=0;
    string = "";
    rect = CGRect.init(x: 0, y: 0, width: 0, height: 0);
  }
}

