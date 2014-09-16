//
//  VisitFieldChooserTableViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/13/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "VisitFieldChooserTableViewController.h"

#import "BaseStore.h"
#import "PatientViewController+TableView.h"
#import "VisitFieldMetadata.h"
#import "VisitNotesComplex.h"

@interface VisitFieldChooserTableViewController ()

@property (weak, nonatomic) NSArray* visitModelDisplayMetadata;
@property (weak, nonatomic) VisitNotesComplex* visitNotes;

@property (strong, nonatomic) NSMutableSet* fieldsToRemove;
@property (strong, nonatomic) NSMutableSet* fieldsToAdd;

@property (strong, nonatomic) UIColor* addedColor;

@end

@implementation VisitFieldChooserTableViewController

- (instancetype) initWithVisit:(VisitNotesComplex*) v {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.visitNotes = v;
    [self.tableView registerClass:[PatientVisitTableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.visitModelDisplayMetadata = VisitFieldMetadata.visitFieldMetadata;
    self.fieldsToAdd = [NSMutableSet set];
    self.fieldsToRemove = [NSMutableSet set];
    self.addedColor = [UIColor colorWithHue:1 saturation:1 brightness:1.0 alpha:1.0];
  }
  return self;
}

- (instancetype) initWithStyle:(UITableViewStyle)style {
  return [self initWithVisit:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                              target:self
                                                                              action:@selector(saveChanges:)];
  self.navigationItem.rightBarButtonItem = saveButton;
}

- (void) saveChanges:(id)sender {
  for(NSNumber* rowNumber in self.fieldsToAdd) {
    NSInteger row = [rowNumber intValue];
    NSDictionary* fieldMetadata = self.visitModelDisplayMetadata[row];
    NSString* fieldName = [fieldMetadata objectForKey:@"fieldName"];

    NSObject* defaultValue = [fieldMetadata objectForKey:@"defaultValue"];
    [self.visitNotes setValue:defaultValue forKey:fieldName];
    // Special case blood pressure (lots of these :-( )
    if ([fieldName isEqualToString:@"bp_systolic"]) {
      [self.visitNotes setValue:defaultValue forKey:@"bp_diastolic"];
    }
  }
  
  for (NSNumber* rowNumber in self.fieldsToRemove) {
    NSInteger row = [rowNumber intValue];
    NSDictionary* fieldMetadata = self.visitModelDisplayMetadata[row];
    NSString* fieldName = [fieldMetadata objectForKey:@"fieldName"];
    [self.visitNotes setValue:nil forKey:fieldName];
    
  }
  [[BaseStore sharedStoreForEntity:@"VisitNotesComplex"] saveChanges];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return self.visitModelDisplayMetadata.count;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  NSDictionary* fieldMetadata = self.visitModelDisplayMetadata[row];
  NSString* fieldName = [fieldMetadata objectForKey:@"fieldName"];

  NSNumber* rowNumber = [NSNumber numberWithInteger:row];
  if ([self.fieldsToAdd member:rowNumber]) {
    [self.fieldsToAdd removeObject:rowNumber];
    [self.tableView reloadData];
    NSLog(@"%@", self.fieldsToAdd);
    NSLog(@"%@", self.fieldsToRemove);
    return;
  }
  
  if ([self.fieldsToRemove member:rowNumber]) {
    [self.fieldsToRemove removeObject:rowNumber];
    [self.tableView reloadData];
    NSLog(@"%@", self.fieldsToAdd);
    NSLog(@"%@", self.fieldsToRemove);
    return;
  }
  
  if ([self.visitNotes valueForKey:fieldName] != nil) {
    [self.fieldsToRemove addObject:[NSNumber numberWithInteger:row]];
  } else {
    [self.fieldsToAdd addObject:[NSNumber numberWithInteger:row]];
  }
  [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                          forIndexPath:indexPath];
  NSLog(@"original cell tint: %@", cell.tintColor);
  NSInteger row = [indexPath row];
  NSDictionary* fieldMetadata = self.visitModelDisplayMetadata[row];
  
  NSMutableAttributedString* textLabel = [[NSMutableAttributedString alloc] initWithString:[fieldMetadata objectForKey:@"prettyName"] attributes:nil];

  NSNumber* rowNumber = [NSNumber numberWithInteger:row];
  cell.contentView.backgroundColor = [UIColor clearColor];
  cell.textLabel.backgroundColor = [UIColor clearColor];
  cell.tintColor = [UIColor colorWithWhite:.3333 alpha:1.0];

  if ([self.fieldsToAdd member:rowNumber]) {
    cell.tintColor = [UIColor redColor];
  }
  if ([self.fieldsToRemove member:rowNumber]) {
    NSDictionary* strikeThru = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:NSUnderlineStyleSingle]]
                                                           forKeys:@[NSStrikethroughStyleAttributeName]];

    [textLabel setAttributes:strikeThru range:NSMakeRange(0, textLabel.string.length)];
  }
  cell.textLabel.attributedText = textLabel;
  
  if (([self.visitNotes valueForKey:[fieldMetadata objectForKey:@"fieldName"]] != nil &&
       ![self.fieldsToRemove member:rowNumber]) || [self.fieldsToAdd member:rowNumber]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
}

@end
