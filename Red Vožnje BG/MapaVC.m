//
//  MapaVC.m
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/28/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "MapaVC.h"

@interface MapaVC () <UIScrollViewDelegate>

@end

@implementation MapaVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Mapa Linija";
    
    self.scrollV.minimumZoomScale = 1;
    self.scrollV.maximumZoomScale = 20;
    self.scrollV.delegate = self;
    
    UIImage *slikaLinije = [UIImage imageNamed:@"mapa"];
    
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width * slikaLinije.size.height) / slikaLinije.size.width)];
    [self.scrollV addSubview:self.imageV];
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    self.imageV.image = slikaLinije;
    
    self.scrollV.zoomScale = 1;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.nocni == YES) {
        self.view.backgroundColor = [UIColor blackColor];
        self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        self.tabBarController.tabBar.barStyle = UIBarStyleDefault;
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
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


@end
