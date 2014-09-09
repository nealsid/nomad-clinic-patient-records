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

@property (strong, nonatomic) NSArray* allVillages;
@property (strong, nonatomic) Clinic* clinic;
@property (strong, nonatomic) UIBarButtonItem* saveButton;
@property (strong, nonatomic) BaseStore* villageStore;

@property BOOL adjustedForTopLayout;

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
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                    target:self
                                                                    action:@selector(saveClinic:)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    if (c) {
      self.title = [NSString stringWithFormat:@"Edit %@", c.village.name];
      self.clinic = c;
    } else {
      self.title = @"New Clinic";
    }
    
  }
  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil andClinic:nil];
}

- (void) saveClinic:(id) sender {

}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.villageTextBox.inputView = self.clinicVillagePickerView;
  self.villageTextBox.inputAccessoryView = self.toolbar;
  self.clinicDateTextBox.inputView = self.clinicDatePicker;
  self.clinicDateTextBox.inputAccessoryView = self.toolbar;
  if (self.clinic) {
    self.villageTextBox.text = self.clinic.village.name;
    self.clinicDateTextBox.text = [Utils dateToMediumFormat:self.clinic.clinic_date];
  }
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
- (IBAction)cancelEditing:(id)sender {
  [self.villageTextBox resignFirstResponder];
}

- (IBAction)doneEditing:(id)sender {
  NSInteger selected = [self.clinicVillagePickerView selectedRowInComponent:0];
  self.villageTextBox.text = [[self.allVillages objectAtIndex:selected] name];
  [self.villageTextBox resignFirstResponder];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
  return self.allVillages.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  NSString* villageName = [[self.allVillages objectAtIndex:row] name];
  NSLog(@"Row %ld - %@", (long)row, villageName);
  return villageName;
}

@end
