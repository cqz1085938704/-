//
//  EmotionListView.h
//  图文混排
//
//  Created by caiyao's Mac on 15/10/14.
//  Copyright © 2015年 core's Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Global.h"

@protocol EmotionListViewDelegate <NSObject>

- (void) imageViewTapedWithTag:(NSInteger)index;

@end

@interface EmotionListView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, assign) id<EmotionListViewDelegate>delegate;

@end
