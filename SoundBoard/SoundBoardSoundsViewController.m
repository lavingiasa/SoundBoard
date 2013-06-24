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
@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation SoundBoardSoundsViewController

@synthesize board = _board;
@synthesize theAudio;
@synthesize imageFromCamera = _imageFromCamera;
@synthesize recordingTimer = _recordingTimer;
@synthesize fetchRequest = _fetchRequest;
@synthesize fetchedController = _fetchedController;
@synthesize soundName = _soundName;
@synthesize label = _label;
@synthesize viewToDelte = _viewToDelte;
@synthesize popOpen = _popOpen;




//show the sheey when the add sound button is tapped
- (IBAction)showActionSheet:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Where to Get Photo?" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Library", nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
        [popupQuery showInView:self.view];
    }else{
        [self addSound];

        
   }
   
    
}

//when a button is tapped
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
     switch (buttonIndex) {
     case 0:
     self.label.text = @"Camera";
             [self addSound];
             
             
     break;
     case 1:
     self.label.text = @"Library";
             
         if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
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
     break;
     case 2:
     self.label.text = @"Cancel";
     break;
     
     }
     
}

//get sounds in the group
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

//set the group for the new board
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
//ask the question for the controller I wrote
- (void)askerViewController:(RecordViewController *)sender
             didAskQuestion:(NSString *)question
               andGotAnswer:(NSString *)answer
                  withSound:(AVAudioPlayer *) player
{
    _soundName = answer;
    audioPlayer = player;
    
    
    NSLog(@"Here!");
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sound.caf"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    [self addToDocWithName:_soundName soundURL:soundFileURL andImage:_imageFromCamera];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
    {
    [super viewWillAppear:animated];
    [self updateView];
    }
//update the view for when a new thing is added
-(void)updateView
    {
    int temp = 0;
    NSLog(@"Processing view");
    NSArray *sounds = [[NSArray alloc] init];
    sounds = [self getSoundsFromGroup];
        
    if(([sounds count] % 4) != 0)
        {
        temp = 83;
        }
        
    
    scroller.contentSize = CGSizeMake(320, 83 * ([sounds count] / 4) + temp + 83);
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
        float y = 83 + (80 * ( (int) i / 4 ) );
        
        newButton.center = CGPointMake(x, y);
        label.center = CGPointMake(x, y+40);

        [newButton setImage:[sounds[i] image] forState:UIControlStateNormal];
        [newButton setTag:i];
        [label setTag:i];
        [newButton addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
        [scroller addSubview:newButton];
        [scroller addSubview:label];
        }
    }

//after the image is taken it pops up the recorder
- (void)pushRecordController
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                  bundle:nil];
    UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"RecordViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        RecordViewController *asker = (RecordViewController *)vc;
        asker.question = @"Sound Button Title?";
        asker.answer = @"Sample Answer!";
        asker.delegate = self;
    }];

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
//plays the sound at an index
- (IBAction)playSound:(id)sender
    {
    NSArray *sounds = [[NSArray alloc] init];
    sounds = [self getSoundsFromGroup];
    int buttonNumber = [sender tag];
    NSLog(@"sender object tag %d", buttonNumber);
    NSLog(@"sound %@", [sounds[buttonNumber] sound]);
    theAudio = [[AVAudioPlayer alloc] initWithData:[sounds[buttonNumber] sound] error:NULL];
   
    theAudio.delegate = self;
    [theAudio play];
    sounds = NULL;
   
 
    }
//adds the sound
- (void)addSound
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
//used to pick the image
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
    
    }
//if its held, delete it
- (void)handleHold:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint tapLocation = [recognizer locationInView:self->scroller];

    
    for (UIView *view in [self->scroller subviews])
    {
        if (CGRectContainsPoint(view.frame, tapLocation))
        {
            _viewToDelte = view;
            if(_popOpen == FALSE)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete?"
                message:@"Are you sure you want to delete this sound" delegate:self
                cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
                _popOpen = TRUE;

                [alert show];
                
            }
            
        }
    }
    
}
//askes if you really want to delete
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        NSInteger myInt = _viewToDelte.tag;
        NSArray *sounds = [[NSArray alloc] init];
        sounds = [self getSoundsFromGroup];
        [self.board.managedObjectContext deleteObject:sounds[myInt]];
        [_viewToDelte removeFromSuperview];
        
        for (UIView *subview in [self->scroller subviews])
        {
            if (subview.tag == myInt)
            {
                [subview removeFromSuperview];
                [self updateView];
            }
        }
	}
	else {
		NSLog(@"user pressed Cancel");
	}
    
_popOpen = FALSE;
}

- (void)didReceiveMemoryWarning
    {
    [super didReceiveMemoryWarning];
    }

@end
