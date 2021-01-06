        
//  CVWrapper.m
//  CVOpenTemplate
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

#import "CVWrapper.h"
#import "UIImage+OpenCV.h"
#import "stitching.h"
#import "UIImage+Rotate.h"


#import "ocr_a_page.h" 


@implementation CVWrapper

+ (NSString*) saveImage:(UIImage*)inputImage:(NSString*)fileName
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:fileName ];
  UIImage *image = inputImage; // imageView is my image from camera
  NSData *imageData = UIImagePNGRepresentation(image);
  [imageData writeToFile:savedImagePath atomically:NO];
  return @"no";
}

+ (UIImage*) DrawResult:(UIImage*)inputImage:(CGRect)m_rects
{
  
  
  cv::Mat matImage = [inputImage CVMat3];
  int x=m_rects.origin.x;
  int y=m_rects.origin.y;
  int w=m_rects.size.width;
  int h=m_rects.size.height;
 
  cv::Rect rt=cv::Rect(x,y,w,h);
  DrawResult(rt,matImage);
  UIImage* result =  [UIImage imageWithCVMat:matImage];
  return result;
  
  
}
+ (UIImage*) mergeImage:(UIImage*)firstImage:(UIImage*)secondImage
{
    cv::Mat matImagefirst = [firstImage CVMat3];
    cv::Mat matImagesecond = [secondImage CVMat3];
    cv::Mat matImage = combinetwoimg (matImagefirst, matImagesecond);
    UIImage* result =  [UIImage imageWithCVMat:matImage];
    return result;
}
+ (UIImage*) GetTesseractString:(UIImage*)inputImage
{
  G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];

 //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CVProgressNotification"), object: nil);

  cv::Mat matImage = [inputImage CVMat3];
  //cv::Mat matImage=RemoveBackground(matImage_u);
//  [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
//                                                      object:inputImage];
  std::vector<Rows> m_LotoRows=GetRowsfromMat(matImage);
  //m_LotoRowOther=m_LotoRows;
  if(m_LotoRows.size()<2)
  {
    

    NSString *itemstr= @"please retake your picture.";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                        object:itemstr];
    UIImage* result =  [UIImage imageWithCVMat:matImage];
    return result;
  }
    

 
  LotoType m_type=Unknown;
  
  //////take other info of the loto as data
  Rows bottominfoitem=m_LotoRows.back();
  Rows headinfoitem=m_LotoRows[m_LotoRows.size()-2];
  ////head info
  NSString *itemstr1=  @"The head information";
  NSLog(@"%@", itemstr1);
  for (int infoindex=0;infoindex< headinfoitem.row_coupons.size(); infoindex++)
  {
    Coupon m_info=headinfoitem.row_coupons[infoindex];
    UIImage* infoimage =  [UIImage imageWithCVMat:m_info.plateImg];
    if (m_info.m_type==HeadInfo)
    {
      NSString* recognizedText=@"";
      tesseract.pageSegmentationMode=G8PageSegmentationModeSingleLine;
      tesseract.charWhitelist=@"0123456789sdqwertyuıoplkjhgfdsazxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM.:/, ";
      if (m_info.plateImg.size().width*2<m_info.plateImg.size().height) {
        
        UIImage *rotatedImage = [UIImage imageWithCGImage:infoimage.CGImage
                                                    scale:infoimage.scale
                                              orientation:UIImageOrientationRight];
        
        
        NSAssert(infoimage.imageOrientation != rotatedImage.imageOrientation, @"Error! Image has not been rotated");
        tesseract.image=rotatedImage.g8_blackAndWhite;
        [tesseract recognize] ;
        recognizedText= tesseract.recognizedText;

      }
      else
      {
        tesseract.image=infoimage.g8_blackAndWhite;
        [tesseract recognize] ;
        recognizedText= tesseract.recognizedText;
      }
      recognizedText=[self removeWhiteSpaceInString:recognizedText];
      NSLog(@"%@", recognizedText);
      if ([recognizedText containsString:@"6/49"])
      {
        m_type=Sayisal;
        
      }
      else if ([recognizedText containsString:@"NUMARA"])
      {
        m_type=Numara;
        
      }
      else if ([recognizedText containsString:@"/49"])
      {
        m_type=Sayisal;
        
      }
      else if ([recognizedText containsString:@"6/4"])
      {
        m_type=Sayisal;
        
      }
      else if ([recognizedText containsString:@"say"])
      {
        m_type=Sayisal;
        
      }
      else if ([recognizedText containsString:@"6/54"]) {
        m_type=Super;
      }
      else if ([recognizedText containsString:@"/54"]) {
        m_type=Super;
      }
      else if ([recognizedText containsString:@"6/5"]) {
        m_type=Super;
      }
      else if ([recognizedText containsString:@"Pu"]) {
        m_type=Sans;
      }
      else if ([recognizedText containsString:@"San"]) {
        m_type=Sans;
      }
      
    }
    

  }
  ////head info end
  ////////bottom info
  int geoverdate_number = 0;
  for (int infoindex=0;infoindex< bottominfoitem.row_coupons.size(); infoindex++)
  {
    Coupon m_info=bottominfoitem.row_coupons[infoindex];
    
      UIImage* infoimage =  [UIImage imageWithCVMat:m_info.plateImg];

      tesseract.pageSegmentationMode=G8PageSegmentationModeSingleLine;

      tesseract.image=infoimage.g8_blackAndWhite;
    

      if (m_info.m_type==GovermentTakeDate)
      {
        geoverdate_number++;

        tesseract.charWhitelist=@"0123456789.-";
        [tesseract recognize] ;
       
        NSString* recognizedText= tesseract.recognizedText;
        //recognizedText =@"013 1851-01 09.2018";
        NSLog(@"the original goverdate:%@",recognizedText);
        
        if ([recognizedText containsString:@"-" ])
        {
          NSArray *strarray = [recognizedText componentsSeparatedByString:@"-"];
          for(int strindex=0;strindex<strarray.count;strindex++)
          {
            NSString * comp = strarray[strindex];
            
            int  compstrlength =(int) [[self removeWhiteSpaceInString:comp] length];
            
            if ([comp containsString:@"." ]&&strindex != 0) {
              NSArray *mainarray = [comp componentsSeparatedByString:@"."];
              if (mainarray.count == 3) {
//                if(![mainarray[0] isEmpty]&&![mainarray[1] isEmpty]&&![mainarray[2] isEmpty])
//                {
//                    recognizedText = comp;
//                }
                 recognizedText = comp;
                 //break;
              }
              else if(mainarray.count>=2&&compstrlength>9 )
              {
                recognizedText = comp;
              }
            }
            else if((compstrlength == 7||compstrlength == 8||compstrlength == 9)&&strindex != 0)
            {
              recognizedText = comp;
            }
          }
          
        }
        else if ([recognizedText containsString:@"\n" ])
        {
          NSArray *strarray = [recognizedText componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
          for(int strindex=0;strindex<strarray.count;strindex++)
          {
            NSString * comp = strarray[strindex];
            if ([comp containsString:@"." ]) {
              NSArray *mainarray = [comp componentsSeparatedByString:@"."];
              if (mainarray.count == 3) {
//                if(![mainarray[0] isEmpty]&&![mainarray[1] isEmpty]&&![mainarray[2] isEmpty])
//                {
//                  recognizedText = comp;
//                }
                 recognizedText = comp;
                 //break;
              }
            }
          }
          
        }
        // NSString *itemstr1=  @"GoverDate-";
        NSString *itemstr1=  [NSString stringWithFormat:@"GoverDate%i-",geoverdate_number];
        
        NSString* correctstr=[self proccessDateString:recognizedText];
        //itemstr1 = [itemstr1 stringByAppendingString:correctstr];
        NSLog(@"the total goverdate:%@",correctstr);
        NSString *applegover=  @"AppleGover-";
        applegover = [applegover stringByAppendingString:correctstr];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                            object:applegover];
        
        Rows one = GetIndiNumberRegions(m_info,matImage);
        
        //tesseract.pageSegmentationMode=G8PageSegmentationModeSingleLine;
        tesseract.charWhitelist=@"0123456789";
        NSString *indiNumberstr=  @"";
        for(int indiindex=0;indiindex<one.row_coupons.size();indiindex++)
        {
          
            
          Coupon  indinumber = one.row_coupons[indiindex];
          float ratio =(float) indinumber.position.height/float(indinumber.position.width);
          if(ratio>3)
          {
                NSLog(@"GoverDate individual rects rec: 1 from ratio");
                indiNumberstr = [indiNumberstr stringByAppendingString:@"1"];
          }
          else
          {
            UIImage* indiimage =  [UIImage imageWithCVMat:indinumber.plateImg];
            tesseract.image=indiimage.g8_blackAndWhite;
            [tesseract recognize] ;
            NSString* rec= tesseract.recognizedText;
            rec=[self removeWhiteSpaceInString:rec];
            NSLog(@"GoverDate individual rects rec:%@",rec);
            
            if(indinumber.position.width<12&&ratio<2&&indinumber.firstLcdChar != 'X')
            {
              NSLog(@"GoverDate  individual rects rec lcd :%c",indinumber.firstLcdChar);
              NSString *temp=[NSString stringWithFormat: @"%c",indinumber.firstLcdChar];
              
              int lcd_int =[temp intValue];
              int o_int = [rec intValue];
              NSString*coindi=[self DateWithLcd:o_int :lcd_int];
              indiNumberstr = [indiNumberstr stringByAppendingString:coindi];

            }
            else
            {
              if([rec length] == 0)
              {
               indiNumberstr = [indiNumberstr stringByAppendingString:@"0"];
              }else
              {
               indiNumberstr = [indiNumberstr stringByAppendingString:rec];
              }
              

            }
          }
        }
        
        
        NSString*correctDateStr=[self CorrectDateString:correctstr :indiNumberstr];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
//                                                            object:indiNumberstr];
        
        itemstr1 = [itemstr1 stringByAppendingString:correctDateStr];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                            object:itemstr1];

        NSLog(@"%@", itemstr1);
        
  
      }
      if (m_info.m_type==PlayTimeDate)
      {
        tesseract.charWhitelist=@"0123456789.";
        [tesseract recognize] ;
        NSString* recognizedText= tesseract.recognizedText;
         NSLog(@"the original playdate:%@",recognizedText);
        NSString* correctstr=[self proccessDateString:recognizedText];
        NSString *itemstr1=  @"PlayDate-";
        NSLog(@"the total playdate:%@",correctstr);
        NSString *applegover=  @"ApplePlay-";
        applegover = [applegover stringByAppendingString:correctstr];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                            object:applegover];

        Rows one = GetIndiNumberRegions(m_info,matImage);
        tesseract.charWhitelist=@"0123456789";
        NSString *indiNumberstr=  @"";
        for(int indiindex=0;indiindex<one.row_coupons.size();indiindex++)
        {
          Coupon  indinumber = one.row_coupons[indiindex];
          float ratio =(float) indinumber.position.height/float(indinumber.position.width);
          if(ratio>3)
          {
            NSLog(@"PlayDate  individual rects rec: 1 from ratio");
            indiNumberstr = [indiNumberstr stringByAppendingString:@"1"];
          }
          else
          {
            UIImage* indiimage =  [UIImage imageWithCVMat:indinumber.plateImg];
            tesseract.image=indiimage.g8_blackAndWhite;
            [tesseract recognize] ;
            NSString* rec= tesseract.recognizedText;
            rec=[self removeWhiteSpaceInString:rec];
           
            NSLog(@"PlayDate  individual rects rec:%@",rec);
            
            if(indinumber.position.width<12&&ratio<2&&indinumber.firstLcdChar != 'X')
            {
                 NSLog(@"PlayDate  individual rects rec lcd :%c",indinumber.firstLcdChar);
                 NSString *temp=[NSString stringWithFormat: @"%c",indinumber.firstLcdChar];
                 int lcd_int =[temp intValue];
                 int o_int = [rec intValue];
                 NSString*coindi=[self DateWithLcd:o_int :lcd_int];
                 indiNumberstr = [indiNumberstr stringByAppendingString:coindi];
            }
            else
            {
               indiNumberstr = [indiNumberstr stringByAppendingString:rec];
            }
          }
        }

        
        NSString*correctDateStr=[self CorrectDateString:correctstr :indiNumberstr];
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
//                                                            object:indiNumberstr];

        itemstr1 = [itemstr1 stringByAppendingString:correctDateStr];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                            object:itemstr1];

        NSLog(@"%@", itemstr1);

      }
      if (m_info.m_type==PlayTime)
      {
        tesseract.charWhitelist=@"0123456789:";
        [tesseract recognize] ;
        NSString* recognizedText= tesseract.recognizedText;
        NSString *itemstr1=  @"PlayTime-";
        NSLog(@"PlayTime original-%@", recognizedText);
        
        NSString* correctstr=[self proccessTimeString:recognizedText];
        itemstr1 = [itemstr1 stringByAppendingString:correctstr];


        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                            object:itemstr1];
        NSLog(@"%@", itemstr1);


    }
    if (m_info.m_type==DrawTimes)
    {
      tesseract.charWhitelist=@"0123456789";
      [tesseract recognize] ;
      NSString* recognizedText= tesseract.recognizedText;
      NSString *itemstr1=  @"DrawTimes-";
      NSString *tarvalu=  @"";
      NSLog(@"DrawTimes original-%@", recognizedText);
      NSArray * drawitems   = [recognizedText componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
      
      NSString*lastitem =[drawitems lastObject];

      if ([lastitem hasPrefix:@"0"]) {
        lastitem = [self removeWhiteSpaceInString:lastitem];
        if ([lastitem length] == 2) {
          tarvalu = lastitem;
        }
      }
      
    
      itemstr1 = [itemstr1 stringByAppendingString:tarvalu];
      
      
      
      [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                          object:itemstr1];
      NSLog(@"%@", itemstr1);
      
    }
  }
  
  ///////end take other info of the loto as data
  
  BOOL prehasplusSymbol= false;

  if (m_LotoRows.size()<=2) {
    NSString *itemstr= @"please retake your picture.";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                        object:itemstr];
    UIImage* result =  [UIImage imageWithCVMat:matImage];
    return result;

  }
  
  for (int index=0; index<m_LotoRows.size()-2; index++)
  {
    
    Rows one=m_LotoRows[index];


    int coupons_in_row_number=(int)one.row_coupons.size();
    if (coupons_in_row_number==10) {
      m_type=Numara;
    }
    NSLog(@"#################the one row has the %i coupons.",coupons_in_row_number);
//    if (coupons_in_row_number==7) {
//      m_type=Sans;
//    }

    NSString *itemstr=@"";

    
    NSString* one_total_coupon_str=@"";
    for (int i=0; i<one.row_coupons.size(); i++)
    {
      
      Coupon couponitem=one.row_coupons[i];
      UIImage* couponimage =  [UIImage imageWithCVMat:couponitem.plateImg];
     

      NSString *itemrectstr=[NSString stringWithFormat: @"%lu:%lu:%lu:%lu-",(unsigned long)couponitem.position.x,(unsigned long)couponitem.position.y,(unsigned long)couponitem.position.width,(unsigned long)couponitem.position.height];

    
      one_total_coupon_str = [one_total_coupon_str stringByAppendingString: itemrectstr];
      
      
      
      tesseract.pageSegmentationMode=G8PageSegmentationModeSingleLine;
      tesseract.charWhitelist=@"0123456789+";
      tesseract.image=couponimage.g8_blackAndWhite;

      
      [tesseract recognize] ;
      NSString* recognizedText= tesseract.recognizedText;
      bool is_str_empty = false;
      if (recognizedText.length == 0) {
        is_str_empty = true;
      }
      bool is_three_number = false;
      string number_str=recognizedText.UTF8String;
      string interresult=GetOnlyNumbers(number_str);
      NSString *number_nsstring=[[NSString alloc] initWithUTF8String:interresult.c_str() ];
     
      if ([number_nsstring length] >= 3) {
        is_three_number = true;
      }


      NSLog(@"%i%i:sub recognize str:%s",index,i,recognizedText.UTF8String);

      
      BOOL hasplusSymbol= [recognizedText containsString:@"+"];
      
      if (hasplusSymbol||(prehasplusSymbol&&i==5)) {
        if (m_type==Unknown) {
                  m_type=Sans;
        }
        m_type=Sans;
        one_total_coupon_str = [one_total_coupon_str stringByAppendingString: @"+"];//@"+"
      }
      else
      {

        int coupon_int=[number_nsstring intValue];
        if (is_three_number) {
          coupon_int = 900;
        }
        int number_one=10;
        int number_two=10;
        
        if (coupon_int>=900)
        {
          NSString *itemstr= number_nsstring;

          {
            BOOL is_three=[itemstr containsString:@"15"];
            if (is_three)
            {
              NSString *newGreeting = [itemstr stringByReplacingOccurrencesOfString:@"15"
                                                                         withString:@"6"];
              coupon_int=[newGreeting intValue];
              NSString *itemstr1= [NSString stringWithFormat: @"%i", coupon_int];
              
              //one_total_coupon_str = [one_total_coupon_str stringByAppendingString:itemstr1];
            }
            
          }
          NSLog(@"three number correct:%i",coupon_int);
        }
        
        {
          if (i==5&&coupon_int==0)
          {
            //itemstr=@"+";
            itemstr=@"+";
          }
          if(number_nsstring.length==1)
          {
            coupon_int=999;
          }
          if
            (coupon_int < 90 && coupon_int>80 && m_type==Numara) {
            
              int onenum=coupon_int-(int)(coupon_int/10)*10;
              coupon_int=60+onenum;

          }
          
         int dec_one=coupon_int-(int)(coupon_int/10)*10;
          if (m_type==Sans&&dec_one>4&&i==6) {
            coupon_int = dec_one;
          }
      if (coupon_int==51||dec_one==8||dec_one==5||coupon_int==80||coupon_int==56||coupon_int==53||coupon_int==52||coupon_int==50||coupon_int==26||coupon_int==36||coupon_int==16|| coupon_int==6||coupon_int==57||coupon_int==66 ||coupon_int==61 ||is_str_empty|| coupon_int==23||coupon_int >= 90||coupon_int==0||coupon_int==53||coupon_int==63||coupon_int==33||coupon_int==60||(m_type==Sans&&coupon_int==14)||(m_type==Sans&&coupon_int>34)||(m_type==Sayisal&&coupon_int>49)||(m_type==Super&&coupon_int>54))

            {
              if (coupon_int>=100)
              {

                coupon_int = 0;
  
              }
              
              tesseract.pageSegmentationMode=G8PageSegmentationModeSingleLine;
              tesseract.charWhitelist=@"0123456789+";
              UIImage* newcouponimage =  [UIImage imageWithCVMat:couponitem.oriImg];
              tesseract.image=newcouponimage.g8_blackAndWhite;
              
              
              [tesseract recognize] ;
              NSString* otherecognizedText= tesseract.recognizedText;
              NSLog(@"the original mat from tesseract %@",otherecognizedText);
              int ori_number=[otherecognizedText intValue];
              
              tesseract.pageSegmentationMode=G8PageSegmentationModeSingleChar;
              tesseract.charWhitelist=@"0123456789";
              bool firstratio=false;
              bool secondratio=false;
              
              couponitem=GetSubCharInfo(couponitem,matImage,coupon_int);
              float second_top_right=couponitem.second_top_right;
              
              if (couponitem.firstCharMat.empty())
              {
                NSLog(@"the first ratio is 1");
                firstratio=true;
                number_one=1;
              }
              else
              {
                //if (!couponitem.firstCharMat.empty())
                {
                  UIImage* couponfirstCharImage =  [UIImage imageWithCVMat:couponitem.firstCharMat];
                  tesseract.image=couponfirstCharImage.g8_blackAndWhite;
                  [tesseract recognize];
                  NSString*onechar=tesseract.recognizedText;
                  number_one=[onechar intValue];
                  NSLog(@"first char mat recognize:%s",onechar.UTF8String);
                  NSLog(@"first char LCD recognize:%c",couponitem.firstLcdChar);
                  
                }
                
              }
              if (couponitem.secondCharMat.empty()) {
                number_two=1;
                secondratio=true;
                NSLog(@"the second ratio is 1");
                //substr = [substr stringByAppendingString: @"1"];
              }
              else
              {
                //if (!couponitem.secondCharMat.empty())
                {
                  UIImage* couponsecondCharImage =  [UIImage imageWithCVMat:couponitem.secondCharMat];
                  tesseract.image=couponsecondCharImage;
                  [tesseract recognize];
                  NSString*onechar=tesseract.recognizedText;
                  number_two=[onechar intValue];
                  //substr = [substr stringByAppendingString: onechar];
                  NSLog(@"second char mat recognize:%s",onechar.UTF8String);
                  NSLog(@"second char LCD recognize:%c",couponitem.secondLcdChar);
                  
                }
                
              }

   
              int coupon_int_other=number_one*10+number_two;
              NSLog(@"new recognization  result :%i",coupon_int_other);

              if(coupon_int!=coupon_int_other&&coupon_int!=0)
              {
                NSString *correctStr=@"";
                if (m_type==Sans&&i==6) {
                     correctStr=[self GetCorrectCouponString:coupon_int :number_one:number_two:couponitem.firstLcdChar:couponitem.secondLcdChar:firstratio:secondratio:ori_number:9];
                }
                else
                {
                     correctStr=[self GetCorrectCouponString:coupon_int :number_one:number_two:couponitem.firstLcdChar:couponitem.secondLcdChar:firstratio:secondratio:ori_number:m_type];
                }

  
                if(number_nsstring.length==1)
                {
                  int temp_int=[correctStr intValue];
                  if (temp_int==31) {
                    correctStr=@"34";
                  }
                }
                
                   one_total_coupon_str = [one_total_coupon_str stringByAppendingString:correctStr];
                
                
                
              }
              else
              {
                if(m_type==Unknown)
                {
                  if(coupon_int>=50&&coupon_int_other>=50)
                  {
                    m_type = Super;
                  }
                }
                NSString*itemstr_newsame =@"";
                if (m_type==Sans&&i==6) {
                  itemstr_newsame = [self GetCorrectSameString:coupon_int:number_one:number_two:couponitem.firstLcdChar:couponitem.secondLcdChar:firstratio:secondratio:ori_number:couponitem.second_top_right:9];
                }
                else
                {
                  itemstr_newsame = [self GetCorrectSameString:coupon_int:number_one:number_two:couponitem.firstLcdChar:couponitem.secondLcdChar:firstratio:secondratio:ori_number:couponitem.second_top_right:m_type];
                }

                 one_total_coupon_str = [one_total_coupon_str stringByAppendingString:itemstr_newsame];

                
              }
            }
           else
           {
               NSString *itemstr= [NSString stringWithFormat: @"%i", coupon_int];
             
                             one_total_coupon_str = [one_total_coupon_str stringByAppendingString:itemstr];

             
           }
            
          
        }
      }
      
      if(hasplusSymbol)
      {
        prehasplusSymbol=hasplusSymbol;
      }
      
      
      one_total_coupon_str = [one_total_coupon_str stringByAppendingString:@"$"];
    }

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                            object:one_total_coupon_str];

  }
  //////take other info of the loto as data
//  if(m_type==Unknown)
//  {
//      m_type = Sayisal;
//  }
  NSString *typestr=@"";
  //typestr= @"{type"":""}";
  typestr=[NSString stringWithFormat:  @"type:%i", m_type];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                      object:typestr];

  ///////end take other info of the loto as data
  UIImage* result =  [UIImage imageWithCVMat:matImage];
 
  return result;

}
+ (UIImage*) GetDebugImage:(UIImage*)image
{
  cv::Mat bugamat= [image CVMat3];
  
  if (bugamat.empty()) {
    UIImage* result =  [UIImage imageWithCVMat:bugamat];
    return result;
  }
  return image;

}
+ (NSString*) GetTwoString:(NSUInteger)m_couponnum
{
  NSString *str=@"";
  if (m_couponnum>9) {
    str= [NSString stringWithFormat: @"%2lu\t", (unsigned long)m_couponnum];
  }
  else
  {
    str= [NSString stringWithFormat: @"0%lu\t", (unsigned long)m_couponnum];
  }
  return str;
}
+ (NSString*) proccessTimeString:(NSString*)m_timestr
{
  NSString*str=@"";
  string timestr=m_timestr.UTF8String;
  string interresult=GetOnlyNumbers(timestr);
  NSString *itemstr=[[NSString alloc] initWithUTF8String:interresult.c_str() ];
  if ([itemstr length]!=4)
  {
    if ([itemstr containsString:@"11"])
    {
      itemstr= [itemstr stringByReplacingOccurrencesOfString:@"11"
                                                                 withString:@"1"];
    }
  }
  if ([itemstr length]==4) {
    NSString* hourstr=[itemstr substringToIndex:2];
    NSString* minstr=[itemstr substringFromIndex:2];
   
    int hour_int=[hourstr intValue];
    int min_int=[minstr intValue];
    if (hour_int==15&&min_int==40) {
      hourstr=[NSString stringWithFormat: @"%2lu", 16];
    }
    str=[str stringByAppendingString:hourstr];
    str=[str stringByAppendingString:@"."];
    str=[str stringByAppendingString:minstr];
    return str;
  }
  if ([itemstr length]==5) {
    NSString* hourstr=[itemstr substringToIndex:2];
    NSString* minstr=[itemstr substringFromIndex:3];
    str=[str stringByAppendingString:hourstr];
    str=[str stringByAppendingString:@"."];
    str=[str stringByAppendingString:minstr];
    return str;
  }
  NSDate *currentTime = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"hh.mm"];
  NSString *resultString = [dateFormatter stringFromDate: currentTime];
  return resultString;
//  string trimstr=CustomTrims(timestr);
//  return [[NSString alloc] initWithUTF8String:trimstr.c_str() ];

 }
+ (NSString*) GetCorrectSameString:(NSUInteger)total_coupon_int:(NSUInteger)dec2:(NSUInteger)one2:(char)firstchar:(char)secondchar:(bool)firstratio:(bool)secondratio:(NSUInteger)orinum:(NSUInteger)lcd_top_right:(NSUInteger)type
{
  NSUInteger tardec = 0;
  NSUInteger tarone = 0;
  NSUInteger ori_dec=0;
  NSUInteger ori_one=0;
  if(orinum>=100)
  {
    int ori_hun =(int) orinum/100;
    ori_dec = (orinum-ori_hun*100)/10;
    ori_one=orinum-ori_hun*100-ori_dec*10;
  }
  else
  {
    ori_dec=orinum/10;
    ori_one=orinum-ori_dec*10;
  }
  
  int lcddec=44;
  int lcdone=44;
  if (firstchar!='X') {
    NSString*getnumber=[NSString stringWithFormat:@"%c" ,firstchar];
    lcddec =[getnumber intValue];
  }
  if (secondchar!='X') {
    NSString*getnumber=[NSString stringWithFormat:@"%c" ,secondchar];
    lcdone =[getnumber intValue];
  }
  
  if(one2==5 && secondchar=='6')//&&couponitem.firstLcdChar=='5'//&&dec2!=0
  {
    tarone=6;
  }
  else if(one2==8 && secondchar=='9'&&ori_one==8)
  {
    tarone=8;
  }
  else if(one2==8 && secondchar=='9')
  {
    tarone=9;
  }

  else if(one2==8 && secondchar=='6')
  {
    if(ori_one==8)
    {
      if (lcd_top_right>1) {
        tarone=8;
      }else
      {
        tarone=6;
      }
      
    }else
    {
      tarone=6;
    }
    
  }

  else if(one2==8 && secondchar=='5')
  {
    tarone=6;
  }
  else if(one2==3 && secondchar=='8'&& firstchar=='5')
  {
    tarone=3;
  }
  else if(one2==3 && secondchar=='8')
  {
    tarone=8;
  }
//  else if(one2==3 && secondchar=='9')
//  {
//    tarone=9;
//  }
  else if(one2==5 && secondchar=='8'&&dec2!=0)
  {
    tarone=8;
  }
  //                else if(number_two==8 && couponitem.secondLcdChar=='9')
  //                {
  //                  number_two=9;
  //                }
  else if(one2==3 && secondchar=='6')
  {
    tarone=8;
  }
  else if(one2==6 && secondchar=='8'&&dec2!=3&&firstchar!='3')
  {
    tarone=8;
  }
  
  else if(one2==8 && ori_one==6&&lcdone==44)
  {
    if (lcd_top_right>=1) {
      tarone=8;
    }
    else
    {
       tarone=6;
    }
 
    
  }
  else if(one2==5 && ori_one==6)
  {

      tarone=6;

  }
  else
  {
    tarone=one2;
  }
  
  
  if(dec2==5 && firstchar=='6')
  {
    tardec=6;
    
  }
  else if(dec2==8 && firstchar=='6')
  {
    tardec=6;
    
  }
  else if(dec2==8 && tarone > 0)
  {
    if (lcddec>=8) {
      tardec=0;
    }
    else
    {
      tardec=lcddec;
    }
  }
  else if(ori_dec==lcddec )
  {
    tardec=lcddec;
    
  }

  else
  {
    tardec=dec2;
  }
  
  if (total_coupon_int==0&&orinum>99) {
    if(lcdone!=44)
    {
      if (lcdone==1) {
        if (one2==4||one2==7||one2==ori_one) {
          tarone = one2;
        }
        else
        {
          if (one2==1) {
            tarone = one2;
          }
          else
          {
            tarone = one2;
          }
          
        }
      }else
      {
        tarone=lcdone;
      }
    }
    if (lcddec!=44) {
      if (lcddec==1) {
        if (dec2==4||dec2==7||dec2==ori_dec) {
          tardec = dec2;
        }
        else
        {
          if (dec2==1) {
             tardec = dec2;
          }
          else
          {
            tardec = dec2;
          }

        }
      }else
      {
        tardec=lcddec;
      }
      

    }

    
  }
  NSUInteger tarval=tardec*10+tarone;
 
  if (type==1&&tarval>49) {
    if(dec2==0||lcddec==0||ori_dec==0)
    {
      tardec=0;
    }
    
  }
  else if(type==2&&tarval>54)
  {
    if(dec2==0||lcddec==0||ori_dec==0)
    {
      tardec=0;
    }
  }
  else if(type==3&&tarval>80)
  {
    if(dec2==0||lcddec==0||ori_dec==0)
    {
      tardec=0;
    }
  }
  else if(type==4&&tarval>34)
  {
    if(dec2==0||lcddec==0||ori_dec==0)
    {
      tardec=0;
    }
  }
  else if(type==9&&tarval>14)
  {
    
    tardec=0;
    
  }

  
  tarval=tardec*10+tarone;
  NSString*getstr= [NSString stringWithFormat: @"%lu", (unsigned long)tarval];
  NSLog(@"same from case correct %@", getstr);
  
  return getstr;
}
+ (NSString*) GetCorrectCouponString:(NSUInteger)number1:(NSUInteger)dec2:(NSUInteger)one2:(char)firstchar:(char)secondchar:(bool)firstratio:(bool)secondratio:(NSUInteger)orinum:(NSUInteger)type
{
  
  NSUInteger dec1=number1/10;
  NSUInteger one1=number1-dec1*10;
  NSUInteger ori_dec=0;
  NSUInteger ori_one=0;
  if(orinum>=100)
  {
    int ori_hun = orinum/100;
    ori_dec = (orinum-ori_hun*100)/10;
    ori_one=orinum-ori_hun*100-ori_dec*10;
  }
  else
  {
  ori_dec=orinum/10;
  ori_one=orinum-ori_dec*10;
  }
    

  NSUInteger tardec = 0;
  NSUInteger tarone = 0;
  int lcddec=44;
  int lcdone=44;
  if (firstchar!='X') {
      NSString*getnumber=[NSString stringWithFormat:@"%c" ,firstchar];
      lcddec =[getnumber intValue];
  }
  if (secondchar!='X') {
    NSString*getnumber=[NSString stringWithFormat:@"%c" ,secondchar];
    lcdone =[getnumber intValue];
  }
 
  

  
  if (one1!=one2) {
    

    if (((one1==5 && one2==8)||(one1==8 && one2==5))&&lcdone!=8&&lcdone!=44) {
      tarone =6;
    }
    if (one1==8 && one2==5 &&lcdone==44) {
      tarone =8;
    }
    else if(one1==8&&one2==5&&lcdone==6)
    {
      tarone=6;
    }
    else if(one1==3&&one2==5&&lcdone==44)
    {
      tarone=9;
    }
    else if(one1==5&&one2==6&&lcdone==6)
    {
      tarone=6;
    }
    else if(one1==5&&one2==6&&ori_dec==1&&lcdone==44&&dec1==1&&dec2==1)
    {
      tarone=6;
    }
    else if(one1==5&&one2==6&&ori_one==5)
    {
      tarone=5;
    }
    else if(one1==6&&one2==5&&lcdone==5&&ori_one==5)
    {
      tarone=5;
    }
    else if((one1==5&&one2==6)||(one1==6&&one2==5))
    {
      tarone=6;
    }
    else if(one1!=1&&secondratio)
    {
      tarone=one1;
    }
    else if((one1==8&&one2==5&&lcdone==6))
    {
      tarone=8;
    }
    else if((one1==6&&one2==8&&lcdone==5))
    {
      tarone=6;
    }
    else if((one1==8&&one2==5&&lcdone==9))
    {
      tarone=8;
    }

    else if(one1==8&&one2==0&&lcdone!=44&&lcdone!=0)
    {
      tarone=lcdone;
    }
    else if( one1==8 && one2==3 &&lcdone==6&&ori_one==6)
    {
      tarone=6;
    }
    else if( one1==8 && one2==6 &&lcdone==3 &&ori_one==6)
    {
      tarone=6;
    }
    else if(one1==8 && one2==3 && lcdone==6)
    {
      tarone=8;
    }
    else if(one1==3 && one2==8 && lcdone==8&&dec1==0&&dec2==0)
    {
      tarone=8;
    }
    else if(one1==3 &&one2==5&&lcdone==8)
    {
      tarone=6;
    }
    else if(one2==0&&lcdone==0&&dec2==0&&one1!=0)
    {
      tarone=one1;
    }
    else if(one1==7&&secondratio)
    {
      tarone=7;
    }
    else if(one1==4&&secondratio)
    {
      tarone=4;
    }
    else if(one2==lcdone)
    {
      if (tardec==0) {
        if (one2==0) {
          tarone=one1;
        }
        else
        {
          tarone=one2;
        }
      }
      else
      {
         tarone=one2;
      }
     
    }
    else if(one1==lcdone&&number1!=0)
    {
      if (tardec==0) {
        if (one1==0) {
          tarone=one2;
        }
        else
        {
          tarone=one1;
        }
      }
      else
      {
        tarone=one1;
      }      
    }
    else if(number1==0 && one2==9 && lcdone==0)
    {
      tarone=9;
    }
    else if(number1==0 && one2==5 && lcdone==6)
    {
      tarone=6;
    }
    else if(number1==0 && one2==8 && lcdone==6)
    {
      tarone=lcdone;
    }
    else if(one1!=0&&one2==0)
    {
       tarone=one1;
    }
    else if(one2==5&&one1==0&&lcdone==44)
    {
      tarone=0;
    }
    else if(one2==8&&one1==0&&ori_one==0)
    {
      tarone=0;
    }


    else if( one1==3 && one2==9 &&lcdone==5)
    {
      tarone=9;
    }
    else if( one1==8 && one2==6 &&lcdone==5&&ori_one==6)
    {
      tarone=6;
    }
    else if(one2==6&&(one1!=5&&one1!=8&&one1!=9)&&lcdone!=6)
    {
      tarone=one1;
    }

    else if(one1==9&&one2==8)
    {
      tarone=9;
    }
    else if(one1==9&&one2==5)
    {
      tarone=9;
    }
    else if(dec1==0 && one1==1 && one2==2 &&lcdone==44)
    {
      tarone=2;
    }
    else if( one1==1 && one2==7 &&lcdone==44)
    {
      tarone=one2;
    }

    else if(one1!=0&&one2!=0&&lcdone!=44&&lcdone!=0&&lcdone!=7)
    {
      tarone=lcdone;
    }

    else
    {
       tarone=one1;
    }
  }
  else
  {
    
    if (one1==5&&lcdone==6) {
      tarone=6;
    }
    else if (one1==8&&lcdone==6) {
      tarone=6;
    }
    else if (one1==8&&lcdone==9) {
      tarone=9;
    }
    else if(one1==1&&one2==1&&lcdone!=1&&lcdone!=44)
    {
      tarone=lcdone;
    }
    else if(one1==3&&one2==3&&lcdone==8)
    {
      tarone=lcdone;
    }
    else
    {
      tarone=one1;
    }
  }
  
  if (dec1!=dec2) {
    if ((dec1==5 && dec2==8)||(dec1==8 && dec2==5)) {
      tardec =6;
    }
    else if((dec1==6 && dec2==8)||(dec1==8 && dec2==6))
    {
      tardec=6;
    }
    else if((dec1==5 && dec2==6)||(dec1==6&& dec2==5))
    {
      tardec=6;
    }
    else if(dec1==7 && (lcddec==1||lcddec==44))
    {
      tardec=7;
    }
    else if(dec1==1 && dec2==7)
    {
      tardec=7;
    }
    else if((dec1==8 && dec2==3&&one1==0&&one2==0))
    {
      tardec=6;
    }
    else if(dec1==0&&one1==0&&dec2!=0)
    {
      if (dec2==lcddec) {
        tardec=dec2;
      }
      else if (lcddec==44) {
        tardec=dec2;
      }
      
    }
    else if(dec1==0&&(dec2==3||dec2==1)&&one1!=0)
    {
      tardec=0;
    }
    else if(dec1==6&&dec2==3&&lcddec==3)
    {
      tardec=6;
    }
    else if(dec2==lcddec&&dec2!=1)
    {
      tardec=dec2;
    }
    else if(dec1==1 &&dec2==0&&lcdone == 44 )
    {
      tardec=1;
    }
    else if(dec1!=0&&dec2==0)
    {
      if(lcddec==44)
      {
        if (dec1==1) {
          tardec=0;
        }
      }else
      {
        tardec=dec1;
      }
    }
    //    else if(dec1==0&&dec2!=0)
    //    {
    //      tardec=dec2;
    //    }
    else if(dec1==0&&one1==1&&dec2==2)
    {
      tardec=2;
    }
    else if(dec1==lcddec)
    {
      tardec=dec1;
    }
    else if(ori_dec==lcddec )
    {
      tardec=lcddec;
      
    }
    else
    {
      tardec=dec1;
    }
  }
  else
  {
    if (dec1==5&&lcddec==6) {

      tardec=6;
    }
    else if(dec2==1&&dec1==1&&lcdone==0)
    {
      tardec=0;
    }
    else if (dec1==6&&lcddec==5&&lcdone==9&&one2==9) {
      tardec=5;
    }
    else if(ori_dec==lcddec )
    {
      tardec=lcddec;
      
    }
    else
    {
      if (dec2>=8&&tarone>0) {
            tardec=lcddec;
      }
      else
      {
            tardec=dec2;
      }
    }
  }
  NSUInteger tarval=tardec*10+tarone;
  if (type==1&&tarval>49) {

    if(dec2==0||dec1==0||lcddec==0||ori_dec==0)
    {
      tardec=0;
    }
  }
  else if(type==2&&tarval>54)
  {
    if(dec2==0||dec1==0||lcddec==0||ori_dec==0)
    {
      tardec=0;
    }
  }
  else if(type==3&&tarval>80)
  {
    if(dec2==0||dec1==0||lcddec==0||ori_dec==0)
    {
      tardec=0;
    }
  }
  else if(type==4&&tarval>34)
  {
    if(dec2==0||dec1==0||lcddec==0||ori_dec==0)
    {
      tardec=0;
    }
  }
  else if(type==9&&tarval>14)
  {

      tardec=0;

  }
  
  tarval=tardec*10+tarone;
  NSString*getstr= [NSString stringWithFormat: @"%lu", (unsigned long)tarval];
  NSLog(@"the correct number %@", getstr);

  return getstr;
}
+ (NSString*) proccessDateString:(NSString*)m_datestr
{
  
  if([m_datestr length]<7)
  {
    return m_datestr;
  }
    
  NSArray* words1 = [m_datestr componentsSeparatedByCharactersInSet :[NSCharacterSet punctuationCharacterSet]];
  if ([words1 count] == 3 &&[[self removeWhiteSpaceInString: words1[1]] length] == 2)
  {
    
    
    NSString*daysstr = [self removeWhiteSpaceInString: words1[0]];
    if([daysstr length]>2)
    {
      daysstr = [daysstr substringFromIndex:[daysstr length] - 2];
    }
    
    int ond = [daysstr intValue];
    int onm = [[self removeWhiteSpaceInString: words1[1]] intValue];
    NSString*yearsstr =[self removeWhiteSpaceInString: words1[2]];
    if([yearsstr length]>4)
    {
      yearsstr = [yearsstr substringToIndex:4];
    }
    int ony = [yearsstr intValue];
    NSString*str = @"";
    if (ond>0&&ond<32) {
      str= [str stringByAppendingString:[NSString stringWithFormat:@"%d",ond]];
      //str= [str stringByAppendingString:daysstr];
    }
    else if(ond>32&&ond<100)
    {
      ond = ond % 30;
      if (ond == 0) {
        str= [str stringByAppendingString:[NSString stringWithFormat:@"%d",30]];
      }
      else
      {
        str= [str stringByAppendingString:[NSString stringWithFormat:@"%d",ond]];
      }
    }
   
    if(onm > 0&&onm <=12 )
    {
      
      
        str=[str stringByAppendingString:@"."];
        str=[str stringByAppendingString:[NSString stringWithFormat:@"%d",onm]];
    }
    else if(onm >12)
    {
      onm = onm -onm/10*10;
      str=[str stringByAppendingString:@"."];
      str=[str stringByAppendingString:[NSString stringWithFormat:@"%d",onm]];
    }
    else
    {
      str=[str stringByAppendingString:@"."];
      str=[str stringByAppendingString:[NSString stringWithFormat:@"%d",0]];
      
    }
    
    str=[str stringByAppendingString:@"."];
    if(ony>2100)
    {
      NSString*yerasufixstr = [yearsstr substringFromIndex:2];
      str=[str stringByAppendingString:@"20"];
      str=[str stringByAppendingString:yerasufixstr];
    }
    else
    {
          str=[str stringByAppendingString:[NSString stringWithFormat:@"%d",ony]];
    }
    

    return  str;
      

  }

  NSString*str=@"";
  string timestr=m_datestr.UTF8String;
  string interresult=GetOnlyNumbers(timestr);
  NSString *itemstr=[[NSString alloc] initWithUTF8String:interresult.c_str() ];
  if([itemstr length]>=12)
  {
    itemstr=[itemstr substringFromIndex:[itemstr length] - 8];
  }
  if([itemstr length]>8)
  {
    itemstr=[itemstr substringToIndex:8];
  }
  NSString*yearcompstr =@"";
  if ([itemstr length] >6) {
    yearcompstr = [itemstr substringFromIndex:[itemstr length] - 4 ];
  }

  if ([itemstr length]==8&&[yearcompstr hasPrefix:@"20"])
  {
    NSString* daystr=[itemstr substringToIndex:2];
    NSRange range;
    range.length=2;
    range.location=2;
    NSString* monstr=[itemstr substringWithRange:range];
    int mon_int=[monstr intValue];
    if (mon_int==13) {
      
      monstr=[NSString stringWithFormat: @"0%d", 8];
    }
    else if (mon_int>12) {
      int mon_intone=mon_int-(int)(mon_int/10)*10;
      monstr=[NSString stringWithFormat: @"0%lu", (unsigned long)mon_intone];
    }
    int day_int=[daystr intValue];
    if (day_int>31) {
      int ond = day_int % 30;
      if (day_int== 0) {
        daystr=@"30";
      }
      else{
        daystr=[NSString stringWithFormat: @"%d", ond];
      }
      
    }
    NSString* yearstr=[itemstr substringFromIndex:4];
    if (![yearstr compare:@"2015"]||![yearstr compare:@"2013"]||![yearstr compare:@"2016"]||[yearcompstr compare:@"2010"]) {
      yearstr=@"2018";
    }
//    yearstr=[@"20" stringByAppendingString:yearstr];
    str=[str stringByAppendingString:daystr];
    str=[str stringByAppendingString:@"."];
    str=[str stringByAppendingString:monstr];
    str=[str stringByAppendingString:@"."];
    str=[str stringByAppendingString:yearstr];
    return str;
  }
  else
  {
    string onlycomadigit=CustomTrims(timestr);
    NSString*newstring =  [[NSString alloc] initWithUTF8String:onlycomadigit.c_str() ];
    NSArray* words1 = [newstring componentsSeparatedByCharactersInSet :[NSCharacterSet punctuationCharacterSet]];
    
    
    NSMutableArray *words = [NSMutableArray arrayWithCapacity:10];
    if (words1.count<10) {
      for (int index = 0;index<words1.count;index++)
      {
        NSString*item =words1[index];
        if([item length]>2 &&index == 0)
        {
          continue;
        }
        
        if([item length] != 0&&[item length] < 6)
        {
          [words addObject:[self removeWhiteSpaceInString:item]];
        }
      }
    }
    if([words count] == 3)
    {
      NSString*daysstr =words[0];
      if([daysstr length]>2)
      {
        daysstr = [daysstr substringFromIndex:[daysstr length] - 2];
      }
      NSString*yearsstr =words[2];
      if([yearsstr length]>4)
      {
        yearsstr = [yearsstr substringToIndex:4];
      }
      
      int ond = [daysstr intValue];
      int onm = [ words[1] intValue];
      int ony = [yearsstr intValue];
      NSString*str = @"";
      if (ond>0&&ond<32) {
        str= [str stringByAppendingString:[NSString stringWithFormat:@"%d",ond]];
        //str= [str stringByAppendingString:daysstr];
      }
      else if(ond>=32&&ond<100)
      {
        ond = ond % 30;
        if (ond == 0) {
          str= [str stringByAppendingString:[NSString stringWithFormat:@"%d",30]];
        }
        else
        {
          str= [str stringByAppendingString:[NSString stringWithFormat:@"%d",ond]];
        }
        
      }
      
      
      if(onm > 0&&onm <=12 )
      {

        str=[str stringByAppendingString:@"."];
        str=[str stringByAppendingString:[NSString stringWithFormat:@"%d",onm]];

      }
      else if(onm >12)
      {
        onm = onm -onm/10*10;
        str=[str stringByAppendingString:@"."];
        str=[str stringByAppendingString:[NSString stringWithFormat:@"%d",onm]];
      }
      else
      {
        str=[str stringByAppendingString:@"."];
        str=[str stringByAppendingString:[NSString stringWithFormat:@"%d",0]];
      }
      str=[str stringByAppendingString:@"."];
      str=[str stringByAppendingString:[NSString stringWithFormat:@"%d",ony]];
      return  str;
    }
    else if ([itemstr length]==7&&[yearcompstr hasPrefix:@"20"])
    {
      NSString* daystr=[itemstr substringToIndex:2];
      NSRange range;
      range.length=2;
      range.location=1;
      NSString* monstr=[itemstr substringWithRange:range];
      int mon_int=[monstr intValue];
      if (mon_int==13) {
        
        monstr=[NSString stringWithFormat: @"0%d", 8];
      }
      else if (mon_int>12) {
        int mon_intone=mon_int-(int)(mon_int/10)*10;
        monstr=[NSString stringWithFormat: @"0%lu", (unsigned long)mon_intone];
      }
      int day_int=[daystr intValue];
      if (day_int>31) {
        int ond = day_int % 30;
        if (day_int== 0) {
          daystr=@"30";
        }
        else{
          daystr=[NSString stringWithFormat: @"%d", ond];
        }
        
      }
//      yearcompstr = [itemstr substringFromIndex:[itemstr length] - 4 ];
//      NSString* yearstr=[itemstr substringFromIndex:4];
      if (![yearcompstr compare:@"2015"]||![yearcompstr compare:@"2013"]||![yearcompstr compare:@"2016"]||[yearcompstr compare:@"2010"]) {
        yearcompstr=@"2018";
      }
      //    yearstr=[@"20" stringByAppendingString:yearstr];
      str=[str stringByAppendingString:daystr];
      str=[str stringByAppendingString:@"."];
      str=[str stringByAppendingString:monstr];
      str=[str stringByAppendingString:@"."];
      str=[str stringByAppendingString:yearcompstr];
      return str;
    }
    
    else if([newstring containsString:@".20"])
    {
      NSRange mrangeyear = [newstring rangeOfString:@".20"];
      NSString*yearsstr =[newstring substringFromIndex:mrangeyear.location+1];
      if([yearsstr length]>4)
      {
        yearsstr = [yearsstr substringToIndex:4];
      }
      if([yearsstr length] == 4 && mrangeyear.location>6)
      {
        NSString*befordaymonth = [newstring substringToIndex:mrangeyear.location];

        NSString* daystr=@"";
        NSString* monstr=@"";
        
        NSString*dayandmonth = [befordaymonth substringFromIndex:[befordaymonth length]-5];
        if([dayandmonth containsString:@"."]||[dayandmonth containsString:@"-"])
        {
          NSArray* otherwords = [dayandmonth componentsSeparatedByCharactersInSet :[NSCharacterSet punctuationCharacterSet]];
          if([otherwords count] == 2)
          {
            daystr = otherwords[0];
            monstr = otherwords[1];
          }
        }
        else
        {
          dayandmonth = [befordaymonth substringFromIndex:[befordaymonth length]-4];
          daystr = [dayandmonth substringToIndex:2];
          monstr = [dayandmonth substringFromIndex:2];
        }
        int mon_int=[monstr intValue];
        if (mon_int==13) {
          
          monstr=[NSString stringWithFormat: @"0%d", 8];
        }
        else if (mon_int>12) {
          int mon_intone=mon_int-(int)(mon_int/10)*10;
          monstr=[NSString stringWithFormat: @"0%lu", (unsigned long)mon_intone];
        }
        int day_int=[daystr intValue];
        if (day_int>31) {
          int ond = day_int % 30;
          if (day_int== 0) {
            daystr=@"30";
          }
          else{
            daystr=[NSString stringWithFormat: @"%d", ond];
          }
          
        }
        
        if (![yearsstr compare:@"2015"]||![yearsstr compare:@"2013"]||![yearsstr compare:@"2016"]||[yearcompstr compare:@"2010"]) {
          yearsstr=@"2018";
        }
        NSString*otherstr = @"";
        otherstr=[otherstr stringByAppendingString:daystr];
        otherstr=[otherstr stringByAppendingString:@"."];
        otherstr=[otherstr stringByAppendingString:monstr];
        otherstr=[otherstr stringByAppendingString:@"."];
        otherstr=[otherstr stringByAppendingString:yearsstr];
        return otherstr;

      }
      
      
    }
    else if ([itemstr length]==9&&[yearcompstr hasPrefix:@"20"])
    {
      NSString* daystr=[itemstr substringToIndex:2];
      NSRange range;
      range.length=3;
      range.location=2;
      NSString* monstr=[itemstr substringWithRange:range];
      int mon_int=[monstr intValue];
      if (mon_int==13) {
        
        monstr=[NSString stringWithFormat: @"0%d", 8];
      }
      else if (mon_int>12) {
        int mon_intone=mon_int-(int)(mon_int/10)*10;
        monstr=[NSString stringWithFormat: @"0%lu", (unsigned long)mon_intone];
      }
      int day_int=[daystr intValue];
      if (day_int>31) {
        int ond = day_int % 30;
        if (day_int== 0) {
          daystr=@"30";
        }
        else{
          daystr=[NSString stringWithFormat: @"%d", ond];
        }
        
      }
     // NSString* yearstr=[itemstr substringFromIndex:4];
      if (![yearcompstr compare:@"2015"]||![yearcompstr compare:@"2013"]||![yearcompstr compare:@"2016"]||[yearcompstr compare:@"2010"]) {
        yearcompstr=@"2018";
      }
      //    yearstr=[@"20" stringByAppendingString:yearstr];
      str=[str stringByAppendingString:daystr];
      str=[str stringByAppendingString:@"."];
      str=[str stringByAppendingString:monstr];
      str=[str stringByAppendingString:@"."];
      str=[str stringByAppendingString:yearcompstr];
      return str;
    }
    
    return newstring;
  }

  string trimstr = CustomTrims(timestr);
//
//  return [self StringCurrentTime];
  return [[NSString alloc] initWithUTF8String:trimstr.c_str() ];
  
  
}
+ (NSString*) proccessLotoType:(int)m_type
{
  NSString *itemstr=@"";
  if(m_type==Sayisal)
  {
   itemstr= @"\nThis lottery type is “Sayısal Loto” (Numerical Lottery).\n";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                        object:itemstr];
  }
  else if(m_type==Sans)
  {
 itemstr= @"\nThis lottery type is “Şans Topu” (Lucky Ball).\n";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                        object:itemstr];
    
  }
  else if(m_type==Numara)
  {
itemstr= @"\nThis lottery type is “On Numara”  (Ten Number).\n";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                        object:itemstr];
  }
  else if(m_type==Super)
  {
  itemstr= @"\nThis lottery type is “Süper Loto” (Super Lottery).\n";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CVProgressNotification"
                                                        object:itemstr];
    
  }
  return  itemstr;
  //1.  “Sayısal Loto” (Numerical Lottery)
  //2.  “Süper Loto” (Super Lottery)
  //3.  “On Numara”  (Ten Number)
  //4.  “Şans Topu” (Lucky Ball)
  
}

+(NSString*)StringCurrentTime
{
  NSDate *currentTime = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"dd.MM.yyyy"];
  NSString *resultString = [dateFormatter stringFromDate: currentTime];
  return resultString;
}
+ (UIImage*) processImageWithOpenCV: (UIImage*) inputImage
{

  
    NSArray* imageArray = [NSArray arrayWithObject:inputImage];
    UIImage* result = [[self class] processWithArray:imageArray];
  
  
  
    return result;
}

+ (UIImage*) processWithOpenCVImage1:(UIImage*)inputImage1 image2:(UIImage*)inputImage2;
{
    NSArray* imageArray = [NSArray arrayWithObjects:inputImage1,inputImage2,nil];
    UIImage* result = [[self class] processWithArray:imageArray];
    return result;
}

+ (UIImage*) processWithArray:(NSArray*)imageArray
{
    if ([imageArray count]==0){
        NSLog (@"imageArray is empty");
        return 0;
        }
    std::vector<cv::Mat> matImages;


    for (id image in imageArray) {
        if ([image isKindOfClass: [UIImage class]]) {
            /*
             All images taken with the iPhone/iPa cameras are LANDSCAPE LEFT orientation. The  UIImage imageOrientation flag is an instruction to the OS to transform the image during display only. When we feed images into openCV, they need to be the actual orientation that we expect them to be for stitching. So we rotate the actual pixel matrix here if required.
             */
            UIImage* rotatedImage = [image rotateToImageOrientation];
            cv::Mat matImage = [rotatedImage CVMat3];
            NSLog (@"matImage: %@",image);
            matImages.push_back(matImage);
        }
    }
    NSLog (@"stitching...");
    cv::Mat stitchedMat = stitch (matImages);
    UIImage* result =  [UIImage imageWithCVMat:stitchedMat];
    return result;
}
+ (UIImage*) onlyCouponImage:(UIImage*)Image
{
  cv::Mat matImage = [Image CVMat3];

  cv::Mat reMat = RemoveBackground(matImage);
  UIImage* result =  [UIImage imageWithCVMat:reMat];
  return result;
  
  
}
+ (NSString *) removeWhiteSpaceInString:(NSString *) srcString{
  if (srcString == nil){
    srcString = @"";
  }
  NSString * resultStr = [[NSString alloc] init];
  NSArray* words = [srcString componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
  resultStr = [words componentsJoinedByString:@""];
  resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  return resultStr;
}
+ (NSString*) CorrectDateString:(NSString*)m_total:(NSString*)m_indi
{

  if([m_total length]<7)
  {
    return m_total;
  }
  NSArray* words1 = [m_total componentsSeparatedByCharactersInSet :[NSCharacterSet punctuationCharacterSet]];
  
  
  NSMutableArray *words = [NSMutableArray arrayWithCapacity:10];
  if (words1.count<10) {
    for (int index = 0;index<words1.count;index++)
    {
      NSString*item =words1[index];
      if([item length] != 0)
      {
        [words addObject:[self removeWhiteSpaceInString:item]];
      }
    }
    
  }

    

  
  
  NSString*yearstr=@"";
  NSString*monstr=@"";
  NSString*daystr=@"";
  if ([words count] == 3)
  {
//    int ond = [words[0] intValue];
//    int onm = [words[1] intValue];
//    int ony = [words[2] intValue];
//    if(ond> 0 && ond<32 &&onm > 0&&onm <=12 && ony>1000)
//    {
////      if (ony>2000)
////      {
////        NSString*str = @"";
////        str= [str stringByAppendingString:words[0]];
////        str=[str stringByAppendingString:@"."];
////        str=[str stringByAppendingString:words[1]];
////        str=[str stringByAppendingString:@"."];
////        str=[str stringByAppendingString:words[2]];
////        return  str;
////      }
////      else
////      {
////        NSString*str = @"";
////        str= [str stringByAppendingString:words[0]];
////
////        str=[str stringByAppendingString:@"."];
////        str=[str stringByAppendingString:words[1]];
////        str=[str stringByAppendingString:@"."];
////        NSString *curstr =  [self StringCurrentTime];
////        NSArray* datearray = [curstr componentsSeparatedByCharactersInSet :[NSCharacterSet punctuationCharacterSet]];
////        str=[str stringByAppendingString:datearray[3]];
////
////        return str;
////      }
//
//
//    }
  }
  NSString*str=@"";
  string timestr=m_indi.UTF8String;
  string interresult=GetOnlyNumbers(timestr);
  NSString *itemstr=[[NSString alloc] initWithUTF8String:interresult.c_str() ];
  
  if([words count] == 3&&[itemstr length] >11 )
  {
    NSString*yearcompstr = [itemstr substringFromIndex:[itemstr length] - 4 ];
    if(([itemstr hasSuffix:words[2]]||(([words[2] hasPrefix:@"20"])&&[yearcompstr hasPrefix:@"20"])))//&&([yearcompstr isEqualToString:@"2010"])
    {
       itemstr = [itemstr substringFromIndex:[itemstr length]-8];
    }
    
  }
  if ([words count] == 3&&[m_total length]>=8&&[itemstr length]>6&&[itemstr length]<11) {
    
    int ori_day = [words[0] intValue];
    int ori_month =[words[1] intValue];
    yearstr=words[2];
    monstr=words[1];
    daystr=words[0];

    NSString* daystr1=[itemstr substringToIndex:2];
    NSRange range;
    range.length=2;
    range.location=2;
    NSString* monstr1=[itemstr substringWithRange:range];
    
    int mon_int=[monstr1 intValue];
    int day_int=[daystr1 intValue];
    if (mon_int!=ori_month) {
      if (mon_int<12&&[itemstr length]==8) {
        if ((ori_month<9&&mon_int<9)||(ori_month>9&&mon_int>9)) {
          if (mon_int>9) {
 
              monstr=[NSString stringWithFormat: @"%lu", (unsigned long)mon_int];
          }else if(ori_month != 0 && mon_int != 0)
          {
            if (ori_month==6||mon_int==6) {
              monstr=[NSString stringWithFormat: @"0%d", 6];
            }
            else
            {
              if ((ori_month==5&&mon_int==8)||(ori_month==8&&mon_int==5)) {
                monstr=[NSString stringWithFormat: @"0%d", 6];
              }else{
                monstr=[NSString stringWithFormat: @"0%lu", (unsigned long)mon_int];}
            }

          }
          else
          {
            if (mon_int != 0) {
               monstr=[NSString stringWithFormat: @"0%lu", (unsigned long)mon_int];
            }
            else if(ori_month != 0)
            {
              monstr=[NSString stringWithFormat: @"0%lu", (unsigned long)ori_month];
            }
          }
        }
        else if(ori_month == 0 && mon_int != 0)
        {
          monstr=[NSString stringWithFormat: @"0%lu", (unsigned long)mon_int];
        }

      }
    }
    if (ori_day!=day_int) {
      if (day_int<=31&&[itemstr length]==8) {
        if ((ori_day<9&&day_int<9)||(ori_day>9&&day_int>9)) {
          if (day_int>9) {
            if (day_int==15&&ori_day==16) {
              daystr=[NSString stringWithFormat: @"%d", 16];
            }
            else if (day_int==15&&ori_day==14) {
              daystr=[NSString stringWithFormat: @"%d", 14];
            }
            else if (abs(day_int-ori_day) > 10) {
              daystr=[NSString stringWithFormat: @"%d", ori_day];
            }
            else if (day_int<ori_day) {
              daystr=[NSString stringWithFormat: @"%d", ori_day];
            }
            
            else
            {
              daystr=[NSString stringWithFormat: @"%lu", (unsigned long)ori_day];
         
            }
            
          }
          else if(day_int != 0)
          {
            daystr=[NSString stringWithFormat: @"0%lu", (unsigned long)day_int];
          }
          else if(ori_day != 0)
          {
            daystr=[NSString stringWithFormat: @"0%lu", (unsigned long)ori_day];
          }
        }
        else if(ori_day != 0)
        {
          daystr=[NSString stringWithFormat: @"0%lu", (unsigned long)ori_day];
        }
        else if(ori_day == 0 && day_int != 0)
        {
          daystr=[NSString stringWithFormat: @"0%lu", (unsigned long)day_int];
        }

      }
      
    }
    
    NSString *curstr =  [self StringCurrentTime];
    NSArray* datearray = [curstr componentsSeparatedByCharactersInSet :[NSCharacterSet punctuationCharacterSet]];

    if ( [daystr length] == 0 || [daystr isEqualToString:@"0"]||[daystr isEqualToString:@"00"]) {
      daystr = datearray[0];
    }
    
    if ( [monstr length] == 0 || [monstr isEqualToString:@"0"]||[monstr isEqualToString:@"00"]) {
      monstr = datearray[1];
    }
    str=[str stringByAppendingString:daystr];
    
    str=[str stringByAppendingString:@"."];
    str=[str stringByAppendingString:monstr];
    str=[str stringByAppendingString:@"."];
    str=[str stringByAppendingString:yearstr];
    
    return str;
    
  }
  else if([itemstr length] == 8)
  {
      NSString* daystr=[itemstr substringToIndex:2];
      NSRange range;
      range.length=2;
      range.location=2;
      NSString* monstr=[itemstr substringWithRange:range];
      int mon_int=[monstr intValue];
      if (mon_int>12) {
        int mon_intone=mon_int-(int)(mon_int/10)*10;
        monstr=[NSString stringWithFormat: @"0%lu", (unsigned long)mon_intone];
      }

      int day_int=[daystr intValue];

      if (day_int>31) {
        day_int =day_int %30;
        
        if (day_int== 0) {
          daystr=@"30";
        }
        else{
          daystr=[NSString stringWithFormat: @"%d", day_int];
        }
      }
    
      NSString* yearstr=[itemstr substringFromIndex:4];
      if (![yearstr compare:@"2015"]||![yearstr compare:@"2013"]||![yearstr compare:@"2016"]) {
        yearstr=@"2018";
      }
    
      str=[str stringByAppendingString:daystr];
      str=[str stringByAppendingString:@"."];
      str=[str stringByAppendingString:monstr];
      str=[str stringByAppendingString:@"."];
      str=[str stringByAppendingString:yearstr];
      return str;
    
  }
  else if([itemstr length] >11&&([itemstr hasSuffix:@"2018"]||[itemstr hasSuffix:@"2010"]))
  {
    itemstr = [itemstr substringFromIndex:[itemstr length]-8];
    NSString* daystr=[itemstr substringToIndex:2];
    NSRange range;
    range.length=2;
    range.location=2;
    NSString* monstr=[itemstr substringWithRange:range];
    int mon_int=[monstr intValue];
    if (mon_int>12) {
      int mon_intone=mon_int-(int)(mon_int/10)*10;
      monstr=[NSString stringWithFormat: @"0%lu", (unsigned long)mon_intone];
    }
    
    int day_int=[daystr intValue];
    
    if (day_int>31) {
      day_int =day_int %30;
      
      if (day_int== 0) {
        daystr=@"30";
      }
      else{
        daystr=[NSString stringWithFormat: @"%d", day_int];
      }
    }
    
    NSString* yearstr=[itemstr substringFromIndex:4];

    str=[str stringByAppendingString:daystr];
    str=[str stringByAppendingString:@"."];
    str=[str stringByAppendingString:monstr];
    str=[str stringByAppendingString:@"."];
    str=[str stringByAppendingString:yearstr];
    return str;
  }
  

  //return [self StringCurrentTime];
 return m_total;

}
+ (NSString*) DateWithLcd:(int)m_num:(int)m_lcd
{
  int reint = m_num;
  if(m_lcd==6)
  {
    reint = 6;
    
  }
  NSString*restr=[NSString stringWithFormat:@"%u",reint];
  return restr;
    
}

  @end
  
