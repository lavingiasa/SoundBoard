//
//  RecordViewController.m
//  SoundBoard
//
//  Created by Samir Lavingia on 08/01/2013.
//  Copyright (c) 2013 SAM. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()

@end

@implementation RecordViewController

@synthesize playButton, stopButton, recordButton, confirmButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    playButton.enabled = NO;
    [playButton setHidden:YES];
    stopButton.enabled = NO;
    [stopButton setHidden:YES];
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
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
-(void)stop
{
    stopButton.enabled = NO;
    stopButton.hidden = YES;
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

-(void) confirm
{
    NSLog(@"Confirm");
    [self dismissViewControllerAnimated:YES completion:nil];
    //[[self parentViewController] dismissModalViewControllerAnimated:YES];
}
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
    audioPlayer = nil;
    audioRecorder = nil;
    stopButton = nil;
    recordButton = nil;
    playButton = nil;
}
- (IBAction)recordButton:(id)sender
{
    [self recordAudio];
}

- (IBAction)stopButton:(id)sender
{
    [self stop];
}

- (IBAction)playButton:(id)sender
{
    [self playAudio];
}
- (IBAction)confirmButton:(id)sender
{
    [self confirm];
}

@end








