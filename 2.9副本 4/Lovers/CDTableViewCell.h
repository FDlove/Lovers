//
//  CDTableViewCell.h
//  Lovers
//
//  Created by student on 16/1/19.
//  Copyright © 2016年 FDDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *DayLabel;
@property (weak, nonatomic) IBOutlet UILabel *Year_monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContextLabel;
@property (weak, nonatomic) IBOutlet UILabel *DayNumberLabel;


@end
