//
//  ComDayModel.h
//  Lovers
//
//  Created by student on 16/1/18.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^BlockValue)(id responder);
@interface ComDayModel : NSObject
@property(nonatomic,strong)NSString *belongName;
@property(nonatomic,strong)NSString *Context;
@property(nonatomic,strong)NSString *Date;
@property(nonatomic,strong)BlockValue returnBlock;
@property(nonatomic,strong)NSString *Daynumber;
@property(nonatomic,strong)NSString *objectId;
@property(nonatomic,strong)NSIndexPath *index;
-(void)loadCDModelDate:(NSString *)blName;
@end
