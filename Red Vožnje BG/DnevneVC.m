//
//  DnevneVC.m
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "DnevneVC.h"
#import "WhiteCell.h"

@interface DnevneVC () <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>

@end

@implementation DnevneVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.barStyle = UIBarStyleDefault;
}

-(void)loadData
{
    NSFileManager *defaulManager = [NSFileManager defaultManager];
    
    if ([defaulManager fileExistsAtPath: self.dataPlistPath]) {
        self.sveDnevneINocne = [NSMutableArray arrayWithContentsOfFile: self.dataPlistPath];
        self.sveDnevneLinije = [self.sveDnevneINocne objectAtIndex:0];
    } else {
        // do nothing
    }
    NSSortDescriptor *sortD = [[NSSortDescriptor alloc]initWithKey:@"sort" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortD];
    NSArray *sortedArray = [self.sveDnevneLinije sortedArrayUsingDescriptors:sortDescriptors];
    self.sveDnevneLinije = [sortedArray mutableCopy];
    
    [self.dnevneTable reloadData];
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return self.searchResults.count;
    else
        return self.sveDnevneLinije.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WhiteCell *cell = (WhiteCell *)[self.dnevneTable dequeueReusableCellWithIdentifier:@"whiteCell"];
    if (!cell) {
        cell = [[WhiteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"whiteCell"];
    }
    
    cell.delegate = self;
    
    NSMutableDictionary *linija = [[NSMutableDictionary alloc]init];
    
    if (tableView == self.searchDisplayController.searchResultsTableView){
        linija = [self.searchResults objectAtIndex:indexPath.row];
    }else {
        linija = [self.sveDnevneLinije objectAtIndex:indexPath.row];
    }
    
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Izbriši"
                                                    icon:[UIImage imageNamed:@"Xmali"]
                                         backgroundColor:[UIColor colorWithRed:253.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1]
                                                callback:^BOOL(MGSwipeTableCell *sender) {
                                                    
                                                    [self.sveDnevneINocne removeObjectAtIndex: 0];
                                                    [self.sveDnevneLinije removeObject:linija];
                                                    [self.sveDnevneINocne insertObject:self.sveDnevneLinije atIndex:0];
                                                    [self.sveDnevneINocne writeToFile: self.dataPlistPath atomically:YES];
                                                    [self.dnevneTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                    if (self.sveDnevneLinije.count > 0) {
                                                        [self.dnevneTable reloadData];
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
    return 45;
}

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point {
    return YES;
}

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell shouldHideSwipeOnTap:(CGPoint)point {
    return YES;
}


//øøøøøøøøøøøøøøø SEARCH øøøøøøøøøøøøøøø

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"brojLinije BEGINSWITH[cd]%@ OR pocetno BEGINSWITH[cd]%@", searchText, searchText];
    
    self.searchResults = [self.sveDnevneLinije filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

//øøøøøøøøøøøøøøø DID SELECT ROW øøøøøøøøøøøøøøø

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *odabranaLinija = [[NSMutableDictionary alloc]init];
    SlikaVC *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"slikaVC"];
    svc.sveFavLinije = [self.sveFavLinije mutableCopy];

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        odabranaLinija = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        odabranaLinija = [self.sveDnevneLinije objectAtIndex:indexPath.row];
    }
    svc.odabranaLinija = odabranaLinija;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:svc animated:YES];
}

@end
