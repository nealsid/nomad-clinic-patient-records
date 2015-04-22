//
//  DiseaseChooserTableViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 9/16/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "DiseaseChooserTableViewController.h"

#import "BaseStore.h"
#import "Disease.h"
#import "VisitNotesComplex.h"

@interface DiseaseChooserTableViewController ()

@property (weak, nonatomic) VisitNotesComplex* visitNotes;

@property (strong, nonatomic) NSMutableSet* diseasesToRemove;
@property (strong, nonatomic) NSMutableSet* diseasesToAdd;
@property (strong, nonatomic) BaseStore* diseaseStore;
@property (strong, nonatomic) NSArray* allDiseases;
@property (strong, nonatomic) id<FieldEditDelegate> delegate;
@end

@implementation DiseaseChooserTableViewController

- (instancetype) initWithFieldMetadata:(NSDictionary*)fieldMetadata
                        fromVisitNotes:(VisitNotesComplex*)notes
                  fieldChangedDelegate:(id<FieldEditDelegate>) delegate {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.visitNotes = notes;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.diseasesToAdd = [NSMutableSet set];
    self.diseasesToRemove = [NSMutableSet set];
    self.diseaseStore = [BaseStore sharedStoreForEntity:@"Disease"];
    self.allDiseases = [self.diseaseStore entities];
    self.delegate = delegate;
    self.numberOfRows = self.allDiseases.count;
    self.useColorCoding = NO;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                              target:self
                                                                              action:@selector(saveChanges:)];
  self.navigationItem.rightBarButtonItem = saveButton;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void) saveChanges:(id)sender {
  for(NSNumber* rowNumber in self.diseasesToAdd) {
    NSInteger row = [rowNumber intValue];
    [self.visitNotes addDiagnosesObject:self.allDiseases[row]];
  }

  for (NSNumber* rowNumber in self.diseasesToRemove) {
    NSInteger row = [rowNumber intValue];
    [self.visitNotes removeDiagnosesObject:self.allDiseases[row]];
  }
  [[BaseStore sharedStoreForEntity:@"Disease"] saveChanges];
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.allDiseases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
  NSInteger row = [indexPath row];
  NSNumber* rowNumber = [NSNumber numberWithInteger:row];
  cell.contentView.backgroundColor = [UIColor clearColor];
  cell.textLabel.backgroundColor = [UIColor clearColor];
  cell.tintColor = [UIColor colorWithWhite:.3333 alpha:1.0];

  NSMutableAttributedString* textLabel = [[NSMutableAttributedString alloc] initWithString:((Disease*)self.allDiseases[row]).name
                                                                                attributes:nil];
  if ([self.diseasesToAdd member:rowNumber]) {
    cell.tintColor = [UIColor redColor];
  }
  if ([self.diseasesToRemove member:rowNumber]) {
    NSDictionary* strikeThru = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithInt:NSUnderlineStyleSingle]]
                                                           forKeys:@[NSStrikethroughStyleAttributeName]];

    [textLabel setAttributes:strikeThru range:NSMakeRange(0, textLabel.string.length)];
  }
  cell.textLabel.attributedText = textLabel;
  NSSet* existingDiseases = self.visitNotes.diagnoses;
  Disease* currentRowDisease = self.allDiseases[row];
  if (([existingDiseases member:currentRowDisease] && ![self.diseasesToRemove member:rowNumber])
      || [self.diseasesToAdd member:rowNumber]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
}


// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  NSInteger row = [indexPath row];
  NSNumber* rowNumber = [NSNumber numberWithInteger:row];
  if ([self.diseasesToAdd member:rowNumber]) {
    [self.diseasesToAdd removeObject:rowNumber];
    [self.tableView reloadData];
    return;
  }

  if ([self.diseasesToRemove member:rowNumber]) {
    [self.diseasesToRemove removeObject:rowNumber];
    [self.tableView reloadData];
    return;
  }

  NSSet* existingDiseases = self.visitNotes.diagnoses;
  Disease* currentRowDisease = self.allDiseases[row];
  if ([existingDiseases member:currentRowDisease]) {
    [self.diseasesToRemove addObject:[NSNumber numberWithInteger:row]];
  } else {
    [self.diseasesToAdd addObject:[NSNumber numberWithInteger:row]];
  }
  [self.tableView reloadData];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
