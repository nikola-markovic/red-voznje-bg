//
//  MapaVC.h
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/28/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapaVC : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) UIImageView *imageV;

@property (nonatomic) BOOL nocni;


@end
