//
//  PullDownView.h
//  Palm365
//
//  Created by yangdong on 14-11-26.
//  Copyright (c) 2014年 杨栋. All rights reserved.
//

#define NOTIFY_PULLDOWNVIEW @"PullDownView"

typedef NS_OPTIONS(NSUInteger, PullDownDirection) {
    PullDownDirection_down,
    PullDownDirection_up,
    PullDownDirection_left,
    PullDownDirection_right
};

@class PullDownView;
@protocol PullDownViewDelegate <NSObject>
@optional
- (void)pullDownView:(PullDownView *)view withOverView:(UIControl *)overView;
- (void)pullDownView:(PullDownView *)view withMenuView:(UIImageView *)menuView isInit:(BOOL)is;
- (void)pullDownView:(PullDownView *)view withExtraView:(UIImageView *)extraView;
- (void)pullDownViewToExpand:(PullDownView *)view;
- (void)pullDownViewToWithdraw:(PullDownView *)view;
@end

@interface PullDownView : UIView
@property (nonatomic,assign)NSTimeInterval              mDuration;
@property (nonatomic,assign)PullDownDirection           mDircetion;
@property (nonatomic,strong)id<PullDownViewDelegate>    mPullDownViewDelegate;
@property (nonatomic,assign)BOOL                        isPulled;
@property (nonatomic,strong)UIControl                   *mControl_over;


///刷新标题
-(void)reloadForTitles;

-(UIView *)GetMenuView;
-(UIView *)GetExtraView;
-(void)withdraw;
@end
