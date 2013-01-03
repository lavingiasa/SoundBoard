//
//  SoundBoardSoundsViewController.m
//  SoundBoard
//
//  Created by Samir Lavingia on 12/30/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import "SoundBoardSoundsViewController.h"

@interface SoundBoardSoundsViewController ()

@end

@implementation SoundBoardSoundsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)playSound1:(id)sender
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Rol" ofType:@"mp3"];
    AVAudioPlayer* theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    theAudio.delegate = self;
    [theAudio play];
    /*
    For this method, we can add identifiers to the buttons (essentially numbers that get passed when a certain button is pressed), and these numbers that get passed through can access an array with the sound in it...cutting down time and simplifying code.
    */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
