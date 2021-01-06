#pragma once
#include "common.h"

enum CouponType
{
Not =1,
CouponNumber=2,
Serial=3,
GovermentTakeDate=4,
PlayTime=5,
PlayTimeDate=6,
HeadInfo=7,
DrawTimes=8

};
enum LotoType
{
  Sayisal=1,
  Super=2,
  Numara =3,
  Sans=4,
  Unknown=5
 
  //1.  “Sayısal Loto” (Numerical Lottery)
  //2.  “Süper Loto” (Super Lottery)
  //3.  “On Numara”  (Ten Number)
  //4.  “Şans Topu” (Lucky Ball)
  
};
class Coupon
{

public:
	Coupon();
  Coupon(Mat img, cv::Rect pos);
  Coupon(Mat img, cv::Rect pos,Mat ori);
  cv::Rect position;
  cv::Mat plateImg;
  cv::Mat oriImg;
  cv::Mat firstCharMat;
  cv::Mat secondCharMat;
  char firstLcdChar;
  char secondLcdChar;
  float second_top_right;
  int one;
  int two;
  string str;
	CouponType m_type;
	~Coupon();
};
class Rows
{
public:
  cv::Rect row_pos;
  LotoType type;
  std::vector<Coupon> row_coupons;
  Rows();
  ~Rows();
  
};

