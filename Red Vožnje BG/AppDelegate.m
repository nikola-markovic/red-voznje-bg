//
//  AppDelegate.m
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "AppDelegate.h"
#import "Firebase.framework/Headers/Firebase.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self osveziSveLinije];
    
    [[UITabBar appearance]setSelectedImageTintColor:[UIColor colorWithRed:255.0/255.0 green:146.0/255.0 blue:61.0/255.0 alpha:1]];
    
    // PISANJE SORT-a
    
//    Firebase *baza = [[Firebase alloc]initWithUrl:@"https://gsp-red-voznje.firebaseio.com/dnevne/"];
//    [baza observeSingleEventOfType: FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        
//        for (Firebase *linija in snapshot.children.allObjects) {
//            NSLog(@"%@",linija);
//            
//            Firebase *sort = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://gsp-red-voznje.firebaseio.com/dnevne/%@/sort/", linija.key]];
//            
//            if ([linija.key integerValue] < 10 ) {
//                [sort setValue:[NSString stringWithFormat:@"00%@",linija.key]];
//            }
//            if ([linija.key integerValue] > 9 &&  [linija.key integerValue] < 100) {
//                [sort setValue:[NSString stringWithFormat:@"0%@",linija.key]];
//            }
//            if ([linija.key integerValue] > 99 ) {
//                [sort setValue:[NSString stringWithFormat:@"%@",linija.key]];
//            }
//            NSLog(@"%@",sort);
//        }
//    }];
    
    
    return YES;
}

-(void)osveziSveLinije {
    self.sveDnevneLinije = [[NSMutableArray alloc]init];
    self.sveNocneLinije = [[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
//    self.appFolderPath = documentsPath;
    NSString *dataPlistPath = [documentsPath stringByAppendingPathComponent:@"Data.plist"];
    
    NSFileManager *defaulManager = [NSFileManager defaultManager];
    
    if ([defaulManager fileExistsAtPath: dataPlistPath]) {
        self.sveDnevneISveNocne = [NSMutableArray arrayWithContentsOfFile: dataPlistPath];
        self.sveDnevneLinije = [self.sveDnevneISveNocne objectAtIndex:0];
        self.sveNocneLinije = [self.sveDnevneISveNocne objectAtIndex:1];
        for (NSMutableDictionary *linija in self.sveDnevneLinije) {
            [linija setValue:[NSString stringWithFormat:@"%@/linija_%@-%@.png",documentsPath,[linija valueForKey:@"brojLinije"], [linija valueForKey:@"pocetno"]] forKey:@"kSlika"];
        }
        self.sveDnevneISveNocne[0] = self.sveDnevneLinije;
        
        for (NSMutableDictionary *linija in self.sveNocneLinije)
        {
            [linija setValue:[NSString stringWithFormat:@"%@/linija_%@-%@.png",documentsPath,[linija valueForKey:@"brojLinije"], [linija valueForKey:@"pocetno"]] forKey:@"kSlika"];
        }
        self.sveDnevneISveNocne[1] = self.sveNocneLinije;
        
        [self.sveDnevneISveNocne writeToFile: dataPlistPath atomically:YES];
    } else {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:self.sveDnevneLinije];
        [array addObject:self.sveNocneLinije];
        [array writeToFile:dataPlistPath atomically:YES];
    }
    
    NSString *favPlistPath = [documentsPath stringByAppendingPathComponent:@"favorites.plist"];
    
    if ([defaulManager fileExistsAtPath: favPlistPath]) {
        self.favoritesArray = [NSMutableArray arrayWithContentsOfFile:favPlistPath];
        for (NSMutableDictionary *linija in self.favoritesArray) {
            [linija setValue:[NSString stringWithFormat:@"%@/linija_%@-%@.png",documentsPath,[linija valueForKey:@"brojLinije"], [linija valueForKey:@"pocetno"]] forKey:@"kSlika"];
        }
        
        [self.favoritesArray writeToFile:favPlistPath atomically:YES];
        
    } else {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array writeToFile:favPlistPath atomically:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
