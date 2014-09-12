//
//  PatientViewController+TableView.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/20/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PatientViewController+TableView.h"

#import "PickerFieldViewController.h"
#import "SOAPViewController.h"
#import "Visit.h"
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
  return self.visitSpecificFieldMetadata.count;
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
  view.contentView.backgroundColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor whiteColor];
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
  return [indexPath row] != 1;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([indexPath row] == 0) {
    NSArray* weightClasses = [VisitNotesComplex allWeightClassesAsStrings];

    PickerFieldViewController* vc = [[PickerFieldViewController alloc]
                                     initWithFieldName:@"Weight"
                                     choices:weightClasses
                                     initialChoiceIndex:[self.mostRecentVisit.notes.weight_class integerValue]
                                     fieldEditDelegate:self];
    [self.navigationController pushViewController:vc animated:YES];
    return;
  }
  if ([indexPath row] == 2) {
    SOAPViewController* vc = [[SOAPViewController alloc] initWithNibName:nil
                                                                  bundle:nil
                                                                soapType:O
                                                                    note:self.mostRecentVisit.notes.objective
                                                                delegate:self];
    [self.navigationController pushViewController:vc animated:YES];
    return;
  }
}

- (UITableViewCell*) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                 reuseIdentifier:@"UITableViewCell"];

  cell.textLabel.textColor = [UIColor darkGrayColor];
  NSDictionary* fieldInfo = [self.visitSpecificFieldMetadata objectAtIndex:row];
  cell.textLabel.text = [fieldInfo objectForKey:@"prettyName"];
  NSMethodSignature* formatMethod = [fieldInfo objectForKey:@"formatSelector"];
  if (formatMethod != nil) {
    NSInvocation* formatInvocation = [NSInvocation invocationWithMethodSignature:formatMethod];
    [formatInvocation setArgument:self.mostRecentVisit.notes atIndex:0];
    [formatInvocation invoke];
    cell.detailTextLabel.text;
  }
  // if (row == 0) {
  //   cell.textLabel.text = @"Weight";
  //   cell.detailTextLabel.text = [VisitNotesComplex stringForWeightClass:self.mostRecentVisit.notes.weight_class];
  //   cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:20];
  //   if ([self.mostRecentVisit.notes isWeightExteme]) {
  //     cell.detailTextLabel.textColor = [UIColor redColor];
  //   } else {
  //     cell.detailTextLabel.textColor = [UIColor blackColor];
  //   }
  // } else if (row == 1) {
  //   cell.textLabel.text = @"Healthy?";
  //   UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
  //   [switchView addTarget:self
  //                  action:@selector(isHealthySwitchClicked:)
  //        forControlEvents:UIControlEventValueChanged];
  //   cell.accessoryView = switchView;
  //   switchView.on = [self.mostRecentVisit.notes.healthy boolValue];
  //   if (![self.mostRecentVisit.notes.healthy boolValue]) {
  //     cell.textLabel.textColor = [UIColor redColor];
  //   }
  // } else if (row == 2) {
  //   cell.textLabel.text = @"Note";
  //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  // }
  return cell;
}

@end
