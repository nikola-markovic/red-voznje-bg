//
//  CheckmarkView.h
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/23/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckmarkView : UIView

@property (nonatomic) BOOL positive;

@property (nonatomic) CGRect popupFrame;
@property (nonatomic) BOOL darkenBackground;
@property (nonatomic) NSString *message;
@property (nonatomic) UIColor *messageColor;
@property (nonatomic) UIColor *popUpColor;
@property (nonatomic) UIColor *checkBackColor;
@property (nonatomic) UIColor *checkBackBorderColor;
@property (nonatomic) float animationDuration;

-(void)animate;

@end
