//
//  AgeEditViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/8/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "AgeEditViewController.h"
#import <UIKit/UIKit.h>

@interface AgeEditViewController ()
@property (weak, nonatomic) IBOutlet UIView *specificAgeView;
@property (weak, nonatomic) IBOutlet UIView *ageRangeView;
@property (weak, nonatomic) IBOutlet UIView *dobPickerView;

@property (strong, nonatomic) UIGestureRecognizer *specificAgeTapRecognizer;
@property (strong, nonatomic) UIGestureRecognizer *ageRangeTapRecognizer;
@property (strong, nonatomic) UIGestureRecognizer *dobPickerTapRecognizer;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation AgeEditViewController
- (IBAction)datePickerTouchdown:(id)sender {
  NSLog(@"Date picker touchdown");
  [self changeHighlight:sender];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.specificAgeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(changeHighlight:)];
  [self.specificAgeView addGestureRecognizer:self.specificAgeTapRecognizer];

  self.ageRangeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(changeHighlight:)];
  [self.ageRangeView addGestureRecognizer:self.ageRangeTapRecognizer];

  self.dobPickerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(changeHighlight:)];
  [self.dobPickerView addGestureRecognizer:self.dobPickerTapRecognizer];
  [self.datePicker addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(changeHighlight:)]];

}

- (void) changeHighlight:(id)sender {
  NSLog(@"Changing highlight: %@", sender);
  UIView *highlightedView;
  NSMutableArray* downlightedViews = [[NSMutableArray alloc] init];
  if (sender == self.specificAgeTapRecognizer) {
    NSLog(@"specific age view tapped");
    highlightedView = self.specificAgeView;
    [downlightedViews addObjectsFromArray:@[self.ageRangeView,self.dobPickerView]];
  }
  if (sender == self.ageRangeTapRecognizer) {
    NSLog(@"age range view tapped");
    highlightedView = self.ageRangeView;
    [downlightedViews addObjectsFromArray:@[self.specificAgeView,self.dobPickerView]];
  }
  if (sender == self.dobPickerTapRecognizer || sender == self.datePicker) {
    NSLog(@"date picker view tapped");
    highlightedView = self.dobPickerView;
    [downlightedViews addObjectsFromArray:@[self.specificAgeView,self.ageRangeView]];
  }
  [highlightedView setAlpha:.75];
  for (UIView* oneView in downlightedViews) {
    [oneView setAlpha:.15];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
