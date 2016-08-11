//
//  PrikupiVC.m
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "PrikupiVC.h"
#import "LinijeCell.h"
#import "Firebase.framework/Headers/Firebase.h"
#import "CheckmarkView.h"

@interface PrikupiVC () <UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *linijeZaPrikupiti;

@property (strong, nonatomic) UIActivityIndicatorView *loading;


@end

@implementation PrikupiVC {
    
    int progressValue;
    
    NSMutableArray *sveDnevneLinije;
    NSMutableArray *sveNocneLinije;
    NSMutableIndexSet *publicIndexSet;
    NSMutableArray *odabraneLinije;
    UILabel *progressLabel;
    NSString *progressString;
    
    UIView *backgroundDimView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Preuzimanje";
    [self.linijeTable setTintColor:[UIColor orangeColor]];
    publicIndexSet = [[NSMutableIndexSet alloc]init];
    sveDnevneLinije = [[NSMutableArray alloc]init];
    sveNocneLinije = [[NSMutableArray alloc]init];
    odabraneLinije = [[NSMutableArray alloc]init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Preuzmi obeležene" style:UIBarButtonItemStyleDone target:self action:@selector(prikupiObelezene)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    self.linijeZaPrikupiti = [[NSMutableArray alloc]init];
    
    [self.prikupiSveDugme setEnabled: NO];
}

-(void)viewDidAppear:(BOOL)animated {
    
    self.loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loading.hidesWhenStopped = YES;
    self.loading.center = self.view.center;
    [self.view addSubview:self.loading];
    [self.loading startAnimating];
    
    Firebase *sveLinije = [[Firebase alloc]initWithUrl:@"https://gsp-red-voznje.firebaseio.com/dnevne"];
    
    [sveLinije observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSString *odabrana = @"NO";
        
        for (int i = 0; i < snapshot.childrenCount; i++) {
            
            NSMutableDictionary *linija = [[NSMutableDictionary alloc]init];
            
            FDataSnapshot *liii = snapshot.children.allObjects[i];
            
            [linija setValue: [NSString stringWithFormat:@"%@",liii.key]
                      forKey: @"brojLinije"];
            
            [linija setValue: [NSString stringWithFormat:@"%@",liii.value[@"pSredstvo"]]
                      forKey: @"pSredstvo"];
            
            [linija setValue: [NSString stringWithFormat:@"%@",liii.value[@"pocetno-a"]]
                      forKey: @"pocetno"];
            
            [linija setValue: [NSString stringWithFormat:@"%@",liii.value[@"slika1"]]
                      forKey: @"slika"];
            
            [linija setValue: [NSString stringWithFormat:@"%@",liii.value[@"sort"]]
                      forKey: @"sort"];
            
            [linija setValue: odabrana forKey:@"odabrana"];
            
            [self.linijeZaPrikupiti addObject:linija];
            
            if (liii.value[@"pocetno-b"] != NULL) {
                NSMutableDictionary *linija2 = [[NSMutableDictionary alloc]init];
                
                [linija2 setValue: [NSString stringWithFormat:@"%@",liii.key]
                           forKey:@"brojLinije"];
                
                [linija2 setValue: [NSString stringWithFormat:@"%@",liii.value[@"pSredstvo"]]
                           forKey: @"pSredstvo"];
                
                [linija2 setValue:[NSString stringWithFormat:@"%@",liii.value[@"pocetno-b"]]
                           forKey: @"pocetno"];
                
                [linija2 setValue:[NSString stringWithFormat:@"%@",liii.value[@"slika2"]]
                           forKey: @"slika"];
                
                [linija2 setValue: [NSString stringWithFormat:@"%@",liii.value[@"sort"]]
                           forKey: @"sort"];
                
                [linija2 setValue: odabrana forKey:@"odabrana"];
                
                
                [self.linijeZaPrikupiti addObject:linija2];
            }
            
            if (liii.value[@"pocetno-c"] != NULL) {
                NSMutableDictionary *linija3 = [[NSMutableDictionary alloc]init];
                
                [linija3 setValue: [NSString stringWithFormat:@"%@",liii.key]
                           forKey:@"brojLinije"];
                
                [linija3 setValue: [NSString stringWithFormat:@"%@",liii.value[@"pSredstvo"]]
                           forKey: @"pSredstvo"];
                
                [linija3 setValue:[NSString stringWithFormat:@"%@",liii.value[@"pocetno-c"]]
                           forKey:@"pocetno"];
                
                [linija3 setValue:[NSString stringWithFormat:@"%@",liii.value[@"slika3"]]
                           forKey:@"slika"];
                
                [linija3 setValue: [NSString stringWithFormat:@"%@",liii.value[@"sort"]]
                           forKey: @"sort"];
                
                [linija3 setValue: odabrana forKey:@"odabrana"];
                
                
                [self.linijeZaPrikupiti addObject:linija3];
            }
        }
        
        NSSortDescriptor *sortD = [[NSSortDescriptor alloc]initWithKey:@"sort" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortD];
        NSArray *sortedArray = [self.linijeZaPrikupiti sortedArrayUsingDescriptors:sortDescriptors];
        self.linijeZaPrikupiti = [sortedArray mutableCopy];
        
        [self.loading stopAnimating];
        [self.linijeTable reloadData];
        [self.prikupiSveDugme setEnabled: YES];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.barStyle = UIBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return self.searchResults.count;
    else
        return self.linijeZaPrikupiti.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LinijeCell *cell = (LinijeCell *)[self.linijeTable dequeueReusableCellWithIdentifier:@"linijeCell" forIndexPath:indexPath];
    if (self.linijeZaPrikupiti.count > 0) {
        NSMutableDictionary *linija = [[NSMutableDictionary alloc]init];
        if (tableView == self.searchDisplayController.searchResultsTableView){
            linija = [self.searchResults objectAtIndex:indexPath.row];
        } else {
            linija = [self.linijeZaPrikupiti objectAtIndex:indexPath.row];
        }
        
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
        
        if ([linija[@"odabrana"] isEqualToString:@"NO"]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"brojLinije BEGINSWITH[cd]%@ OR pocetno BEGINSWITH[cd]%@", searchText, searchText];
    
    self.searchResults = [self.linijeZaPrikupiti filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *odabranaLinija = [[NSMutableDictionary alloc]init];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        odabranaLinija = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        odabranaLinija = [self.linijeZaPrikupiti objectAtIndex:indexPath.row];
    }
    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
        [odabraneLinije addObject: odabranaLinija];
        [odabranaLinija setValue:@"YES" forKey:@"odabrana"];
    } else {
        [odabraneLinije removeObject:odabranaLinija];
        [odabranaLinija setValue:@"NO" forKey:@"odabrana"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *selectedRows = @[indexPath];
    [tableView reloadRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationNone];
    
    if (odabraneLinije.count == 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
}

-(void)prikupiObelezene {
    NSSortDescriptor *sortD = [[NSSortDescriptor alloc]initWithKey:@"sort" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortD];
    NSArray *sortedArray = [odabraneLinije sortedArrayUsingDescriptors:sortDescriptors];
    odabraneLinije = [sortedArray mutableCopy];
    [self prikupiLinijeIzNiza: odabraneLinije];
}


- (IBAction)prikupiSve:(UIButton *)sender {
    [[[UIAlertView alloc]initWithTitle:@"Prikupiti sve?"
                               message:[NSString stringWithFormat:@"Dostupno je %d tabela za preuzimanje. Da li ste sigurni da ih želite preuzeti sve?", _linijeZaPrikupiti.count]
                              delegate:self
                     cancelButtonTitle:@"Ne"
                     otherButtonTitles:@"Da", nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [sveDnevneLinije removeAllObjects];
        [sveNocneLinije removeAllObjects];
        odabraneLinije = [self.linijeZaPrikupiti mutableCopy];
        [self prikupiLinijeIzNiza: odabraneLinije];
    }
}


-(void)prikupiLinijeIzNiza:(NSMutableArray *)nizLinija {
    progressValue = 0;
    progressString = [NSString stringWithFormat:@"%i / %lu",progressValue, (unsigned long)nizLinija.count];
    [self updateProgressView];
    
    backgroundDimView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundDimView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    [self.view addSubview:backgroundDimView];
    
    UIView *holder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    holder.backgroundColor = [UIColor whiteColor];
    holder.layer.cornerRadius = 20;
    holder.clipsToBounds = YES;
    holder.alpha = 0;
    [backgroundDimView addSubview:holder];
    holder.center = backgroundDimView.center;
    
    CGRect proportionedRect = CGRectMake(holder.frame.size.width/4, holder.frame.size.height/10, holder.frame.size.width/2, holder.frame.size.width/2);
    
    UIView *checkBack = [[UIView alloc]initWithFrame:proportionedRect];
    checkBack.backgroundColor = [UIColor orangeColor];
    checkBack.layer.cornerRadius = checkBack.frame.size.width / 2;
    checkBack.clipsToBounds = YES;
    checkBack.layer.borderWidth = holder.frame.size.width/40;
    checkBack.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
    [holder addSubview:checkBack];
    
    UIImageView *busView = [[UIImageView alloc]initWithFrame:CGRectMake(0 - checkBack.frame.size.width, 0, checkBack.frame.size.width, checkBack.frame.size.height)];
    busView.image = [UIImage imageNamed:@"busLoading"];
    busView.contentMode = UIViewContentModeScaleAspectFit;
    [checkBack addSubview:busView];
    busView.alpha = 0;
    
    progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, checkBack.frame.size.height + 8, holder.frame.size.width - 8, holder.frame.size.height - checkBack.frame.size.height - 8)];
    progressLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14];
    [self updateProgressView];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.textColor = [UIColor blackColor];
    progressLabel.numberOfLines = 0;
    [holder addSubview:progressLabel];
    
    [UIView animateWithDuration:0.2 animations:^{
        holder.alpha = 1;
        busView.alpha = 1;
    } completion:^(BOOL finished) {
        NSUInteger opts = UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear;
        [UIView animateWithDuration:2 delay:0 options: opts animations:^{
            CGPoint p = busView.center;
            p.x += busView.frame.size.width * 4;
            busView.center = p;
            
        } completion:^(BOOL finished) {
        }];
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
        NSMutableArray *plistDataArray;
        NSFileManager *defaulManager = [NSFileManager defaultManager];
        NSString  *filePath = [NSString stringWithFormat:@"%@/linija", documentsPath];
        
        if ([defaulManager fileExistsAtPath:plistPath]) {
            plistDataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
            sveDnevneLinije = plistDataArray[0];
            sveNocneLinije = plistDataArray[1];
            [plistDataArray removeAllObjects];
        } else {
            NSMutableArray *array = [NSMutableArray array];
            [array writeToFile:plistPath atomically:YES];
            plistDataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
        }
        
        NSData *data; //Za sliku
        
        NSMutableDictionary *linija = [[NSMutableDictionary alloc]init];
        
        for (int i = 0; i < nizLinija.count; i++) {
            linija = [nizLinija objectAtIndex:i];
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[linija valueForKey:@"slika"]]];
            NSString *kSlika = [NSString stringWithFormat:@"%@_%@-%@.png",filePath, [linija valueForKey:@"brojLinije"],[linija valueForKey:@"pocetno"]];
            
            [data writeToFile: kSlika atomically: YES];
            [linija setValue: kSlika forKey:@"kSlika"];
//            NSLog(@"%i / %lu",i, (unsigned long)nizLinija.count);
            progressString = [NSString stringWithFormat:@"%i / %lu",progressValue + 1, (unsigned long)nizLinija.count];
            
            if ([linija[@"pSredstvo"] isEqualToString:@"nocni"]) {
                NSMutableArray *sveNocneCopy = [sveNocneLinije mutableCopy];
                
                for (NSDictionary *nLinija in sveNocneLinije) {
                    if ([[nLinija valueForKey:@"brojLinije"] isEqualToString:[linija valueForKey: @"brojLinije"]]) {
                        [sveNocneCopy removeObject:nLinija];
                    }
                }
                [sveNocneCopy addObject: linija];
                sveNocneLinije = sveNocneCopy;
            } else {
                NSMutableArray *sveDnevneCopy = [sveDnevneLinije mutableCopy];
                for (NSDictionary *nLinija in sveDnevneLinije) {
                    if ([[nLinija valueForKey:@"brojLinije"] isEqualToString:[linija valueForKey: @"brojLinije"]]
                        &&
                        [[nLinija valueForKey:@"pocetno"] isEqualToString:[linija valueForKey: @"pocetno"]] ){
                        [sveDnevneCopy removeObject:nLinija];
                    }
                }
                [sveDnevneCopy addObject: linija];
                sveDnevneLinije = sveDnevneCopy;
            }
            progressValue++;
            linija = nil;
        }
        
        
        NSSortDescriptor *sortD = [[NSSortDescriptor alloc]initWithKey:@"sort" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortD];
        NSArray *sortiraneDnevne = [sveDnevneLinije sortedArrayUsingDescriptors:sortDescriptors];
        NSArray *sortiraneNocne = [sveNocneLinije sortedArrayUsingDescriptors:sortDescriptors];
        
        
        [plistDataArray addObject:sortiraneDnevne];
        [plistDataArray addObject:sortiraneNocne];
        [plistDataArray writeToFile:plistPath atomically: YES];
    });
}

- (void)updateProgressView
{
    progressLabel.text = [NSString stringWithFormat:@"Preuzimanje tabela u toku.\n%@",progressString];
    self.navigationController.navigationBarHidden = YES;
    
    if (progressValue != odabraneLinije.count) {
        [self performSelector:@selector(updateProgressView) withObject:self afterDelay:0.2];
    } else {
        [backgroundDimView removeFromSuperview];
        CheckmarkView *potvrda = [[CheckmarkView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:potvrda];
        potvrda.message = @"Tabele uspešno preuzete.";
        potvrda.positive = YES;
        potvrda.checkBackColor = [UIColor greenColor];
        [potvrda animate];
        self.navigationController.navigationBarHidden = NO;
    }
}

@end
