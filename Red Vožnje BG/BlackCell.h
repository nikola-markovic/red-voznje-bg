//
//  BlackCell.h
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface BlackCell : MGSwipeTableCell

@property (strong, nonatomic) IBOutlet UILabel *brojLabel;
@property (strong, nonatomic) IBOutlet UILabel *pocetnoStajalisteLabel;

@end
