

#define MAX_HEIGHT_FOR_TEXT				50
#define MAX_INTERVAL_BTW_RECT_WIDTH		13
#define MAX_INTERVAL_BTW_RECT_HEIGHT	8
#define MAX_INTERVAL_WIDTH          	4
#define THRESHOLD_IN_GETSTR				159
#define THRESHOLD_IN_NORMAL				178
#define THRESHOLD_IN_DETAIL			    160

#include <opencv2/opencv.hpp>



#include "Coupon.h"
//openCV 2.4.x
//#include "opencv2/stitching/stitcher.hpp"

//openCV 3.x
//#include "opencv2/stitching.hpp"


using namespace std;
using namespace cv;

void merge_conflict_rects(std::vector<cv::Rect> &rects);
void remove_include_rects(std::vector<cv::Rect> &rects);
void remove_include_rects_in_number(std::vector<cv::Rect2f> &rects);
std::vector<cv::Rect> get_coupon_rects(vector<cv::Rect> &possible_rect, vector<cv::Rect> &dash_rects,Mat&src);
std::vector <map<int,cv::Rect>> get_coupon_rects_new(vector<cv::Rect>& rects, Mat&src, vector<cv::Rect> &dash_rects);
void merge_width_rects(vector<cv::Rect> &rects);
void merge_width_rects_other(vector<cv::Rect> &rects);
void merge_height_rects(vector<cv::Rect> &rects);
vector <map<int, cv::Rect>> get_coupon_sort_rects(std::vector<cv::Rect> &rects, Mat& src);
vector <map<int, cv::Rect>> get_coupon_rects_without_dash(std::vector<cv::Rect> &rects, Mat& src,int bottom_y);
bool get_map_vector_rect(map<int, cv::Rect> &sorted_rects,vector <map<int, cv::Rect>>&map_vector);
vector <map<int, cv::Rect>>  get_map_vector_rect_without_same(map<int, cv::Rect> &sorted_rect);
vector <map<int, cv::Rect>>  mergewidthfrommat(vector<map<int, cv::Rect>> &sorted_rect,cv::Mat &src);
bool insertCouponTomapvector(vector <map<int, cv::Rect>>& coupon_rects);
bool isValidCouponRect(vector <map<int, cv::Rect>>& coupon_rects);








