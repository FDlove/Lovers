//
//  StatusCell.m
//  Lovers
//
//  Created by student on 15/12/29.
//  Copyright © 2015年 FDDeveloper. All rights reserved.
//

#import "StatusCell.h"
#import "StatusModel.h"

@implementation StatusCell
+ (StatusCell *)statusCellWith:(UITableView *)tableView withIdentifier:(NSString *)identifier
{
    
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell==nil) {
        cell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
    
}
//重写set方法
- (void)setStatus:(StatusModel *)status{
    _status = status;
    [self setUpUI];
    
    [self setViewFrame];
}

- (void)setUpUI{
    for(UIView *sub in [self subviews]){
        [sub removeFromSuperview];
    }
    
    
    myImageView=[[ClickImage alloc]init];
    ImageView=[[UIView alloc]init];
    [self addSubview:ImageView];
    feelContenyLabel = [[UILabel alloc] init];
    feelContenyLabel.numberOfLines = 0;
   
    createDateLable = [[UILabel alloc] init];
    createDateLable.textColor = [UIColor lightGrayColor];
    createDateLable.font = [UIFont systemFontOfSize:10];
    
    AddressLabel =[[UILabel alloc]init];
    AddressLabel.textColor=[UIColor blackColor];
    AddressLabel.font = [UIFont systemFontOfSize:10];
    
    self.cancleButton =[[UIButton alloc]init];
    
    createDateLable.font = [UIFont systemFontOfSize:10];
    
    verticalline=[[UIView alloc]init];
    horizontalline=[[UIView alloc]init];
    
    LoverImageView =[[UIImageView alloc]init];
    
   
    [self addSubview:myImageView];
    [self addSubview:feelContenyLabel];
    [self addSubview:createDateLable];
    [self addSubview:AddressLabel];
    [self addSubview:self.cancleButton];
    [self addSubview:verticalline];
    [self addSubview:horizontalline];
    [self addSubview:LoverImageView];
}



- (void)setViewFrame{
    
    //图片
    if (_status.imageArray==nil) {
        NSLog(@"没有照片");
    }else{
        
        //判断数组中有几张图片 根据图片张数定义View的frame
        if (_status.imageArray.count<=3) {
            int height=(_status.imageArray.count-1)/3+1;
            [self LoadImage:height];
                            //        //第三方
            //        ImageModel *model=_status.imageArray[0];
            //    [myImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
            
            
        }else if(_status.imageArray.count<=6)
        {
            int height=(_status.imageArray.count-1)/3+1;
            [self LoadImage:height];
            
        }else{
            
        
            int height=(_status.imageArray.count-1)/3+1;
            [self LoadImage:height];
       
        }

    }
    //内容
    CGFloat content_x = UITableViewSpaceMargin_x;
    CGFloat content_y =CGRectGetMaxY(ImageView.frame)+UITableViewSpaceMargin_y;
    CGFloat content_width = winWidth-UITableViewSpaceMargin_x-5;
    //多行自适应
    feelContenyLabel.text = _status.feelContent;
    CGSize content_size = [feelContenyLabel.text boundingRectWithSize:CGSizeMake(100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    [feelContenyLabel setFrame:CGRectMake(content_x, content_y, content_width, content_size.height)];
    
    //时间
    //多行自适应
    createDateLable.text =[NSString stringWithFormat:@"%@", _status.createDate];
    CGFloat CreataDate_x = UITableViewSpaceMargin_x;
    CGFloat CreateDate_y=CGRectGetMaxY(feelContenyLabel.frame)+3;
    
    CGSize createDateLable_size = [createDateLable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    [createDateLable setFrame:CGRectMake(CreataDate_x, CreateDate_y, createDateLable_size.width, createDateLable_size.height)];
    //定位
    AddressLabel.text=_status.Address;
    [AddressLabel  setFont:[UIFont  systemFontOfSize:10]];
    CGFloat AddressLabel_x=CGRectGetMaxX(createDateLable.frame)+3;
    CGFloat AddressLabel_y=CreateDate_y;
    [AddressLabel  setFrame:CGRectMake(AddressLabel_x, AddressLabel_y, 50, 10)];
    
 
    //删除button
    [self.cancleButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.cancleButton  setTitleColor:[UIColor  colorWithRed:27/255.0 green:151/255.0 blue:238/255.0 alpha:1] forState:UIControlStateNormal];

    [self.cancleButton.titleLabel  setFont:[UIFont  systemFontOfSize:10]];
    CGFloat cancleButton_x=CGRectGetMaxX(AddressLabel.frame);
    CGFloat cancleButton_y=CreateDate_y;
   [self.cancleButton setFrame:CGRectMake(cancleButton_x, cancleButton_y, 50, 10)];
    
    [self.cancleButton  addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    
    
    _height = CGRectGetMaxY(createDateLable.frame)+UITableViewSpaceMargin_y;
    
    //竖线
    [verticalline setFrame:CGRectMake(40, 2, 3, _height)];
    [verticalline setBackgroundColor:[UIColor lightGrayColor]];
    
    
    //横线
    [horizontalline setFrame:CGRectMake(40, 30, 30, 3)];
    [horizontalline setBackgroundColor:[UIColor lightGrayColor]];
    
    [LoverImageView setFrame:CGRectMake(30, 20, 20  , 20)];
    [LoverImageView setImage:[UIImage imageNamed:@"爱心"]];

}
//加载显示图片
-(void)LoadImage:(int)height
{
    //设置每张图片的大小
    CGFloat image_width=(winWidth-UITableViewSpaceMargin_x-9)/3;
    CGFloat image_height=image_width;
    
    CGFloat ImageView_x = UITableViewSpaceMargin_x;
    CGFloat ImageView_y =UITableViewSpaceMargin_y;
    CGFloat ImageView_width = winWidth-UITableViewSpaceMargin_x;
    
    CGFloat ImageView_height=image_height*height;
    
    [ImageView setFrame:CGRectMake(ImageView_x, ImageView_y, ImageView_width, ImageView_height)];
    
    for (int i=0;i<_status.imageArray.count;i++) {
        int row=i/3+1;
        int arr=i%3+1;
        ClickImage *image=[[ClickImage alloc]init];
        image.canClick=YES;
        [image sd_setImageWithURL:[NSURL URLWithString:_status.imageArray[i]]];
        [image setFrame:CGRectMake(3*arr+(arr-1)*image_width,3*row +(row -1)*image_height , image_width, image_height)];
        [ImageView addSubview:image];
    }

}
//点击button删除cell
-(void)cancle
{
    NSLog(@"点击删除本条数据");
    [self.delegate CancleData:self.index];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
