//
//  StatusModel.m
//  Lovers
//
//  Created by student on 15/12/29.
//  Copyright © 2015年 FDDeveloper. All rights reserved.
//

#import "StatusModel.h"
#import <BmobSDK/Bmob.h>

@implementation StatusModel


-(void)loadStatusData:(NSString *)belongName
{
    self.imageArray=[NSMutableArray array];
    NSArray *temparray = [belongName componentsSeparatedByString:@"+"];
    NSLog(@"%@",temparray);
    NSString *str=[NSString stringWithFormat:@"%@+%@",temparray[0],temparray[1]];
    NSString *str1=[NSString stringWithFormat:@"%@+%@",temparray[1],temparray[0]];
    NSMutableArray *checkarray=[NSMutableArray array];
    [checkarray addObject:str];
    [checkarray addObject:str1];
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Timers"];
    
    [bquery whereKey:@"belongName" containedIn:checkarray];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0) {
            NSLog(@"用户不存在");
        }else{
            [self getarray:array];

        }
    }];
   
}
-(void)getarray:(NSArray *)resultArray
{
    NSMutableArray *backArray=[NSMutableArray array];
    for (BmobObject *obj in resultArray) {

        StatusModel *model=[[StatusModel alloc]init];

       // model.imageArray=[NSMutableArray array];
        model.feelContent=[obj objectForKey:@"feelContent"];
        
        NSDate *createDate = [obj objectForKey:@"createdAt"];
        
        model.createDate=createDate;
        
        model.objectId=obj.objectId;
        
        model.Address=[obj objectForKey:@"Address"];
        
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Image"];
        
        [bquery whereKey:@"owner" equalTo:obj.objectId];
        
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (array.count==0) {
                NSLog(@"用户不存在");
            }else{
                
                model.imageArray=[NSMutableArray array];
                for (BmobObject *obj in array) {
                    BmobFile *file =[obj objectForKey:@"Image"];
                    NSString *str =file.url;
                    [model.imageArray insertObject:str atIndex:0];
                }
            }
        }];
        [backArray insertObject:model atIndex:0];
        self.returnBlock(backArray);

    }


}


@end
