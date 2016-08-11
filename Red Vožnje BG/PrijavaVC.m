//
//  PrijavaVC.m
//  Red Vožnje BG
//
//  Created by Nikola Markovic on 3/22/16.
//  Copyright © 2016 Nikola Markovic. All rights reserved.
//

#import "PrijavaVC.h"
#import "Firebase.framework/Headers/Firebase.h"
#import "CheckmarkView.h"

@interface PrijavaVC () <UITextViewDelegate, UIGestureRecognizerDelegate> {
    BOOL internetReachable;
}

@end

@implementation PrijavaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle: @"Pošalji" style:UIBarButtonItemStyleDone target:self action:@selector(posalji:)];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zapocetiPisanjeOpisa:)];
    UITapGestureRecognizer *tapUprazno = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(prekinutiPisanjeOpisa:)];
    [self.opisPrijaveLabel addGestureRecognizer:tap1];
    [self.view addGestureRecognizer:tapUprazno];
    
    self.hidesBottomBarWhenPushed = YES;
}

-(void)zapocetiPisanjeOpisa:(id)sender {
    self.opisPrijaveLabel.hidden = YES;
    [self.reportTextView becomeFirstResponder];
}

-(void)prekinutiPisanjeOpisa:(id)sender {
    [self.reportTextView resignFirstResponder];
    [self.naslovTF resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
    [self testInternetConnection];
}


-(void)viewWillAppear:(BOOL)animated {
    if ([self.razlog isEqualToString:@"Greška"]) {
        self.naslovTF.placeholder = @"Naslov prijave";
        self.title = @"Prijava";
        self.naslovTF.keyboardType = UIKeyboardTypeDefault;
    } else {
        self.naslovTF.placeholder = @"Broj linije";
        self.title = @"Preporuka";
        self.naslovTF.keyboardType = UIKeyboardTypeNumberPad;
    }

}

-(void)testInternetConnection {
    
    internetReachable = NO;

    Firebase *isAvailable = [[Firebase alloc]initWithUrl:@"https://gsp-red-voznje.firebaseio.com/isAvailable"];
    [isAvailable observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if ([snapshot.value  isEqual: @"YES"]) {
            internetReachable = YES;
        }
    }];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,(float_t)(3 * NSEC_PER_SEC));
    void (^goBack) (void) = ^{
        if (internetReachable == NO) {
            CheckmarkView *potvrda = [[CheckmarkView alloc]initWithFrame:self.view.frame];
            potvrda.message = @"Nema internet konekcije.\nPokušajte ponovo.";
            potvrda.positive = NO;
            potvrda.checkBackColor = [UIColor colorWithRed:253.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1];
            [self.view addSubview:potvrda];
            [potvrda animate];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,(float_t)(1.7 * NSEC_PER_SEC));
            void (^enableSendButton) (void) = ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            };
            dispatch_after(popTime, dispatch_get_main_queue(), enableSendButton);
        }
    };
    dispatch_after(popTime, dispatch_get_main_queue(), goBack);
}

-(void)posalji:(id)sender {
    if (internetReachable == YES) {
        [self zapocniSlanje];
    } else {
        [sender setEnabled:NO];
        [self prekinutiPisanjeOpisa:nil];
        CheckmarkView *potvrda = [[CheckmarkView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:potvrda];
        potvrda.message = @"Nema internet konekcije.\nPokušajte ponovo.";
        potvrda.positive = NO;
        potvrda.checkBackColor = [UIColor redColor];
        [potvrda animate];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,(float_t)(1.7 * NSEC_PER_SEC));
        void (^enableSendButton) (void) = ^{
            [sender setEnabled:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
        dispatch_after(popTime, dispatch_get_main_queue(), enableSendButton);
    }
}

-(void)zapocniSlanje {
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    [self prekinutiPisanjeOpisa:nil];
    UIActivityIndicatorView *sending = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    sending.center = self.view.center;
    UIView *backgroundDim = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundDim.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    [self.view addSubview:backgroundDim];
    [self.view addSubview:sending];
    sending.hidesWhenStopped = YES;
    [sending startAnimating];
    
    Firebase *svePrijave = [[Firebase alloc]initWithUrl:@"https://gsp-red-voznje.firebaseio.com/prijave"];
    
    [svePrijave observeSingleEventOfType: FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSString *brojPrijave = [NSString stringWithFormat:@"%u%@", (int)(snapshot.childrenCount) + 1, self.razlog];
        NSString *naslovPrijave = [NSString stringWithFormat:@"%@", self.naslovTF.text];
        NSString *opisPrijave = [NSString stringWithFormat:@"%@",self.reportTextView.text];
        NSMutableDictionary *prijava = [[NSMutableDictionary alloc]init];
        
        //        [greska setValue: brojGreske forKey:@"brojGreske"];
        [prijava setValue: naslovPrijave forKey:@"naslovPrijave"];
        [prijava setValue: opisPrijave forKey:@"opisPrijave"];
        
        Firebase *novaGreska = [svePrijave childByAppendingPath:brojPrijave];
        [novaGreska setValue: prijava withCompletionBlock:^(NSError *error, Firebase *ref) {
            CheckmarkView *potvrda = [[CheckmarkView alloc]initWithFrame:self.view.frame];
            [self.view addSubview:potvrda];
            [backgroundDim removeFromSuperview];
            if (error) {
                potvrda.message = [NSString stringWithFormat:@"%@ se nije poslala. \nPokušajte ponovo.",self.razlog];
                potvrda.positive = NO;
                potvrda.checkBackColor = [UIColor redColor];
                [potvrda animate];
                [sending stopAnimating];
            } else {
                potvrda.message = [NSString stringWithFormat:@"%@ poslata!",self.razlog];
                potvrda.positive = YES;
                potvrda.checkBackColor = [UIColor greenColor];
                [potvrda animate];
                self.naslovTF.text = @"";
                self.reportTextView.text = @"";
                self.opisPrijaveLabel.hidden = NO;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,(float_t)(1.7 * NSEC_PER_SEC));
                void (^goBack) (void) = ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                };
                dispatch_after(popTime, dispatch_get_main_queue(), goBack);
            }

            [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        }];
    }];
}

-(void)textViewDidChange:(UITextView *)textView {
    if ([self.reportTextView.text isEqualToString:@""]) {
        self.opisPrijaveLabel.hidden = NO;
    }
    self.opisPrijaveLabel.hidden = YES;
}

-(void)goBack {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
