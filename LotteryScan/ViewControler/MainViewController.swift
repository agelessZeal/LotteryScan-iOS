//
//  MainViewController.swift
//  LoveInASnap
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit
import TesseractOCR
import MBProgressHUD
import SwiftyJSON
import Alamofire
import JSSAlertView
import SCLAlertView


class ViewController: BaseViewController {
  

  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var check_tick_btn: UIButton!
  @IBOutlet weak var findTextField: UITextField!
  @IBOutlet weak var replaceTextField: UITextField!
  @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!

 

  //@IBOutlet weak var debug_text: UITextView!
    
  
    
  @IBOutlet weak var contentView: UIView!
  
  @IBOutlet weak var next_progress: UIButton!

  
  @IBAction func NextBtnTouchUp(_ sender: Any)
  {


     cusstart()
    
  }
    
  @IBAction func EndTouchUpS(_ sender: Any) {
        showMessageResetApp()
    }
    
  static var dateComponentsGover = DateComponents()
  static var dateComponentsGover2 = DateComponents()
  static var dateComponentsPlay = DateComponents()
  static var datearray :Array = [DateComponents]()
  
  var GoverPlay:String =  ""
  var PlayerPlay:String =  ""


  
  static var NumberMutary : NSMutableArray = [] ;
  
  static var m_lototype:LotoTypeSwift=LotoTypeSwift.Unknown
  static var coupon_name_str = ""
  var create_dir_str = ""
  static var lotoimge :UIImage = UIImage.init(named: "Rectangle 118.png")!
  static var originallotoimge :UIImage = UIImage.init(named: "Rectangle 118.png")!
  
  static var total_reco_str  = ""
  static var week_win_number_str = ""
  static var week_win_number_str1 = ""
  static var loto_type_str = ""
  static var numara_prize_str = ""
  static var sayisal_prize_str = ""
  static var super_prize_str = ""
  static var sans_prize_str = ""
  
  static var double_drawtimes :Int = 0
  
  static var is_reco_corect:Bool = false
  static var is_double_date:Bool = false
  static var is_date_reco:Bool = false
  static var re_compare_date:Bool = false
  
  static var numaraWeeklyWinNunbers = [Int]()
  static var sayisalWeeklyWinNunbers = [Int]()
  static var superWeeklyWinNunbers = [Int]()
  static var sansWeeklyWinNunbers = [Int]()
  
  var image1:UIImage =  UIImage(named: "img-02.jpg")!;
  var image2:UIImage =  UIImage(named: "img-01.jpg")!;
 


  @IBAction func NavItemDoneAction(_ sender: Any) {
      showMessageResetApp()
    }
    
  @IBAction func NavBarNextAction(_ sender: Any) {
     cusstart()
    }
  @IBOutlet weak var lotteryImage: UIImageView!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.CVProgressNotification), name: NSNotification.Name(rawValue: "CVProgressNotification"), object: nil)
      if lotteryImage.image == nil
      {
        lotteryImage.image = ViewController.lotoimge

//          lotteryImage.image = imge
      }
      if  (ViewController.re_compare_date && ViewController.datearray.count > 1){
        check_tick_btn.isEnabled = true
        check_tick_btn.isHidden  = false
      }
      else
      {
        check_tick_btn.isEnabled = false
        check_tick_btn.isHidden  = true

      }
    

    
    if (BaseViewController.isvaluechaed && BaseViewController.isselfrecheck) {
      recheck()
      BaseViewController.isselfrecheck = false
    }


      
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "CVProgressNotification"), object: nil)

  }
  func GetCorectDayOnCoupon(input:DateComponents,m_type:LotoTypeSwift) -> DateComponents {
    if (input.year != nil && input.month != nil && input.day != nil) {
      var weekday = 0;
      if let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian),
        let date = gregorianCalendar.date(from: input as DateComponents) {
        weekday = gregorianCalendar.component(.weekday, from: date)
        print(weekday) // 5, which corresponds to Thursday in the Gregorian Calendar
      }
     
      var doutout = DateComponents();
      doutout.year = input.year
      doutout.month = input.month
      doutout.day = input.day
      let oriday = doutout.day
      let ori_dec = oriday!/10;
      if (weekday != nil)
      {
        switch m_type
        {
          
        case .Sayisal:
          do {
            if( false)//!(weekday == 7 ||  weekday == 4 )//ViewController.is_double_date ==
            {
              if (weekday != 7)
              {
                let dif = weekday - 7
                doutout.day  = doutout.day! - dif
                if doutout.day! < 0
                {
                  doutout.day  = doutout.day! + 7
                }
                
                let after_dec = doutout.day!/10;
                if ori_dec < after_dec
                {
                  doutout.day  = doutout.day! - 7
                }
                else if ori_dec > after_dec
                {
                  doutout.day  = doutout.day! + 7
                }
                if doutout.month! < input.month!
                {
                  doutout.day  = doutout.day! + 7
                }
                else if doutout.month! > input.month!
                {
                  doutout.day  = doutout.day! - 7
                }
              }
            }
          }
        case .Super:
          do
          {
            if(weekday != 5)
            {
              let dif = weekday - 5
              doutout.day  = doutout.day! - dif
              if doutout.day! < 0
              {
                doutout.day  = doutout.day! + 7
              }
              
              let after_dec = doutout.day!/10;
              if ori_dec < after_dec
              {
                doutout.day  = doutout.day! - 7
              }
              else if ori_dec > after_dec
              {
                doutout.day  = doutout.day! + 7
              }
              if doutout.month! < input.month!
              {
                doutout.day  = doutout.day! + 7
              }
              else if doutout.month! > input.month!
              {
                doutout.day  = doutout.day! - 7
              }
            }
          }
        case .Numara:
          do
          {
            if(weekday != 2)
            {
              let dif = weekday - 2
              doutout.day  = doutout.day! - dif
              
              if doutout.day! < 0
              {
                doutout.day  = doutout.day! + 7
              }
              
              let after_dec = doutout.day!/10;
              if ori_dec < after_dec
              {
                doutout.day  = doutout.day! - 7
              }
              else if ori_dec > after_dec
              {
                doutout.day  = doutout.day! + 7
              }
              if doutout.month! < input.month!
              {
                doutout.day  = doutout.day! + 7
              }
              else if doutout.month! > input.month!
              {
                doutout.day  = doutout.day! - 7
              }
            }
          }
        case .Sans:
          do
          {
            if(weekday != 4)
            {
              let dif = weekday - 4
              doutout.day  = doutout.day! - dif
              if doutout.day! < 0
              {
                doutout.day  = doutout.day! + 7
              }
              
              let after_dec = doutout.day!/10;
              if ori_dec < after_dec
              {
                doutout.day  = doutout.day! - 7
              }
              else if ori_dec > after_dec
              {
                doutout.day  = doutout.day! + 7
              }
              if doutout.month! < input.month!
              {
                doutout.day  = doutout.day! + 7
              }
              else if doutout.month! > input.month!
              {
                doutout.day  = doutout.day! - 7
              }
              
            }
            
          }
        case .Unknown:
          return input
        }
        
        return doutout
      }

    }
    return input
  }
  func recheck() ->Void {
  

    BaseViewController.isvaluechaed = false
    BaseViewController.is_circled = false
    BaseViewController.is_numara_onerow = false
    ViewController.week_win_number_str = ""
    ViewController.week_win_number_str1 = ""
    
    ViewController.sans_prize_str = ""
    ViewController.sayisal_prize_str = ""
    ViewController.super_prize_str = ""
    ViewController.numara_prize_str = ""

    
    ViewController.numaraWeeklyWinNunbers.removeAll()
    ViewController.sansWeeklyWinNunbers.removeAll()
    ViewController.sayisalWeeklyWinNunbers.removeAll()
    ViewController.superWeeklyWinNunbers.removeAll()
    
    processAfterGoverDate()

  }

  @IBAction func check_ticket_btn_touch(_ sender: Any)
  {
    //recheck()
 
    if ViewController.datearray.count > 0{
      ViewController.week_win_number_str = ""
      ViewController.week_win_number_str1 = ""
      BaseViewController.is_circled = false
      BaseViewController.is_numara_onerow = false
      ViewController.numaraWeeklyWinNunbers.removeAll()
      ViewController.sansWeeklyWinNunbers.removeAll()
      ViewController.sayisalWeeklyWinNunbers.removeAll()
      ViewController.superWeeklyWinNunbers.removeAll()
      
      ViewController.sans_prize_str = ""
      ViewController.sayisal_prize_str = ""
      ViewController.super_prize_str = ""
      ViewController.numara_prize_str = ""

      lotteryImage.image = ViewController.originallotoimge
      
      let appearance = SCLAlertView.SCLAppearance(
      
      kTitleFont: UIFont(name: "Bebas Neue", size: 16)!,
      kTextFont: UIFont(name: "Bebas Neue", size: 14)!,
      kButtonFont: UIFont(name: "Bebas Neue", size: 20)!,
      showCloseButton: false,
      dynamicAnimatorActive: true,
      buttonsLayout: .vertical
      )
      let alert = SCLAlertView(appearance: appearance)

//      let icon = UIImage(named:"custom_icon.png")
      let color = UIColor.blue
      

      for (subitem) in ViewController.datearray
      {
        let item_str = componentToStr(components: subitem as DateComponents)
        _ = alert.addButton(item_str) {
          ViewController.re_compare_date = true
          self.check_tick_btn.isEnabled = true
          self.check_tick_btn.isHidden  = false
          
          ViewController.dateComponentsGover = subitem
          _ = self.processAfterGoverDate()
          
        }
        
      }
        _ = alert.showSuccess("Winner Result:".localized, subTitle: "")
    }

  }
  
  
  
  @objc func CVProgressNotification(notification: NSNotification) {

    if let imagestr = notification.object as? NSString
    {
      
        if imagestr.contains("Apple")
        {
          ViewController.total_reco_str += "\n"
          ViewController.total_reco_str += imagestr as String
        }
        if imagestr.contains("retake")
        {
          ViewController.is_reco_corect = false
        }
        if imagestr.contains("GoverDate1")
        {
          ViewController.is_date_reco = true;
          // textView.insertText("\n")
          let string_type = imagestr as String
          //self.debug_text.insertText(string_type)
          ViewController.total_reco_str += "\n"
          ViewController.total_reco_str += string_type
          
          let  substrraray=imagestr.components(separatedBy: "-")
          for subitem in substrraray
          {
            let is_val:Bool = subitem.contains(".")
            if is_val
            {
              self.GoverPlay = subitem
              let  ssubstrraray=subitem.components(separatedBy: ".")
              if ssubstrraray.count == 3 {
                
                var day:Int = 0
                var month:Int = 0
                var year:Int = 0
                if(!ssubstrraray[0].isEmpty)
                {
                  day = Int(removeWhiteSpaceInString(original: ssubstrraray[0]) as String)!
                }
                if(!ssubstrraray[1].isEmpty)
                {
                  month = Int(removeWhiteSpaceInString(original: ssubstrraray[1]) as String)!
                }
                if(!ssubstrraray[2].isEmpty)
                {
                  year = Int(removeWhiteSpaceInString(original: ssubstrraray[2]) as String)!
                }

                if(day > 31){
                  ViewController.dateComponentsGover.day = 31}else if(day<32&&day>0)
                {
                 ViewController.dateComponentsGover.day = day
                }
                if(month>12){ ViewController.dateComponentsGover.month = 12}else if(month<13&&month>0){ ViewController.dateComponentsGover.month = month}
                if (year>0){   ViewController.dateComponentsGover.year = year}
             

              }
            }
          }
        }
      if imagestr.contains("GoverDate2")
      {
        // textView.insertText("\n")
        ViewController.is_double_date = true
        let string_type = imagestr as String
        //self.debug_text.insertText(string_type)

        
        let  substrraray=imagestr.components(separatedBy: "-")
        for subitem in substrraray
        {
          let is_val:Bool = subitem.contains(".")
          if is_val
          {
            self.GoverPlay = subitem
            let  ssubstrraray=subitem.components(separatedBy: ".")
            if ssubstrraray.count == 3 {
              
              var day:Int = 0
              var month:Int = 0
              var year:Int = 0
              if(!ssubstrraray[0].isEmpty)
              {
                day = Int(removeWhiteSpaceInString(original: ssubstrraray[0]) as String)!
              }
              if(!ssubstrraray[1].isEmpty)
              {
                month = Int(removeWhiteSpaceInString(original: ssubstrraray[1]) as String)!
              }
              if(!ssubstrraray[2].isEmpty)
              {
                year = Int(removeWhiteSpaceInString(original: ssubstrraray[2]) as String)!
              }

              if(month>12){ ViewController.dateComponentsGover2.month = 12}else if(month<13&&month>0){ ViewController.dateComponentsGover2.month = month}
              if (year>0){   ViewController.dateComponentsGover2.year = year}
              if(day > 31){
              ViewController.dateComponentsGover2.day = 31}else if(day<32&&day>0)
              {
                ViewController.dateComponentsGover2.day = day
              }

            }
          }
        }
      }
        
        if imagestr.contains("PlayDate")
        {
          ViewController.total_reco_str += "\n"
          let string_type = imagestr as String
          // self.debug_text.insertText(string_type)
          ViewController.total_reco_str += string_type
          let  substrraray=imagestr.components(separatedBy: "-")
          for subitem in substrraray
          {
            let is_val:Bool = subitem.contains(".")
            if is_val
            {
              self.PlayerPlay = subitem
              let  ssubstrraray=subitem.components(separatedBy: ".")
              if ssubstrraray.count == 3 {
                var day:Int = 0
                var month:Int = 0
                var year:Int = 0
                if(!ssubstrraray[0].isEmpty)
                {
                    day = Int(removeWhiteSpaceInString(original: ssubstrraray[0]) as String)!
                }
                if(!ssubstrraray[1].isEmpty)
                {
                  month = Int(removeWhiteSpaceInString(original: ssubstrraray[1]) as String)!
                }
                if(!ssubstrraray[2].isEmpty)
                {
                  year = Int(removeWhiteSpaceInString(original: ssubstrraray[2]) as String)!
                }

                if(day>31){ViewController.dateComponentsPlay.day = 31}else if(day<32&&day>0){ViewController.dateComponentsPlay.day = day}
                if(year>0){ViewController.dateComponentsPlay.year = year}
                
                if(month>12){ViewController.dateComponentsPlay.month = 12}else if(month<13&&month>0){ViewController.dateComponentsPlay.month = month}
                
                
                
              }
            }
          }
          
        }
        if imagestr.contains("PlayTime")
        {

          let string_type = imagestr as String
          ViewController.total_reco_str += string_type

          let  substrraray=imagestr.components(separatedBy: "-")
          for subitem in substrraray
          {
            let is_val:Bool = subitem.contains(".")
            if is_val
            {
              self.PlayerPlay += subitem
              let  ssubstrraray=subitem.components(separatedBy: ".")
              if ssubstrraray.count == 2 {
                var time :Int = 0
                var min :Int = 0
                if(!ssubstrraray[0].isEmpty)
                {
                  time=Int(removeWhiteSpaceInString(original: ssubstrraray[0]) as String)!}
                  
                if (!ssubstrraray[1].isEmpty)
                {
                  min = Int(removeWhiteSpaceInString(original: ssubstrraray[1])as String)!
                }
                if(time<25&&time>0)
                {
                  ViewController.dateComponentsPlay.hour = time
                }
                if(min>0&&min<61)
                {
                  ViewController.dateComponentsPlay.minute = min
                }

              }
            }
          }
          
       }
      if(imagestr.contains("DrawTimes-"))
      {
        let  substrraray=imagestr.components(separatedBy: "-")
        let last: String = substrraray.last!
        if (!last.isEmpty)
        {
          ViewController.double_drawtimes = Int(removeWhiteSpaceInString(original: last)as String)!
        }
        
      }
        
        
        let is_new_row:Bool = imagestr.contains("$")
        let is_type:Bool = imagestr.contains("type")
        if is_new_row
        {
          
          ViewController.is_reco_corect = true

          var Mutary2 : NSMutableArray = [];
          
          let  Strraray=imagestr.components(separatedBy: "$")
          for item in Strraray
          {
            if item.isEmpty
            {
              continue
            }
            
            var rectitem :  RectItem = RectItem.init()
            let  substrraray=item.components(separatedBy: "-")
            for subitem in substrraray
            {
              let is_val:Bool = subitem.contains(":")
              if is_val
              {
                let  ssubstrraray=subitem.components(separatedBy: ":")
                if ssubstrraray.count==4 {
                  let x=Int(ssubstrraray[0] as String)
                  let y=Int(ssubstrraray[1] as String)
                  let w=Int(ssubstrraray[2] as String)
                  let h=Int(ssubstrraray[3] as String)
                  rectitem.rect=CGRect.init(x: x!, y: y!, width: w!, height: h!)
                }
              }
              else
              {
                if subitem.contains("+")
                {
                  rectitem.integervalue = 255
                }
                else
                {
                  if(!subitem.isEmpty)
                  {
                    let val = Int(subitem as String)
                    rectitem.string=subitem as String
                    if val != nil
                    {
                      rectitem.integervalue = val as! Int
                    }
                  }

                }
              }
            }
            
            Mutary2.add(rectitem)
          }

            ViewController.NumberMutary.add(Mutary2)
        }
        if is_type
        {

          let json:String=imagestr as String;
          let  ssubstrraray=json.components(separatedBy: ":")
          if ssubstrraray.count > 1{
            let x=Int(ssubstrraray[1] as String)
            switch x {
            case 1?:
              do {
                ViewController.m_lototype=LotoTypeSwift.Sayisal
                

                ViewController.loto_type_str = "“Sayısal Loto”"
              }
            case 2?:
              do {

                ViewController.loto_type_str = "“Süper Loto”"
                ViewController.m_lototype=LotoTypeSwift.Super
              }
            case 3?:
              do {

                ViewController.loto_type_str = "“On Numara”"

                ViewController.m_lototype=LotoTypeSwift.Numara
              }
            case 4?:
              do {
                ViewController.loto_type_str = "“Şans Topu”"

                ViewController.m_lototype=LotoTypeSwift.Sans
              }
            default:
              ViewController.m_lototype = LotoTypeSwift.Unknown
            }
          }
        }
      

        
      }
      
     
    if (notification.object as? UIImage) != nil
    {

    }

  }
  ///with sans topu coupon
  func CompareSans() -> Int {
    
    var weekwinnumbernew = ViewController.sansWeeklyWinNunbers
    if ViewController.sansWeeklyWinNunbers.count != 6 {
      return 444
    }
    
    for (index, value) in weekwinnumbernew.enumerated() {

      if index == 4
      {
        if value < 10{
             ViewController.week_win_number_str += " 0\(value) + "
        }else
        {
             ViewController.week_win_number_str += " \(value) + "
        }
          
      }
      else
      {
        if value < 10{
          ViewController.week_win_number_str += " 0\(value)  "
        }else
        {
          ViewController.week_win_number_str += " \(value)  "
        }
      
     
      }
      
    }
    var returnval = 0

    ViewController.lotoimge = self.lotteryImage.image!
    var image:UIImage = ViewController.lotoimge
    
    for item in ViewController.NumberMutary as NSArray
    {
     
      let items=item as! NSArray
      if(items.count==7)
      {
        var is_extra_number_equal = false
        let lastitem = items[6] as! RectItem
        if(weekwinnumbernew[5] == lastitem.integervalue){
          is_extra_number_equal = true
          lastitem.is_same = true
        }

        var  samecount:Int = 0
        for index in 0...4
        {
          let rectitem = items[index] as! RectItem
          
          for index1 in 0...4 {
            
            if weekwinnumbernew[index1] == rectitem.integervalue
            {
              samecount = samecount + 1
              rectitem.is_same = true
            }
          }
        }
        
        if ((samecount == 1&&is_extra_number_equal)||(samecount == 2&&is_extra_number_equal)||(samecount == 3&&is_extra_number_equal)||(samecount == 4&&is_extra_number_equal)||(samecount == 5&&is_extra_number_equal)||(samecount == 3)||(samecount == 4)||(samecount == 5))
        {
          BaseViewController.is_circled = true
          returnval = returnval + 1
        }
        else
        {
          for (index,_) in items.enumerated() {
            let rectitem = items[index] as! RectItem
             rectitem.is_same = false
          }
          
        }
      }
    }
    
    if BaseViewController.is_circled {
      let alertview = JSSAlertView().show(self,
                                          title: "CONGRATULATIONS".localized,
                                          text: "Your coupon has winning numbers".localized,
                                          buttonText: "OK".localized
                                         )

      alertview.addAction(drawresultcallback)


    }

    return returnval;
    
  }
  func drawresultcallback() {
    var image:UIImage = ViewController.lotoimge
    for item in ViewController.NumberMutary as NSArray
    {
      let items=item as! NSArray
      for (index,_) in items.enumerated() {
        let rectitem = items[index] as! RectItem
        if rectitem.is_same
        {
          let img:UIImage  = CVWrapper.drawResult(image, rectitem.rect as CGRect);
          image = img
        }
      }
    }
    ViewController.lotoimge = image
    self.lotteryImage.image = image
    self.saveImageDocumentDirectory(saveimage: self.lotteryImage.image!, filename: ViewController.coupon_name_str)
    self.savetoPhotoLibrary()
    print("printresultcallback called")
  }
  /////with super coupon
  func CompareSuper() -> Int {
    
    var weekwinnumbernew = ViewController.superWeeklyWinNunbers
    if ViewController.superWeeklyWinNunbers.count != 6 {
      return 444
    }
   
    for (_, value) in weekwinnumbernew.enumerated() {

      if value < 10{
        ViewController.week_win_number_str += " 0\(value)   "
      }else
      {
        ViewController.week_win_number_str += " \(value)   "
      }
     
      
    }
    var returnval = 0

    for item in ViewController.NumberMutary as NSArray
    {
      let items=item as! NSArray
      var  samecount:Int = 0
      for (index,_) in items.enumerated() {
        let rectitem = items[index] as! RectItem
        
        for (index1,_) in weekwinnumbernew.enumerated() {
          
          if weekwinnumbernew[index1] == rectitem.integervalue
          {
            samecount = samecount + 1
            rectitem.is_same = true
          }
        }
      }
      if samecount >= 3
      {
       
        BaseViewController.is_circled = true
        returnval = returnval + 1
      }
      else
      {
        for (index,_) in items.enumerated() {
          let rectitem = items[index] as! RectItem
          rectitem.is_same = false
        }
        
      }
      
    }
    
    if BaseViewController.is_circled {
      
      let alertview = JSSAlertView().show(self,
                                          title: "CONGRATULATIONS".localized,
                                          text: "Your coupon has winning numbers".localized,
                                          buttonText: "OK".localized
      )
      // cancelButtonText: "Cancel".localized
      alertview.addAction(drawresultcallback)


    }

    return returnval;
    
  }
  /////with sayisal coupon
  func CompareSayisal() -> Int {
    if ViewController.sayisalWeeklyWinNunbers.count != 6 {
      return 444
    }
    var weekwinnumbernew = ViewController.sayisalWeeklyWinNunbers
   
    for (_, value) in weekwinnumbernew.enumerated() {
      if value < 10{
        ViewController.week_win_number_str += " 0\(value)   "
      }else
      {
        ViewController.week_win_number_str += " \(value)   "
      }

    }
    var returnval = 0

    for item in ViewController.NumberMutary as NSArray
    {
      let items=item as! NSArray
      var  samecount:Int = 0
      for (index,_) in items.enumerated() {
        let rectitem = items[index] as! RectItem
        
        for (index1,_) in weekwinnumbernew.enumerated() {
          
          if weekwinnumbernew[index1] == rectitem.integervalue
          {
            samecount = samecount + 1
            rectitem.is_same = true
          }
        }
      }
      if samecount >= 3
      {

        
        BaseViewController.is_circled = true
        returnval = returnval + 1
      }
      else
      {
        for (index,_) in items.enumerated() {
          let rectitem = items[index] as! RectItem
          rectitem.is_same = false
        }
        
      }

    }
    if BaseViewController.is_circled {
      
      let alertview = JSSAlertView().show(self,
                                          title: "CONGRATULATIONS".localized,
                                          text: "Your coupon has winning numbers".localized,
                                          buttonText: "OK".localized
      )
      // cancelButtonText: "Cancel".localized
      alertview.addAction(drawresultcallback)
      

    }

    return returnval;
    
  }

  ///with the weekly  win numbers
  func CompareNumara() -> Int {
    if ViewController.numaraWeeklyWinNunbers.count != 22 {
      return 444
    }
    
    var weekwinnumbernew = ViewController.numaraWeeklyWinNunbers
   
    for (index, value) in weekwinnumbernew.enumerated() {
 
      if index<11{
        if value < 10{
          ViewController.week_win_number_str += " 0\(value)   "
        }else
        {
          ViewController.week_win_number_str += " \(value)   "
        }
      }
      
      else{
        if value < 10{
          ViewController.week_win_number_str1 += " 0\(value)   "
        }else
        {
          ViewController.week_win_number_str1 += " \(value)   "
        }

      }
    }
    var returnval = 0
    
    for item in ViewController.NumberMutary as NSArray
    {
      let items=item as! NSArray
      var  samecount:Int = 0
      
      
      for (index,_) in items.enumerated()
      {
        let rectitem = items[index] as! RectItem
        
        for (index1,_) in weekwinnumbernew.enumerated() {
        
        if weekwinnumbernew[index1] == rectitem.integervalue
        {
          samecount = samecount + 1
          rectitem.is_same = true
        }
        }
      }
      
      
      if samecount > 5
      {
        
        BaseViewController.is_circled = true
        returnval = returnval + 1
      }
      else
      {
        for (index,_) in items.enumerated() {
          let rectitem = items[index] as! RectItem
          rectitem.is_same = false
        }
        
      }
      if samecount == 0
      {
          returnval = returnval + 1
          BaseViewController.is_numara_onerow = true

        for (index,_) in items.enumerated() {
          let rectitem = items[index] as! RectItem
          rectitem.numara_noone = true
        }
          

        

      }
    }
    if BaseViewController.is_numara_onerow {
      
      let alertview = JSSAlertView().show(self,
                                          title: "CONGRATULATIONS".localized,
                                          text: "none of the numbers on your coupon are included in the lottery numbers".localized,
                                          buttonText: "OK".localized
      )
      // cancelButtonText: "Cancel".localized
      alertview.addAction(drawresultnumaracallback)
      
    }
    else if BaseViewController.is_circled {
      
      let alertview = JSSAlertView().show(self,
                                          title: "CONGRATULATIONS".localized,
                                          text: "Your coupon has winning numbers".localized,
                                          buttonText: "OK".localized
      )
      // cancelButtonText: "Cancel".localized
      alertview.addAction(drawresultcallback)
      

    }

    return returnval;
  
  }
  func drawresultnumaracallback() {
    var image:UIImage = ViewController.lotoimge
    for item in ViewController.NumberMutary as NSArray
    {
               var is_one_row = true;
                let items=item as! NSArray
                for (index,_) in items.enumerated() {
                  let rectitem = items[index] as! RectItem
                  if rectitem.numara_noone {}else
                   {
                    is_one_row = false;
                   }
                  if rectitem.is_same
                   {
                   let img:UIImage  = CVWrapper.drawResult(image, rectitem.rect as CGRect);
                   image = img
                   }
                }
      if (items.count > 9 && is_one_row ){
        
        let rectitem = items[0] as! RectItem
        let lasrectitem = items[9] as! RectItem
        let width:Int = Int(lasrectitem.rect.origin.x-rectitem.rect.origin.x + lasrectitem.rect.size.width)
        let row_rect:CGRect = CGRect.init(x: rectitem.rect.origin.x, y: rectitem.rect.origin.y, width: CGFloat(width), height: rectitem.rect.size.height)
        
        let img:UIImage = CVWrapper.drawResult(image,  row_rect)
        
        image = img

      }

    }
    ViewController.lotoimge = image
    self.lotteryImage.image = image
    self.saveImageDocumentDirectory(saveimage: self.lotteryImage.image!, filename: ViewController.coupon_name_str)
    self.savetoPhotoLibrary()
    print("printresultcallback called")
  }
  

  // IBAction methods
  @IBAction func backgroundTapped(_ sender: Any) {
    view.endEditing(true)
  }
  
  @IBAction func textFieldEndOnExit(_ sender: Any) {
    view.endEditing(true)
  }
  
  @IBAction func takePhoto(_ sender: Any) {
    view.endEditing(true)
    presentImagePicker()
  }
  
  @IBAction func swapText(_ sender: Any) {
    view.endEditing(true)

    guard let text = textView.text,
      let findText = findTextField.text,
      let replaceText = replaceTextField.text else {
        return
    }

    textView.text = text.replacingOccurrences(of: findText, with: replaceText)
    findTextField.text = nil
    replaceTextField.text = nil
  }
  @IBAction func onbuttonTapped(_ sender: Any) {
    
      if(ViewController.m_lototype == LotoTypeSwift.Numara)
      {
        self.performSegue(withIdentifier: "segue_numara_view", sender: nil)
      }
      else if(ViewController.m_lototype == LotoTypeSwift.Sayisal)
      {
        self.performSegue(withIdentifier: "segue_sayisal_view", sender: nil)
       }
      else if(ViewController.m_lototype == LotoTypeSwift.Sans)
      {
        self.performSegue(withIdentifier: "segue_sanstopu_view", sender: nil)
      }
      else if(ViewController.m_lototype == LotoTypeSwift.Super)
      {
        self.performSegue(withIdentifier: "segue_super_view", sender: nil)
      }
    }
    
  @IBAction func sharePoem(_ sender: Any) {
    if textView.text.isEmpty {
      return
    }
    let activityViewController = UIActivityViewController(activityItems:
      [textView.text], applicationActivities: nil)
    let excludeActivities:[UIActivity.ActivityType] = [
      .assignToContact,
      .saveToCameraRoll,
      .addToReadingList,
      .postToFlickr,
      .postToVimeo]
    activityViewController.excludedActivityTypes = excludeActivities
    present(activityViewController, animated: true)
  }
  func cusstart()
  {
    presentImagePicker()

  }

  func getWinwersFromDB(date: Date, type:LotoTypeSwift)->Bool {
    
    let dayinterval = getCurrentDayStampWO(dateToConvert: date)
    let count = Category.count()
    if (count<4) {
      return false
      
    }
    else
    {
      let type_rawval = type.rawValue
      let sql = "SELECT * FROM categories WHERE mycusid='\(dayinterval)' and lototype='\(type_rawval)'"
      let aim_array = Category.rowsFor(sql: sql)

      print("mycusid='\(dayinterval)' getWinwersFromDB");
      print(aim_array.count);
      if aim_array.count == 0 {

        let sql = "SELECT * FROM categories WHERE lototype='\(type_rawval)' ORDER BY 'myid'"
        let prize_array = Category.rowsFor(sql: sql)

        if prize_array.count == 0 {
          return false
        }

        let  prizecat = prize_array.last as! Category
        switch type
        {
        case .Sayisal:
           ViewController.sayisal_prize_str = prizecat.prize
        case .Super:
           ViewController.super_prize_str = prizecat.prize
        case .Numara:
           ViewController.numara_prize_str = prizecat.prize
        case .Sans:
           ViewController.sans_prize_str = prizecat.prize
        case .Unknown:
          _ = 34
        }
        return false
      }
      //if let cat = Category.row(number: 1, order: "winners")
      var  cat = aim_array[0];
      for cat_int in aim_array
      {
        if(cat_int.id>cat.id)
        {
          cat = cat_int
        }
      }
      

      do {
        let winners = cat.winners
        if cat.lototype == LotoTypeSwift.Numara.rawValue
        {
          if ViewController.numaraWeeklyWinNunbers.count == 0
          {
            let substrraray=winners.components(separatedBy: "-")
            for subitem in substrraray
            {
              let indiItem = removeWhiteSpaceInString(original: subitem)
              if indiItem.isEmpty
              {
                continue
              }
              else
              {
                let winval=Int(indiItem as String)
                ViewController.numaraWeeklyWinNunbers.append(winval!)
              }
            }

          }
          ViewController.numara_prize_str = cat.prize

        }
        //
        if cat.lototype == LotoTypeSwift.Sayisal.rawValue
        {
          if ViewController.sayisalWeeklyWinNunbers.count == 0
          {
            let substrraray=winners.components(separatedBy: "-")
            for subitem in substrraray
            {
              let indiItem = removeWhiteSpaceInString(original: subitem)
              if indiItem.isEmpty
              {
                continue
              }
              else
              {
                let winval=Int(indiItem as String)
                ViewController.sayisalWeeklyWinNunbers.append(winval!)
              }
            }
             ViewController.sayisal_prize_str = cat.prize

          }

        }
        ///
        if cat.lototype == LotoTypeSwift.Super.rawValue
        {
          if ViewController.superWeeklyWinNunbers.count == 0
          {
            let substrraray=winners.components(separatedBy: "-")
            for subitem in substrraray
            {
              let indiItem = removeWhiteSpaceInString(original: subitem)
              if indiItem.isEmpty
              {
                continue
              }
              else
              {
                let winval=Int(indiItem as String)
                ViewController.superWeeklyWinNunbers.append(winval!)
              }
            }
             ViewController.super_prize_str = cat.prize

          }

        }
        ///
        if cat.lototype == LotoTypeSwift.Sans.rawValue
        {
          if ViewController.sansWeeklyWinNunbers.count == 0
          {
            let substrraray=winners.components(separatedBy: "-")
            for subitem in substrraray
            {
              let indiItem = removeWhiteSpaceInString(original: subitem)
              if indiItem.isEmpty
              {
                continue
              }
              else
              {
                if(indiItem.contains("+"))
                {
                  let ssubarry=indiItem.components(separatedBy: "+")
                  if (ssubarry.count==2){
                    
                    let winval=Int(ssubarry[0] as String)
                    ViewController.sansWeeklyWinNunbers.append(winval!)
                    let winval1=Int(ssubarry[1] as String)
                    ViewController.sansWeeklyWinNunbers.append(winval1!)
                  }
                  
                }else
                {
                  let winval=Int(indiItem as String)
                  ViewController.sansWeeklyWinNunbers.append(winval!)
                }
                
              }
            }
           ViewController.sans_prize_str = cat.prize
          }

        }
      }
      
    }

    return true
  }

  // Tesseract Image Recognition
  func performImageRecognition(_ image: UIImage) {

    // showLoadingHUD()
    
    check_tick_btn.isEnabled = false
    check_tick_btn.isHidden  = true
    ViewController.double_drawtimes = 0
    ViewController.loto_type_str = ""
    ViewController.m_lototype=LotoTypeSwift.Unknown
    BaseViewController.isvaluechaed = false
    NotificationCenter.default.addObserver(self, selector: #selector(self.CVProgressNotification), name: NSNotification.Name(rawValue: "CVProgressNotification"), object: nil)
    ViewController.NumberMutary.removeAllObjects()
    ViewController.dateComponentsGover.year = nil
    ViewController.dateComponentsGover.month = nil
    ViewController.dateComponentsGover.day = nil
    ViewController.total_reco_str = ""

    ViewController.loto_type_str = ""
    
    ViewController.sans_prize_str = ""
    ViewController.sayisal_prize_str = ""
    ViewController.super_prize_str = ""
    ViewController.numara_prize_str = ""

    
    ViewController.week_win_number_str = ""
    ViewController.week_win_number_str1 = ""
    BaseViewController.is_circled = false
    BaseViewController.is_numara_onerow = false
    ViewController.is_double_date = false
    ViewController.is_date_reco = false
    ViewController.is_reco_corect = false
    ViewController.re_compare_date = false

    ViewController.datearray.removeAll()
    
    
    let remoteImageURL1 = URL(string: "http://173.212.199.191:100/pics/img-02.jpg")!
    let remoteImageURL2 = URL(string: "http://173.212.199.191:100/pics/img-01.jpg")!
    
    
    // Use Alamofire to download the image
    AF.request(remoteImageURL1).responseData { (response) in
      if response.error == nil {

        if let data = response.data {
          self.image1 = UIImage(data: data)!
        }
      }
    }
    AF.request(remoteImageURL2).responseData { (response) in
      if response.error == nil {

        if let data = response.data {
          self.image2 = UIImage(data: data)!
        }
      }
    }
    

    ViewController.originallotoimge = image;
    
    ViewController.lotoimge = CVWrapper.getTesseractString(image)
    lotteryImage.image = ViewController.lotoimge
    //guard let strongSelf = self else { return }
    
    self.hideLoadingHUD()
    //// process the time

    
    ////
    
    
    if (ViewController.is_reco_corect == false || ViewController.m_lototype == LotoTypeSwift.Unknown)
    {
//      
//      http://173.212.199.191:100/pics/img-01.jpg
//      
//      http://173.212.199.191:100/pics/img-02.jpg
      
               // The image to dowload



      
       let message1 = "Please align the coupon as shown in the image examples below. Take your photo in daylight and in a shadowless environment.".localized;
      let alertVC = PMAlertController(title: "Recognization Error!".localized, description: message1, image: nil, style: .alert) //Image by freepik.com, taken on flaticon.com
      
      alertVC.addAction(PMAlertAction(title: "Case 1".localized, style: .default, action: { () -> Void in

        let message2 = " Please align the coupon as shown in the image example above. Take your photo in daylight and in a shadowless environment.".localized;
        let alertVC = PMAlertController(title: "".localized, description: message2, image: self.image1, style: .alert) //Image by freepik.com, taken on flaticon.com
        
        alertVC.addAction(PMAlertAction(title: "OK".localized, style: .cancel, action: { () -> Void in
          print("Cancel")
        }))

        
        self.present(alertVC, animated: true, completion: nil)
      }))
      
      alertVC.addAction(PMAlertAction(title: "Case 2".localized, style: .default, action: { () in
        
        
        let message2 = "message2".localized;
        let alertVC = PMAlertController(title: "".localized, description: message2, image:self.image2, style: .alert) //Image by freepik.com, taken on flaticon.com
        
        alertVC.addAction(PMAlertAction(title: "OK".localized, style: .cancel, action: { () -> Void in
          print("Cancel")
        }))
        
        
        self.present(alertVC, animated: true, completion: nil)

      }))
      
      self.present(alertVC, animated: true, completion: nil)
      
     

      
      return
    }


    //activityIndicator.stopAnimating()
    //textView.text = ViewController.total_reco_str
    ViewController.numaraWeeklyWinNunbers.removeAll()
    ViewController.sansWeeklyWinNunbers.removeAll()
    ViewController.sayisalWeeklyWinNunbers.removeAll()
    ViewController.superWeeklyWinNunbers.removeAll()

    let r = NoticeCouponTimeValid()
    if(r == 44)
    {


      let message1 = "Please align the coupon as shown in the image examples below. Take your photo in daylight and in a shadowless environment.".localized;
      let message2 = " Please align the coupon as shown in the image example above. Take your photo in daylight and in a shadowless environment.".localized;
      let alertVC = PMAlertController(title: "Date Infomation Error".localized, description: message1, image: nil, style: .alert)
      
      alertVC.addAction(PMAlertAction(title: "Case 1".localized, style: .default, action: { () -> Void in
        

        let alertVC = PMAlertController(title: "".localized, description: message2, image: self.image1, style: .alert)
        
        alertVC.addAction(PMAlertAction(title: "OK".localized, style: .cancel, action: { () -> Void in
          print("Cancel")
        }))
        
        
        self.present(alertVC, animated: true, completion: nil)
      }))
      
      alertVC.addAction(PMAlertAction(title: "Case 2".localized, style: .default, action: { () in
        
        

        let alertVC = PMAlertController(title: "".localized, description: message2, image: self.image2, style: .alert) //Image by freepik.com, taken on flaticon.com
        
        alertVC.addAction(PMAlertAction(title: "OK".localized, style: .cancel, action: { () -> Void in
          print("Cancel")
        }))
        
        
        self.present(alertVC, animated: true, completion: nil)
        
      }))
      
      self.present(alertVC, animated: true, completion: nil)
      

    }

    if ViewController.is_date_reco {
      if ViewController.is_double_date {
        if(ViewController.dateComponentsGover.month != nil &&  ViewController.dateComponentsGover.day != nil)
        {
          var  is_yet_drawn = false
          if (ViewController.dateComponentsGover2.day != nil && ViewController.dateComponentsGover2.month != nil)
          {
            

            var medidatecomponent =  DateComponents()
            medidatecomponent.year = ViewController.dateComponentsGover.year
            medidatecomponent.month = ViewController.dateComponentsGover.month
            var endday = ViewController.dateComponentsGover2.day!
            if (ViewController.dateComponentsGover.month! < ViewController.dateComponentsGover2.month!)
            {
              endday = endday + 33
            }
            
            print("dateComponentsGover");
            let item_str1 = componentToStr(components: ViewController.dateComponentsGover as DateComponents)
            print(item_str1);
            print("dateComponentsGover2");
            let item_str = componentToStr(components: ViewController.dateComponentsGover2 as DateComponents)
            print(item_str);
            
            let dayInterval = 7
            let startday = ViewController.dateComponentsGover.day!
            
            if ViewController.m_lototype == LotoTypeSwift.Sayisal
            {
              for tickMark in stride(from: startday, through: endday, by: dayInterval) {
                medidatecomponent.day = tickMark
                let mdate = createDateFromComponents(components: medidatecomponent)
                let dayinterval = getCurrentDayStampWO(dateToConvert: mdate)
                let type_rawval =  ViewController.m_lototype.rawValue
                let sql = "SELECT * FROM categories WHERE mycusid='\(dayinterval)' and lototype='\(type_rawval)'"
                let aim_array = Category.rowsFor(sql: sql)

                print(aim_array.count);
                let item_str = componentToStr(components: medidatecomponent as DateComponents)
                print(item_str);
                if aim_array.count > 0
                {
                  is_yet_drawn=true
                  ViewController.datearray.append(medidatecomponent)

                }

              }
              

              
              medidatecomponent.month =  ViewController.dateComponentsGover2.month
              medidatecomponent.day = ViewController.dateComponentsGover2.day
              let oriday :Int = ViewController.dateComponentsGover2.day!

              let insertindex = ViewController.datearray.count ;

              if(ViewController.double_drawtimes>0)
              {
                let power = ViewController.double_drawtimes/2
                
                for index in 1...power {
                  medidatecomponent.day =  oriday - 7*(index-1)
                  let mdate = createDateFromComponents(components: medidatecomponent)
                  let dayinterval = getCurrentDayStampWO(dateToConvert: mdate)
                  let type_rawval =  ViewController.m_lototype.rawValue
                  let sql = "SELECT * FROM categories WHERE mycusid='\(dayinterval)' and lototype='\(type_rawval)'"
                  let aim_array = Category.rowsFor(sql: sql)

                  print(aim_array.count);
                  let item_str = componentToStr(components: medidatecomponent as DateComponents)
                  print(item_str);
                  if aim_array.count > 0
                  {
                    is_yet_drawn=true
                    
                    if (insertindex >=  0)
                    {
                      ViewController.datearray.insert(medidatecomponent, at: insertindex)
                    }
                    else
                    {
                      ViewController.datearray.insert(medidatecomponent, at: 0)
                    }
                    
                  }
                }
              }
              else
              {
                
                var mdate = createDateFromComponents(components: medidatecomponent)
                var dayinterval = getCurrentDayStampWO(dateToConvert: mdate)
                let type_rawval =  ViewController.m_lototype.rawValue
                var sql = "SELECT * FROM categories WHERE mycusid='\(dayinterval)' and lototype='\(type_rawval)'"
                var aim_array = Category.rowsFor(sql: sql)

                print(aim_array.count);
                var item_str = componentToStr(components: medidatecomponent as DateComponents)
                print(item_str);
                if aim_array.count > 0
                {
                  is_yet_drawn=true
                  
                  if (insertindex >=  0)
                  {
                    ViewController.datearray.insert(medidatecomponent, at: insertindex)
                  }
                  else
                  {
                    ViewController.datearray.insert(medidatecomponent, at: 0)
                  }
                  
                }
                 medidatecomponent.day = medidatecomponent.day! - 7
         
                 mdate = createDateFromComponents(components: medidatecomponent)
                 dayinterval = getCurrentDayStampWO(dateToConvert: mdate)

                 sql = "SELECT * FROM categories WHERE mycusid='\(dayinterval)' and lototype='\(type_rawval)'"
                 aim_array = Category.rowsFor(sql: sql)

                print(aim_array.count);
                item_str = componentToStr(components: medidatecomponent as DateComponents)
                print(item_str);
                if aim_array.count > 0
                {
                  is_yet_drawn=true
                  
                  if (insertindex >=  0)
                  {
                    ViewController.datearray.insert(medidatecomponent, at: insertindex)
                  }
                  else
                  {
                    ViewController.datearray.insert(medidatecomponent, at: 0)
                  }
                  
                }
                
              }
            }else
            {
              for tickMark in stride(from: startday, through: endday, by: dayInterval) {
                medidatecomponent.day = tickMark
                let mdate = createDateFromComponents(components: medidatecomponent)
                let dayinterval = getCurrentDayStampWO(dateToConvert: mdate)
                let type_rawval =  ViewController.m_lototype.rawValue
                let sql = "SELECT * FROM categories WHERE mycusid='\(dayinterval)' and lototype='\(type_rawval)'"
                let aim_array = Category.rowsFor(sql: sql)

                
                let item_str = componentToStr(components: medidatecomponent as DateComponents)
                print(item_str);
                
                print(aim_array.count);
                if aim_array.count > 0
                {
                  is_yet_drawn=true
                  if(ViewController.double_drawtimes>0)
                  {
                    if ViewController.datearray.count < ViewController.double_drawtimes
                    {
       
                      ViewController.datearray.append(medidatecomponent)
                    }
                  }else
                  {
                    if ViewController.datearray.count <= 5
                    {
                      ViewController.datearray.append(medidatecomponent)
                    }
                  }
      
                  

                }

              }
            }

          }
          else if(ViewController.double_drawtimes > 0)
          {

            var boolarray :Array = [Bool]()
            var medidatecomponent =  DateComponents()
            medidatecomponent.year = ViewController.dateComponentsGover.year
            medidatecomponent.month = ViewController.dateComponentsGover.month
            print("dateComponentsGover");
            let item_str1 = componentToStr(components: ViewController.dateComponentsGover as DateComponents)
            print(item_str1)
            let startday = ViewController.dateComponentsGover.day  as! Int
            
            if (ViewController.m_lototype == LotoTypeSwift.Sayisal && ViewController.double_drawtimes == 4)
            {

                
                medidatecomponent.day = startday
                var mdate = createDateFromComponents(components: medidatecomponent)
                var dayinterval = getCurrentDayStampWO(dateToConvert: mdate)
                let type_rawval =  ViewController.m_lototype.rawValue
                var sql = "SELECT * FROM categories WHERE mycusid='\(dayinterval)' and lototype='\(type_rawval)'"
                var aim_array = Category.rowsFor(sql: sql)

                print(aim_array.count);
                var item_str = componentToStr(components: medidatecomponent as DateComponents)
                print(item_str);
                if aim_array.count > 0
                {
                  is_yet_drawn=true
                  ViewController.datearray.append(medidatecomponent)

                }
              
               medidatecomponent.day = startday + 7
               mdate = createDateFromComponents(components: medidatecomponent)
               dayinterval = getCurrentDayStampWO(dateToConvert: mdate)
               sql = "SELECT * FROM categories WHERE mycusid='\(dayinterval)' and lototype='\(type_rawval)'"
               aim_array = Category.rowsFor(sql: sql)
               item_str = componentToStr(components: medidatecomponent as DateComponents)
               print(item_str);
               if aim_array.count > 0
               {
                is_yet_drawn=true
                ViewController.datearray.append(medidatecomponent)
               }
              
              medidatecomponent.day = startday + 3
              mdate = createDateFromComponents(components: medidatecomponent)
              dayinterval = getCurrentDayStampWO(dateToConvert: mdate)
              sql = "SELECT * FROM categories WHERE mycusid='\(dayinterval)' and lototype='\(type_rawval)'"
              aim_array = Category.rowsFor(sql: sql)
              item_str = componentToStr(components: medidatecomponent as DateComponents)
              print(item_str);
              if aim_array.count > 0
              {
                is_yet_drawn=true
                ViewController.datearray.append(medidatecomponent)
              }
              
              medidatecomponent.day = startday + 10
              mdate = createDateFromComponents(components: medidatecomponent)
              dayinterval = getCurrentDayStampWO(dateToConvert: mdate)
              sql = "SELECT * FROM categories WHERE mycusid='\(dayinterval)' and lototype='\(type_rawval)'"
              aim_array = Category.rowsFor(sql: sql)
              item_str = componentToStr(components: medidatecomponent as DateComponents)
              print(item_str);
              if aim_array.count > 0
              {
                is_yet_drawn=true
                ViewController.datearray.append(medidatecomponent)
              }
      



            }
          }
          /////////////
          if is_yet_drawn == false
          {

            let appearance = SCLAlertView.SCLAppearance(
              kTitleFont: UIFont(name: "Bebas Neue", size: 22)!,
              kTextFont: UIFont(name: "Bebas Neue", size: 18)!,
              kButtonFont: UIFont(name: "Bebas Neue", size: 15)!,
              showCloseButton: false,
              dynamicAnimatorActive: true,
              buttonsLayout: .vertical
            )
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("OK".localized) {
            }
            
            
            _ = alert.showInfo("Alert".localized, subTitle: "This coupon does not win".localized)
            
          }
          else{
            
            let appearance = SCLAlertView.SCLAppearance(
              kTitleFont: UIFont(name: "Bebas Neue", size: 16)!,
              kTextFont: UIFont(name: "Bebas Neue", size: 14)!,
              kButtonFont: UIFont(name: "Bebas Neue", size: 20)!,
              showCloseButton: false,
              dynamicAnimatorActive: true,
              buttonsLayout: .vertical
            )
            let alert = SCLAlertView(appearance: appearance)
            
            
            
            
            let color = UIColor.blue
            
            

            for (subitem) in ViewController.datearray
            {
              let item_str = componentToStr(components: subitem as DateComponents)
              _ = alert.addButton(item_str) {
                ViewController.re_compare_date = true
                self.check_tick_btn.isEnabled = true
                self.check_tick_btn.isHidden  = false
                
                ViewController.dateComponentsGover = subitem
                _ = self.processAfterGoverDate()
                
              }
              
              
            }
            _ = alert.showSuccess("Coupon Result:".localized, subTitle: "")
            //            present(imagePickerActionSheet, animated: true)
          }
          
        }
      }
      else
      {
        _ = self.processAfterGoverDate()
      }

    }
    
  }
  func processAfterGoverDate()->Bool
  {
    let gover = createDateFromComponents(components: ViewController.dateComponentsGover)
    
    let getsuccess = getWinwersFromDB(date: gover,type: ViewController.m_lototype)

    if getsuccess == false
    {
      
      let appearance = SCLAlertView.SCLAppearance(
        kTitleFont: UIFont(name: "Bebas Neue", size: 22)!,
        kTextFont: UIFont(name: "Bebas Neue", size: 18)!,
        kButtonFont: UIFont(name: "Bebas Neue", size: 15)!,
        showCloseButton: false,
        dynamicAnimatorActive: true,
        buttonsLayout: .vertical
      )
      let alert = SCLAlertView(appearance: appearance)
      _ = alert.addButton("OK".localized) {
      }
      

    _ = alert.showInfo("Alert".localized, subTitle: "This coupon does not win".localized)
      

      return false
    }
    else
    {
      var returunval :Int = 0
      
      if ViewController.m_lototype == LotoTypeSwift.Numara
      {
        ViewController.coupon_name_str = "Numara"
        returunval = self.CompareNumara()
      }
      if ViewController.m_lototype == LotoTypeSwift.Sayisal
      {
        ViewController.coupon_name_str = "Sayisal"
        returunval = self.CompareSayisal()
      }
      if ViewController.m_lototype == LotoTypeSwift.Super
      {
        ViewController.coupon_name_str = "Super"
        returunval = self.CompareSuper()
      }
      if ViewController.m_lototype == LotoTypeSwift.Sans
      {
        ViewController.coupon_name_str = "Sans"
        returunval = self.CompareSans()
      }
      let currentDateTime = Date()

      
      self.create_dir_str = dateToStringForCouponDir(date: currentDateTime)
      ViewController.coupon_name_str += "_"
      ViewController.coupon_name_str += minitueToStringForCouponName(date: currentDateTime)
      ViewController.coupon_name_str += ".jpg"
      
      
      
      
      if (returunval > 0 && returunval != 444)
      {

        
        _ = JSSAlertView().show(self,
                                title: "Congratulation!".localized,
                                text: "Your numara loto image has archived a success.".localized,
                                buttonText: "OK".localized)
        

      }
      else
      {
        _ = JSSAlertView().show(self,
                                title: "Sorry".localized,
                                text: "No prize for coupon rows.".localized,
                                buttonText: "OK".localized)
        

      }
      return true;
    }


  }
  ////close app function
  
  func showMessageResetApp(){

    let appearance = SCLAlertView.SCLAppearance(
      kTitleFont: UIFont(name: "Bebas Neue", size: 20)!,
      kTextFont: UIFont(name: "Bebas Neue", size: 14)!,
      kButtonFont: UIFont(name: "Bebas Neue", size: 18)!,
      showCloseButton: false,
      dynamicAnimatorActive: true,
      buttonsLayout: .vertical
    )
    let alert = SCLAlertView(appearance: appearance)
    _ = alert.addButton("Close Now".localized,backgroundColor:UIColor.red,textColor:UIColor.white)
    {
      UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
      // terminaing app in background
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
        exit(EXIT_SUCCESS)
      })
    }
    _ = alert.addButton("Later".localized) {

    }

      let color = UIColor.red
      //alert.showTitle("Close app".localized, subTitle:  "Are you sure close this app?".localized,style: SCLAlertViewStyle.notice)
    alert.showError("Close app".localized, subTitle:  "Are you sure close this app?".localized)

  }

  public func showLoadingHUD() {
    let hud = MBProgressHUD.showAdded(to: contentView, animated: true)
    hud.contentColor = UIColor.brown
    hud.label.text = "Analysing".localized
  }
  public func showWaitHUD() {
    _ = MBProgressHUD.showAdded(to: contentView, animated: true)

  }
  
  public func hideLoadingHUD() {
    MBProgressHUD.hide(for: contentView, animated: true)
  }
  
  // The following methods handle the keyboard resignation/
  // move the view so that the first responders aren't hidden
  func moveViewUp() {
    if topMarginConstraint.constant != 0 {
      return
    }
    topMarginConstraint.constant -= 135
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  func moveViewDown() {
    if topMarginConstraint.constant == 0 {
      return
    }
    topMarginConstraint.constant = 0
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  private func createDateFromIndividual(weekday: Int, hour: Int, minute: Int,day: Int,month: Int,year: Int)->Date{
    
    var components = DateComponents()
    
    components.hour = hour
    components.minute = minute
    components.year = year
    components.month = month
    components.month = day
    components.weekday = weekday
    components.weekdayOrdinal = 10
    components.timeZone = TimeZone(abbreviation: "CET")
    
    var cal = Calendar.current
    cal.timeZone = TimeZone(abbreviation: "CET")!
    
    return cal.date(from: components)!
  }
  private func createDateFromComponents(components: DateComponents)->Date
  {
    
    let cal = Calendar.current
    //cal.timeZone = TimeZone(abbreviation: "CET")!
    
    return cal.date(from: components)!
  }
  func NoticeCouponTimeValid()->Int{
    let currentDateTime = Date()
    let userCalendar = Calendar.current
    //Ankara - Turkey;
    // choose which date and time components are needed
    let requestedComponents: Set<Calendar.Component> = [
      .year,
      .month,
      .day,
      .hour,
      .minute,
      .second
    ]
    // get the components
    let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
    
    if (ViewController.dateComponentsGover.month == nil) {
      if (ViewController.dateComponentsPlay.month != nil) {
        ViewController.dateComponentsGover.month = ViewController.dateComponentsPlay.month
      }
    }
    if (ViewController.dateComponentsPlay.month == nil) {
      if (ViewController.dateComponentsGover.month != nil) {
        ViewController.dateComponentsPlay.month = ViewController.dateComponentsGover.month
      }
    }
    if (ViewController.dateComponentsPlay.day == nil) {
      if (ViewController.dateComponentsGover.day != nil) {
        ViewController.dateComponentsPlay.day = ViewController.dateComponentsGover.day
      }
    }
    if(ViewController.dateComponentsGover.year == nil&&ViewController.dateComponentsPlay.year != nil)
    {
      if (ViewController.dateComponentsPlay.year!>2010)
      {
        ViewController.dateComponentsGover.year = ViewController.dateComponentsPlay.year
      }
    }
    if(ViewController.dateComponentsGover.month == nil || ViewController.dateComponentsPlay.month == nil || ViewController.dateComponentsPlay.day == nil || ViewController.dateComponentsGover.year == nil || ViewController.dateComponentsGover.day == nil )
    {
      return 44;
    }
    if ViewController.is_double_date {
      if(ViewController.dateComponentsGover2.month == nil || ViewController.dateComponentsGover2.year == nil || ViewController.dateComponentsGover2.day == nil )
      {
         return 44;
      }

    }

    
    if(ViewController.dateComponentsGover.month != nil && ViewController.dateComponentsPlay.month != nil)
    {
      let gomo=ViewController.dateComponentsGover.month!
      let plmo=ViewController.dateComponentsPlay.month!
      if gomo != plmo {
        if gomo < plmo
        {
          ViewController.dateComponentsGover.month! = plmo
        }else
        {
          if(ViewController.dateComponentsGover.day != nil && ViewController.dateComponentsPlay.day != nil)
          {
          if ViewController.dateComponentsGover.day! > ViewController.dateComponentsPlay.day!
          {
            if((plmo<9&&gomo<9)||(plmo>9&&gomo>9))
            {
              ViewController.dateComponentsPlay.month! = ViewController.dateComponentsGover.month!
            }
            else if(plmo>9&&gomo<9)
            {
               ViewController.dateComponentsPlay.month! = ViewController.dateComponentsGover.month!
            }
            else if(plmo<9&&gomo>9)
            {
              ViewController.dateComponentsGover.month! = ViewController.dateComponentsPlay.month!
            }            
            }
            
          }
        }
      }
    }
    if(ViewController.dateComponentsGover.year != nil&&ViewController.dateComponentsPlay.year != nil)
    {
      if (ViewController.dateComponentsGover.year!<2010&&ViewController.dateComponentsPlay.year!>2010)
      {
        ViewController.dateComponentsGover.year = ViewController.dateComponentsPlay.year
      }
    }
    if(ViewController.dateComponentsGover.year != nil&&ViewController.dateComponentsPlay.year == nil)
    {
      ViewController.dateComponentsPlay.year = ViewController.dateComponentsGover.year

    }

    ViewController.dateComponentsGover = GetCorectDayOnCoupon(input: ViewController.dateComponentsGover, m_type: ViewController.m_lototype);
    
    if (ViewController.dateComponentsGover2.day != nil && ViewController.is_double_date){
      
      if(ViewController.dateComponentsGover.year != nil)
      {
        ViewController.dateComponentsGover2.year = ViewController.dateComponentsGover.year
      }
      if(ViewController.dateComponentsGover2.month == nil && ViewController.dateComponentsGover.month != nil)
      {
        ViewController.dateComponentsGover2.month = ViewController.dateComponentsGover.month
      }
      ViewController.dateComponentsGover2 = GetCorectDayOnCoupon(input: ViewController.dateComponentsGover2, m_type: ViewController.m_lototype);
    }
    var is_valid = false
    if(ViewController.dateComponentsGover.year != nil&&ViewController.dateComponentsGover.month != nil)
    {
      if dateTimeComponents.year as! Int > ViewController.dateComponentsGover.year  as! Int   {
        let yearg :Int = ViewController.dateComponentsGover.year  as! Int
        if dateTimeComponents.year == (yearg+1) {
          if dateTimeComponents.month  as! Int >= ViewController.dateComponentsGover.month  as! Int   {
            is_valid=true
          }
        }
      }
      if dateTimeComponents.year as! Int == ViewController.dateComponentsGover.year  as! Int   {
        is_valid  = true
      }
      if is_valid == false {
//        let ac = UIAlertController(title: "Time!".localized, message: "The lottery paper is not valid.".localized, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK".localized, style: .default))
//        present(ac, animated: true)
//        cusstart()
//        return 0
      }
    }
    ////scenario 2
    if ViewController.dateComponentsPlay.hour != nil {
      let playhour:Int = ViewController.dateComponentsPlay.hour as! Int
      if playhour > 21 {
        if ViewController.dateComponentsPlay.year == ViewController.dateComponentsGover.year
        {
          if ViewController.dateComponentsPlay.month == ViewController.dateComponentsGover.month
          {
            if ViewController.dateComponentsPlay.day == ViewController.dateComponentsGover.day
            {

//
//              _ = JSSAlertView().show(self,
//                                                  title: "Time!".localized,
//                                                  text: "This coupon have to be evaluated for the next weeks winner prize.".localized,
//                                                  buttonText: "OK".localized)

            }
          }
          
        }
        
        
      }
    }
     return 0
 }

  func saveImageDocumentDirectory(saveimage:UIImage,filename:String){
    ///////
    let directoryPath =  NSHomeDirectory().appending("/Documents/\(self.create_dir_str)/")
    if !FileManager.default.fileExists(atPath: directoryPath) {
      do {
        try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
      } catch {
        print(error)
      }
    }
    //let filename = NSDate().string(withDateFormatter: yyyytoss).appending(".jpg")
    let filepath = directoryPath.appending(filename)
    let url = NSURL.fileURL(withPath: filepath)
    do {
        try saveimage.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomic)
      //return String.init("/Documents/\(filename)")
     
      
    } catch {
      print(error)
      print("file cant not be save at path \(filepath), with error : \(error)");
      return
    }
    
    /////////

  }

  func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }
  
  func getImage(image_name:String){
    let fileManager = FileManager.default
    let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(image_name)
    if fileManager.fileExists(atPath: imagePAth){
      self.lotteryImage.image = UIImage(contentsOfFile: imagePAth)
    }else{
      print("No Image")
    }
  }
  func createDirectory(new_dir:String){
    
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(new_dir)
    if !fileManager.fileExists(atPath: paths){
      try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
    }else{
      print("Already dictionary created.")
    }
    
  }
  func deleteDirectory(del_dir:String){
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(del_dir)
    if fileManager.fileExists(atPath: paths)
    {
      try! fileManager.removeItem(atPath: paths)
    }
    else
    {
      print("Something wrong. ")
    }
  }

  
  func savetoPhotoLibrary(){
    
    UIImageWriteToSavedPhotosAlbum(lotteryImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
 
  }
  //MARK: - Add image to Library
  @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    if let error = error {

    } else {

    }
  }
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    var nextController: UIViewController?
    nextController = segue.destination
    if ( segue.identifier == "segue_sanstopu_view")
    {
      (nextController as! SansTopuResultViewController).sansMutary1 = ViewController.NumberMutary
    }
    else if ( segue.identifier == "segue_numara_view")
    {
      (nextController as! NumaraResultViewController).sansMutary1 = ViewController.NumberMutary
    }
    else if ( segue.identifier == "segue_sayisal_view")
    {
      (nextController as! SayisalViewController).sansMutary1 = ViewController.NumberMutary
    }
    else if ( segue.identifier == "segue_super_view")
    {
      (nextController as! SuperViewController).sansMutary1 = ViewController.NumberMutary
    }
  }
}

//MARK: - Saving Image here


// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    moveViewUp()
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    moveViewDown()
  }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
  
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
  
  func presentImagePicker() {
    
    let appearance = SCLAlertView.SCLAppearance(
      kTitleFont: UIFont(name: "Bebas Neue", size: 20)!,
      kTextFont: UIFont(name: "Bebas Neue", size: 18)!,
      kButtonFont: UIFont(name: "Bebas Neue", size: 19)!,
      showCloseButton: true,
      dynamicAnimatorActive: true,
      buttonsLayout: .vertical
    )
    let alert = SCLAlertView(appearance: appearance)
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      _ = alert.addButton("Use Camera".localized,backgroundColor:UIColor.red)
      {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true)
      }
     
    }
    
    _ = alert.addButton("Use Photo Library".localized,backgroundColor:UIColor.red) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = .photoLibrary
      self.present(imagePicker, animated: true)
    }
    

    let color = UIColor.red
    
    _ = alert.showSuccess("Take Lottery Image".localized, subTitle: "")



  }

  func only_camera_image_pick()
  {

    
    let imagePicker:UIImagePickerController = UIImagePickerController()
    //Set delegate to imagePicker
    imagePicker.delegate = self
    //Allow user crop or not after take picture
    imagePicker.allowsEditing = false
    //set what you need to use "camera or photo library"
    imagePicker.sourceType = .camera
    //Switch flash camera
    imagePicker.cameraFlashMode = .off
    //Set camera Capture Mode photo or Video
    imagePicker.cameraCaptureMode = .photo
    //set camera front or rear
    imagePicker.cameraDevice = .rear
    //Present camera viewcontroller
    self.present(imagePicker, animated: true, completion: nil)
    
  }

  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
       {
      
        var  scaledImage :UIImage? = nil
        if (picker.sourceType == .camera)
        {
          scaledImage = selectedPhoto.scaleImage(960)!
        }
        else if(picker.sourceType == .photoLibrary)
        {
          scaledImage=CVWrapper.onlyCouponImage(selectedPhoto)
        }
        else
        {
          scaledImage = selectedPhoto.scaleImage(960)!
        }
        self.showLoadingHUD()
        dismiss(animated: true, completion: {
        //self.savetoPhotoLibrary()
        self.performImageRecognition(scaledImage!)

       })
    }
  }
}

// MARK: - UIImage extension
extension UIImage {
  func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
    
    var scaledSize = CGSize(width: maxDimension, height: maxDimension)
    
    if size.width > size.height {
      let scaleFactor = size.height / size.width
      scaledSize.height = scaledSize.width * scaleFactor
    } else {
      let scaleFactor = size.width / size.height
      scaledSize.width = scaledSize.height * scaleFactor
    }
    
    UIGraphicsBeginImageContext(scaledSize)
    draw(in: CGRect(origin: .zero, size: scaledSize))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
  }
}
