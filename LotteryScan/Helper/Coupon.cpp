
#include "Coupon.h"


Coupon::Coupon()
{
  m_type=Not;
}
Coupon::Coupon(Mat img, Rect pos)
{
	
	plateImg = img.clone();
	position = Rect(pos);
  one=0;
  two=0;

}
Coupon::Coupon(Mat img, cv::Rect pos,Mat ori)
{
  plateImg = img.clone();
  position = Rect(pos);
  oriImg=ori.clone();
  one=0;
  two=0;
}


Coupon::~Coupon()
{
}
Rows::Rows()
{
  
}
Rows::~Rows()
{
  
}


