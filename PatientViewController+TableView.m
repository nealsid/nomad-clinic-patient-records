//
//  PatientViewController+TableView.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/20/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PatientViewController+TableView.h"

#import "PickerFieldViewController.h"
#import "StringFieldViewController.h"
#import "Visit.h"
#import "VisitFieldChooserTableViewController.h"
#import "VisitNotesComplex.h"
#import "VisitNotesComplex+WeightClass.h"

@implementation PatientViewController (TableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (BOOL)    tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (BOOL)    tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return NO;
}

- (CGFloat)    tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
  return 40;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
  // + 2 for some extra "special" fields.  See cellForRowAtIndexPath for more details.
  return self.visitSpecificFieldMetadata.count + 2;
}

- (void)    tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
           forSection:(NSInteger)section {
  UITableViewHeaderFooterView* headerView = (UITableViewHeaderFooterView*)view;
  if (self.shouldAnimateHeaderBackground) {
    self.shouldAnimateHeaderBackground = NO;
    // This color is Apple iOS blue.
    UIColor* flashColor = [UIColor colorWithHue:212.0/360 saturation:.98 brightness:.98 alpha:1.0];
    [UIView animateKeyframesWithDuration:1.0 delay:0.0 options:0 animations:^{
      [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:.20 animations:^{
        headerView.contentView.backgroundColor = [UIColor clearColor];
      }];
      [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:.20 animations:^{
        headerView.contentView.backgroundColor = flashColor;
      }];
      [UIView addKeyframeWithRelativeStartTime:.4 relativeDuration:.20 animations:^{
        headerView.contentView.backgroundColor = [UIColor clearColor];
      }];
      [UIView addKeyframeWithRelativeStartTime:.6 relativeDuration:.20 animations:^{
        headerView.contentView.backgroundColor = flashColor;

      }];
      [UIView addKeyframeWithRelativeStartTime:.8 relativeDuration:.20 animations:^{
        headerView.contentView.backgroundColor = [UIColor clearColor];
      }];
    } completion:^(BOOL finished) {
      NSLog(@"Animation finished: %d", finished);
    }];
  } else {
    headerView.contentView.backgroundColor = [UIColor clearColor];
  }
}

- (UIView*)  tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
  UITableViewHeaderFooterView* view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];

  UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(13.0, 0.0, 200.0, 40.0)];

  label.text = [NSString stringWithFormat:@"%@",
                [self.dateFormatter stringFromDate:self.mostRecentVisit.visit_date]];
  view.contentView.backgroundColor = [UIColor clearColor];
//  label.backgroundColor = [UIColor whiteColor];
  [view.contentView addSubview:label];
  NSLog(@"vfhins: %@", view.contentView);
  return view;
}

- (void) animateSectionHeaderBackground {
  NSLog(@"Inside animate");
  self.shouldAnimateHeaderBackground = YES;
}

- (CGFloat)    tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
  return 0;
}

- (CGFloat)   tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (BOOL)            tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  return [indexPath row] != self.visitSpecificFieldMetadata.count;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  if (row == (self.visitSpecificFieldMetadata.count + 1)) {
    VisitFieldChooserTableViewController* vc = [[VisitFieldChooserTableViewController alloc] initWithVisit:self.mostRecentVisit.notes];
    [self.navigationController pushViewController:vc animated:YES];
    return;
  }

  NSDictionary* fieldMetadata = self.visitSpecificFieldMetadata[row];
  Class c = [fieldMetadata objectForKey:@"editClass"];
  if (c) {

    UIViewController* vc = [[c alloc] initWithFieldMetadata:fieldMetadata
                                             fromVisitNotes:self.mostRecentVisit.notes
                                       fieldChangedDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
  }
//  if (row == 0) {
//    NSArray* weightClasses = [VisitNotesComplex allWeightClassesAsStrings];
//
//    PickerFieldViewController* vc = [[PickerFieldViewController alloc]
//                                     initWithFieldName:@"Weight"
//                                     choices:weightClasses
//                                     initialChoiceIndex:[self.mostRecentVisit.notes.weight_class integerValue]
//                                     fieldEditDelegate:self];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
//  }
//  if ([indexPath row] == 2) {
//    SOAPViewController* vc = [[SOAPViewController alloc] initWithNibName:nil
//                                                                  bundle:nil
//                                                                soapType:O
//                                                                    note:self.mostRecentVisit.notes.objective
//                                                                delegate:self];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
//  }
}

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell* cell = [self.recentVisitTable dequeueReusableCellWithIdentifier:@"UITableViewCell"];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  cell.textLabel.textColor = [UIColor blackColor];
  NSInteger row = [indexPath row];
  if (row < self.visitSpecificFieldMetadata.count) {
    NSDictionary* fieldInfo = [self.visitSpecificFieldMetadata objectAtIndex:row];

    cell.textLabel.text = [fieldInfo objectForKey:@"prettyName"];

    VisitNotesComplex* notes = self.mostRecentVisit.notes;
    SEL formatSelector = [[fieldInfo objectForKey:@"formatSelector"] pointerValue];

    if (formatSelector != nil) {
      IMP imp = [self methodForSelector:formatSelector];
      NSString* (*func)(id, SEL, VisitNotesComplex*) = (void *)imp;
      NSString* formattedValue = func(self, formatSelector, notes);
      NSLog(@"Formatted value: %@", formattedValue);
      cell.detailTextLabel.text = formattedValue;
    } else {
      cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[notes valueForKey:[fieldInfo objectForKey:@"fieldName"]]];
    }
    cell.detailTextLabel.textColor = [UIColor blackColor];
    return cell;
  } else if (row == self.visitSpecificFieldMetadata.count) {
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
  } else {
    cell.textLabel.text = @"Add/remove fields to visit";
    cell.detailTextLabel.text = @"";
  }
  return cell;
}

@end

@implementation PatientVisitTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
  // ignore the style argument, use our own to override
  return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

@end
