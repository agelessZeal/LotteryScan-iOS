//
//  SuperViewController.swift
//  LoveInASnap
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit
import SCLAlertView

class SayisalViewController:  BaseViewController ,UITextViewDelegate, NumberCellDelegate{
  
  func cellchanged(index: Int, value: Int, type: LotoTypeSwift, indexPath: IndexPath) {
    print("my delegate receive index :\(index)  " )
    
    if (type == LotoTypeSwift.Sayisal)
    {
      BaseViewController.is_cellchanged = true
      
      let appearance = SCLAlertView.SCLAppearance(
        kTextFieldHeight: 30,
        kTitleFont: UIFont(name: "Bebas Neue", size: 20)!,
        kTextFont: UIFont(name: "Bebas Neue", size: 14)!,
        kButtonFont: UIFont(name: "Bebas Neue", size: 16)!,
        showCloseButton: false,
        dynamicAnimatorActive: true,
        buttonsLayout: .horizontal
      )
      let alert = SCLAlertView(appearance: appearance)
      
      let txt = alert.addTextField("Enter Correct Value".localized)
      txt.keyboardType = UIKeyboardType.numberPad
      _ = alert.addButton("Change".localized) {
        let text = txt.text
        
        self.numberchanged(valstr:text!,index: index,indexPath: indexPath)
        BaseViewController.is_cellchanged = false
        
      }
      _ = alert.addButton("Cancel".localized) {
        self.m_colViewNumberResult.reloadItems(at: [indexPath])
        BaseViewController.is_cellchanged = false
      }
      _ = alert.showEdit("New Value".localized, subTitle:"")
      
      
    }
  }
  
  var maxCnt : Int = 6
  var pageIndex : Int = 0
  var pageMaxCnt = 6
  var sansMutary1 : NSMutableArray = [];
  
  var selPageIndex : Int = 100
  
  @IBOutlet weak var m_colViewNumberResult: UICollectionView!
  @IBOutlet weak var win_numbers_lbl: UILabel!
  @IBOutlet weak var loto_type_lbl: UILabel!
  
  @IBOutlet var popUpview: UIView!
  @IBOutlet var level1: UILabel!
  @IBOutlet var level2: UILabel!
  @IBOutlet var level3: UILabel!
  @IBOutlet var level4: UILabel!
  @IBOutlet var prize1: UILabel!
  @IBOutlet var prize2: UILabel!
  @IBOutlet var prize3: UILabel!
  @IBOutlet var prize4: UILabel!
  
    @IBOutlet var level_m1: UILabel!
    @IBOutlet var level_m2: UILabel!
    @IBOutlet var level_m3: UILabel!
    @IBOutlet var level_m4: UILabel!
    @IBOutlet var prize_title: UILabel!
    @IBOutlet var prize_btn: UIButton!
    @IBOutlet var winner_title_lbl: UILabel!
  @IBOutlet var result_title: UILabel!

  @IBAction func pop_ok(_ sender: Any) {
    self.popUpview.isHidden =  true
    result_title.isHidden = false
  }
  @IBAction func prize_view_touch(_ sender: Any) {
     let customFont1: UIFont! = UIFont(name: "Bebas Neue", size: 18.0)
     self.prize_title.font = UIFontMetrics.default.scaledFont(for: customFont1)
     self.prize_btn.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont1);
    
    let customFont: UIFont! = UIFont(name: "Bebas Neue", size: 16.0)
    if #available(iOS 11.0, *) {
      self.level1.font = UIFontMetrics.default.scaledFont(for: customFont)
      self.level2.font = UIFontMetrics.default.scaledFont(for: customFont)
      self.level3.font = UIFontMetrics.default.scaledFont(for: customFont)
      self.level4.font = UIFontMetrics.default.scaledFont(for: customFont)
      self.prize1.font = UIFontMetrics.default.scaledFont(for: customFont)
      self.prize2.font = UIFontMetrics.default.scaledFont(for: customFont)
      self.prize3.font = UIFontMetrics.default.scaledFont(for: customFont)
      self.prize4.font = UIFontMetrics.default.scaledFont(for: customFont)
      self.level_m1.font = UIFontMetrics.default.scaledFont(for: customFont)
      self.level_m2.font = UIFontMetrics.default.scaledFont(for: customFont)
      self.level_m3.font = UIFontMetrics.default.scaledFont(for: customFont)
      self.level_m4.font = UIFontMetrics.default.scaledFont(for: customFont)
      
    } else {
      // Fallback on earlier versions
    }
    
    
    let prize = ViewController.sayisal_prize_str
    let  substrraray=prize.components(separatedBy: ";")

    if substrraray.count == 4 {
      
      for (index, subitem) in substrraray.enumerated()
      {
        if !subitem.isEmpty
        {
          let  ssubstrraray=subitem.components(separatedBy: ":")
          if ssubstrraray.count == 2
          {
            switch index
            {
            case 0:
              do {
                let  levelstrs=ssubstrraray[0].components(separatedBy: "-")
                
                if levelstrs.count == 2
                {
                  self.level1.text = levelstrs[1];
                }
                self.prize1.text = ssubstrraray[1];
              }
              
            case 1:
              do {
                let  levelstrs=ssubstrraray[0].components(separatedBy: "-")
                
                if levelstrs.count == 2
                {
                  self.level2.text = levelstrs[1];
                }
                self.prize2.text = ssubstrraray[1];
              }
            case 2:
              do {
                let  levelstrs=ssubstrraray[0].components(separatedBy: "-")
                
                if levelstrs.count == 2
                {
                  self.level3.text = levelstrs[1];
                }
                self.prize3.text = ssubstrraray[1];
              }
            case 3:
              do {
                
                let  levelstrs=ssubstrraray[0].components(separatedBy: "-")
                
                if levelstrs.count == 2
                {
                  self.level4.text = levelstrs[1];
                }
                self.prize4.text = ssubstrraray[1];
              }
         
            default:
              do {
                
              }
            }
          }
        }
      }
    }
    result_title.isHidden = true
    self.popUpview.isHidden =  false
  }
  @IBOutlet weak var gover_date_lbl: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.m_colViewNumberResult.dataSource = self
    self.m_colViewNumberResult.delegate = self
    self.m_colViewNumberResult.backgroundColor = UIColor.clear
    let customFont: UIFont! = UIFont(name: "Bebas Neue", size: 28.0)
    if #available(iOS 11.0, *) {
      self.winner_title_lbl.font = UIFontMetrics.default.scaledFont(for: customFont)
      
    } else {
      // Fallback on earlier versions
    }
    if #available(iOS 11.0, *) {
      self.result_title.font = UIFontMetrics.default.scaledFont(for: customFont)
      
    } else {
      // Fallback on earlier versions
    }
    if #available(iOS 11.0, *) {
      self.loto_type_lbl.font = UIFontMetrics.default.scaledFont(for: BaseViewController.noDataFont)
    } else {
      // Fallback on earlier versions
    }
    self.loto_type_lbl.adjustsFontForContentSizeCategory = true
    if #available(iOS 11.0, *) {
      self.win_numbers_lbl.font = UIFontMetrics.default.scaledFont(for: BaseViewController.noDataFont)
    } else {
      // Fallback on earlier versions
    }
    self.win_numbers_lbl.adjustsFontForContentSizeCategory = true
    
    if #available(iOS 11.0, *) {
      self.gover_date_lbl.font = UIFontMetrics.default.scaledFont(for: BaseViewController.noDataFont)
    } else {
      // Fallback on earlier versions
    }
    self.gover_date_lbl.adjustsFontForContentSizeCategory = true
    
    self.loto_type_lbl.text = ViewController.loto_type_str
    self.win_numbers_lbl.text = ViewController.week_win_number_str
    self.gover_date_lbl.text = super.componentToStr(components: ViewController.dateComponentsGover)
    self.maxCnt = self.getTotalItemCount()
    
    if let flowLayout = self.m_colViewNumberResult.collectionViewLayout as? UICollectionViewFlowLayout {
      flowLayout.sectionHeadersPinToVisibleBounds = true
    }
    let cellNib = UINib(nibName: "NumberCollectionViewCell", bundle: nil)
    self.m_colViewNumberResult.register(cellNib, forCellWithReuseIdentifier: "NumberCollectionViewCell")
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
    @IBAction func self_touch_in(_ sender: Any) {
        
        if  BaseViewController.isvaluechaed{
            
            BaseViewController.isselfrecheck = true
            self.performSegue(withIdentifier: "segue_sayisal_back", sender: nil)
        }
    }
    
  @IBAction func date_btn_touch_in(_ sender: Any) {
    if BaseViewController.is_change_date == false {
      BaseViewController.is_change_date = true
      let appearance = SCLAlertView.SCLAppearance(
        kTextFieldHeight: 30,
        kTitleFont: UIFont(name: "Bebas Neue", size: 18)!,
        kTextFont: UIFont(name: "Bebas Neue", size: 14)!,
        kButtonFont: UIFont(name: "Bebas Neue", size: 16)!,
        showCloseButton: false,
        dynamicAnimatorActive: true,
        buttonsLayout: .horizontal
      )
      let alert = SCLAlertView(appearance: appearance)
      
      let txt = alert.addTextField("new goverment date: dd.mm.yyyy".localized)
      txt.keyboardType = UIKeyboardType.numbersAndPunctuation
      _ = alert.addButton("Change".localized) {
        let text = txt.text
        let cLength = strlen(text ?? "9")
        print(cLength)
        if(cLength == 9||cLength == 10)
        {
          super.CorrectGoverDate(datestr: text!)
          self.gover_date_lbl.text = text
        }
        BaseViewController.is_change_date = false
      }
      _ = alert.addButton("Cancel".localized) {
        BaseViewController.is_change_date = false
        
      }
      _ = alert.showEdit("New Goverment Date".localized, subTitle:"")
    }


  }
  
  
  func numberchanged(valstr:String,index:Int,indexPath: IndexPath)
  {
    
    if (valstr.isEmpty) {
      self.m_colViewNumberResult.reloadItems(at: [indexPath])
      return
    }
    let cLength = strlen(valstr)
    print(cLength)
    
    if(cLength == 2||cLength == 1)
    {
      let value:Int = Int(valstr)!
      if (value > 0&&value<50)
      {
        let row = index/6
        let subindex = index - row*6
        if sansMutary1.count > row {
          let items=sansMutary1[row] as! NSArray
          if items.count > subindex
          {
            BaseViewController.isvaluechaed = true
            
            let rectitem = items[subindex] as! RectItem
            
            rectitem.integervalue = value
          }
        }
      }
    }
    
    self.m_colViewNumberResult.reloadItems(at: [indexPath])
    //self.m_colViewNumberResult.reloadData()
  }
  func getItemValue(index:Int)->String
  {
    if (sansMutary1.count == 0 ){
      return "0";
    }
    let row = index/6
    let subindex = index - row*6
    if sansMutary1.count > row {
      let items=sansMutary1[row] as! NSArray
      if items.count > subindex
      {
        
        let rectitem = items[subindex] as! RectItem
        let value = rectitem.integervalue
        if  value < 10{
          return "0\(value)"
        }else
        {
          return "\(value)"
        }
      }
    }
    return "0";
  }
  func IsWinnerItem(index:Int)->Bool
  {
    if (sansMutary1.count == 0 ){
      return false;
    }
    let row = index/6
    let subindex = index - row*6
    if sansMutary1.count > row {
      let items=sansMutary1[row] as! NSArray
      if items.count > subindex
      {
          let rectitem = items[subindex] as! RectItem
          if rectitem.is_same == true
          {
            return true;
          }
          else
          {
            return false;
          }
        
      }
    }
    return false;
  }
  func getTotalItemCount()->Int
  {
    if sansMutary1.count == 0 {
      return 0;
    }
    var total = 0
    for item in sansMutary1 as NSArray
    {
      
      let items=item as! NSArray
      if(items.count==6)
      {
        total += items.count
      }
    }
    return total
  }

  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    var nextController: UIViewController?
    nextController = segue.destination
    if ( segue.identifier == "segue_sayisal_back")
    {
      //(nextController as! ViewController).NumberMutary = self.sansMutary1
      ViewController.NumberMutary = self.sansMutary1
    }
  }
  
  
}
extension SayisalViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.maxCnt
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCollectionViewCell", for: indexPath) as! NumberCollectionViewCell
    cell.celllabelview.text = getItemValue(index:indexPath.row)
    cell.index = indexPath.row
    cell.indexPath = indexPath
    if(self.IsWinnerItem(index: indexPath.row))
    {
      cell.cellimageview?.image = UIImage.init(named: "ball.png")
      cell.celllabelview.textColor = UIColor.green
    }
    else
    {
      cell.cellimageview?.image = UIImage.init(named: "ball.png")
      cell.celllabelview.textColor = UIColor.black
    }

    cell.type = LotoTypeSwift.Sayisal
    cell.backgroundColor = UIColor.clear
    cell.delegate = self
    return cell
  }
}

extension SayisalViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath.item + 1)
  }
}

extension SayisalViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    if (sansMutary1.count>0) {
      let all_row:CGFloat = CGFloat(sansMutary1.count)
      let cellheight = (collectionView.bounds.size.height-10 - 3*(CGFloat)(sansMutary1.count-1))/all_row;
      let viewwidth = collectionView.bounds.size.width/6-4;
      if(viewwidth>cellheight)
      {
        return CGSize(width: cellheight, height: cellheight)
      }else
      {
        return CGSize(width: viewwidth, height: viewwidth)
      }
      
    }
    return CGSize(width: collectionView.bounds.size.width/6-4, height: collectionView.bounds.size.width/6-4)
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    if (sansMutary1.count>0) {
      let all_row:CGFloat = CGFloat(sansMutary1.count)
      let cellheight = (collectionView.bounds.size.height - 3*(CGFloat)(sansMutary1.count-1))/all_row;
      let viewwidth = collectionView.bounds.size.width/6-4;
      if(viewwidth>cellheight)
      {
        let medi = viewwidth - cellheight
        return medi
        
      }else
      {
        return 0
       
      }
      
    }
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    return CGSize(width: collectionView.bounds.size.width, height:3)
  }
  
  
}





