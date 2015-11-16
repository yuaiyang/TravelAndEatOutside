//
//  ReadDataBaseManager.h
//  TravelAndEatOutside
//
//  Created by 雨爱阳 on 15/10/21.
//  Copyright © 2015年 王振. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "CollectModel.h"
#import "MenuModel.h"
#import "CatalogModel.h"
#import "ContentModel.h"


@interface ReadDataBaseManager : NSObject

+(ReadDataBaseManager *)shareDataManager;

//遍历文件夹获得文件夹大小，返回多少M
-(float)folderSize;

//清除缓存
-(void)clearCache;


//打开数据库
-(BOOL)creatDatabase;
//关闭数据库
-(void)closeDatabase;

//创建收藏表格
-(BOOL)creatCollectTable;
//插入收藏表格数据
-(void)insertCollectInfoWith:(CollectModel *)model;

//查询收藏表格数据
-(NSMutableArray *)selectInfo;
//删除收藏表格中得数据
-(void)deleteCollecInfoWith:(long)bookId;


//创建菜单表格
-(void)creatMenuTableInfo;

//更新菜单表格的内容
-(void)updataMenuTableInfo:(MenuModel *)model;

//查询菜单表格的数据
-(MenuModel *)selectMenuTableInfo;


//创建目录表格
-(void)creatCatalogInfo;
//向目录表格插入数据
-(void)insertCatalogInfo:(CatalogModel *)model;
//读取单条目录表格数据
-(CatalogModel *)selectCatalogInfoWithChapterId:(long)chapter_id;
//读取整个目录表格数据
-(NSMutableArray *)selectCatalogInfoWithBookId:(long)book_id;
//读取带标签的目录表格数据
-(NSMutableArray *)selectChapterLabelInfoWithBookId:(long)book_id;

//添加标签
-(void)updateCatalogInfoWith:(long)chapterId;
//删除标签
-(void)deleteChapter_labelWith:(long)chapterId;


//创建文章内容表格
-(void)creatContenInfoWith:(ContentModel *)model;
//向文章内容表格插入数据
-(void)insertContenInfo:(ContentModel *)model;
//读取文章表格的内容
-(ContentModel *)selectContentInfo:(long)chapter_id;
//读取文章所有的内容
-(NSMutableArray *)selectContentInfoWithBookId:(long)book_id;

//删除文章表格的内容
-(void)deleteContentInfoWith:(long)bookId;

@end
