//
//  DetailNotesViewController.m
//  PDC2016
//
//  Created by James Perih on 2016-04-10.
//  Copyright © 2016 Hot Dang Interactive. All rights reserved.
//

#import "DetailNotesViewController.h"
#import "Session.h"
#import "Speaker.h"

#import <IHKeyboardAvoiding.h>

@interface DetailNotesViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@end

@implementation DetailNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Notes";
    [self loadText];
    [self setupKeyboardAccessories];
    [_notesTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"Save!!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextView Delegates
-(void)doneKeyboardButtonPressed {
    [_notesTextView resignFirstResponder];
}

-(void)cancelKeyboardButtonPressed {
    [_notesTextView resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
    [IHKeyboardAvoiding setAvoidingView:_notesTextView];
    
    // get from the notes
    [self loadText];
}

-(void)textViewDidChange:(UITextView *)textView {
    // save to the notes
    [self saveText];
}

#pragma mark - Utilities
- (void)saveText {
    @try {
        [[NSUserDefaults standardUserDefaults] setObject:_notesTextView.text forKey:[self storageKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } @catch (NSException *exception) {
        //
    } @finally {
        //
    }
    
}

- (void)loadText {
    @try {
        _notesTextView.text = [[NSUserDefaults standardUserDefaults] objectForKey:[self storageKey]];
    } @catch (NSException *exception) {
        //
    } @finally {
        //
    }
}

-(NSString *)storageKey {
    NSNumber *identifier = [_sessionOrSpeakerObject performSelector:@selector(identifier)];
    if (identifier) {
        NSString *storageKey = [NSString stringWithFormat:@"session_%ld", identifier.integerValue];
        return storageKey;
    }
    return nil;
}

- (void)setupKeyboardAccessories {
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelKeyboardButtonPressed)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneKeyboardButtonPressed)],
                           nil];
    [numberToolbar sizeToFit];
    
    _notesTextView.inputAccessoryView = numberToolbar;
}
@end
