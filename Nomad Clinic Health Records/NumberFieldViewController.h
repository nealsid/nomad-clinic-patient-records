//
//  NumberFieldViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/18/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FieldEditDelegate

- (void) newFieldValue:(NSString*) newValue;

@end

@interface NumberFieldViewController : UIViewController

- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil
                       fieldName:(NSString*)fieldName
                    initialValue:(NSString*)initialValue;

@end
