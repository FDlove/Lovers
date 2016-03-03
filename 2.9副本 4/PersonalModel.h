//
//  PersonalModel.h
//  Lovers
//
//  Created by student on 16/1/13.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
typedef void (^Returnperson) (id repondResult);
@interface PersonalModel : NSObject
@property(nonatomic,strong)NSString *objectId;
@property(nonatomic,strong)NSString *Name;
@property(nonatomic,strong)NSDate *birthDate;
@property(nonatomic,strong)NSString *schoolName;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *Lovers;

@property(nonatomic,strong)NSString *headImageUrl;

@property(nonatomic,strong)NSMutableArray *imageArray;

@property(nonatomic,strong)Returnperson returnBlock;

-(void)loadStatusData:(NSString *)owner;
@end
