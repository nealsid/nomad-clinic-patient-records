//
//  DiseaseTableViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/16/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "DiseaseTableViewController.h"

#import "BaseStore.h"
#import "Disease.h"
#import "FieldEditDelegate.h"
#import "StringFieldViewController.h"

@interface DiseaseTableViewController () <UITableViewDataSource, UITableViewDelegate, FieldEditDelegate>

@property (strong, nonatomic) BaseStore* diseaseStore;
@property (strong, nonatomic) NSArray* diseases;
@property (strong, nonatomic) UIFont* itemFont;
@property NSInteger currentlyEditing;

@end

@implementation DiseaseTableViewController

- (instancetype) initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    self.diseaseStore = [BaseStore sharedStoreForEntity:@"Disease"];
    self.diseases = [self.diseaseStore entities];
    self.numberOfRows = self.diseases.count;
    self.title = @"Diseases";
    self.itemFont = [UIFont systemFontOfSize:24];
    self.currentlyEditing = -1;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  UIBarButtonItem* newDiseaseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(addNewDisease:)];
  self.navigationItem.rightBarButtonItem = newDiseaseButton;
}

- (void) addNewDisease:(id) sender {
  self.currentlyEditing = -1;
  StringFieldViewController*vc = [[StringFieldViewController alloc] initWithNibName:nil bundle:nil fieldName:@"New disease name" initialValue:@"" fieldChangedDelegate:self];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void) newStringFieldValueFieldMetadata:(NSDictionary*) visitFieldMetadata
                                    value:(NSString*) newValue {
  Disease* d;
  if (self.currentlyEditing != -1) {
    d = self.diseases[self.currentlyEditing];
    self.currentlyEditing = -1;
  } else {
    d = (Disease *)[self.diseaseStore newEntity];
  }
  d.name = newValue;
  [self.diseaseStore saveChanges];
  [self refreshDiseases];
  [self.tableView reloadData];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) newFieldValuesFieldMetadata:(NSDictionary *)visitFieldMetadata value1:(NSNumber *)newValue value2:(NSNumber *)newValue2 {
  NSLog(@"This method is not implemented");
}

- (void) refreshDiseases {
  self.diseases = [self.diseaseStore entities];
  self.numberOfRows = self.diseases.count;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return self.diseases.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
  Disease* d = self.diseases[[indexPath row]];
  cell.textLabel.font = self.itemFont;
  cell.textLabel.textColor = [UIColor darkTextColor];
  cell.textLabel.text = d.name;
  return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  Disease* d = self.diseases[row];
  self.currentlyEditing = row;
  StringFieldViewController*vc = [[StringFieldViewController alloc] initWithNibName:nil bundle:nil fieldName:@"Change disease name" initialValue:d.name fieldChangedDelegate:self];
  [self.navigationController pushViewController:vc animated:YES];
}


@end
