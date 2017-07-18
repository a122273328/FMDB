//
//  ViewController.m
//  FMDB
//
//  Created by WZH on 16/6/7.
//  Copyright © 2016年 WZH. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
@interface ViewController ()

@property (nonatomic, strong)FMDatabase *db;

@property (nonatomic, strong)FMDatabasePool *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //获取数据库文件路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"wzh.sqlite"];
    
    //获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    self.queue = [FMDatabasePool databasePoolWithPath:fileName];
    
    //打开数据库
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' INTEGER, '%@' TEXT)",@"t_wzh",@"ID",@"name",@"age",@"address"];

        
        BOOL result = [db executeUpdate:sqlCreateTable];
        if (result) {
            
            NSLog(@"创建成功");
        }else{
        
            NSLog(@"创建失败");
        }
        
        self.db = db;
    }
}


- (IBAction)insertAction:(id)sender {
    [self insert];
}
- (IBAction)queryAction:(id)sender {
    
    [self query];
}

- (void)insert
{
    for (int i = 0; i < 10; i ++) {
        NSString *name = [NSString stringWithFormat:@"wzh-%d",i];
        
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@','%@','%@')",
                               @"t_wzh",@"name",@"age",@"address", name, @"13", @"南京"];
        [self.db executeUpdate:insertSql1];
    }
    
    
   
}

- (void)query
{
    //执行查询语句
    NSString * sql = [NSString stringWithFormat:
                      @"SELECT * FROM %@",@"t_wzh"];
    FMResultSet *resultSet = [self.db executeQuery:sql];
    
    //遍历结果
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"ID"];
        NSString *name = [resultSet stringForColumn:@"name"];
        int age = [resultSet intForColumn:@"age"];
        NSString *address = [resultSet stringForColumn:@"address"];
        NSLog(@"用户ID:%d,用户名字:%@,用户年龄:%d,用户的地址:%@",ID,name,age,address);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.queue inDatabase:^(FMDatabase *db) {
        
        [self.db beginTransaction];
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@','%@','%@')",
                               @"t_wzh",@"name",@"age",@"address", @"wangzhihao", @"25", @"郑州"];
        NSString *insertSql2= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@','%@','%@')",
                               @"t_wzh",@"name",@"age",@"address", @"wangzhihao", @"26", @"河南"];
        NSString *insertSql3= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@','%@','%@')",
                               @"t_wzh",@"name",@"age",@"address", @"wangzhihao", @"27", @"郑州"];
        NSString *insertSql4= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@','%@','%@')",
                               @"t_wzh",@"name",@"age",@"address", @"wangzhihao", @"28", @"河南"];
        [self.db executeUpdate:insertSql1];
        [self.db executeUpdate:insertSql2];
        [self.db executeUpdate:insertSql3];
        [self.db executeUpdate:insertSql4];
        
        BOOL value = [self.db commit];
        
        if (value) {
            
            NSLog(@"操作成功");
        }else{
        
            NSLog(@"操作失败，数据回滚");
        }
        
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
