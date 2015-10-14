//
//  EmotionListView.m
//  图文混排
//
//  Created by caiyao's Mac on 15/10/14.
//  Copyright © 2015年 core's Mac. All rights reserved.
//

#import "EmotionListView.h"

@interface EmotionListView ()
{
    UIPageControl *pageControl;
}
@end

@implementation EmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.pagingEnabled = YES;
        self.contentSize = CGSizeMake(frame.size.width * 5, frame.size.height);
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        pageControl.numberOfPages = 5;
        pageControl.currentPage = 0;
        [self addSubview:pageControl];
        pageControl.center = CGPointMake(frame.size.width/2.0, frame.size.height - 10);
        
        for (int i = 0; i < 5; i ++)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height)];
            [self addSubview:view];
            
            for (int j = 0; j < 24; j ++)
            {
                float hSpace = (view.frame.size.width - 240)/9.0;
                float vSpace = (view.frame.size.height - 90)/4.0;
                
                UIButton *imageView = [UIButton buttonWithType:UIButtonTypeCustom];
                [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Expression_%i", 24 * i + j + 1]] forState:UIControlStateNormal];
                imageView.frame = CGRectMake(hSpace + (30.0 + hSpace) * (j % 8), vSpace + (30.0 + vSpace) * (j / 8), 30, 30);
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.tag = 24 * i + j + 1;
                [imageView addTarget:self action:@selector(handleImageTap:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:imageView];
            }
            
        }
    }
    return self;
}

- (void) handleImageTap:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewTapedWithTag:)])
    {
        [self.delegate imageViewTapedWithTag:sender.tag];
    }
}

@end
