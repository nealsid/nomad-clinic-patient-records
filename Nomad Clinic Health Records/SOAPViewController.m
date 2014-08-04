//
//  SOAPViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/4/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "SOAPViewController.h"

@interface SOAPViewController () {
  SOAPEntryType entryType;
}

@property (nonatomic, weak) IBOutlet UITextView* soapNoteTextView;

@property (nonatomic, weak) NSString* note;

@end

@implementation SOAPViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
                        soapType:(SOAPEntryType)s
                            note:(NSString*)text {
  self = [super init];
  if (self) {
    entryType = s;
    self.note = text;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.soapNoteTextView.text = self.note;
}

@end
