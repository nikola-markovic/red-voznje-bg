//
//  CheckmarkView.m
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/23/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "CheckmarkView.h"

@implementation CheckmarkView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaults];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

-(void)setDefaults {
    self.positive = YES;
    self.popupFrame = CGRectMake(0, 0, 200, 200);
    self.message = @"";
    self.darkenBackground = YES;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    self.popUpColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    self.checkBackColor = [UIColor colorWithRed:255.0/255.0 green:166.0/255.0 blue:51.0/255.0 alpha:1];
    self.checkBackBorderColor = [UIColor colorWithRed:230.0/255.0 green:146.0/255.0 blue:40.0/255.0 alpha:1];
    self.messageColor = [UIColor blackColor];
    self.animationDuration = 1;
}

-(void)animate {
    
    UIView *holder = [[UIView alloc]initWithFrame:self.popupFrame];
    holder.backgroundColor = self.popUpColor;
    holder.layer.cornerRadius = self.popupFrame.size.width/10;
    holder.clipsToBounds = YES;
    holder.alpha = 0;
    [self addSubview:holder];
    holder.center = self.superview.center;
    
    CGRect proportionedRect = CGRectMake(holder.frame.size.width/4, holder.frame.size.height/10, holder.frame.size.width/2, holder.frame.size.width/2);
    
    UIView *checkBack = [[UIView alloc]initWithFrame:proportionedRect];
    checkBack.backgroundColor = self.checkBackColor;
    checkBack.layer.cornerRadius = checkBack.frame.size.width / 2;
    checkBack.clipsToBounds = YES;
    checkBack.layer.borderWidth = self.popupFrame.size.width/40;
    checkBack.layer.borderColor = (__bridge CGColorRef _Nullable)(self.checkBackBorderColor);
    [holder addSubview:checkBack];
    
    UIImageView *checkmark = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, checkBack.frame.size.width, checkBack.frame.size.height)];
    checkmark.contentMode = UIViewContentModeScaleAspectFit;
    if (self.positive == YES) {
        checkmark.image = [UIImage imageNamed:@"checkmark"];
    } else {
        checkmark.image = [UIImage imageNamed:@"X"];
    }
    [checkBack addSubview:checkmark];
    
    UIView *checkFront = [[UIView alloc]initWithFrame:CGRectMake(0, 0, checkBack.frame.size.width, checkBack.frame.size.height)];
    checkFront.backgroundColor = self.checkBackColor;
    [checkBack addSubview:checkFront];
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, checkBack.frame.size.height + 8, self.popupFrame.size.width - 8, self.popupFrame.size.height - checkBack.frame.size.height - 8)];
    messageLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:13];
    messageLabel.text = self.message;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = self.messageColor;
    messageLabel.numberOfLines = 0;
    messageLabel.alpha = 0;
    [holder addSubview:messageLabel];
    
    [UIView animateWithDuration: self.animationDuration / 5 animations:^{
        holder.alpha = 1;
        if (self.darkenBackground == YES) {
            self.alpha = 1;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration: self.animationDuration / 5 animations:^{
            messageLabel.alpha = 1;
        }];
        [UIView animateWithDuration: self.animationDuration / 1.25 animations:^{
            CGPoint p = checkFront.center;
            if (self.positive == YES) {
                p.x += checkBack.frame.size.width;
            } else {
                p.y += checkBack.frame.size.height;
            }
            checkFront.center = p;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: self.animationDuration / 1.66 animations:^{
                //WAIT FOR IT
                CGPoint p = checkFront.center;
                if (self.positive == YES) {
                    p.x += 100;
                } else {
                    p.y += 100;
                }
                checkFront.center = p;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration: self.animationDuration / 3.33 animations:^{
                    holder.alpha = 0;
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    [holder removeFromSuperview];
                }];
            }];
        }];
    }];
}

@end
