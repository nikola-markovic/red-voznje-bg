//
//  SlikaVC.h
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlikaVC : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) UIImageView *imageV;

@property (strong, nonatomic) NSMutableDictionary *odabranaLinija;

@property (strong, nonatomic) NSMutableArray *sveFavLinije;

@end
