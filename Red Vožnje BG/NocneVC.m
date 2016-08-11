//
//  NocneVC.m
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "NocneVC.h"
#import "BlackCell.h"

@interface NocneVC () <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>

@end

@implementation NocneVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

-(void)loadData
{    
    NSFileManager *defaulManager = [NSFileManager defaultManager];
    
    if ([defaulManager fileExistsAtPath: self.dataPlistPath]) {
        self.sveDnevneINocne = [NSMutableArray arrayWithContentsOfFile: self.dataPlistPath];
        self.sveNocneLinije = [self.sveDnevneINocne objectAtIndex:1];
    } else {
        // do nothing
    }
    NSSortDescriptor *sortD = [[NSSortDescriptor alloc]initWithKey:@"sort" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortD];
    NSArray *sortedArray = [self.sveNocneLinije sortedArrayUsingDescriptors:sortDescriptors];
    self.sveNocneLinije = [sortedArray mutableCopy];
    
    [self.nocneTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sveNocneLinije.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlackCell *cell = (BlackCell *)[self.nocneTable dequeueReusableCellWithIdentifier:@"blackCell"];
    if (!cell) {
        cell = [[BlackCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"blackCell"];
    }
    
    cell.delegate = self;
    
    NSMutableDictionary *linija = [[NSMutableDictionary alloc]init];
    linija = [self.sveNocneLinije objectAtIndex:indexPath.row];
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Izbriši"
                                                    icon:[UIImage imageNamed:@"Xmali"]
                                         backgroundColor:[UIColor colorWithRed:253.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1]
                                                callback:^BOOL(MGSwipeTableCell *sender) {
                                                    
                                                    [self.sveDnevneINocne removeObjectAtIndex: 1];
                                                    [self.sveNocneLinije removeObject: linija];
                                                    [self.sveDnevneINocne insertObject:self.sveNocneLinije atIndex:1];
                                                    [self.sveDnevneINocne writeToFile: self.dataPlistPath atomically: YES];
                                                    [self.nocneTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                    if (self.sveNocneLinije.count > 0) {
                                                        [self.nocneTable reloadData];
                                                    }
                                                    return YES;
                                                }]];
    
    
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Dodaj u favorite"
                                                   icon:[UIImage imageNamed:@"Zvezda_puna"]
                                        backgroundColor:[UIColor colorWithRed:255.0/255.0 green:146.0/255.0 blue:41.0/255.0 alpha:1]
                                               callback:^BOOL(MGSwipeTableCell *sender) {
                                                   [self dodajUFavorites: linija];
                                                   
                                                   [self dodatoAnimacija];
                                                   
                                                   [cell hideSwipeAnimated:YES];
                                                   return YES;
                                               }]];
    
    
    
    cell.brojLabel.font = [UIFont fontWithName:@"DS-Digital" size:22];
    
    cell.brojLabel.text = [linija valueForKey:@"brojLinije"];
    cell.pocetnoStajalisteLabel.text = [linija valueForKey:@"pocetno"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point {
    return YES;
}

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell shouldHideSwipeOnTap:(CGPoint)point {
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SlikaVC *slikaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"slikaVC"];
    
    slikaVC.sveFavLinije = [self.sveFavLinije mutableCopy];
    
    NSMutableDictionary *odabranaLinija = [[NSMutableDictionary alloc]init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        odabranaLinija = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        odabranaLinija = [self.sveNocneLinije objectAtIndex:indexPath.row];
    }
    slikaVC.odabranaLinija = odabranaLinija;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController: slikaVC animated:YES];
}

@end