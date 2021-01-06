//
//  stitching.h
//  CVOpenTemplate
//
//  Created by Foundry on 05/01/2013.
//  Copyright (c) 2013 Foundry. All rights reserved.
//

#ifndef CVOpenTemplate_Header_h
#define CVOpenTemplate_Header_h
#include <opencv2/opencv.hpp>
#include "Coupon.h"

cv::Mat stitch (std::vector <cv::Mat> & images);
vector<Rows> GetRowsfromMat(Mat&src);



#endif
