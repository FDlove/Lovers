//
//  PersonalModel.m
//  Lovers
//
//  Created by student on 16/1/13.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import "PersonalModel.h"
#import "PersonalImageModel.h"
@implementation PersonalModel
-(void)loadStatusData:(NSString *)owner
{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"PersonalInfo"];
    
    [bquery whereKey:@"owner" equalTo:owner];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count==0) {
            NSLog(@"用户不存在");
        }else{
            [self getarray:array];
        }
    }];
}
-(void)getarray:(NSArray *)array
{
    PersonalModel *model=[[PersonalModel alloc]init];
    for (BmobObject *obj in array) {
        
        model.Name=[obj objectForKey:@"Name"];
        model.birthDate=[obj objectForKey:@"birthDate"];
        model.schoolName=[obj objectForKey:@"schoolName"];
        model.sex=[obj objectForKey:@"Sex"];
        model.Lovers=[obj objectForKey:@"Lovers"];
        model.objectId=obj.objectId;
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"personalInfoImage"];
        
        [bquery whereKey:@"owner" equalTo:obj.objectId];
        
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            if (array.count==0) {
                self.returnBlock(model);
                NSLog(@"hahaha");
            }else{
                model.imageArray=[NSMutableArray array];
             //   NSMutableArray *backArray=[NSMutableArray array];
                for (BmobObject *obj in array) {
                    
                    BmobFile *file=[obj objectForKey:@"image"];
                    if (file.url) {
                        [model.imageArray insertObject:file.url atIndex:0];
                    }
                    
                }
                self.returnBlock(model);
            }
        }];
       self.returnBlock(model);
    }
}
@end
