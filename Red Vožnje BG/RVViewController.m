//
//  RVViewController.m
//  Red Voznje BG
//
//  Created by Nikola on 4/21/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "RVViewController.h"

@interface RVViewController () <UIActionSheetDelegate, UIAlertViewDelegate>

@end

@implementation RVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ucitajLinije];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    self.favPlistPath = [[NSString alloc]init];
    self.dataPlistPath = [[NSString alloc]init];
    self.favPlistPath = [documentsPath stringByAppendingPathComponent:@"favorites.plist"];
    self.dataPlistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
    
    self.josActionSheet = [[UIActionSheet alloc]initWithTitle:@"Odaberite opciju:" delegate:self cancelButtonTitle:@"Nazad" destructiveButtonTitle:@"Obriši sve linije" otherButtonTitles:@"Prijavi grešku/promenu", @"Preporuči dodavanje linije", @"Mapa linija", @"O aplikaciji", nil];
    self.sigurnoAlert = [[UIAlertView alloc]initWithTitle:@"Da li ste sigurni?" message:@"Brisanjem svih linija brišu se i linije iz \"Favorites\" liste i sve prikupljene tabele svih linija." delegate:self cancelButtonTitle:@"Ne" otherButtonTitles:@"Da", nil];
    
    self.prijavaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"prijavaVC"];
    self.mapaVC = [self.storyboard instantiateViewControllerWithIdentifier: @"mapaVC"];
}

-(void)ucitajLinije {
    self.sveDnevneINocne = self.delegate.sveDnevneISveNocne;
    self.sveDnevneLinije = self.delegate.sveDnevneLinije;
    self.sveNocneLinije = self.delegate.sveNocneLinije;
    self.sveFavLinije = self.delegate.favoritesArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)izbrisiSveLinije {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.hidesWhenStopped = YES;
    loading.center = self.view.center;
    [self.view addSubview:loading];
    [loading startAnimating];
    
    NSMutableArray *emptyArray1 = [[NSMutableArray alloc]init];

    [emptyArray1 writeToFile: self.favPlistPath atomically:YES];
    NSMutableArray *emptyArray = [[NSMutableArray alloc]init];
    [emptyArray1 addObject:emptyArray];
    [emptyArray1 addObject:emptyArray];
    [emptyArray1 writeToFile: self.dataPlistPath atomically:YES];
    
    NSString *extension = @"png";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    [self.delegate osveziSveLinije];
    [loading stopAnimating];
    
    //Check Animation
    CheckmarkView *potvrda = [[CheckmarkView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:potvrda];
    potvrda.message = @"Podaci uspešno pobrisani.";
    potvrda.positive = YES;
    [potvrda animate];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

-(void)prikaziPrijavaVC {
    self.prijavaVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: self.prijavaVC animated:YES];
}

- (IBAction)prikaziPrikupljanje:(UIBarButtonItem *)sender {
    PrikupiVC *prikupiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"prikupiVC"];
    prikupiVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: prikupiVC animated:YES];
}


-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
    }
    if (buttonIndex == 1) {
        self.prijavaVC.razlog = @"Greška";
        [self prikaziPrijavaVC];
    }
    if (buttonIndex == 2) {
        self.prijavaVC.razlog = @"Preporuka";
        [self prikaziPrijavaVC];
    }
    if (buttonIndex == 3) {
//        self.mapaVC.nocni = YES;
        [self.navigationController pushViewController: self.mapaVC animated:YES];
    }
    if (buttonIndex == 4) {
        self.oAplikacijiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"oAplikacijiVC"];
        self.oAplikacijiVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:self.oAplikacijiVC animated:YES];
    }
    
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self.sigurnoAlert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        //do nothing
    } else {
        [self izbrisiSveLinije];
    }
}

-(void)dodajUFavorites:(NSMutableDictionary *)linija
{
    NSFileManager *defaulManager = [NSFileManager defaultManager];
    
    if ([defaulManager fileExistsAtPath: self.favPlistPath]) {
        self.sveFavLinije = [NSMutableArray arrayWithContentsOfFile: self.favPlistPath];
    } else {
        NSArray *array = [[NSArray alloc]init];
        [array writeToFile: self.favPlistPath atomically:YES];
        self.sveFavLinije = [NSMutableArray arrayWithContentsOfFile: self.favPlistPath];
    }
    if ([self.sveFavLinije containsObject: linija]) {
    } else {
        [self.sveFavLinije addObject: linija];
    }
    [self.sveFavLinije writeToFile: self.favPlistPath atomically: YES];
}

-(void)dodatoAnimacija {
    CheckmarkView *potvrda = [[CheckmarkView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:potvrda];
    potvrda.message = @"Dodato u favorites.";
    potvrda.positive = YES;
    potvrda.animationDuration = 0.4;
    [potvrda animate];
}

- (IBAction)jos:(id)sender {
    [self.josActionSheet showFromBarButtonItem:sender animated:YES];
}

@end
