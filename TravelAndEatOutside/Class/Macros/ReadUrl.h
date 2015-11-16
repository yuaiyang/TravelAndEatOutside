//
//  ReadUrl.h
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/23.
//  Copyright © 2015年 雨爱阳. All rights reserved.
//

#ifndef ReadUrl_h
#define ReadUrl_h

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"



//精品页面
#define Boutique0 @"http://client.ikanshu.cn/teshuapi/rest/cbooks/getbdbooksbytime?cnid=1045&num=0"

#define Boutique1 @"http://client.ikanshu.cn/teshuapi/rest/cbooks/getbdbooksbytime?cnid=1045&num=1"

#define Boutique2 @"http://client.ikanshu.cn/teshuapi/rest/cbooks/getbdbooksbytime?cnid=1045&num=2"

#define Boutique3 @"http://client.ikanshu.cn/teshuapi/rest/cbooks/getbdbooksbytime?cnid=1045&num=3"

#define Boutique4 @"http://client.ikanshu.cn/teshuapi/rest/cbooks/getbdbooksbytime?cnid=1045&num=4"

//图书详情页面
#define ReadHomePage @"http://client.ikanshu.cn/teshuapi/rest/books/getbookinfo?cnid=1045&bookid=%ld"

#define Readcatalog @"http://client.ikanshu.cn/teshuapi/rest/books/getvolumecharge?cnid=1045&bookid=%ld"

#define ReadContent @"http://client.ikanshu.cn/teshuapi/rest/books/getchapter?cnid=1045&chapterid=%ld"

//图书排行页面
#define  ReadRanking @"http://client.ikanshu.cn/teshuapi/rest/books/getpaihangbooks?cnid=1045&parentid=4"

//搜索页面
#define ReadSearch @"http://client.ikanshu.cn/teshuapi/rest/books/getpaihangbooks?cnid=1045&parentid=6"

//搜索结果页面
#define ReadSearchResult @"http://client.ikanshu.cn/teshuapi/rest/books/getsearch?cnid=1045&keyword=%@&offset=0&count=100"




#endif /* ReadUrl_h */
