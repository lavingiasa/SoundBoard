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
@interface SoundBoardSoundsViewController ()

@end

@implementation SoundBoardSoundsViewController

@synthesize board = _board;

- (void)setGroup:(SoundBoardGroup *)board
    {
    _board = board;
    self.title = board.title;
    }

- (NSArray*) getSoundsFromGroup: (NSString *) group inManagedObjectContext:(NSManagedObjectContext *) context
{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SoundButton"];
        request.predicate = [NSPredicate predicateWithFormat:@"title = %@", group];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        NSError *error = nil;
        NSArray *sounds = [context executeFetchRequest:request error:&error];
        return sounds;
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

/*- (IBAction)playSound1:(id)sender
    {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"Rol" ofType:@"mp3"];
    AVAudioPlayer* theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    
    theAudio.delegate = self;
    [theAudio play];
 
    //For this method, we can add identifiers to the buttons (essentially numbers that get passed when a certain button is pressed), and these numbers that get passed through can access an array with the sound in it...cutting down time and simplifying code.
 
    }
*/

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
