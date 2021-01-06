//
//  UIImage+OpenCV.h
//  OpenCVClient
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import <TesseractOCR/TesseractOCR.h>

@interface UIImage (OpenCV)

    //cv::Mat to UIImage

+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;
- (id)initWithCVMat:(const cv::Mat&)cvMat;

    //UIImage to cv::Mat
- (cv::Mat)CVMat;
- (cv::Mat)CVMat3;  // no alpha channel
- (cv::Mat)CVGrayscaleMat;

@end
