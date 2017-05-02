//
//  PullDownView.m
//  Palm365
//
//  Created by yangdong on 14-11-26.
//  Copyright (c) 2014年 杨栋. All rights reserved.
//

#import "PullDownView.h"

@interface PullDownView()

@property (nonatomic,strong)UIImageView     *mMenuView;
@property (nonatomic,strong)UIImageView     *mExtraView;

@property (nonatomic,strong)UIControl       *mControl_menu;

@end

@implementation PullDownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mMenuView = [[UIImageView alloc] init];
        self.mMenuView.backgroundColor = [UIColor clearColor];
        self.mMenuView.userInteractionEnabled = YES;
        [self addSubview:self.mMenuView];
        
        self.mControl_menu = [[UIControl alloc] init];
        self.mControl_menu.backgroundColor = [UIColor clearColor];
        [self.mControl_menu addTarget:self action:@selector(clickToMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mControl_menu];
        
        self.mExtraView = [[UIImageView alloc] init];
        self.mExtraView.backgroundColor = [UIColor clearColor];
        self.mExtraView.userInteractionEnabled = YES;
        self.mExtraView.clipsToBounds = YES;
        
        self.mControl_over = [[UIControl alloc] init];
        self.mControl_over.backgroundColor = [UIColor clearColor];
        [self.mControl_over addTarget:self action:@selector(overTo:) forControlEvents:UIControlEventTouchUpInside];
        
        self.mDuration = 0.12f;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss:) name:NOTIFY_PULLDOWNVIEW object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)layoutSubviews
{
    self.mMenuView.frame = self.bounds;
    self.mControl_menu.frame = self.mMenuView.frame;
    self.mControl_over.frame = self.superview.bounds;
    
    [self reloadForTitles:YES];
    
    [super layoutSubviews];
}

- (void)clickToMenu:(id)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(ShowMenu) object:nil];
    [self performSelector:@selector(ShowMenu) withObject:nil afterDelay:0.01];
}


-(void)ShowMenu{
    
    if (CGRectEqualToRect(self.mExtraView.frame, CGRectZero)) {
        [self expand];
    }else{
        [self withdraw];
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)overTo:(id)sender
{
    [self dismiss:nil];
}

- (void)dismiss:(NSNotification *)notify
{
    if (self.isGolden) {
        self.mMenuView.image = nil;
    }

    [self withdraw];
}

- (void)expand
{
    self.isPulled = YES;
    if([self.mPullDownViewDelegate respondsToSelector:@selector(pullDownView:withExtraView:)])
    {
        for (;[self.mExtraView subviews].count>0;) {
            UIView *aview = [[self.mExtraView subviews] objectAtIndex:0];
            [aview removeFromSuperview];
            aview = nil;
        }
        [self.mPullDownViewDelegate pullDownView:self withExtraView:self.mExtraView];
    }
    
    if (self.mPullDownViewDelegate && [self.mPullDownViewDelegate respondsToSelector:@selector(pullDownView:withOverView:)]) {
        for (;[self.mControl_over subviews].count>0;) {
            UIView *aview = [[self.mControl_over subviews] objectAtIndex:0];
            [aview removeFromSuperview];
            aview = nil;
        }
        [self.mPullDownViewDelegate pullDownView:self withOverView:self.mControl_over];
    }
    
    [self.superview insertSubview:self.mControl_over belowSubview:self.mExtraView];
    CGRect originFrame = self.mExtraView.frame;
    switch (self.mDircetion) {
        case PullDownDirection_down:
            self.mExtraView.frame = CGRectMake(CGRectGetMinX(originFrame), CGRectGetMinY(originFrame), CGRectGetWidth(originFrame), 0);
            break;
        case PullDownDirection_up:
            self.mExtraView.frame = CGRectMake(CGRectGetMinX(originFrame), CGRectGetMaxY(originFrame), CGRectGetWidth(originFrame), 0);
            break;
        case PullDownDirection_left:
            self.mExtraView.frame = CGRectMake(CGRectGetMaxX(originFrame), CGRectGetMinY(originFrame), 0, CGRectGetHeight(originFrame));
            break;
        case PullDownDirection_right:
            self.mExtraView.frame = CGRectMake(CGRectGetMinX(originFrame), CGRectGetMinY(originFrame), 0, CGRectGetHeight(originFrame));
            break;
    }
    self.mControl_over.alpha = 0.2f;
    [UIView animateWithDuration:self.mDuration animations:^{
        self.mExtraView.frame = originFrame;
        self.mControl_over.alpha = 1.0f;
    }completion:nil];
    
    if ([self.mPullDownViewDelegate respondsToSelector:@selector(pullDownViewToExpand:)])
    {
        [self.mPullDownViewDelegate pullDownViewToExpand:self];
    }
}

- (void)withdraw
{
    self.isPulled = NO;
    [UIView animateWithDuration:self.mDuration animations:^{
        self.mControl_over.alpha = 0.0f;
        switch (self.mDircetion) {
            case PullDownDirection_down:
                self.mExtraView.frame = CGRectMake(CGRectGetMinX(self.mExtraView.frame), CGRectGetMinY(self.mExtraView.frame), CGRectGetWidth(self.mExtraView.frame), 0);
                break;
            case PullDownDirection_up:
                self.mExtraView.frame = CGRectMake(CGRectGetMinX(self.mExtraView.frame), CGRectGetMaxY(self.mExtraView.frame), CGRectGetWidth(self.mExtraView.frame), 0);
                break;
            case PullDownDirection_left:
                self.mExtraView.frame = CGRectMake(CGRectGetMaxX(self.mExtraView.frame), CGRectGetMinY(self.mExtraView.frame), 0, CGRectGetHeight(self.mExtraView.frame));
                break;
            case PullDownDirection_right:
                self.mExtraView.frame = CGRectMake(CGRectGetMinX(self.mExtraView.frame), CGRectGetMinY(self.mExtraView.frame), 0, CGRectGetHeight(self.mExtraView.frame));
                break;
        }
    }completion:^(BOOL finished){
        for (;[self.mExtraView subviews].count>0;) {
            UIView *aview = [[self.mExtraView subviews] objectAtIndex:0];
            [aview removeFromSuperview];
            aview = nil;
        }
        [self.mControl_over removeFromSuperview];
        self.mExtraView.frame = CGRectZero;
        [self.mExtraView removeFromSuperview];
        [self reloadForTitles:NO];
      
    }];
    
    if ([self.mPullDownViewDelegate respondsToSelector:@selector(pullDownViewToWithdraw:)])
    {
        [self.mPullDownViewDelegate pullDownViewToWithdraw:self];
    }
    
}

- (void)reloadForTitles
{
    [self reloadForTitles:NO];
}

- (void)reloadForTitles:(BOOL)isInit
{
    if (self.mPullDownViewDelegate)
    {
        if([self.mPullDownViewDelegate respondsToSelector:@selector(pullDownView:withMenuView:isInit:)])
        {
            if (isInit) {
                for (;[self.mMenuView subviews].count>0;) {
                    UIView *aview = [[self.mMenuView subviews] objectAtIndex:0];
                    [aview removeFromSuperview];
                    aview = nil;
                }
            }
            [self.mPullDownViewDelegate pullDownView:self withMenuView:self.mMenuView isInit:isInit];
        }
    }
}
-(UIView *)GetMenuView{
    if (self.mMenuView!=nil) {
        return  self.mMenuView;
    }
    return nil;
}
-(UIView *)GetExtraView{
    if (self.mExtraView!=nil) {
        return  self.mExtraView;
    }
    return nil;
}



@end
