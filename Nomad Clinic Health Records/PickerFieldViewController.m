//
//  PickerFieldViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/1/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PickerFieldViewController.h"

#import "FieldEditDelegate.h"

@interface PickerFieldViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSubviewYConstraint;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *fieldNameLabel;

@property (strong, nonatomic) NSArray* pickerChoices;
@property (strong, nonatomic) NSString* fieldName;
@property NSInteger initialChoice;
@property BOOL adjustedForTopLayout;

@property (strong, nonatomic) id<FieldEditDelegate> delegate;
@end

@implementation PickerFieldViewController

- (instancetype) initWithFieldName:(NSString*)fieldName
                           choices:(NSArray*)choices
                initialChoiceIndex:(NSInteger) initialChoice
                 fieldEditDelegate:(id<FieldEditDelegate>)delegate {
  return [self initWithNibName:nil
                        bundle:nil
                     fieldName:fieldName
                       choices:choices
            initialChoiceIndex:initialChoice
                      fieldEditDelegate:delegate];
}

- (instancetype)initWithNibName:(NSString *) nibNameOrNil
                         bundle:(NSBundle *) nibBundleOrNil
                      fieldName:(NSString*) fieldName
                        choices:(NSArray *) choices
             initialChoiceIndex:(NSInteger) initialChoice
              fieldEditDelegate:(id<FieldEditDelegate>) delegate {

  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self) {
    self.pickerChoices = choices;
    self.fieldName = fieldName;
    self.delegate = delegate;
    self.initialChoice = initialChoice;
  }
  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
  return [self initWithNibName:nibNameOrNil
                        bundle:nibBundleOrNil
                     fieldName:nil
                       choices:nil
            initialChoiceIndex:0
                      fieldEditDelegate:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.fieldNameLabel.text = self.fieldName;
  [self.pickerView selectRow:self.initialChoice inComponent:0 animated:YES];
  UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                              target:self
                                                                              action:@selector(saveField:)];
  [self.navigationItem setRightBarButtonItem:saveButton];
}

- (void) saveField:(id)sender {
  NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
  NSNumber* newValue = [NSNumber numberWithInteger:selectedRow];
//  [self.delegate newFieldValue:newValue];
}


- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return self.pickerChoices.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  return [self.pickerChoices objectAtIndex:row];
}

- (void) viewDidLayoutSubviews {
  if (!self.adjustedForTopLayout) {
    CGFloat topLayoutGuideLength = [self.topLayoutGuide length];
    self.topSubviewYConstraint.constant += topLayoutGuideLength;
    [self.view layoutSubviews];
    self.adjustedForTopLayout = YES;
  }
}
@end
