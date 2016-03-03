//
//  StatusCell.h
//  Lovers
//
//  Created by student on 15/12/29.
//  Copyright © 2015年 FDDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import <BmobSDK/Bmob.h>
#import "ClickImage.h"
@protocol StatusCellDelegate

@optional
-(void)CancleData:(NSIndexPath *)index;
@end

@class StatusModel;
@interface StatusCell : UITableViewCell
{
    
    
    ClickImage *myImageView;
    UIView *ImageView;
    UILabel *feelContenyLabel;
    UILabel *createDateLable;
    UILabel *AddressLabel;
    UIView *verticalline;
    UIView *horizontalline;
    UIImageView *LoverImageView;
    
}

@property (nonatomic, strong) StatusModel *status;
@property (nonatomic, assign) CGFloat height;
@property(nonatomic,strong)NSString *belongName;
@property (nonatomic,strong)NSIndexPath *index;
@property (nonatomic, strong)UIButton *cancleButton;

@property(nonatomic,strong)id<StatusCellDelegate>delegate;

@property (nonatomic, strong) NSOperationQueue *queue;
+ (StatusCell *)statusCellWith:(UITableView *)tableView withIdentifier:(NSString *)identifier;
@end
