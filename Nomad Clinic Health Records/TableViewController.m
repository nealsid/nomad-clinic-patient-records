//
//  TableViewDelegate.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/15/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "TableViewController.h"

@implementation TableViewController

- (instancetype) initWithStyle:(UITableViewStyle) style {
  self = [super initWithStyle:style];
  if (self) {
    self.useColorCoding = YES;
  }
  return self;
}

- (BOOL) isLastRow:(NSInteger)rowNumber {
  return rowNumber == self.numberOfRows + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (BOOL)    tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)                     tableView:(UITableView *)tableView
shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
  return ![self isLastRow: [indexPath row]];
}

- (BOOL)              tableView:(UITableView *)tableView
shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
  return ![self isLastRow: [indexPath row]];
}

- (BOOL)    tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return ![self isLastRow:[indexPath row]];
}

- (CGFloat)    tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
  return 5;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
  // We return the number of rows, plus 1 extra
  // row for the "No more patients" row.
  return self.numberOfRows;
}

- (UIView*)    tableView:(UITableView *)tableView
  viewForHeaderInSection:(NSInteger)section {
  UIView* view = [[UIView alloc] init];
  view.backgroundColor = [UIColor whiteColor];
  return view;
}

- (CGFloat)    tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
  return 0;
}

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  if (![self isLastRow:row]) {
    return 60;
  }
  return 44;
}

- (void) tableView:(UITableView*)tableView
   willDisplayCell:(UITableViewCell *)cell
 forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!self.useColorCoding) {
    return;
  }
  if ([self isLastRow:[indexPath row]]) {
    return;
  }
  if ([indexPath row] % 2 == 0) {
    cell.backgroundColor = [UIColor colorWithRed:0xda/255.0
                                           green:0xe5/255.0
                                            blue:0xf4/255.0
                                           alpha:1.0];
  }
}

- (BOOL)            tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  return ![self isLastRow:row];
}

@end
