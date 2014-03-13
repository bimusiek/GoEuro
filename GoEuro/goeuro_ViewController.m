//
//  goeuro_ViewController.m
//  GoEuro
//
//  Created by Michał Hernas on 09/03/14.
//  Copyright (c) 2014 Michał Hernas. All rights reserved.
//

#import "goeuro_ViewController.h"
#import <MLPAutoCompleteTextField.h>
#import "AutocompletionModel.h"
#import "ClosestLocations.h"
#import "MLPAutoCompleteTextField+Reload.h"

@interface goeuro_ViewController () <MLPAutoCompleteTextFieldDataSource, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *fromField;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *toField;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *currentlyActived;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) ClosestLocations *closestLocations;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation goeuro_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self hookField:self.fromField];
    [self hookField:self.toField];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    [self setupLocationManager];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hookField:(MLPAutoCompleteTextField*)field {
    field.autoCompleteDataSource = self;
    field.autoCompleteTableBackgroundColor = [UIColor whiteColor];
    
    [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setupLocationManager {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
}

- (IBAction)submitTapped:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Search is not yet implemented" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)checkSubmitButton {
    [self.submitButton setEnabled:[self shouldSubmitButtonBeEnabled]];
}

- (BOOL)shouldSubmitButtonBeEnabled {
    return ![[self.fromField text] isEqualToString:@""] && ![[self.toField text] isEqualToString:@""];
}

- (ClosestLocations *)closestLocations {
    if(!_closestLocations) {
        _closestLocations = [ClosestLocations new];
    }
    return _closestLocations;
}

#pragma mark - Delegations


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *latest = [locations lastObject];
    [self.closestLocations updateLocation:latest];
    [self.currentlyActived reload];
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField possibleCompletionsForString:(NSString *)string completionHandler:(void (^)(NSArray *))handler {
    self.currentlyActived = textField;
    [self.closestLocations downloadForString:string success:handler];
}

- (void)textFieldDidChange:(UITextField*)textField {
    [self checkSubmitButton];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.currentlyActived.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.currentlyActived.frame.origin.y-kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWasHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}


@end
