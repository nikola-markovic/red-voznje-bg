//
//  NocneVC.h
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RVViewController.h"

@interface NocneVC : RVViewController

@property (strong, nonatomic) IBOutlet UITableView *nocneTable;

@property (strong, nonatomic) NSArray *searchResults;


@end
