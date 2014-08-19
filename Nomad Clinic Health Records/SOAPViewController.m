//
//  SOAPViewController.m
//  Nomad Clinic Health Records
//
//  Created by Neal Sidhwaney on 8/4/14.
//  Copyright (c) 2014 Upaya Zen Center. All rights reserved.
//

#import "SOAPViewController.h"

@interface SOAPViewController () {
  SOAPEntryType entryType;
}

@property (nonatomic, weak) IBOutlet UITextView* soapNoteTextView;

@property (nonatomic, weak) NSString* note;
@property (nonatomic, strong) UITapGestureRecognizer* tapRecognizer;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (weak, nonatomic) id<SOAPNoteViewControllerDelegate> delegate;

@end

@implementation SOAPViewController

- (IBAction)saveButtonPressed:(id)sender {
  NSString* newText = self.soapNoteTextView.text;
  BOOL theSame = [newText isEqual:self.note];

  if (!theSame) {
    [self.delegate soapViewController:self
                          saveNewNote:newText
                              forType:entryType];
  } else {
    [self cancelButtonPressed:nil];
  }
}

- (IBAction)cancelButtonPressed:(id)sender {
  [self.toolbar setHidden:YES];
  [self.soapNoteTextView setText:self.note];
  [self.soapNoteTextView setEditable:NO];
  [self.navigationController popViewControllerAnimated:YES];
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil
                        soapType:(SOAPEntryType)s
                            note:(NSString*)text
                        delegate:(id<SOAPNoteViewControllerDelegate>)delegate {
  self = [super init];
  if (self) {
    entryType = s;
    self.note = text;
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(tap:)];
    self.delegate = delegate;
  }
  return self;
}

-(void)tap:(id)sender {
  [self.soapNoteTextView setEditable:YES];
  [self.toolbar setHidden:NO];
  [self.soapNoteTextView setSelectedRange:NSMakeRange(3,0)];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.soapNoteTextView.text = self.note;
  [self.soapNoteTextView addGestureRecognizer:self.tapRecognizer];
  self.title = [self stringForSoapEntryType:entryType];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow: (NSNotification *)notification {
  UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
  NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  CGRect keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  [UIView beginAnimations:nil context: nil];
  [UIView setAnimationCurve:animationCurve];
  [UIView setAnimationDuration:animationDuration];
  [self.toolbar setFrame:CGRectMake(0.0f,
                                    self.view.frame.size.height - keyboardBounds.size.height - self.toolbar.frame.size.height,
                                    self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
  [UIView commitAnimations];
}

- (void) keyboardWillHide: (NSNotification *)notification {
  UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
  NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  [UIView beginAnimations:nil context: nil];
  [UIView setAnimationCurve:animationCurve];
  [UIView setAnimationDuration:animationDuration];
  [self.toolbar setFrame:CGRectMake(0.0f,
                                    self.view.frame.size.height - 46.0f, self.toolbar.frame.size.width,
                                    self.toolbar.frame.size.height)];

  [UIView commitAnimations];
}

- (NSString*) stringForSoapEntryType:(SOAPEntryType)s {
  switch(s) {
    case S:
      return @"Subjective";
    case O:
      return @"Objective";
    case A:
      return @"Assessment";
    case P:
      return @"Plan";
    default:
      return @"";
  }
}

@end
