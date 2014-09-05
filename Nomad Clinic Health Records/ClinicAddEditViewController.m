//
//  ClinicAddEditViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/5/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "ClinicAddEditViewController.h"

#import "BaseStore.h"

@interface ClinicAddEditViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *clinicVillagePickerView;
@property (weak, nonatomic) BaseStore* villageStore;
@property (strong, nonatomic) NSArray* allVillages;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property BOOL adjustedForTopLayout;

@property (strong, nonatomic) UIBarButtonItem* saveButton;

@end

@implementation ClinicAddEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.villageStore = [BaseStore sharedStoreForEntity:@"Village"];
    self.allVillages = [self.villageStore entities];
    self.hidesBottomBarWhenPushed = YES;
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                    target:self
                                                                    action:@selector(saveClinic:)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    self.title = @"New Clinic";

  }
  return self;
}

- (void) saveClinic:(id) sender {

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

- (void)viewDidLoad {
  [super viewDidLoad];
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
