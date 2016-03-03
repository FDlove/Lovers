//
//  mycoverFlowLayout.m
//  collectionview
//
//  Created by student on 15/12/11.
//  Copyright © 2015年 NIIT. All rights reserved.
//

#import "mycoverFlowLayout.h"

@implementation mycoverFlowLayout
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    
    
    //proposedContentOffset惯性偏移值
    CGFloat centerX=proposedContentOffset.x+self.collectionView.bounds.size.width*0.5;
    //计算可视区域
    CGFloat visibleX=proposedContentOffset.x;
    CGFloat visibleY=proposedContentOffset.y;
    CGFloat visibleW=self.collectionView.bounds.size.width;
    CGFloat visibleH=self.collectionView.bounds.size.height;
    CGRect  visibleRect=CGRectMake(visibleX, visibleY, visibleW, visibleH);
    
    //获取给定区域内的cell的Attribute对象
    NSArray *arrayAttrs=[self layoutAttributesForElementsInRect:visibleRect];
    
    //比较出最小的偏移
    int  min_idx=0;
    UICollectionViewLayoutAttributes *min_attr=arrayAttrs[min_idx];
    //循环比较出最小的
    for (int i=1;i<arrayAttrs.count;i++) {
        //计算两个距离
        //1min_attr 和中心点得距离
        CGFloat distance1=ABS(min_attr.center.x-centerX);
        //当前循环的attr对象和centerX的距离
        UICollectionViewLayoutAttributes *obj=arrayAttrs[i];
        CGFloat distance2=ABS(obj.center.x-centerX);
        if (distance2<distance1) {
            min_idx=i;
            min_attr=obj;
        }
    }
    //计算出最小的偏移值
    CGFloat offsetX= min_attr.center.x -centerX;
    return CGPointMake(proposedContentOffset.x+offsetX, proposedContentOffset.y);
    
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *arrayAttrs=[super layoutAttributesForElementsInRect:rect];
    CGFloat centerX=self.collectionView.contentOffset.x+self.collectionView.bounds.size.width*0.5;
    for (UICollectionViewLayoutAttributes *attr in arrayAttrs) {
        CGFloat distance=ABS(attr.center.x-centerX);
        CGFloat f=0.004;
        CGFloat scale=1/(1+distance*f);
        attr.transform=CGAffineTransformMakeScale(scale, scale);
        
    }
    return  arrayAttrs;
}
@end
