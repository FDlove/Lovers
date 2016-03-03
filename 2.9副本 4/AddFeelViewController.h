//
//  AddFeelViewController.h
//  Lovers
//
//  Created by student on 16/1/11.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
@protocol updatedelegate
-(void)upDate;
@end
@interface AddFeelViewController : UIViewController
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)id<updatedelegate>delegate;
@end
