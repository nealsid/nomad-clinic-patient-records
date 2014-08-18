//
//  NumberFieldViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/18/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "NumberFieldViewController.h"

@interface NumberFieldViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueField;

@property (strong, nonatomic) NSString* fieldName;
@property (strong, nonatomic) NSString* initialValue;

@end

@implementation NumberFieldViewController

- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil
                       fieldName:(NSString*)fieldName
                    initialValue:(NSString*)initialValue {
  self = [super initWithNibName:nibNameOrNil bundle:bundleOrNil];
  if(self) {
    self.fieldName = fieldName;
    self.initialValue = initialValue;
  }
  return self;
}

- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil {
  self = [self initWithNibName:nibNameOrNil
                        bundle:bundleOrNil
                     fieldName:@""
                  initialValue:@""];
  return self;
}

- (void)viewDidLoad {
  self.titleLabel.text = self.fieldName;
  self.valueField.text = self.initialValue;
  UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                              target:self
                                                                              action:@selector(saveField:)];
  [self.navigationItem setRightBarButtonItem:saveButton];
}

- (void) saveField:(id)sender {
  NSLog(@"Should save here");
}

@end
