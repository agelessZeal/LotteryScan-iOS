

  #include "Coupon.h"

  bool process_page();
  std::vector<Rows> GetRowsfromMat(Mat&src);



  Coupon  GetSubCharInfo(Coupon&original,Mat&total,int refnum);

	string  DetailGetNumber(Mat &img);
	char hasDigit(string numstr);
	std::vector<string> HorizontalpicturenumbersNEW(Mat subTemp);
	string  GetNumberstr(Mat &numbermat);
	bool hasnondigit(string numstr);
	string CustomTrims(string numstr);
	string CorrectNumbersHori(string numstr);
	Mat deskew(Mat& img);

	Mat MakeRightRect(Mat& img);

	Mat preprocessChar(Mat in);

	Mat GetRightMat(Mat&input);
  string  GetCharsInEveryRect(Mat&thresholdinput, Mat&srcMat, Mat&erodeMat, map<int,cv::Rect> &numberRect);

	char LCDDigitGet(Mat roi,float& top_right);
	bool isEqual(int *first, int *second);
	char cusgetchar(int digit);
	char GetAILCDDigit(int*on,float* search);
  vector<cv::Rect> get_dash_rects(Mat &src,int erosion_size, int dilation_size);
  vector<cv::Rect> get_possible_rects(Mat &src,int erosion_size, int dilation_size,int thresholdval,vector<cv::Rect> &dash_rects,int height,int width);
  vector<cv::Rect> get_possible_rects_other(Mat &src,int erosion_size, int dilation_size,int thresholdval,vector<cv::Rect> &dash_rects,int height,int width);
  vector<cv::Rect> get_rects(Mat &src);
  std::vector<Rows> get_rows_coupons(Mat & src,vector <map<int, cv::Rect>> coupon_rects, vector<cv::Rect> &dash_rects);
  Rows  bottom_above_rect(Mat & src,vector<cv::Rect>& found_rects,int top_y,int bottom_y);
  std::vector<Rows> main_proc(Mat&src,int erosion_size, int dilation_size);
  Mat  RotateToRightMat(Mat& src,cv::Rect &m_getAngleRect);
  Rows    only_bottom_rect(Mat & src,vector<cv::Rect>& found_rects,int bottom_y);
  Rows    only_above_rect(Mat & src,vector<cv::Rect>& found_rects,int top_y);


  map<int ,cv::Rect2f>  GetDigitRects(Mat&m_couponmat,int refnum);
  Coupon GetGoverCoupon(Mat&src,cv::Rect possiblert);
  Coupon GetDateCoupon(Mat&src,cv::Rect possiblert);
  Coupon GetTimeCoupon(Mat&src,cv::Rect possiblert);
  Rows GetIndiNumberRegions(Coupon&m_region,Mat&src);

  void printDigitNumber(int*on);
  Mat histeq(Mat in);
  string GetOnlyNumbers(string numstr);
  string GetDateForamtString(string str);
  string GetTimeForamtString(string str);
  void DrawResult(cv::Rect rt,cv::Mat img);

  cv::Mat  combinetwoimg(cv::Mat first,cv::Mat second);
  cv::Mat RemoveBackground(cv::Mat src);

vector<cv::Rect> copy_vector_rects(vector<cv::Rect> possible_rect);

vector<cv::Rect> get_number_rects_on_date_region(cv::Mat& src);





