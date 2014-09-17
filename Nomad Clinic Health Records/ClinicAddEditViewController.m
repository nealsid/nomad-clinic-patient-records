//
//  ClinicAddEditViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/5/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "ClinicAddEditViewController.h"

#import "BaseStore.h"
#import "Clinic.h"
#import "Utils.h"
#import "Village.h"

@interface ClinicAddEditViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *clinicVillagePickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;

@property (weak, nonatomic) IBOutlet UIDatePicker *clinicDatePicker;

@property (weak, nonatomic) IBOutlet UITextField *villageTextBox;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UITextField *clinicDateTextBox;
@property (weak, nonatomic) IBOutlet UILabel *addVillageLabel;
@property (weak, nonatomic) IBOutlet UITextField *addVillageTextbox;

@property (strong, nonatomic) NSArray* allVillages;
@property (strong, nonatomic) Clinic* clinic;
@property (strong, nonatomic) UIBarButtonItem* saveButton;
@property (strong, nonatomic) BaseStore* villageStore;

@property BOOL adjustedForTopLayout;
@property NSInteger lastSelectedVillageIndex;
@property (strong, nonatomic) NSDate* lastChosenDate;

@property (strong, nonatomic) NSString* addNewVillageString;
@end

@implementation ClinicAddEditViewController

- (instancetype)initWithClinic:(Clinic*) c {
  return [self initWithNibName:nil bundle:nil andClinic:c];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil andClinic:(Clinic*) c {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.villageStore = [BaseStore sharedStoreForEntity:@"Village"];
    self.allVillages = [self.villageStore entities];
    self.hidesBottomBarWhenPushed = YES;
    self.addNewVillageString = @"Add new village";

    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                    target:self
                                                                    action:@selector(saveClinic:)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    if (c) {
      self.title = [NSString stringWithFormat:@"Edit %@", c.village.name];
      self.clinic = c;
      self.lastSelectedVillageIndex = [self.allVillages indexOfObject:c.village];
      self.lastChosenDate = self.clinic.clinic_date;
    } else {
      self.lastSelectedVillageIndex = 0;
      self.lastChosenDate = [NSDate date];
      self.title = @"New Clinic";
    }
  }
  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil andClinic:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.villageTextBox.inputView = self.clinicVillagePickerView;
  self.villageTextBox.inputAccessoryView = self.toolbar;
  self.clinicDateTextBox.inputView = self.clinicDatePicker;
  self.clinicDateTextBox.inputAccessoryView = self.toolbar;
  NSString* initialClinicName;
  NSDate* initialDate;
  NSInteger indexOfInitialVillage;
  if (self.clinic) {
    initialClinicName = self.clinic.village.name;
    initialDate = self.clinic.clinic_date;
    indexOfInitialVillage = [self.allVillages indexOfObject:self.clinic.village];
  } else {
    indexOfInitialVillage = 0;
    initialClinicName = [[self.allVillages objectAtIndex:indexOfInitialVillage] name];
    initialDate = [NSDate date];
  }
  self.villageTextBox.text = initialClinicName;
  self.clinicDateTextBox.text = [Utils dateToMediumFormat:initialDate];
  [self.clinicVillagePickerView selectRow:indexOfInitialVillage inComponent:0 animated:NO];
  [self.clinicDatePicker setDate:initialDate];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if (!self.adjustedForTopLayout) {
    CGFloat topLayoutGuideLength = [self.topLayoutGuide length];
    self.topLayoutConstraint.constant += topLayoutGuideLength;
    [self.view layoutSubviews];
    self.adjustedForTopLayout = YES;
  }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
  NSInteger i = [self.clinicVillagePickerView selectedRowInComponent:0];
  self.lastSelectedVillageIndex = [self.allVillages indexOfObject:[self.allVillages objectAtIndex:i]];
  self.lastChosenDate = self.clinicDatePicker.date;
}

- (IBAction)cancelEditing:(id)sender {
  [self.villageTextBox resignFirstResponder];
  [self.clinicDateTextBox resignFirstResponder];

  [self.clinicVillagePickerView selectRow:self.lastSelectedVillageIndex inComponent:0 animated:NO];
  [self.clinicDatePicker setDate:self.lastChosenDate];

  if (self.lastSelectedVillageIndex == self.allVillages.count) {
    self.addVillageLabel.hidden = NO;
    self.addVillageTextbox.hidden = NO;
    self.villageTextBox.text = self.addNewVillageString;
  } else {
    self.addVillageLabel.hidden = YES;
    self.addVillageTextbox.hidden = YES;
    self.villageTextBox.text = [[self.allVillages objectAtIndex:self.lastSelectedVillageIndex] name];
    self.clinicDateTextBox.text = [Utils dateToMediumFormat:self.lastChosenDate];
  }
}

- (IBAction)doneEditing:(id)sender {
  [self.villageTextBox resignFirstResponder];
  [self.clinicDateTextBox resignFirstResponder];

  NSInteger selected = [self.clinicVillagePickerView selectedRowInComponent:0];
  if (selected == self.allVillages.count) {
    self.addVillageLabel.hidden = NO;
    self.addVillageTextbox.hidden = NO;
    self.lastSelectedVillageIndex = self.allVillages.count;
    self.villageTextBox.text = self.addNewVillageString;
  } else {
    self.addVillageLabel.hidden = YES;
    self.addVillageTextbox.hidden = YES;
    self.lastSelectedVillageIndex = [self.allVillages indexOfObject:[self.allVillages objectAtIndex:selected]];
    self.villageTextBox.text = [[self.allVillages objectAtIndex:selected] name];
  }
  
  self.lastChosenDate = self.clinicDatePicker.date;
  self.clinicDateTextBox.text = [Utils dateToMediumFormat:self.lastChosenDate];
}

- (BOOL) highlightFieldsIfInvalid {
  if ([self.clinicVillagePickerView selectedRowInComponent:0] == self.allVillages.count) {
    NSCharacterSet* ws = [NSCharacterSet whitespaceCharacterSet];
    if ([[self.addVillageTextbox.text stringByTrimmingCharactersInSet:ws] isEqualToString:@""]) {
      self.addVillageTextbox.layer.borderColor = [[UIColor redColor] CGColor];
      self.addVillageTextbox.layer.borderWidth = 1.0f;
      return YES;
    } else {
      self.addVillageTextbox.layer.borderColor = [[UIColor clearColor] CGColor];
      self.addVillageTextbox.layer.borderWidth = 1.0f;
    }
  }
  return NO;
}

- (void) saveClinic:(id) sender {
  if ([self highlightFieldsIfInvalid]) {
    return;
  }
  NSInteger selectedVillageIndex = [self.clinicVillagePickerView selectedRowInComponent:0];
  Village* v;
  if (selectedVillageIndex == self.allVillages.count) {
    v = (Village*)[self.villageStore newEntity];
    v.name = self.addVillageTextbox.text;
  } else {
    v = [self.allVillages objectAtIndex:[self.clinicVillagePickerView selectedRowInComponent:0]];
  }
  NSDate* clinic_date = [self.clinicDatePicker date];
  if (!self.clinic) {
    BaseStore* b = [BaseStore sharedStoreForEntity:@"Clinic"];
    NSPredicate *conflictingClinicsPredicate =  [NSPredicate predicateWithFormat:@"village == %@ and clinic_date == %@", v, clinic_date];
    NSArray* conflictingClinics = [b entitiesWithPredicate:conflictingClinicsPredicate];
    NSLog(@"Conflicting Clinics count: %ld", (long)conflictingClinics.count);
    self.clinic = (Clinic*)[b newEntity];
  }
  self.clinic.village = v;
  self.clinic.clinic_date = clinic_date;
  [[BaseStore sharedStoreForEntity:@"Clinic"] saveChanges];
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
  return self.allVillages.count + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  if (row < self.allVillages.count) {
    NSString* villageName = [[self.allVillages objectAtIndex:row] name];
    return villageName;
  } else {
    return self.addNewVillageString;
  }
}

@end
