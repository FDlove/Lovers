//
//  PersonalImageModel.h
//  Lovers
//
//  Created by student on 16/1/13.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
typedef void (^ReturnepersonalImage) (id repondResult);
@interface PersonalImageModel : NSObject
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)ReturnepersonalImage returnBlock;
-(void)getUrl:(NSString *)owner;
@end
