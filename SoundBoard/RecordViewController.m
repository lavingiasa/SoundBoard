//
//  RecordViewController.m
//  SoundBoard
//
//  Created by Samir Lavingia on 08/01/2013.
//  Copyright (c) 2013 SAM. All rights reserved.
//

#import "RecordViewController.h"
#import "SoundBoardSoundsViewController.h"

@interface RecordViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;

@end

@implementation RecordViewController

@synthesize playButton, stopButton, recordButton, confirmButton;
@synthesize questionLabel = _questionLabel;
@synthesize question = _question;
@synthesize answer = _answer;
@synthesize answerTextField = _answerTextField;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//sets up everything including the recording settings
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.questionLabel.text = self.question;
    self.answerTextField.placeholder = self.answer;
    self.answerTextField.delegate = self;
    
    playButton.enabled = NO;
    [playButton setHidden:YES];
    stopButton.enabled = NO;
    [stopButton setHidden:YES];
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        [audioRecorder prepareToRecord];
    }
}
//sets the question
- (void)setQuestion:(NSString *)question
{
    _question = question;
    self.questionLabel.text = question;
}
//sets the answer default
- (void)setAnswer:(NSString *)answer
{
    _answer = answer;
    self.answerTextField.placeholder = answer;
}
//if the test was done being edited then do this stuff
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.answer = textField.text;
    if (![textField.text length]) {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}
//if the test field has text in it
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length]) {
        [textField resignFirstResponder];
        return YES;
    } else {
        return NO;
    }
}
//bring up the view and set it up with the buttons
-(void) recordAudio
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(120, 230, 50, 50);
    [self.view addSubview:activityView];
    
    if (!audioRecorder.recording)
    {
        playButton.enabled = NO;
        [playButton setHidden:TRUE];
        stopButton.enabled = YES;
        [stopButton setHidden:FALSE];
        [audioRecorder record];
        
    }
    
    NSLog(@"record");
}
//if the stop button it hit
-(void)stop
{
    stopButton.enabled = NO;
    stopButton.hidden = YES;
    [stopButton setHidden:YES];
    stopButton.alpha = 0.0;
    playButton.enabled = YES;
    playButton.hidden = NO;
    recordButton.enabled = YES;
    recordButton.hidden = NO;
    
    if (audioRecorder.recording)
    {
        [audioRecorder stop];
    } else if (audioPlayer.playing) {
        [audioPlayer stop];
    }
    NSLog(@"stop");
}
//if the confirm button is clicked
-(void) confirm
{
    NSLog(@"Confirm");
    
    
    [self.delegate askerViewController:self didAskQuestion:self.question andGotAnswer:self.answer withSound:audioPlayer];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.answerTextField becomeFirstResponder];
}

//if the play button is clicked
-(void) playAudio
{
    if (!audioRecorder.recording)
    {
        stopButton.enabled = YES;
        stopButton.hidden = NO;
        recordButton.enabled = NO;
        recordButton.hidden = YES;
        
        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:audioRecorder.url
                       error:&error];
        
        audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else
            [audioPlayer play];
    }
    
    NSLog(@"Play");
}
//if the audio player finished playing it changes the options the user has
-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    recordButton.enabled = YES;
    recordButton.hidden = NO;
    stopButton.enabled = NO;
    stopButton.hidden = YES;
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
}

-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setQuestionLabel:nil];
    [self setAnswerTextField:nil];
    audioPlayer = nil;
    audioRecorder = nil;
    stopButton = nil;
    recordButton = nil;
    playButton = nil;
    [super viewDidUnload];
}

@end








