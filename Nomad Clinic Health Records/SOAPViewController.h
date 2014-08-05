//
//  SOAPViewController.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/4/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import <UIKit/UIKit.h>

// An enum that represents which of the 4 components of a SOAP
// note we are displaying.  Used for UI purposes (header, etc).
typedef NS_ENUM(NSInteger, SOAPEntryType) {
  S,   // Subjective
  O,   // Objective
  A,   // Assessment
  P    // Plan
};

@class SOAPViewController;

@protocol SOAPNoteViewControllerDelegate

- (void) soapViewController:(SOAPViewController*)vc saveNewNote:(NSString*)s
                    forType:(SOAPEntryType)type;

@end

@interface SOAPViewController : UIViewController

- (NSString*) stringForSoapEntryType:(SOAPEntryType)s;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
                        soapType:(SOAPEntryType)s
                            note:(NSString*)text
                        delegate:(id<SOAPNoteViewControllerDelegate>)delegate;
@end
