//
//  NumberCollectionViewCell.swift
//  LoveInASnap
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

protocol NumberCellDelegate {
  func cellchanged( index:Int, value:Int, type:LotoTypeSwift,indexPath: IndexPath)
}

class NumberCollectionViewCell: UICollectionViewCell {

    var delegate : NumberCellDelegate?
  

  
    @IBOutlet weak var cellimageview: UIImageView!
    @IBOutlet weak var celllabelview: UILabel!
    var index = 0
    var indexPath: IndexPath =  IndexPath.init(index: 0)  
    var type :LotoTypeSwift = LotoTypeSwift.Unknown

//    @IBOutlet weak var cellTextField: UITextField!
    @IBAction func btnTouchInside(_ sender: Any) {

      if BaseViewController.is_cellchanged == false
      {
        self.cellimageview?.image = UIImage.init(named: "ball_selected.png")
        celllabelview.textColor = UIColor.white
        
        
        delegate?.cellchanged(index: self.index,value:0,type:self.type, indexPath: self.indexPath)
      }
        



    }


    override func awakeFromNib() {
        super.awakeFromNib()
      if #available(iOS 11.0, *) {
        self.celllabelview.font = UIFontMetrics.default.scaledFont(for: BaseViewController.noDataFont)
      } else {
        // Fallback on earlier versions
      }
      self.celllabelview.adjustsFontForContentSizeCategory = true

    }


}
