//
//  FavoritesVC.m
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "FavoritesVC.h"
#import "FavCell.h"

@interface FavoritesVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FavoritesVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    self.tabBarController.tabBar.barStyle = UIBarStyleDefault;
    [self loadData];
}

-(void)loadData
{
    NSFileManager *defaulManager = [NSFileManager defaultManager];
    
    if ([defaulManager fileExistsAtPath: self.favPlistPath]) {
        self.sveFavLinije = [NSMutableArray arrayWithContentsOfFile: self.favPlistPath];
    } else {
        NSMutableArray *array = [NSMutableArray array];
        [array writeToFile: self.favPlistPath atomically:YES];
        self.sveFavLinije = [NSMutableArray arrayWithContentsOfFile: self.favPlistPath];
    }
    NSMutableArray *sortArray = [[NSMutableArray alloc]init];
    NSSortDescriptor *sortD = [NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES];
//    NSMutableArray *sDescriptors = [[NSMutableArray alloc]initWithObjects:sortD, nil];
    sortArray = [[self.sveFavLinije sortedArrayUsingDescriptors:@[sortD]] mutableCopy];
    self.sveFavLinije = sortArray;
    sortArray = nil;
    [self.sveFavLinije writeToFile:self.favPlistPath atomically:YES];
    [self.favTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sveFavLinije.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavCell *cell = (FavCell *)[self.favTable dequeueReusableCellWithIdentifier:@"favCell"];
    if (!cell) {
        cell = [[FavCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favCell"];
    }
    
    NSMutableDictionary *linija = [[NSMutableDictionary alloc]init];
    linija = [self.sveFavLinije objectAtIndex:indexPath.row];
    
    cell.brojLabel.font = [UIFont fontWithName:@"DS-Digital" size:22];
    cell.brojLabel.text = [linija valueForKey: @"brojLinije"];
    cell.pocetnoStajalisteLabel.text = [linija valueForKey: @"pocetno"];
    
    if ([[linija valueForKey:@"pSredstvo"]isEqualToString:@"tramvaj"]) {
        cell.brojLabel.backgroundColor = [UIColor redColor];
        cell.brojLabel.textColor = [UIColor whiteColor];
    } else if ([[linija valueForKey:@"pSredstvo"] isEqualToString:@"bus"])
    {
        cell.brojLabel.backgroundColor = [UIColor yellowColor];
        cell.brojLabel.textColor = [UIColor blackColor];
    } else if ([[linija valueForKey:@"pSredstvo"] isEqualToString:@"trolejbus"])
    {
        cell.brojLabel.backgroundColor = [UIColor orangeColor];
        cell.brojLabel.textColor = [UIColor whiteColor];
    } else if ([[linija valueForKey:@"pSredstvo"]isEqualToString:@"nocni"])
    {
        cell.brojLabel.backgroundColor = [UIColor blackColor];
        cell.brojLabel.textColor = [UIColor whiteColor];
    } else {
        cell.brojLabel.backgroundColor = [UIColor grayColor];
        cell.brojLabel.textColor = [UIColor whiteColor];
    }
    
    cell.brojLabel.layer.cornerRadius = 10;
    cell.brojLabel.clipsToBounds = YES;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *odabranaLinija = [self.sveFavLinije objectAtIndex:indexPath.row];
    SlikaVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"slikaVC"];
    svc.odabranaLinija = odabranaLinija;
    svc.sveFavLinije = [self.sveFavLinije mutableCopy];
    [self.navigationController pushViewController:svc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.sveFavLinije removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.sveFavLinije writeToFile: self.favPlistPath atomically:YES];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableDictionary *linijaZaMrdanje = [self.sveFavLinije objectAtIndex:fromIndexPath.row];
    [self.sveFavLinije removeObjectAtIndex:fromIndexPath.row];
    [self.sveFavLinije insertObject:linijaZaMrdanje atIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if(editing == YES) {
        
        [self.favTable setEditing:editing animated:animated];
        
    } else {
        [self.sveFavLinije writeToFile: self.favPlistPath atomically:YES];
        [self.favTable setEditing:NO animated:animated];
        
    }
}

@end
