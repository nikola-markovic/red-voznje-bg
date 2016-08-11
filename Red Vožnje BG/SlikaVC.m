//
//  SlikaVC.m
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "SlikaVC.h"

@interface SlikaVC () <UIScrollViewDelegate>

@end

@implementation SlikaVC

NSMutableArray *plistDataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@ %@", [self.odabranaLinija valueForKey:@"brojLinije"],[self.odabranaLinija valueForKey:@"pocetno"]];
    
    self.scrollV.minimumZoomScale = 1;
    self.scrollV.maximumZoomScale = 10;
    self.scrollV.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(dodajUFavorites:)];
    
    UIImage *slikaLinije = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@", [self.odabranaLinija valueForKey:@"kSlika"]]]];
        
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width * slikaLinije.size.height) / slikaLinije.size.width)];
    [self.scrollV addSubview:self.imageV];
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    self.imageV.image = slikaLinije;
    self.imageV.backgroundColor = [UIColor whiteColor];
    
    self.scrollV.zoomScale = 1;
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([[self.odabranaLinija valueForKey:@"pSredstvo"]isEqualToString:@"nocni"]) {
        self.view.backgroundColor = [UIColor blackColor];
        self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        self.tabBarController.tabBar.barStyle = UIBarStyleDefault;
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    }
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0];
//    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"favorites.plist"];
//    
//    NSFileManager *defaulManager = [NSFileManager defaultManager];
//    
//    if ([defaulManager fileExistsAtPath:plistPath]) {
//        plistDataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
//    } else {
//        NSArray *array = [[NSArray alloc]init];
//        [array writeToFile:plistPath atomically:YES];
//        plistDataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
//    }
    
    if ([self.sveFavLinije containsObject: self.odabranaLinija]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Zvezda_puna"] style:UIBarButtonItemStyleBordered target:self action:@selector(dodajUFavorites:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Zvezda_prazna"] style:UIBarButtonItemStyleBordered target:self action:@selector(dodajUFavorites:)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    _scrollV.contentSize = _imageV.frame.size;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageV;
}

-(void)dodajUFavorites:(UIButton *)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"favorites.plist"];
    
    NSFileManager *defaulManager = [NSFileManager defaultManager];
    
    if ([defaulManager fileExistsAtPath:plistPath]) {
        plistDataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    } else {
        NSArray *array = [[NSArray alloc]init];
        [array writeToFile:plistPath atomically:YES];
        plistDataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
    
    if ([plistDataArray containsObject:self.odabranaLinija]) {
        [plistDataArray removeObject:self.odabranaLinija];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Zvezda_prazna"] style:UIBarButtonItemStyleBordered target:self action:@selector(dodajUFavorites:)];
    } else {
        [plistDataArray addObject:self.odabranaLinija];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Zvezda_puna"] style:UIBarButtonItemStyleBordered target:self action:@selector(dodajUFavorites:)];
    }
    [plistDataArray writeToFile:plistPath atomically:YES];
}


@end
