//
//  SoundBoardAddViewController.m
//  SoundBoard
//
//  Created by Samir Lavingia on 31/01/2013.
//  Copyright (c) 2013 SAM. All rights reserved.
//

#import "SoundBoardAddViewController.h"

@interface SoundBoardAddViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAnswer;

@end

@implementation SoundBoardAddViewController

@synthesize questionLabel = _questionLabel;
@synthesize textFieldAnswer = textFieldAnswer;

@synthesize question = _question;
@synthesize answer = _answer;

@synthesize delegate = _delegate;

//question field
- (void)setQuestion:(NSString *)question
{
    _question = question;
    self.questionLabel.text = question;
}
//answer field
- (void)setAnswer:(NSString *)answer
{
    _answer = answer;
    self.textFieldAnswer.placeholder = answer;
}
//when the user is done editing
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.answer = textField.text;
    if (![textField.text length]) {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.delegate askerViewController:self didAskQuestion:self.question andGotAnswer:self.answer];
    }
}
//if there is input
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length]) {
        [textField resignFirstResponder];
        return YES;
    } else {
        return NO;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.questionLabel.text = self.question;
    self.textFieldAnswer.placeholder = self.answer;
    self.textFieldAnswer.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textFieldAnswer becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setQuestionLabel:nil];
    self.textFieldAnswer=nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
