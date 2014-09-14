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
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextField *field2;

@property (weak, nonatomic) id<FieldEditDelegate> delegate;

@property (strong, nonatomic) NSString* fieldName;
@property (strong, nonatomic) NSString* initialValue;

@property (strong, nonatomic) NSString* field2Name;
@property (strong, nonatomic) NSString* initialValue;

@end

@implementation NumberFieldViewController

- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil
                       fieldName:(NSString*)fieldName
                    initialValue:(NSString*)initialValue
                      field2Name:(NSString*)field2Name
              field2InitialValue:(NSString*)field2InitialValue
            fieldChangedDelegate:(id<FieldEditDelegate>)delegate {
  self = [super initWithNibName:nibNameOrNil bundle:bundleOrNil];
  if(self) {
    self.fieldName = fieldName;
    self.initialValue = initialValue;
    if (field2Name) {
      self.label2.text = field2Name;
      self.field2.text = field2InitialValue;
    }
    self.delegate = delegate;
  }
  return self;
}

- (instancetype) initWithFieldName:(NSString*)fieldName
                      initialValue:(NSString*)initialValue
                        field2Name:(NSString*)field2Name
                field2InitialValue:(NSString*)field2InitialValue
              fieldChangedDelegate:(id<FieldEditDelegate>)delegate {
  return [self initWithNibName:nil
                        bundle:nil
                     fieldName:fieldName
                  initialValue:initialValue
                    field2Name:field2Name
            field2InitialValue:field2InitialValue
          fieldChangedDelegate:delegate];
}

- (instancetype) initWithFieldName:(NSString*)fieldName
                      initialValue:(NSString*)initialValue
              fieldChangedDelegate:(id<FieldEditDelegate>)delegate {
  return [self initWithNibName:nil
                        bundle:nil
                     fieldName:fieldName
                  initialValue:initialValue
                    field2Name:nil
            field2InitialValue:nil
          fieldChangedDelegate:delegate];
}

- (instancetype) initWithNibName:(NSString*)nibNameOrNil
                          bundle:(NSBundle*)bundleOrNil {
  self = [self initWithNibName:nibNameOrNil
                        bundle:bundleOrNil
                     fieldName:@""
                  initialValue:@""
                    field2Name:nil
            field2InitialValue:nil
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
  if (self.label2) {
    self.label2.hidden = NO;
    self.field2.hidden = NO;
  }
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
