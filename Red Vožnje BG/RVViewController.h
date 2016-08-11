//
//  RVViewController.h
//  Red Voznje BG
//
//  Created by Nikola on 4/21/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckmarkView.h"
#import "MapaVC.h"
#import "PrijavaVC.h"
#import "SlikaVC.h"
#import "PrikupiVC.h"
#import "AppDelegate.h"
#import "OAplikacijiVC.h"

@interface RVViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *sveFavLinije;
@property (strong, nonatomic) NSMutableArray *sveDnevneINocne;
@property (strong, nonatomic) NSMutableArray *sveDnevneLinije;
@property (strong, nonatomic) NSMutableArray *sveNocneLinije;

@property (strong, nonatomic) NSString *dataPlistPath;
@property (strong, nonatomic) NSString *favPlistPath;

@property (strong, nonatomic) UIAlertView *sigurnoAlert;
@property (strong, nonatomic) UIActionSheet *josActionSheet;

@property (strong, nonatomic) AppDelegate *delegate;

@property (strong, nonatomic) MapaVC *mapaVC;
@property (strong, nonatomic) PrijavaVC *prijavaVC;
@property (strong, nonatomic) OAplikacijiVC *oAplikacijiVC;

-(void)dodajUFavorites: (NSMutableDictionary *)linija;

-(void)izbrisiSveLinije;

-(void)prikaziPrijavaVC;

-(void)dodatoAnimacija;

@end
