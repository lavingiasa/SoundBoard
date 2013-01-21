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
#import "RecordViewController.h"


@interface SoundBoardSoundsViewController () <UIImagePickerControllerDelegate>
@property (weak, nonatomic) NSTimer *recordingTimer;


@end

@implementation SoundBoardSoundsViewController

@synthesize board = _board;
@synthesize theAudio;
@synthesize imageFromCamera = _imageFromCamera;
@synthesize recordingTimer = _recordingTimer;
@synthesize numPick = _numPick;
@synthesize fetchRequest = _fetchRequest;
@synthesize fetchedController = _fetchedController;



- (NSArray*) getSoundsFromGroup
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SoundButton"];
    NSLog(@"%@",self.board.title);
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.predicate = [NSPredicate predicateWithFormat:@"partOf = %@", self.board];
    _fetchRequest = request;

    _fetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest:_fetchRequest managedObjectContext:self.board.managedObjectContext sectionNameKeyPath:nil cacheName:nil];



    NSError *error = nil;
    NSArray *sounds = [self.board.managedObjectContext executeFetchRequest:_fetchRequest error:&error];
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
    [self updateView];
    }

-(void)updateView
    {
    int temp = 0;
    NSLog(@"Processing view");
    NSArray *sounds = [[NSArray alloc] init];
    sounds = [self getSoundsFromGroup];
        
    if(([sounds count] % 4) != 0)
        {
        temp = 60;
        }
        
    scroller.contentSize = CGSizeMake(320, (360 * ([sounds count] / 4) + temp));
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

- (void)pushRecordController
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                  bundle:nil];
    UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"RecordViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        _numPick = [NSNumber numberWithInt:3];
    }];
    
    /*[self presentViewController:nav animated:YES completion:^{
        
        NSLog(@"Here!");
        NSArray *dirPaths;
        NSString *docsDir;
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sound.caf"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        //UIViewController *currentVC = self.navigationController.visibleViewController;
        [self addToDocWithName:@"TestRec" soundURL:soundFileURL andImage:_imageFromCamera];
        //[(SoundBoardsTableViewController *)self.parentViewController addToDocWithName:@"TestRec" soundURL:soundFileURL andImage:_imageFromCamera inBoard:_board.title];//add code to add sound to the board
        //[self viewWillAppear:YES]; //not sure if this will work
        
    }];*/
}

- (NSString *) sendNameOfButton:(SoundButton *) button
{
    return button.title;
}

- (NSString *) getTitle
{
    return _board.title;
}

- (UIImage *) getImage
{
    return _imageFromCamera;
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
            [self presentViewController:picker animated:YES completion:nil];
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
            [self presentViewController:picker animated:YES completion:nil];
            
        }
    }
    
}

- (void)dismissImagePicker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self pushRecordController];
    }];

}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _imageFromCamera = image;
    [self dismissImagePicker];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissImagePicker];
}

- (void)viewDidLoad
    {
    [super viewDidLoad];
    UILongPressGestureRecognizer *holdGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                              initWithTarget:self
                                                              action:@selector(handleHold:)];
    [self.view addGestureRecognizer:holdGestureRecognizer];
    
	// Do any additional setup after loading the view.
    }

- (void)handleHold:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint tapLocation = [recognizer locationInView:self->scroller];
    for (UIView *view in [self->scroller subviews])
    {
        if (CGRectContainsPoint(view.frame, tapLocation))
        {
            NSInteger myInt = view.tag;
            NSIndexPath * indexPath = [[NSIndexPath alloc] initWithIndex:(NSUInteger)myInt];
            [self.board.managedObjectContext deleteObject:[self.fetchedController objectAtIndexPath:indexPath]];
            [view removeFromSuperview];
            
            NSLog(@"Test");
        }
    }
}

- (void)didReceiveMemoryWarning
    {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }

@end
