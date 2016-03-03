//
//  PhotoWallViewController.h
//  Lovers
//
//  Created by student on 16/1/21.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalModel.h"
@protocol PhotoWallViewControllerDelegate
-(void)UpImageWallData:(NSMutableArray *)array;
@end
@interface PhotoWallViewController : UIViewController
@property(nonatomic,strong)NSMutableArray *ImageArray;
@property(nonatomic,strong)id<PhotoWallViewControllerDelegate>delegate;
@property(nonatomic,strong)NSMutableArray *ImageDataArray;//存放的是image
@end
