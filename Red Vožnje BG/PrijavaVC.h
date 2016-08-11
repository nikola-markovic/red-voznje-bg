//
//  PrijavaVC.h
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrijavaVC : UIViewController

@property (strong, nonatomic) NSString *razlog;
@property (strong, nonatomic) IBOutlet UITextField *naslovTF;
@property (strong, nonatomic) IBOutlet UITextView *reportTextView;
@property (strong, nonatomic) IBOutlet UILabel *opisPrijaveLabel;

@end
