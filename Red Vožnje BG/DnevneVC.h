//
//  DnevneVC.h
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RVViewController.h"

@interface DnevneVC : RVViewController

@property (strong, nonatomic) IBOutlet UITableView *dnevneTable;

@property (strong, nonatomic) NSArray *searchResults;

@end
