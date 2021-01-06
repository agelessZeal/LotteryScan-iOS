
#include "common.h"
#include "Coupon.h"

bool insertCouponTomapvector(vector <map<int, cv::Rect>>& coupon_rects)
{
  int prev_coupon_number=0;
  vector <map<int, Rect>>::iterator preiter=coupon_rects.begin();
  for (vector <map<int, Rect>>::iterator it=coupon_rects.begin(); it!=coupon_rects.end(); it++) {
    
    if (prev_coupon_number!=0&&prev_coupon_number!=it->size()) {
      if (prev_coupon_number>it->size()) {
        cout<<"the minus rect is added."<<endl;
        Rect nowonwrt=Rect(it->begin()->second);
        it->clear();
        for (map<int,Rect>::iterator mapit=preiter->begin(); mapit!=preiter->end(); mapit++) {
          Rect rt=Rect(mapit->second);
          it->insert(make_pair(rt.x, Rect(rt.x,nowonwrt.y,rt.width,rt.height)));
          
        }
      }
    }
    if (it->size()<5) {
      return false;
    }
    preiter=it;
    prev_coupon_number=(int)it->size();
  }
  return true;
  
}
bool isValidCouponRect(vector <map<int, Rect>>& coupon_rects)
{
  int prev_coupon_number=0;
  
  for (vector <map<int, Rect>>::iterator it=coupon_rects.begin(); it!=coupon_rects.end(); it++) {
    
    if (prev_coupon_number!=0&&prev_coupon_number!=it->size()) {
      
      cout<<"from the isvalid now row "<<it->size()<<" pre "<<prev_coupon_number<<endl;
      return false;
      
    }
    if (it->size()<5) {
      return false;
    }
    
    prev_coupon_number=(int)it->size();
  }
  return true;
}
void merge_conflict_rects(vector<Rect> &rects)
{
	bool is_finished = false;
	while (is_finished == false) {
		is_finished = true;
		int min_x, min_y, max_x, max_y;
		
		if (rects.size() == 0) break;

		for (auto it = rects.begin(); it != rects.end() - 1; it++) {
			for (auto it1 = it + 1; it1 != rects.end(); it1++) {
				if (it->contains(it1->tl()) ||
					it->contains(it1->br()) ||
					it->contains(Point(it1->tl().x, it1->br().y-1)) ||
					it->contains(Point(it1->br().x, it1->tl().y+1)) ||
					it1->contains(it->tl()) ||
					it1->contains(it->br()) ||
					it1->contains(Point(it->tl().x, it->br().y-1)) ||
					it1->contains(Point(it->br().x, it->tl().y+1))) {

					min_x = it->tl().x < it1->tl().x ? it->tl().x : it1->tl().x;
					max_x = it->br().x > it1->br().x ? it->br().x : it1->br().x;
					min_y = it->tl().y < it1->tl().y ? it->tl().y : it1->tl().y;
					max_y = it->br().y > it1->br().y ? it->br().y : it1->br().y;

					it->x = min_x;
					it->y = min_y;
					it->width = max_x - min_x;
					it->height = max_y - min_y;

					rects.erase(it1);
					is_finished = false;
					break;
				}
			}
			if (is_finished == false) break;
		}
	}
}
void remove_include_rects(vector<Rect> &rects)
{
	bool is_finished = false;

	while (is_finished == false) {
		is_finished = true;
		int min_x, min_y, max_x, max_y;

		if (rects.size() == 0) break;

		for (auto it = rects.begin(); it != rects.end() - 1; it++)
		{
			for (auto it1 = it + 1; it1 != rects.end(); it1++) 
			{
				if ((it->contains(it1->tl()) &&it->contains(Point(it1->br().x-2,it1->br().y-2))) ||
					(it1->contains(it->tl()) &&
					it1->contains(Point(it->br().x - 1, it->br().y - 1))))
				{	

					min_x = it->tl().x < it1->tl().x ? it->tl().x : it1->tl().x;
					max_x = it->br().x > it1->br().x ? it->br().x : it1->br().x;
					min_y = it->tl().y < it1->tl().y ? it->tl().y : it1->tl().y;
					max_y = it->br().y > it1->br().y ? it->br().y : it1->br().y;

					it->x = min_x;
					it->y = min_y;
					it->width = max_x - min_x;
					it->height = max_y - min_y;


					rects.erase(it1);
					is_finished = false;
					break;
				}
				/////////
        float maxheight = it->height > it1->height ? it->height : it1->height;
        int intervlaWidth =  ceil(maxheight*0.1);
        if ((abs(it->br().x - it1->tl().x) <= intervlaWidth &&it->br().x<it1->br().x && it->tl().y >= it1->tl().y&&it->br().y <= it1->br().y+2) ||
            (it->contains(Point(it1->br().x+3,it1->tl().y+3)))||
            (it1->contains(Point(it->br().x+3,it->tl().y+3)))||
          (abs(it->br().x - it1->tl().x) <= intervlaWidth &&it->br().x<it1->br().x && it1->tl().y >= it->tl().y&&it1->br().y <= it->br().y+2)||
          (abs(it1->br().x - it->tl().x) <= intervlaWidth &&it1->br().x < it->br().x && it1->tl().y >= it->tl().y&&it1->br().y <= it->br().y+2) ||
          (abs(it1->br().x - it->tl().x) <= intervlaWidth &&it1->br().x < it->br().x && it->tl().y >= it1->tl().y&&it->br().y <= it1->br().y+2))
        {

             min_x = it->tl().x < it1->tl().x ? it->tl().x : it1->tl().x;
          max_x = it->br().x > it1->br().x ? it->br().x : it1->br().x;
          min_y = it->tl().y < it1->tl().y ? it->tl().y : it1->tl().y;
          max_y = it->br().y > it1->br().y ? it->br().y : it1->br().y;

          it->x = min_x;
          it->y = min_y;
          it->width = max_x - min_x;
          it->height = max_y - min_y;

          rects.erase(it1);
          is_finished = false;
          break;
        }
				/////////////
				
			}
			if (is_finished == false) break;
		}
		
	}

}
void merge_height_rects(vector<cv::Rect> &rects)
{
  bool is_finished = false;
  while (is_finished == false) {
    is_finished = true;
    int min_x, min_y, max_x, max_y;
    
    if (rects.size() == 0) break;
    
    for (auto it = rects.begin(); it != rects.end() - 1; it++) {
      for (auto it1 = it + 1; it1 != rects.end(); it1++) {
        
        //float maxheight = it->height > it1->height ? it->height : it1->height;
        //int interWidth = ceil(maxheight*0.4);
        int interWidth = 10;
        int interHeight = 6;
        
        if (it->contains(it1->tl()) ||
            it->contains(it1->br()) ||
            it->contains(Point(it1->tl().x, it1->tl().y-interHeight)) ||
            it->contains(Point(it1->tl().x+interWidth, it1->tl().y-interHeight)) ||
            
            
            it1->contains(it->tl()) ||
            it1->contains(it->br()) ||
            it1->contains(Point(it->tl().x, it->tl().y-interHeight)) ||
            it1->contains(Point(it->tl().x+interWidth, it->tl().y-interHeight)) 
            )
        {
          
          min_x = it->tl().x < it1->tl().x ? it->tl().x : it1->tl().x;
          max_x = it->br().x > it1->br().x ? it->br().x : it1->br().x;
          min_y = it->tl().y < it1->tl().y ? it->tl().y : it1->tl().y;
          max_y = it->br().y > it1->br().y ? it->br().y : it1->br().y;
          
          it->x = min_x;
          it->y = min_y;
          it->width = max_x - min_x;
          it->height = max_y - min_y;
          
          rects.erase(it1);
          is_finished = false;
          break;
        }
      }
      if (is_finished == false) break;
    }
  }
}
void merge_width_rects(vector<Rect> &rects)
{
	bool is_finished = false;
	while (is_finished == false) {
		is_finished = true;
		int min_x, min_y, max_x, max_y;

		if (rects.size() == 0) break;

		for (auto it = rects.begin(); it != rects.end() - 1; it++) {
			for (auto it1 = it + 1; it1 != rects.end(); it1++) {

				//float maxheight = it->height > it1->height ? it->height : it1->height;
				//int interWidth = ceil(maxheight*0.4);
        int interWidth = 4;
				int interHeight = 5;
        
        if ((
             ((abs(it->tl().y - it1->tl().y) <=interHeight)&&(abs(it->br().y - it1->br().y) <= interHeight))||
             (it->br().y>it1->tl().y&&it->br().y<it1->br().y&&it->tl().y<it1->br().y&&it->tl().y+interHeight>it1->tl().y)||
             (it1->br().y>it->tl().y&&it1->br().y<it->br().y&&it1->tl().y<it->br().y&&it1->tl().y+interHeight>it->tl().y)
             
             
             )&&
            (
             (abs(it1->tl().x - it->br().x) <= interWidth &&it->br().x < it1->br().x)||
             (abs(it->br().x - it1->tl().x) <= interWidth &&it->br().x < it1->br().x )||
             (abs(it1->br().x - it->tl().x) <= interWidth &&it1->br().x < it->br().x)||
             (abs(it1->br().x - it->tl().x) <= interWidth &&it1->br().x < it->br().x )||
             (abs(it1->tl().x - it->tl().x) <= interWidth&&abs(it1->br().x - it->br().x) <= interWidth)
             ))
				{

					min_x = it->tl().x < it1->tl().x ? it->tl().x : it1->tl().x;
					max_x = it->br().x > it1->br().x ? it->br().x : it1->br().x;
					min_y = it->tl().y < it1->tl().y ? it->tl().y : it1->tl().y;
					max_y = it->br().y > it1->br().y ? it->br().y : it1->br().y;

					it->x = min_x;
					it->y = min_y;
					it->width = max_x - min_x;
					it->height = max_y - min_y;

					rects.erase(it1);
					is_finished = false;
					break;
				}
			}
			if (is_finished == false) break;
		}
	}
}
void merge_width_rects_other(vector<cv::Rect> &rects)
{
  bool is_finished = false;
  while (is_finished == false) {
    is_finished = true;
    int min_x, min_y, max_x, max_y;
    
    if (rects.size() == 0) break;
    
    for (auto it = rects.begin(); it != rects.end() - 1; it++) {
      for (auto it1 = it + 1; it1 != rects.end(); it1++) {
        
        //float maxheight = it->height > it1->height ? it->height : it1->height;
        //int interWidth = ceil(maxheight*0.4);
        int interWidth = 30;
        int interHeight = 10;
        if ((abs(it1->tl().x - it->br().x) <= interWidth &&it->br().x < it1->br().x && abs(it->tl().y - it1->tl().y) <=interHeight&&abs(it->br().y - it1->br().y) <= interHeight) ||
            (abs(it->br().x - it1->tl().x) <= interWidth &&it->br().x < it1->br().x && abs(it1->tl().y - it->tl().y) <=interHeight&&abs(it1->br().y -it->br().y) <=interHeight) ||
            (abs(it1->br().x - it->tl().x) <= interWidth &&it1->br().x < it->br().x && abs(it1->tl().y - it->tl().y) <=interHeight&&abs(it1->br().y - it->br().y) <=interHeight) ||
            (abs(it1->br().x - it->tl().x) <= interWidth &&it1->br().x < it->br().x && abs(it->tl().y - it1->tl().y) <=interHeight&&abs(it->br().y - it1->br().y) <=interHeight)||
            (abs(it1->tl().x - it->br().x) <= interWidth &&it1->tl().x > it->br().x && (it->tl().y < it1->tl().y) &&((it->br().y > it1->br().y)||abs(it1->br().y -it->br().y) <=interHeight ))||
//            (it1->tl().x <= interWidth+it->br().x&& (it->tl().y+10 >= it1->tl().y ) &&((it->br().y <= it1->br().y+10) ))||
//            (it->tl().x <= interWidth+it1->br().x&& (it1->tl().y+10 >= it->tl().y ) &&((it1->br().y <= it->br().y+10) ))||
            (abs(it->tl().x - it1->br().x) <= interWidth &&it->tl().x > it1->br().x && (it1->tl().y < it->tl().y) &&(it1->br().y > it->br().y) ))
        {
          
          min_x = it->tl().x < it1->tl().x ? it->tl().x : it1->tl().x;
          max_x = it->br().x > it1->br().x ? it->br().x : it1->br().x;
          min_y = it->tl().y < it1->tl().y ? it->tl().y : it1->tl().y;
          max_y = it->br().y > it1->br().y ? it->br().y : it1->br().y;
          
          it->x = min_x;
          it->y = min_y;
          it->width = max_x - min_x;
          it->height = max_y - min_y;
          
          rects.erase(it1);
          is_finished = false;
          break;
        }
        if (it->contains(it1->tl()) ||
            it->contains(it1->br()) ||
            it->contains(Point(it1->tl().x, it1->br().y+10)) ||
            it->contains(Point(abs(it1->tl().x-10), it1->tl().y)) ||
            it->contains(Point(it1->br().x, it1->tl().y+10)) ||
            it->contains(Point(it1->br().x+5, it1->br().y+5)) ||
            it->contains(Point(it1->br().x+10, it1->br().y+5)) ||
            it->contains(Point(it1->br().x+5, it1->tl().y+5)) ||
            (it->contains(Point(it1->tl().x, it1->tl().y-4)) && it->contains(Point(it1->br().x, it1->tl().y-4)))||
            it1->contains(it->tl()) ||
            it1->contains(it->br()) ||
            it1->contains(Point(it->tl().x, it->br().y+10)) ||
            it1->contains(Point(abs(it->tl().x-10), it->tl().y)) ||
            it1->contains(Point(it->br().x+5, it->br().y+5)) ||
            it1->contains(Point(it->br().x+10, it->br().y+5)) ||
            it1->contains(Point(it->br().x+5, it->tl().y+5)) ||
            (it1->contains(Point(it->tl().x, it->tl().y-4)) && it1->contains(Point(it->br().x, it->tl().y-4)))||
            it1->contains(Point(it->br().x, it->tl().y+10))) {
          
          min_x = it->tl().x < it1->tl().x ? it->tl().x : it1->tl().x;
          max_x = it->br().x > it1->br().x ? it->br().x : it1->br().x;
          min_y = it->tl().y < it1->tl().y ? it->tl().y : it1->tl().y;
          max_y = it->br().y > it1->br().y ? it->br().y : it1->br().y;
          
          it->x = min_x;
          it->y = min_y;
          it->width = max_x - min_x;
          it->height = max_y - min_y;
          
          rects.erase(it1);
          is_finished = false;
          break;
        }
      }
      if (is_finished == false) break;
    }
  }
}
std::vector<cv::Rect> get_coupon_rects(vector<cv::Rect> &possible_rect, vector<cv::Rect> &dash_rects,Mat&src)
{
  cout<<"from the get coupon rects:possible_rect:"<<possible_rect.size()<<endl;
  cout<<"from the get cooupon rects ::dash rect " <<dash_rects.size()<<endl;
  std::vector<cv::Rect> coupon_number_rects;
	//dash_rects.clear();
  if (dash_rects.size()!=2)
  {
    dash_rects.clear();
    bool is_finished = false;
    float ratiovalue = 0;
    while (is_finished == false)
    {
      is_finished = true;
      if (possible_rect.size() < 2) break;
      for (auto it = possible_rect.begin(); it != possible_rect.end(); it++)
      {
        if (dash_rects.size() >= 2)
        {
          is_finished = true;
          break;
        }
        else
        {
          ratiovalue = float(it->width) / float(it->height);
          if (ratiovalue > 16)
          {
            if (dash_rects.size())
            {
              if (dash_rects.front().y > it->y)
              {
                dash_rects.insert(dash_rects.begin(), Rect(*it));
              }
              else
              {
                dash_rects.push_back(Rect(*it));
              }
            }
            else
            {
              dash_rects.push_back(Rect(*it));
            }
            
            possible_rect.erase(it);
            is_finished = false;
            break;
          }
        }
      }
      if (is_finished == true) break;
    }
    
  }
	if (dash_rects.size()==2)
	{

    Rect top= dash_rects.front().y > dash_rects.back().y ? dash_rects.back() : dash_rects.front();
    Rect bottom= dash_rects.front().y > dash_rects.back().y ? dash_rects.front(): dash_rects.back();
    //int top_x = top.br().x >= 0 ? top.br().x : 0;
    int top_y = top.br().y>= 0 ? top.br().y : 0;
    for (auto it = possible_rect.begin(); it != possible_rect.end(); it++)
    {
      if (it->br().y > top_y&&it->br().y < bottom.br().y&&top.tl().y<it->tl().y&&bottom.tl().y+5>it->br().y)
        // if (it->y > dash_rects.front().br().y&&it->br().y < dash_rects.back().tl().y)
      {
        if (it->width<src.cols/7&&it->height<src.rows/4)
        {
          float ratio=float(it->height)/float(it->width);
          if (ratio>4.2) {
            coupon_number_rects.push_back(Rect(it->x-2,it->y,it->width+ratio*0.4,it->height));
            
          }
          else
          {
            coupon_number_rects.push_back(Rect(*it));
           
          }
          //rectangle(src,  Rect(it->x-1,it->y-1,it->width+2,it->height+2), Scalar(205,4,232));

         // rects.erase(it);
        }
      }
    }

    if (coupon_number_rects.size()>8)
    {
      cout<<"from the get coupon rects:coupon_number_rects:"<<coupon_number_rects.size()<<endl;
      return coupon_number_rects;
    }
   }
 

	return coupon_number_rects;
}

vector <map<int, Rect>> get_coupon_rects_new(vector<Rect>& rects, Mat&src, vector<Rect> &dash_rects)
{
 	vector <map<int, Rect>> return_rects;
  cout<<"get_coupon_rects_new"<<endl;
	if (dash_rects.size()!=2)
	{
		dash_rects.clear();
		bool is_finished = false;
		float ratiovalue = 0;
		while (is_finished == false)
		{
			is_finished = true;
			if (rects.size() < 2) break;
			for (auto it = rects.begin(); it != rects.end(); it++)
			{
//        if (dash_rects.size() >= 2)
//        {
//          is_finished = true;
//          break;
//        }
//        else
				{
					ratiovalue = float(it->width) / float(it->height);
					if (ratiovalue > 16)
					{
            cout <<"@@@@@@this is dash rect"<<endl;
            cout << "\tx\t:" << it->x << endl;
            cout << "\ty\t:" << it->y << endl;
            cout << "\twidth\t:" << it->width << endl;
            cout << "\theight\t:" << it->height << endl;
            cout << "\tratio\t:" << ratiovalue << endl;
            //rectangle(src,  *it, Scalar(4,4,245));
						if (dash_rects.size())
						{
							if (dash_rects.front().y > it->y)
							{
								dash_rects.insert(dash_rects.begin(), Rect(*it));
							}
							else
							{
								dash_rects.push_back(Rect(*it));
							}
						}
						else
						{
							dash_rects.push_back(Rect(*it));
						}

						rects.erase(it);
						is_finished = false;
						break;
					}
				}
			}
			if (is_finished == true) break;
		}

	}
  if(dash_rects.size()>=2)
  {
    if(dash_rects.size()==2)
    {
      Rect rt1 =Rect(dash_rects.front());
      Rect rt2 = Rect(dash_rects.back());
      if(abs(rt1.y-rt2.y)<6)
      {
        int min_x = rt1.tl().x < rt2.tl().x ? rt1.tl().x : rt2.tl().x;
        int max_x = rt1.br().x > rt2.br().x ? rt1.br().x : rt2.br().x;
        int min_y = rt1.tl().y < rt2.tl().y ? rt1.tl().y : rt2.tl().y;
        int max_y = rt1.br().y > rt2.br().y ? rt1.br().y : rt2.br().y;
        
        
        rt1.x = min_x;
        rt1.y = min_y;
        rt1.width = max_x - min_x;
        rt1.height = max_y - min_y;
        
        dash_rects.clear();
        dash_rects.push_back(rt1);
      }
    }
    
    
    merge_conflict_rects(dash_rects);
    
    
    cout <<"after merge dash rect :"<<dash_rects.size()<<endl;
    //rectangle(src, dash_rects.front(), Scalar(4,4,255),3);
  }


//////////////////////////

	
	if (dash_rects.size() == 2)
		
	{
    cout <<"the dash rect is recognized. "<<dash_rects.size()<<"other rect size "<< rects.size()<<endl;
    
		vector<Rect> coupon_number_rects;
		coupon_number_rects.clear();
    bool is_finished = false;
    Rect top= dash_rects.front().y > dash_rects.back().y ? dash_rects.back() : dash_rects.front();
    Rect bottom= dash_rects.front().y > dash_rects.back().y ? dash_rects.front(): dash_rects.back();
    
    //int top_x = top.br().x >= 0 ? top.br().x : 0;
    int top_y = top.br().y>= 0 ? top.br().y : 0;
    //int min_x=top.tl().x >=bottom.tl().x?  top.tl().x : bottom.tl().x;
   // int max_x=top.br().x >=bottom.br().x?  top.br().x : bottom.br().x;
   // int width = abs(max_x-min_x);
   // int height =abs( bottom.tl().y - top.br().y);


    while (is_finished == false)
    {
      is_finished = true;
      for (auto it = rects.begin(); it != rects.end(); it++)
      {

        if (it->br().y > top_y&&it->br().y < bottom.br().y&&top.tl().y<it->tl().y&&bottom.tl().y+5>it->br().y)
         // if (it->y > dash_rects.front().br().y&&it->br().y < dash_rects.back().tl().y)
        {

          
          if (it->width<src.cols/7&&it->height<src.rows/4)
          {
            coupon_number_rects.push_back(Rect(*it));
           
            rects.erase(it);
            is_finished = false;
            break;
          }
            


        }
        if (it == rects.end()-1)
        {
          is_finished = true;
          break;
        }

      }
      if (is_finished == true) break;
    }
    cout<<"the all detected coupon rects is "<<coupon_number_rects.size()<<endl;
		///sorted the coupon number rect
		if (coupon_number_rects.size()>=7)
		{
      
      
			map<int, Rect> one_row_coupons;
			map<int, Rect> sorted_rect;
			for (auto it = coupon_number_rects.begin(); it != coupon_number_rects.end(); it++) {
				int x = it->x >= 0 ? it->x : 0;
				int y = it->y >= 0 ? it->y : 0;
				int width = it->x + it->width >= src.size().width ? src.size().width - it->x - 1 : it->width;
				int height = it->y + it->height >= src.size().height ? src.size().height - it->y - 1 : it->height;
				int key = x + y*src.size().width;//* src.size().width
        //rectangle(src,*it, Scalar(15,134,224)  );
         //rectangle(src,  Rect(it->x-2,it->y-2,it->width+4,it->height+4), Scalar(20,24,244));
				sorted_rect.insert(make_pair(key, Rect(x, y, width, height)));
				
			}
       bool isdiffer= get_map_vector_rect(sorted_rect, return_rects);

      
      ///////////////////
        if (isdiffer) {
    

          map<int, Rect>::iterator  get_sorted_rect_iterator=return_rects.front().begin()++;
          Rect normalrt=Rect(return_rects.front().begin()->second);
          Rect cnrt=Rect(get_sorted_rect_iterator->second);
//          get_sorted_rect_iterator++;
//          Rect cnrt1=Rect(get_sorted_rect_iterator->second);
//          int between=cnrt.y-cnrt1.br().y>0 ? cnrt.y-cnrt1.br().y:cnrt1.y-cnrt.br().y;
          for (auto it = return_rects.begin(); it != return_rects.end(); it++)
          {
            Rows onerows;
            int compare_index=0;
            for (auto mapit = it->begin(); mapit != it->end(); mapit++)
            {
              compare_index++;
              cout<<"index"<<compare_index<<":w"<<mapit->second.width<<":h"<<mapit->second.height<<endl;
              Rect temprt=Rect(mapit->second);
              if (temprt.width>8&&temprt.width<32&&temprt.height>19&&temprt.height<42) {
                cnrt=Rect(temprt);
              }
              
            }
          }
          cout<<"nor w:"<<cnrt.width<<endl;
          cout<<"nor h:"<<cnrt.height<<endl;
          
          bool is_finished = false;
          float ratiovalue = 0;
          while (is_finished == false)
          {
           is_finished = true;
          for (auto it = sorted_rect.begin(); it != sorted_rect.end(); it++)
          {
            ///////

            if (it->second.width<cnrt.width*3&&(float)it->second.width/(float)cnrt.width>1.8&&abs(cnrt.height-it->second.height)<5) {
            
              //rectangle(src, it->second, Scalar(255,255,1));
              cout<<"double width rect is removed"<<endl;
              cout<<"nor w:"<<cnrt.width<<endl;
              cout<<"nor h:"<<cnrt.height<<endl;
             
              cout<<"ori x:"<<it->second.x<<endl;
              cout<<"ori y:"<<it->second.y<<endl;
              cout<<"ori w:"<<it->second.width<<endl;
              cout<<"ori h:"<<it->second.height<<endl;
              cout<<"ori br x:"<<it->second.br().x<<endl;
              cout<<"ori br y:"<<it->second.br().y<<endl;
              
             
              ///it->second.height=normalrt.height;
              int m_key1=it->first+1;
              Rect newitem1=Rect(it->second.x,it->second.y,cnrt.width,it->second.height);
              sorted_rect.insert(make_pair(m_key1,newitem1));
              int m_key=it->second.br().x-cnrt.width+(it->second.y)*src.size().width;
              Rect newitem=Rect(it->second.br().x-cnrt.width,it->second.y,cnrt.width,it->second.height);
              
              sorted_rect.insert(make_pair(m_key,newitem));
              sorted_rect.erase(it);
              is_finished=false;
              break;
              
            }
            ////////
            
            if (it->second.height<normalrt.height*3&&(float)it->second.height/(float)normalrt.height>1.8&&abs(normalrt.width-it->second.width)<5) {
                cout<<"double height rect is removed"<<endl;
                ///it->second.height=normalrt.height;
                int m_key1=it->first+1;
                Rect newitem1=Rect(it->second.x,it->second.y,it->second.width,it->second.height/2-3);
                sorted_rect.insert(make_pair(m_key1,newitem1));
                int m_key=it->second.x+(it->second.height/2+it->second.y+1)*src.size().width;
                Rect newitem=Rect(it->second.x,it->second.y+it->second.height/2+2,it->second.width,it->second.height/2);

                sorted_rect.insert(make_pair(m_key,newitem));
                sorted_rect.erase(it);
                is_finished=false;
                break;

            }
            
            if (it->second.height<normalrt.height*4&&(float)it->second.height/(float)normalrt.height>2.8&&abs(normalrt.width-it->second.width)<5) {
              int m_high=it->second.height;
             
              int m_key=it->second.x+(m_high/3+it->second.y+2)*src.size().width;
              Rect newitem=Rect(it->second.x,it->second.y+m_high/3+1,it->second.width,m_high/3);
              sorted_rect.insert(make_pair(m_key,newitem));
              int m_key1=it->second.x+(m_high*2/3+it->second.y+1)*src.size().width;
              Rect newitem1=Rect(it->second.x,it->second.y+m_high*2/3+1,it->second.width,m_high/3);
              sorted_rect.insert(make_pair(m_key1,newitem1));
              it->second.height=normalrt.height;
            }
            if (it==sorted_rect.end()--) {
              is_finished=true;
              break;
            }
          }
            if(is_finished) break;
            
          }
          isdiffer= get_map_vector_rect(sorted_rect, return_rects);
          if (isdiffer) {
            return_rects.clear();
          }
          
			}
      ///////

		}
	}
	return return_rects;
}
vector <map<int, cv::Rect>>  get_map_vector_rect_without_same(map<int, cv::Rect> &sorted_rect)
{
  vector <map<int, cv::Rect>> map_vector;
  if (sorted_rect.size()) {
    map<int, Rect> one_row_coupons;
    map_vector.clear();

    int one_row_coupon_number_prev = 0;
    Rect firstRect = sorted_rect.begin()->second;
    one_row_coupons.clear();
 //   cout << "#####get_map_vector_rect_without_same" << endl;
    for (auto it = sorted_rect.begin(); it != sorted_rect.end(); it++)
    {
//      cout << "\tx\t:" << it->second.x << endl;
//      cout << "\ty\t:" << it->second.y << endl;
//      cout << "\twidth\t:" << it->second.width << endl;
//      cout << "\theight\t:" << it->second.height << endl;
//      cout << "\tbtx\t:" << it->second.br().x << endl;
//      cout << "\tbtyy\t:" << it->second.br().y << endl;
      if (it->second.y < firstRect.br().y-10 )
      {
        one_row_coupons.insert(make_pair(it->second.x, Rect(it->second)));
      }
      else
      {
        ///new map body create
        map<int, Rect> other_row_coupons;
        other_row_coupons.clear();
        for (auto mapit = one_row_coupons.begin(); mapit != one_row_coupons.end(); mapit++)
        {
          other_row_coupons.insert(make_pair(mapit->first, mapit->second));
        }
//        if (one_row_coupon_number_prev != 0 && one_row_coupon_number_prev != other_row_coupons.size())
//        {
//          number_differ=true;
//          cout<<"the row is differnt coupon number. pre is "<< one_row_coupon_number_prev<<"\tnow is "<<other_row_coupons.size()<<endl;
//          return map_vector;
//
//          }
        
          map_vector.push_back(other_row_coupons);
          one_row_coupon_number_prev =(int) other_row_coupons.size();
          
          one_row_coupons.clear();
          one_row_coupons.insert(make_pair(it->second.x, Rect(it->second)));
          
          firstRect = it->second;
          continue;
          }
          }
          //////////////////////////////////////////////////////////////////////////
          map<int, Rect> other_row_coupons;
          other_row_coupons.clear();
          
          for (auto mapit = one_row_coupons.begin(); mapit != one_row_coupons.end(); mapit++)
          {
            other_row_coupons.insert(make_pair(mapit->first, mapit->second));
          }
//          if (one_row_coupon_number_prev != 0 && one_row_coupon_number_prev != other_row_coupons.size())
//          {
//
//            cout<<"the last row is differnt number of coupons.pre is "<< one_row_coupon_number_prev<<"\tnow is "<<other_row_coupons.size()<<endl;
//            number_differ=true;
//            return map_vector;
//          }
    
          map_vector.push_back(other_row_coupons);
          one_row_coupons.clear();
          return  map_vector;
          
    }
  return map_vector;
}
bool get_map_vector_rect(map<int, cv::Rect> &sorted_rect,vector <map<int, cv::Rect>>&map_vector)
{
  cout<<"get_map_vector_rect"<<endl;
  if (sorted_rect.size()) {
    map<int, Rect> one_row_coupons;
    map_vector.clear();
    bool number_differ=false;
    int one_row_coupon_number_prev = 0;
    
    Rect firstRect = sorted_rect.begin()->second;
//    for (auto it = sorted_rect.begin(); it != sorted_rect.end(); it++)
//    {
//      if (firstRect.y>it->second.y) {
//        firstRect=Rect(it->second);
//      }
//    }
    
    one_row_coupons.clear();
    
    for (auto it = sorted_rect.begin(); it != sorted_rect.end(); it++)
    {
//      cout << "\tx\t:" << it->second.x << endl;
//      cout << "\ty\t:" << it->second.y << endl;
//      cout << "\twidth\t:" <<  it->second.width << endl;
//      cout << "\theight\t:" <<  it->second.height << endl;
      
      if (it->second.y < firstRect.br().y)
      {
        one_row_coupons.insert(make_pair(it->second.x, Rect(it->second)));
      }
      else
      {
        ///new map body create
        map<int, Rect> other_row_coupons;
        other_row_coupons.clear();
        for (auto mapit = one_row_coupons.begin(); mapit != one_row_coupons.end(); mapit++)
        {
          other_row_coupons.insert(make_pair(mapit->first, mapit->second));
        }
        if (one_row_coupon_number_prev != 0 && one_row_coupon_number_prev != other_row_coupons.size())
        {
          number_differ=true;
          cout<<"the row is differnt coupon number. pre is "<< one_row_coupon_number_prev<<"\tnow is "<<other_row_coupons.size()<<endl;
          return true;
          
        }

        
        map_vector.push_back(other_row_coupons);
        if(other_row_coupons.size()<6||other_row_coupons.size()>12)
        {
          cout<<"from get_map_vector_rect row size invalid "<<other_row_coupons.size()<<endl;
          return true;
        }
        one_row_coupon_number_prev =(int) other_row_coupons.size();
        
        one_row_coupons.clear();
        one_row_coupons.insert(make_pair(it->second.x, Rect(it->second)));
        
        firstRect = it->second;
        continue;
      }
    }
    //////////////////////////////////////////////////////////////////////////
    map<int, Rect> other_row_coupons;
    other_row_coupons.clear();
    
    for (auto mapit = one_row_coupons.begin(); mapit != one_row_coupons.end(); mapit++)
    {
      other_row_coupons.insert(make_pair(mapit->first, mapit->second));
    }
    if (one_row_coupon_number_prev != 0 && one_row_coupon_number_prev != other_row_coupons.size())
    {
      
      cout<<"the last row is differnt number of coupons.pre is "<< one_row_coupon_number_prev<<"\tnow is "<<other_row_coupons.size()<<endl;
      number_differ=true;
      return true;
    }

    map_vector.push_back(other_row_coupons);
    if(other_row_coupons.size()<6||other_row_coupons.size()>12)
    {
      cout<<"from get_map_vector_rect row size invalid "<<other_row_coupons.size()<<endl;
      return true;
    }
    if(map_vector.size()==1)
    {
      if(map_vector.front().size()<11&&map_vector.front().size()>9)
      {
        return true;
      }
    }
      
    one_row_coupons.clear();
    return  number_differ;

  }
  return true;
}
void remove_include_rects_in_number(vector<Rect2f> &rects)
{
	bool is_finished = false;

	while (is_finished == false) {
		is_finished = true;
		int min_x, min_y, max_x, max_y;

		if (rects.size() == 0) break;

		for (auto it = rects.begin(); it != rects.end() - 1; it++)
		{
			for (auto it1 = it + 1; it1 != rects.end(); it1++)
			{

				if (
					(it->contains(Point(it1->tl().x+1,it1->tl().y+1)) && ((it->br().x>=it1->br().x)&&(it1->y>=it->y))) ||
					(it1->contains(Point(it->tl().x + 1, it->tl().y + 1)) && ((it1->br().x >= it->br().x) && (it->y >= it1->y)))||
					( ((it->br().x >= it1->tl().x&&it->br().x < it1->br().x) || (it1->br().x >= it->tl().x&&it1->br().x < it->br().x)))//it->y == it1->y&&it->height == it1->height &&
				 
					)
				{

					min_x = it->tl().x < it1->tl().x ? it->tl().x : it1->tl().x;
					max_x = it->br().x > it1->br().x ? it->br().x : it1->br().x;
					min_y = it->tl().y < it1->tl().y ? it->tl().y : it1->tl().y;
					max_y = it->br().y > it1->br().y ? it->br().y : it1->br().y;

					it->x = min_x;
					it->y = min_y;
					it->width = max_x - min_x;
					it->height = max_y - min_y;


					rects.erase(it1);
					is_finished = false;
					break;
				}


			}
			if (is_finished == false) break;
		}
	}

	////
	//////////the two rect height is different
	if (rects.size()==2)
	{
		int min_x, min_y, max_x, max_y;
		Rect first = rects.front();
		Rect second = rects.back();
		if ((first.y - second.y)>2 )
		{
			min_y = second.y; 
			max_y = first.br().y < second.br().y ? first.br().y : second.br().y;

			rects.front().y = min_y;
			rects.front().height = max_y - min_y;
		}
		if (second.y - first.y > 2)
		{
			min_y = first.y;
			max_y = first.br().y < second.br().y ? first.br().y : second.br().y;

			rects.back().y = min_y;
			rects.back().height = max_y - min_y;

		}
	}

	/////////
}

vector <map<int, Rect>> get_coupon_sort_rects(std::vector<cv::Rect> &rects, Mat& src)
{
  cout<<"get_coupon_sort_rects"<<endl;
  vector <map<int, Rect>> return_rects;
  if (rects.size())
  {
   
    map<int, Rect> one_row_coupons;
    map<int, Rect> sorted_rect;
    for (auto it = rects.begin(); it != rects.end(); it++)
    {
      int x = it->x >= 0 ? it->x : 0;
      int y = it->y >= 0 ? it->y : 0;
      int width = it->x + it->width >= src.size().width ? src.size().width - it->x - 1 : it->width;
      int height = it->y + it->height >= src.size().height ? src.size().height - it->y - 1 : it->height;
      int key = x + y*src.size().width;//* src.size().width
      sorted_rect.insert(make_pair(key, Rect(x, y, width, height)));
      
    }
    
    if (sorted_rect.size())
    {
      int one_row_coupon_number_prev = 0;
      Rect firstRect = sorted_rect.begin()->second;
      one_row_coupons.clear();
      for (auto it = sorted_rect.begin(); it != sorted_rect.end(); it++)
      {
        
        if (it->second.y < firstRect.br().y)
        {
          one_row_coupons.insert(make_pair(it->second.x, Rect(it->second)));
        }
        else
        {
          
          ///new map body create
          map<int, Rect> other_row_coupons;
          other_row_coupons.clear();
          for (auto mapit = one_row_coupons.begin(); mapit != one_row_coupons.end(); mapit++)
          {
            other_row_coupons.insert(make_pair(mapit->first, mapit->second));
          }
          //one_row_coupon_number_prev=0;
          if (one_row_coupon_number_prev != 0 && one_row_coupon_number_prev != other_row_coupons.size())
          {

            cout<<"the row is differnt coupon number. pre is "<< one_row_coupon_number_prev<<"\tnow is "<<other_row_coupons.size()<<endl;
            return_rects.clear();
            return return_rects;
          }
          
          return_rects.push_back(other_row_coupons);
          one_row_coupon_number_prev =(int) other_row_coupons.size();
          
          one_row_coupons.clear();
          one_row_coupons.insert(make_pair(it->second.x, Rect(it->second)));
          
          firstRect = it->second;
          continue;
        }
        
      }
      //////////////////////////////////////////////////////////////////////////
      ////the last row of coupon
      map<int, Rect> other_row_coupons;
      other_row_coupons.clear();

      for (auto mapit = one_row_coupons.begin(); mapit != one_row_coupons.end(); mapit++)
      {
        other_row_coupons.insert(make_pair(mapit->first, mapit->second));
      }
      if (one_row_coupon_number_prev != 0 && one_row_coupon_number_prev != other_row_coupons.size())
      {
        
        cout<<"the last row is differnt number of coupons.pre is "<< one_row_coupon_number_prev<<"\tnow is "<<other_row_coupons.size()<<endl;
        return_rects.clear();
        return return_rects;
      }
      
      return_rects.push_back(other_row_coupons);
      one_row_coupons.clear();
      ///////////////////
      
    }
    
  }

  return return_rects;
  
  
}


////
vector <map<int, cv::Rect>> get_coupon_rects_without_dash(std::vector<cv::Rect> &rects, Mat& src,int bottom_y)
{
  cout<<"get_coupon_rects_without_dash"<<endl;
  vector <map<int, Rect>> return_rects;
  if (rects.size())
  {
    
    map<int, Rect> one_row_coupons;
    map<int, Rect> sorted_rect;
    for (auto it = rects.begin(); it != rects.end(); it++)
    {
      int x = it->x >= 0 ? it->x : 0;
      int y = it->y >= 0 ? it->y : 0;
      int width = it->x + it->width >= src.size().width ? src.size().width - it->x - 1 : it->width;
      int height = it->y + it->height >= src.size().height ? src.size().height - it->y - 1 : it->height;
      if (height>=24&&width<src.size().width/7&&y>src.size().height/10)//width>=13&&
      {
         //(width>=18&&height>=38&&width<src.size().width/5)
        if(bottom_y)
        {
          if (y<bottom_y) {
            int key = x + y*src.size().width;//* src.size().width
            sorted_rect.insert(make_pair(key, Rect(x, y, width, height)));
            //rectangle(src,Rect(x, y, width, height), Scalar(2,234,231));
          }
        }
        else
        {
          
          int key = x + y*src.size().width;//* src.size().width
          sorted_rect.insert(make_pair(key, Rect(x, y, width, height)));
          //rectangle(src,Rect(x, y, width, height), Scalar(2,234,231));
        }

      }
    }
    cout << " get_coupon_rects_without_dash  possible sorted_rect " <<sorted_rect.size()<< endl;
    if (sorted_rect.size())
    {
      int one_row_coupon_number_prev = 0;
      Rect firstRect = sorted_rect.begin()->second;
      one_row_coupons.clear();
      for (auto it = sorted_rect.begin(); it != sorted_rect.end(); it++)
      {
        
        if (it->second.y < firstRect.br().y)
        {
          one_row_coupons.insert(make_pair(it->second.x, Rect(it->second)));
        }
        else
        {
          
          ///new map body create
          map<int, Rect> other_row_coupons;
          other_row_coupons.clear();
          for (auto mapit = one_row_coupons.begin(); mapit != one_row_coupons.end(); mapit++)
          {
            other_row_coupons.insert(make_pair(mapit->first, mapit->second));
          }
          if (other_row_coupons.size()>=7&&other_row_coupons.size()<13)
          {
           
            return_rects.push_back(other_row_coupons);
          }
      
          one_row_coupon_number_prev =(int) other_row_coupons.size();
          
          one_row_coupons.clear();
          one_row_coupons.insert(make_pair(it->second.x, Rect(it->second)));
          
          firstRect = it->second;
          continue;
        }
        
      }
      //////////////////////////////////////////////////////////////////////////
      ////the last row of coupon
      map<int, Rect> other_row_coupons;
      other_row_coupons.clear();
      one_row_coupon_number_prev=0;
      for (auto mapit = one_row_coupons.begin(); mapit != one_row_coupons.end(); mapit++)
      {
        other_row_coupons.insert(make_pair(mapit->first, mapit->second));
      }
      if (other_row_coupons.size()>=7&&other_row_coupons.size()<13)
      {
        return_rects.push_back(other_row_coupons);
      }
      one_row_coupons.clear();
      ///////////////////
      
    }
    
  }
  
  return return_rects;
  

  
}
vector <map<int, cv::Rect>>  mergewidthfrommat(vector <map<int, cv::Rect>> &sorted_rect,cv::Mat &src)
{
  cout<<"the total rows "<<sorted_rect.size()<<endl;
  for (auto it = sorted_rect.begin(); it != sorted_rect.end()--; it++)
  {
    cout<<"the indi rows coupon  "<<it->size()<<endl;
    for (auto mapit = it->begin(); mapit != it->end(); mapit++)
    {
      Rect rt=mapit->second;
      //rectangle(src,Rect(rt.x-1,rt.y-1,rt.width+2,rt.height+2), Scalar(233,23,3));
    }
  }
  cout<<"from the mergewidthfrommat"<<endl;
  Rect first_rect,second_rect;
  int terrain_width=7;
  
  for (auto it = sorted_rect.begin(); it != sorted_rect.end()--; it++)
  {
    bool is_break=false;
    bool is_finished = false;

    while (is_finished == false)
    {
      is_finished = true;
      for (auto mapit = it->begin(); mapit != it->end(); mapit++)
      {
        
        first_rect=Rect(mapit->second);
        for (auto secmapit = mapit++; secmapit != it->end(); secmapit++)
        {
          
          second_rect=Rect(secmapit->second);
          if (first_rect.br().x<second_rect.tl().x&&second_rect.tl().x-first_rect.br().x<terrain_width) {
            mapit->second.width=second_rect.br().x-first_rect.x;
            it->erase(secmapit);
            is_break=true;
            break;
          }
          if (first_rect.tl().x>second_rect.br().x&&first_rect.tl().x-second_rect.br().x<terrain_width) {
            mapit->second.width=first_rect.br().x-second_rect.x;
            mapit->second.x=second_rect.x;
            it->erase(secmapit);
            is_break=true;
            break;
          }
        }
        if (is_break) {
          break;
        }
        if (mapit==it->end()--) {
          is_finished=true;
          break;
        }
      }
      
      if(is_finished) break;

      
    }

  }
  cout<<"the total rows "<<sorted_rect.size()<<endl;
  for (auto it = sorted_rect.begin(); it != sorted_rect.end()--; it++)
  {
    cout<<"the indi rows coupon  "<<it->size()<<endl;
    for (auto mapit = it->begin(); mapit != it->end(); mapit++)
    {
 
      Rect rt=mapit->second;
      //rectangle(src,Rect(rt.x-3,rt.y,rt.width+6,rt.height), Scalar(3,3,193));
      
    }
  }
  return sorted_rect;
}
////
  

