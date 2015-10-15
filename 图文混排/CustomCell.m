//
//  CustomCell.m
//  图文混排
//
//  Created by caiyao's Mac on 15/10/15.
//  Copyright © 2015年 core's Mac. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.imageView.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

-(void)generate
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.textLabel.frame.origin.x + self.textLabel.frame.size.width, 20)];
    [path addLineToPoint:CGPointMake(self.textLabel.frame.origin.x + self.textLabel.frame.size.width + 8, 25)];
    [path addLineToPoint:CGPointMake(self.textLabel.frame.origin.x + self.textLabel.frame.size.width, 30)];
    [path fill];

     CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor redColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.path = path.CGPath;
    
    [self.layer addSublayer:layer];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = [self.textLabel.text boundingRectWithSize:CGSizeMake(WIN_SIZE.width - 10 - 60 - 10 - 10, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    CGFloat height = rect.size.height + 10;
    NSLog(@"height:%f", height);
    self.imageView.frame = CGRectMake(WIN_SIZE.width - 10 - 60, 10, 60, 60);
    self.textLabel.frame = CGRectMake(WIN_SIZE.width - 10 - 60 - 10 - rect.size.width, self.imageView.frame.origin.y, rect.size.width, height);
    
    self.textLabel.backgroundColor = [UIColor redColor];
    
    [self generate];
}


@end
