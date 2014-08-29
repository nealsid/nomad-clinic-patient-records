//
//  PatientViewController+TableView.h
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/20/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "PatientViewController.h"

@interface PatientViewController (TableView) <UITableViewDataSource, UITableViewDelegate>

- (void) animateSectionHeaderBackground;

@end
