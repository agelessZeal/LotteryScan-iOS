//
//  CVWrapper.h
//  CVOpenTemplate
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@interface CVWrapper : NSObject

+ (UIImage*) processImageWithOpenCV: (UIImage*) inputImage:(NSString*)fileName;

+ (UIImage*) processWithOpenCVImage1:(UIImage*)inputImage1 image2:(UIImage*)inputImage2;
        
+ (UIImage*) processWithArray:(NSArray<UIImage*>*)imageArray;
+ (UIImage*) GetDebugImage:(UIImage*)image;
+ (UIImage*) GetTesseractString:(UIImage*)inputImage;
+ (UIImage*) DrawResult:(UIImage*)inputImage:(CGRect)m_rects;

+ (NSString*) saveImage:(UIImage*)inputImage;
+ (NSString*) proccessTimeString:(NSString*)m_timestr;
+ (NSString*) proccessDateString:(NSString*)m_datestr;
+ (NSString*) GetCorrectCouponString:(NSUInteger)number1:(NSUInteger)dec2:(NSUInteger)one2:(char)firstchar:(char)secondchar:(bool)firstratio:(bool)secondratio:(NSUInteger)orinum:(NSUInteger)type;
+ (NSString*) GetTwoString:(NSUInteger)m_couponnum;
+ (UIImage*) mergeImage:(UIImage*)firstImage:(UIImage*)secondImage;
+ (UIImage*) onlyCouponImage:(UIImage*)Image;
+ (NSString*) GetCorrectSameString:(NSUInteger)total_coupon_int:(NSUInteger)dec2:(NSUInteger)one2:(char)firstchar:(char)secondchar:(bool)firstratio:(bool)secondratio:(NSUInteger)orinum:(NSUInteger)lcd_top_right:(NSUInteger)type;
+ (NSString *) removeWhiteSpaceInString:(NSString *) srcString;
+ (NSString*) CorrectDateString:(NSString*)m_total:(NSString*)m_indi;
+ (NSString*) DateWithLcd:(int)m_num:(int)m_lcd;
+(NSString*)StringCurrentTime;

@property (nonatomic, strong, readwrite, nonnull) NSArray<UIImage*>* coders;
@property NSArray *items;

@end
NS_ASSUME_NONNULL_END
