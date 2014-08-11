//
//  AgeEditViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/8/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AgeChosenDelegate

- (void) ageWasChosenByBirthdate:(NSDate*) birthDate;
- (void) ageWasChosenByAge:(NSInteger) age;
- (void) ageWasChosenByAgeRange:(NSInteger)minAge to:(NSInteger)maxAge;

@end

@interface AgeEntryChoiceViewController : UIViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
                     patientName:(NSString*)patientName
               ageChosenDelegate:(id<AgeChosenDelegate>)delegate;

@end
