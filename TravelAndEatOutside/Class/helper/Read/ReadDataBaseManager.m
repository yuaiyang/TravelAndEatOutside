//
//  ReadDataBaseManager.m
//  TravelAndEatOutside
//
//  Created by lanou4g on 15/10/21.
//  Copyright © 2015年 王振. All rights reserved.
//

#import "ReadDataBaseManager.h"

@implementation ReadDataBaseManager

{
    sqlite3 *database;
}

static  ReadDataBaseManager * clearCacher = nil;

+(ReadDataBaseManager *)shareDataManager{
    
    @synchronized(self) {
        if (clearCacher == nil) {
            clearCacher = [[ReadDataBaseManager alloc]init];
        }
    }
    return clearCacher;
}

#pragma mark -----计算缓存大小
//单个文件

-(long long)fileSizeAtPath:(NSString *)filePath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil]fileSize];
    }
    return 0;
    
}

//遍历文件夹获得文件夹大小，返回多少M
-(float)folderSize
{
    
    NSString * folderPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator * chileFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString * fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [chileFilesEnumerator nextObject])) {
        
        NSString * fileAbsouletePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize +=[self fileSizeAtPath:fileAbsouletePath];
    }
    
    
    return folderSize/(1024.0*1024);
}

//清除缓存
-(void)clearCache
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray * files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
        
        for (NSString * str in files) {
            NSError * error = nil;
            
            NSString * path = [cachePath stringByAppendingPathComponent:str];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        
    });
}


-(BOOL)creatDatabase
{
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[array lastObject]stringByAppendingPathComponent:@"bookInfo.sqlite"];
    
    int result = sqlite3_open(filePath.UTF8String, &database);
    if (result != SQLITE_OK) {
        CLog(@"创建失败");
        
        return NO;
    }
    
    CLog(@"%@",filePath);
    return YES;
}



- (BOOL)creatCollectTable
{
    const char *sql = "create table if not exists t_bookInfo (bookID integer primary key ,book_name text ,img_url text,isDownload text)";
    
    char *errmsg;
    int result = sqlite3_exec(database,sql ,NULL , NULL, &errmsg);
    
    if (result != SQLITE_OK) {
        CLog(@"创建收藏表失败");
        return NO;
    }
    
    
    return YES;
}

#pragma mark - 目录表格

//创建目录表格
-(void)creatCatalogInfo
{
    const char *sql = "create table if not exists t_catalogInfo (chapter_id integer primary key,chapter_name text,chapter_label integer,book_id)";
    char *errmsg;
    int result = sqlite3_exec(database, sql, NULL, NULL, &errmsg);
    if (result != SQLITE_OK) {
        CLog(@"创建目录表格失败");
    }
}

//插入目录表格数据

-(void)insertCatalogInfo:(CatalogModel *)model
{
    NSString *sql = [NSString stringWithFormat:@"insert into t_catalogInfo (chapter_id,chapter_name,chapter_label,book_id) values (%ld,'%@',%d,%ld)",model.chaperId,model.chapterName,model.chaper_label,model.book_id];
    char *errmsg = nil;
    sqlite3_exec(database, sql.UTF8String, NULL, NULL, &errmsg);
}

//读取目录表格数据
-(CatalogModel *)selectCatalogInfoWithChapterId:(long)chapter_id
{
    
    NSString *sql1 = [NSString stringWithFormat:@"select chapter_name,chapter_label from t_catalogInfo where chapter_id = %ld;",chapter_id];
    
    //定义SQL语句
    const char *sql = [sql1 UTF8String];
    
    //定义一个stmt，存放结果集
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    CatalogModel *model = [[CatalogModel alloc]init];
    if (result == SQLITE_OK) {
        //开始执行SQL语句
        //        int stepResult = sqlite3_step(stmt);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获得这行对应的数据
            //获得第0列的bookID
            
            model.chaperId = sqlite3_column_int(stmt, 0);
            const unsigned char *str = sqlite3_column_text(stmt, 1);
            model.chapterName = [NSString stringWithFormat:@"%s",str];
            model.chaper_label = sqlite3_column_int(stmt, 2);
            
        }
    }else
    {
        CLog(@"语句错误1");
    }
    return model;
    
}

//读取所有目录的数据

-(NSMutableArray *)selectCatalogInfoWithBookId:(long)book_id
{
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    NSString *sql1 = [NSString stringWithFormat:@"select chapter_id, chapter_name,chapter_label from t_catalogInfo where book_id = %ld;",book_id];
    
    //定义SQL语句
    const char *sql = [sql1 UTF8String];
    
    //定义一个stmt，存放结果集
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (result == SQLITE_OK) {
        //开始执行SQL语句
        //        int stepResult = sqlite3_step(stmt);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获得这行对应的数据
            CatalogModel *model = [[CatalogModel alloc]init];
            model.chaperId = sqlite3_column_int(stmt, 0);
            const unsigned char *chapter_name = sqlite3_column_text(stmt, 1);
            model.chaper_label = sqlite3_column_int(stmt, 2);
            
            model.chapterName = [NSString stringWithFormat:@"%s",chapter_name];
            
            [mArray addObject:model];
            
        }
    }else
    {
        CLog(@"语句错误2");
    }
    return mArray;
    
    
}
//读取带标签的目录表格

-(NSMutableArray *)selectChapterLabelInfoWithBookId:(long)book_id
{
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    NSString *sql1 = [NSString stringWithFormat:@"select chapter_id, chapter_name,chapter_label from t_catalogInfo where book_id = %ld and chapter_label = 1;",book_id];
    
    //定义SQL语句
    const char *sql = [sql1 UTF8String];
    
    //定义一个stmt，存放结果集
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (result == SQLITE_OK) {
        //开始执行SQL语句
        //        int stepResult = sqlite3_step(stmt);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获得这行对应的数据
            CatalogModel *model = [[CatalogModel alloc]init];
            model.chaperId = sqlite3_column_int(stmt, 0);
            const unsigned char *chapter_name = sqlite3_column_text(stmt, 1);
            model.chaper_label = sqlite3_column_int(stmt, 2);
            
            model.chapterName = [NSString stringWithFormat:@"%s",chapter_name];
            
            [mArray addObject:model];
            
        }
    }else
    {
        CLog(@"语句错误3");
    }
    return mArray;
    
}

//添加标签
-(void)updateCatalogInfoWith:(long)chapterId
{
    
    NSString *sql = [NSString stringWithFormat:@"update t_catalogInfo set chapter_label = 1 where chapter_id = %ld",chapterId];
    char *errmsg = nil;
    sqlite3_exec(database, sql.UTF8String, NULL, NULL, &errmsg);
}

//删除标签
-(void)deleteChapter_labelWith:(long)chapterId
{
    
    NSString *sql = [NSString stringWithFormat:@"update t_catalogInfo set chapter_label = 0 where chapter_id = %ld",chapterId];
    char *errmsg = nil;
    sqlite3_exec(database, sql.UTF8String, NULL, NULL, &errmsg);
    
}

#pragma mark - 菜单表格视图
//创建菜单表格
-(void)creatMenuTableInfo
{
    const char *sql = "create table if not exists t_settingInfo (font_Size  integer primary key,font_color integer ,day_night integer,pageTurn integer,process integer,crossScreen integer)";
    char *errmsg;
    int result = sqlite3_exec(database,sql ,NULL , NULL, &errmsg);
    
    if (result != SQLITE_OK) {
        CLog(@"创建菜单表失败");
        
    }
    
    NSString *insertSql = @"insert into t_settingInfo (font_Size,font_color,day_night,pageTurn,process,crossScreen) values (17,20,0,0,0,0)";
    
    char *errmsgs = nil;
    sqlite3_exec(database, insertSql.UTF8String, NULL, NULL, &errmsgs);
    
}

//更新菜单表数据
-(void)updataMenuTableInfo:(MenuModel *)model
{
    NSString *sql = [NSString stringWithFormat:@"update t_settingInfo set font_Size = %d,font_color = %ld,day_night = %d,pageTurn = %d,process = %d,crossScreen = %d",model.font_size,model.font_color,model.day_night,model.pageTurn,model.process,model.crossScreen];
    char *errmsg = nil;
    sqlite3_exec(database, sql.UTF8String, NULL, NULL, &errmsg);
    
    
}

//查询菜单表数据

-(MenuModel *)selectMenuTableInfo
{
    //定义SQL语句
    const char *sql = "select font_Size,font_color,day_night,pageTurn,process,crossScreen from t_settingInfo;";
    
    //定义一个stmt，存放结果集
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    MenuModel *model = [[MenuModel alloc]init];
    if (result == SQLITE_OK) {
        //开始执行SQL语句
        //        int stepResult = sqlite3_step(stmt);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获得这行对应的数据
            //获得第0列的bookID
            
            model.font_size = sqlite3_column_int(stmt, 0);
            model.font_color = sqlite3_column_int64(stmt, 1);
            model.day_night = sqlite3_column_int(stmt, 2);
            model.pageTurn = sqlite3_column_int(stmt, 3);
            model.process = sqlite3_column_int(stmt, 4);
            model.crossScreen = sqlite3_column_int(stmt, 5);
            
        }
    }else
    {
        CLog(@"语句错误4");
    }
    return model;
    
}


#pragma mark - 收藏表格操作



-(void)insertCollectInfoWith:(CollectModel *)model
{
    [self creatDatabase];
    [self creatCollectTable];
    
    NSString *sql = [NSString stringWithFormat:@"insert into t_bookInfo (bookID,book_name,img_url,isDownload) values (%ld,'%@','%@',%d);",model.bookId,model.book_name,model.img_url,model.isDownLoad];
    
    char *errmsg = nil;
    sqlite3_exec(database, sql.UTF8String, NULL, NULL, &errmsg);
//    [self closeDatabase];
}

-(NSMutableArray *)selectInfo
{
    NSMutableArray *mArray = [NSMutableArray array];
    //定义SQL语句
    const char *sql = "select bookID,book_name,img_url,isDownload from t_bookInfo;";
    
    //定义一个stmt，存放结果集
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (result == SQLITE_OK) {
        //开始执行SQL语句
        //        int stepResult = sqlite3_step(stmt);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获得这行对应的数据
            //获得第0列的bookID
            CollectModel *model = [[CollectModel alloc]init];
            int bookID = sqlite3_column_int(stmt, 0);
            const unsigned char *book_name = sqlite3_column_text(stmt, 1);
            const unsigned char *img_url = sqlite3_column_text(stmt, 2);
            model.bookId = bookID;
            model.book_name = [[NSString stringWithFormat:@"%s",book_name] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            model.img_url = [NSString stringWithFormat:@"%s",img_url];
            model.isDownLoad = sqlite3_column_int(stmt, 3);
            [mArray addObject:model];
            
        }
    }else
    {
        CLog(@"语句错误");
    }
    return mArray;
}


-(void)deleteCollecInfoWith:(long)bookId
{
    [self creatDatabase];
    [self creatCollectTable];
    sqlite3_stmt *stmt = NULL;
    NSString *sql = [NSString stringWithFormat:@"delete from t_bookInfo where bookId = %ld;",bookId];
    int result = sqlite3_prepare_v2(database,[sql UTF8String] , -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        sqlite3_step(stmt);
        
    }
    
    
}

-(void)closeDatabase
{
    sqlite3_close(database);
}

#pragma mark - 内容表格视图操作
//创建内容表格
-(void)creatContenInfoWith:(ContentModel *)model
{
    NSString *sql1 = [NSString stringWithFormat:@"create table if not exists t_%ldcontentInfo (chapter_id integer primary key,book_id integer,content text)",model.book_id];
    
    const char *sql = [sql1 UTF8String];
    char *errmsg;
    int result = sqlite3_exec(database, sql, NULL, NULL, &errmsg);
    if (result != SQLITE_OK) {
        CLog(@"创建目录表格失败");
    }
    
}
//往内容表格插入数据
-(void)insertContenInfo:(ContentModel *)model
{
    NSString *sql = [NSString stringWithFormat:@"insert into t_%ldcontentInfo (chapter_id,book_id,content) values (%ld,%ld,'%@');",model.book_id,model.chapter_id,model.book_id,model.content];
    char *errmsg = nil;
    sqlite3_exec(database, sql.UTF8String, NULL, NULL, &errmsg);
}

//读取内容表格内容

-(ContentModel *)selectContentInfo:(long)chapter_id
{
    NSString *sql1 = [NSString stringWithFormat:@"select content from t_contenInfo where chapter_id = %ld",chapter_id];
    
    
    //定义SQL语句
    const char *sql = [sql1 UTF8String];
    
    //定义一个stmt，存放结果集
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    ContentModel *model = [[ContentModel alloc]init];
    if (result == SQLITE_OK) {
        //开始执行SQL语句
        //        int stepResult = sqlite3_step(stmt);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获得这行对应的数据
            //获得第0列的bookID
            const unsigned char *str = sqlite3_column_text(stmt, 2);
            model.content = [NSString stringWithFormat:@"%s",str];
            
        }
    }else
    {
        CLog(@"语句错误5");
    }
    return model;
    
    
}
//读取内容表格所有内容

-(NSMutableArray *)selectContentInfoWithBookId:(long)book_id
{
    NSMutableArray *mArray = [NSMutableArray array];
    
    NSString *sql1 = [NSString stringWithFormat:@"select content from t_%ldcontentInfo",book_id];
    
    //定义SQL语句
    const char *sql = [sql1 UTF8String];
    
    //定义一个stmt，存放结果集
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    
    if (result == SQLITE_OK) {
        //开始执行SQL语句

        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //获得这行对应的数据
            ContentModel *model = [[ContentModel alloc]init];
            
            const unsigned char *str = sqlite3_column_text(stmt, 2);
            
            model.content = [NSString stringWithFormat:@"%s",str];
            CLog(@"%@",model.content);
            
            [mArray addObject:model];
        }
    }else
    {
        CLog(@"语句错误6");
    }
    return mArray;
}

//删除存储的内容
-(void)deleteContentInfoWith:(long)bookId
{
    NSString *sql = [NSString stringWithFormat:@"drop table t_%ldcontentInfo",bookId];
    char *errmsg = nil;
    sqlite3_exec(database, sql.UTF8String, NULL, NULL, &errmsg);
    
}

@end
