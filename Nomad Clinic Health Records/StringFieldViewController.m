//
//  StringFieldViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/16/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "StringFieldViewController.h"

#import "FieldEditDelegate.h"

@interface StringFieldViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;

@property (weak, nonatomic) IBOutlet UILabel *labelField;
@property (weak, nonatomic) IBOutlet UITextField *labelTextField;

@property (strong, nonatomic) NSString* fieldName;
@property (strong, nonatomic) NSString* initialValue;

@property (strong, nonatomic) id<FieldEditDelegate> delegate;
@property BOOL didAdjustForLayoutGuides;

@end

@implementation StringFieldViewController

- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil
                       fieldName:(NSString*)fieldName
                    initialValue:(NSString*)initialValue
            fieldChangedDelegate:(id<FieldEditDelegate>)delegate {
  self = [super initWithNibName:nibNameOrNil bundle:bundleOrNil];
  if(self) {
    self.fieldName = fieldName;
    self.initialValue = initialValue;
    self.delegate = delegate;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.labelField.text = self.fieldName;
  self.labelTextField.text = self.initialValue;
  UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                              target:self
                                                                              action:@selector(saveField:)];
  [self.navigationItem setRightBarButtonItem:saveButton];
}

- (void) viewDidLayoutSubviews {
  if (!self.didAdjustForLayoutGuides) {
    CGFloat topLayoutGuideLength = [self.topLayoutGuide length];
    self.topLayoutConstraint.constant += topLayoutGuideLength;
    [self.view layoutSubviews];
    self.didAdjustForLayoutGuides = YES;
  }
}

- (BOOL) highlightFieldsIfInvalid {
  BOOL fieldIsValid = [self fieldIsValid:self.labelTextField];
  if (!fieldIsValid) {
    self.labelTextField.layer.borderColor = [[UIColor redColor] CGColor];
    self.labelTextField.layer.borderWidth = 1.0f;
  } else {
    self.labelTextField.layer.borderColor = [[UIColor clearColor] CGColor];
    self.labelTextField.layer.borderWidth = 1.0f;
  }
  return !fieldIsValid;
}

- (BOOL) fieldIsValid:(UITextField*)textField {
  NSCharacterSet* ws = [NSCharacterSet whitespaceCharacterSet];
  if ([[textField.text stringByTrimmingCharactersInSet:ws] isEqualToString:@""]) {
    return NO;
  }
  return YES;
}

- (void) saveField:(id)sender {
  if ([self highlightFieldsIfInvalid]) {
    return;
  }
  
  NSCharacterSet* ws = [NSCharacterSet whitespaceCharacterSet];
  NSString* input = [self.labelTextField.text stringByTrimmingCharactersInSet:ws];

  [self.delegate newStringFieldValueFieldMetadata:nil value:input];
}

@end
