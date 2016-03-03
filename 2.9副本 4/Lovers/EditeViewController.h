//
//  EditeViewController.h
//  Lovers
//
//  Created by student on 16/1/19.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComDayModel.h"
@protocol ComDayModelDelegate
@optional
-(void)CancleCDData:(NSIndexPath *)index;
@end

@interface EditeViewController : UIViewController
@property(nonatomic,strong) ComDayModel *model;
@property(nonatomic,strong)id<ComDayModelDelegate>delegate;
@end
