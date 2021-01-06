//
//  BaseViewController.swift
//  LoveInASnap
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    static var isvaluechaed = false
    static var isselfrecheck = false
    static var is_first_open = false
    static var is_circled = false
    static var is_numara_onerow = false
    static var is_cellchanged = false
    static var is_change_date = false
    static let noDataFont: UIFont! = UIFont(name: "Bebas Neue", size: 23.0)

  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  func getCurrentDayStampWO(dateToConvert: Date) -> String {
    
    let objDateformat: DateFormatter = DateFormatter()
    objDateformat.dateFormat = "dd.MM.yyyy"
    let strTime: String = objDateformat.string(from: dateToConvert as Date)
    
    let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
    
    let otherdate: NSDate = objDateformat.date(from: "01.01.2010")! as NSDate
    
    let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince(otherdate as Date))
    let strTimeStamp: String = "\(milliseconds)"
    return strTimeStamp
  }
  func getCurrentDayStampWOInt(dateToConvert: Date) -> Int64 {
    
    let objDateformat: DateFormatter = DateFormatter()
    objDateformat.dateFormat = "dd.MM.yyyy"
    let strTime: String = objDateformat.string(from: dateToConvert as Date)
    
    let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
    
    let otherdate: NSDate = objDateformat.date(from: "01.01.2010")! as NSDate
    
    let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince(otherdate as Date))
    //let strTimeStamp: String = "\(milliseconds)"
    return milliseconds
  }
  func stringToDate(string: String) -> Date {
    let formatter = DateFormatter.init()
    //        let local = Locale.init(identifier: "en_US")
    //        formatter.locale = local
    formatter.dateFormat = "dd.MM.yyyy"
    formatter.timeZone = TimeZone.init(secondsFromGMT: 6)
    formatter.timeZone = TimeZone.init(identifier: "Taiyuan - China")
    if let date = formatter.date(from: string)
    {
      
      return date
    }
    return Date.init()
    
  }
  func CorrectGoverDate(datestr:String)
  {
    let  ssubstrraray=datestr.components(separatedBy: ".")
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

      if(day>0&&day<31&&month>0&&month<13 && year>2000)
      {
        BaseViewController.isvaluechaed = true
        ViewController.dateComponentsGover.year = year
        ViewController.dateComponentsGover.month = month
        ViewController.dateComponentsGover.day = day
 
      }
      else
      {
        let ac = UIAlertController(title: "Time Format!".localized, message: "Enter with the correct format 'dd.mm.yyyy'.".localized, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK".localized, style: .default))
        present(ac, animated: true)
      }
    }
    else
    {
      let ac = UIAlertController(title: "Time Format!".localized, message: "Enter with the correct format 'dd.mm.yyyy'.".localized, preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK".localized, style: .default))
      present(ac, animated: true)
      
    }
  }
  func componentToStr(components: DateComponents) -> String {
    
    let cal = Calendar.current

    let date = cal.date(from: components)!
    
    let objDateformat: DateFormatter = DateFormatter()
    objDateformat.dateFormat = "dd.MM.yyyy"
    let strTime: String = objDateformat.string(from: date as Date)
    return strTime
  }
  

  
  
  func stringToDateAll(string: String) -> Date {
    let formatter = DateFormatter.init()
    //        let local = Locale.init(identifier: "en_US")
    //        formatter.locale = local
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'zzz'Z'"
    formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
    formatter.timeZone = TimeZone.init(identifier: "Ankara - Turkey")
    if let date = formatter.date(from: string)
    {
      return date
    }
    formatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss 'GMT'Z"
    //formatter.timeZone = TimeZone.init(abbreviation: "UTC")
    if let date = formatter.date(from: string)
    {
      return date
    }
    return Date.init()
    
  }
  func dateToString(date: Date) -> String {
    
    let formatter = DateFormatter.init()
    //        let local = Locale.init(identifier: "en_US")
    //        formatter.locale = local
    formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.000Z'"
    formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
    formatter.timeZone = TimeZone.init(identifier: "Ankara - Turkey")
    
    return formatter.string(from:date)
  }
  func dateToStringForDisplay(date: Date) -> String {
    
    let formatter = DateFormatter.init()
    //        let local = Locale.init(identifier: "en_US")
    //        formatter.locale = local
    formatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss"
    formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
    formatter.timeZone = TimeZone.init(identifier: "Ankara - Turkey")
    return formatter.string(from:date)
  }
  func dateToStringForCouponDir(date: Date) -> String {
    
    let formatter = DateFormatter.init()
    //        let local = Locale.init(identifier: "en_US")
    //        formatter.locale = local
    formatter.dateFormat = "EEE_MMM_dd_yyyy_HH"
    formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
    formatter.timeZone = TimeZone.init(identifier: "Ankara - Turkey")
    return formatter.string(from:date)
  }
  func minitueToStringForCouponName(date: Date) -> String {
    
    let formatter = DateFormatter.init()
    //        let local = Locale.init(identifier: "en_US")
    //        formatter.locale = local
    formatter.dateFormat = "mm"
    formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
    formatter.timeZone = TimeZone.init(identifier: "Ankara - Turkey")
    return formatter.string(from:date)
  }
  func getCurrentTimeStampWOMiliseconds(dateToConvert: Date) -> String {
    let objDateformat: DateFormatter = DateFormatter()
    objDateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let strTime: String = objDateformat.string(from: dateToConvert as Date)
    let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
    let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
    let strTimeStamp: String = "\(milliseconds)"
    return strTimeStamp
  }
func removeWhiteSpaceInString(original: String) ->String{
  if (original.isEmpty ){
    return original
  }
  var resultStr = ""
  let array = original.components(separatedBy: CharacterSet.whitespacesAndNewlines)
  for item in array
  {
    if item.isEmpty
    {continue}
    resultStr += item
  }
  return resultStr;
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
