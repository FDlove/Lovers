//
//  ComDayModel.m
//  Lovers
//
//  Created by student on 16/1/18.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import "ComDayModel.h"
#import <BmobSDK/Bmob.h>
@implementation ComDayModel
-(void)loadCDModelDate:(NSString *)blName
{
    NSMutableArray *DateArray=[NSMutableArray array];
    
    NSArray *temparray = [blName componentsSeparatedByString:@"+"];
    NSLog(@"%@",temparray);
    NSString *str=[NSString stringWithFormat:@"%@+%@",temparray[0],temparray[1]];
    NSString *str1=[NSString stringWithFormat:@"%@+%@",temparray[1],temparray[0]];
    NSMutableArray *checkarray=[NSMutableArray array];
    [checkarray addObject:str];
    [checkarray addObject:str1];
    BmobQuery *query=[BmobQuery queryWithClassName:@"CommenDay"];
    [query whereKey:@"owner" containedIn:checkarray];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0) {
            NSLog(@"纪念日里没有查询到符合条件的数据");
        }else{
            for (BmobObject *obj in array) {
                ComDayModel *model=[[ComDayModel alloc]init];
                model.belongName=[obj objectForKey:@"owner"];
                model.Context=[obj objectForKey:@"context"];
                model.objectId=obj.objectId;
                model.Date=[obj  objectForKey:@"Date"];
                [DateArray addObject:model];
                
            }
            self.returnBlock(DateArray);
        }
    }];
}
@end
