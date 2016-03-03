//
//  PersonalImageModel.m
//  Lovers
//
//  Created by student on 16/1/13.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import "PersonalImageModel.h"

@implementation PersonalImageModel
-(void)getUrl:(NSString *)owner
{
    NSLog(@"%@",owner);
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"personalInfoImage"];
    
    [bquery whereKey:@"owner" equalTo:owner];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count==0) {
            NSLog(@"11111");
        }else{
            [self getarray:array];
            
        }
    }];
    
}
-(void)getarray:(NSArray *)array
{
    NSMutableArray *backArray=[NSMutableArray array];
    for (BmobObject *obj in array) {
        

    
        BmobFile *file=[obj objectForKey:@"image"];
        if (file.url) {
            [backArray insertObject:file.url atIndex:0];
        }
        
    }
    //通知执行添加方法
    NSNotification * notice = [NSNotification notificationWithName:@"123" object:nil userInfo:@{@"1":backArray}];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    NSLog(@"%@",backArray);
    self.returnBlock(backArray);
}
@end
