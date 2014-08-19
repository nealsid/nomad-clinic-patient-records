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

@property (weak, nonatomic) id<FieldEditDelegate> delegate;

@property (strong, nonatomic) NSString* fieldName;
@property (strong, nonatomic) NSString* initialValue;

@end

@implementation NumberFieldViewController

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

- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil {
  self = [self initWithNibName:nibNameOrNil
                        bundle:bundleOrNil
                     fieldName:@""
                  initialValue:@""
                      fieldChangedDelegate:nil];
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

- (void) highlightFieldIfInvalid {
  if (![self fieldIsValid]) {
    self.valueField.layer.borderColor = [[UIColor redColor] CGColor];
    self.valueField.layer.borderWidth = 1.0f;
  } else {
    self.valueField.layer.borderColor = [[UIColor clearColor] CGColor];
    self.valueField.layer.borderWidth = 1.0f;
  }
}

- (BOOL) fieldIsValid {
  NSCharacterSet* ws = [NSCharacterSet whitespaceCharacterSet];
  if ([self.valueField.text integerValue] == 0 &&
      ![[self.valueField.text stringByTrimmingCharactersInSet:ws] isEqualToString:@"0"]) {
    return NO;
  }
  return YES;
}

- (void) saveField:(id)sender {
  if (![self fieldIsValid]) {
    [self highlightFieldIfInvalid];
    return;
  }
  NSCharacterSet* ws = [NSCharacterSet whitespaceCharacterSet];
  NSString* input = [self.valueField.text stringByTrimmingCharactersInSet:ws];

  NSNumber* newValue = [NSNumber numberWithInteger:[input integerValue]];
  [self.delegate newFieldValue:newValue];
}

@end
