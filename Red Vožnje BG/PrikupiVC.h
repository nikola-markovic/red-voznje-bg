//
//  PrikupiVC.h
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrikupiVC : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *linijeTable;

@property (strong, nonatomic) IBOutlet UIButton *prikupiSveDugme;

- (IBAction)prikupiSve:(UIButton *)sender;

@property (strong, nonatomic) NSArray *searchResults;

@end
