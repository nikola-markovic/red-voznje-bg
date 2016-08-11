//
//  AppDelegate.h
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapaVC.h"
#import "PrijavaVC.h"
#import "SlikaVC.h"
#import "PrikupiVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *appFolderPath;
@property (strong, nonatomic) NSMutableArray *sveDnevneLinije;
@property (strong, nonatomic) NSMutableArray *sveDnevneISveNocne;
@property (strong, nonatomic) NSMutableArray *sveNocneLinije;
@property (strong, nonatomic) NSMutableArray *favoritesArray;

@property (strong, nonatomic) MapaVC *mapaVC;
@property (strong, nonatomic) PrijavaVC *prijavaVC;
@property (strong, nonatomic) SlikaVC *slikaVC;
@property (strong, nonatomic) PrikupiVC *prikupiVC;


-(void)osveziSveLinije;

@end

