//
//  StatusModel.h
//  Lovers
//
//  Created by student on 15/12/29.
//  Copyright © 2015年 FDDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ReturnValue) (id repondResult);
@interface StatusModel : NSObject

@property(nonatomic,strong)NSString *objectId;
@property(nonatomic,strong)NSString *profileImageUrl;
@property(nonatomic,strong)NSString *feelContent;
@property(nonatomic,strong)NSDate *createDate;
@property(nonatomic,strong)NSString *Address;
@property(nonatomic,strong)NSMutableArray *imageArray;

@property(nonatomic,strong)ReturnValue returnBlock;
@property(nonatomic,strong)ReturnValue returnImageBlock;
-(void)loadStatusData:(NSString *)belongName;
//-(void)aaa:(NSString *)modelId;
@end
