//
//  SoundBoardSoundsViewController.m
//  SoundBoard
//
//  Created by Samir Lavingia on 12/30/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import "SoundBoardSoundsViewController.h"
#import "SoundBoardsTableViewController.h"
#import "SoundBoardGroup.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface SoundBoardSoundsViewController () <UIImagePickerControllerDelegate>

@end

@implementation SoundBoardSoundsViewController

@synthesize board = _board;
@synthesize theAudio;


- (NSArray*) getSoundsFromGroup
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SoundButton"];
    NSLog(@"%@",self.board.title);
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"partOf = %@", self.board];
    
    NSError *error = nil;
    NSArray *sounds = [self.board.managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"%i", [sounds count]);
    return sounds;
    }

- (void)setGroup:(SoundBoardGroup *)board
    {
    _board = board;
    self.title = board.title;
    [self getSoundsFromGroup];
    }


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
    {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
        {
        // Custom initialization
        }
    return self;
    }

-(void)viewWillAppear:(BOOL)animated
    {
    [super viewWillAppear:animated];
    int temp = 0;
    
    NSArray *sounds = [[NSArray alloc] init];
    sounds = [self getSoundsFromGroup];
    
    if(([sounds count] % 4) != 0)
        {
        temp = 60;
        }
        
    scroller.contentSize = CGSizeMake(320, (60 * ([sounds count] / 4) + temp));
    scroller.delaysContentTouches = YES;
    
    for(int i = 0; i < [sounds count]; i++)
        {
        UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 60, 20)];
        newButton.frame= CGRectMake(30.0, 30.0, 60.0, 60.0);
        
        label.text = [sounds[i] title]; //gotta get title of soundobject
        label.font = [UIFont systemFontOfSize:10.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        float x = 40 + (80 * ( i % 4 ) );
        float y = 40 + (80 * ( (int) i / 4 ) );
        
        newButton.center = CGPointMake(x, y);
        label.center = CGPointMake(x, y+40);
        //[[newButton layer] setBorderWidth:.5f];
        //[[newButton layer] setBorderColor:[UIColor grayColor].CGColor];
        
        //[newButton setBackgroundColor: [UIColor redColor]];
        [newButton setImage:[sounds[i] image] forState:UIControlStateNormal];
        [newButton setTag:i];
        [newButton addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
        [scroller addSubview:newButton];
        [scroller addSubview:label];
        }
        
    }

- (IBAction)playSound:(id)sender
    {
    NSArray *sounds = [[NSArray alloc] init];
    sounds = [self getSoundsFromGroup];
    int buttonNumber = [sender tag];
    NSLog(@"sender object tag %d", buttonNumber);
    NSLog(@"sound %@", [sounds[buttonNumber] sound]);
    theAudio = [[AVAudioPlayer alloc] initWithData:[sounds[buttonNumber] sound] error:NULL];
    //NSString * path = [[NSBundle mainBundle] pathForResource:@"matches-1" ofType:@"mp3"];
    //theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
    theAudio.delegate = self;
    [theAudio play];
    sounds = NULL;
        

        //NSString * path = [[NSBundle mainBundle] pathForResource:@"Rol" ofType:@"mp3"];
        //theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
        
        //theAudio.delegate = self;
        //[theAudio play];
        
    //For this method, we can add identifiers to the buttons (essentially numbers that get passed when a certain button is pressed), and these numbers that get passed through can access an array with the sound in it...cutting down time and simplifying code.
 
    }


- (IBAction)addSound:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([mediaTypes containsObject:(NSString *)kUTTypeImage])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
            picker.allowsEditing = YES;
            [self presentModalViewController:picker animated:YES];
        }
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        if ([mediaTypes containsObject:(NSString *)kUTTypeImage]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
            picker.allowsEditing = YES;
            [self presentModalViewController:picker animated:YES];
            
        }
    }
}

- (void)dismissImagePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePicker];
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
