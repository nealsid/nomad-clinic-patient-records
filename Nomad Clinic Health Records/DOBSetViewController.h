//
//  DOBSetViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/11/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgeEntryChoiceViewController.h"

@interface DOBSetViewController : UIViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
               ageChosenDelegate:(id<AgeChosenDelegate>)delegate;

@end
