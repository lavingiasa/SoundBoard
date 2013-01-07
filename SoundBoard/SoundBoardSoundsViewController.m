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
- (NSArray*) getSoundsFromGroup
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SoundButton"];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", self.board.title];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
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
    
    if(([sounds count] % 5) != 0)
        {
        temp = 60;
        }
        
    scroller.contentSize = CGSizeMake(320, (60 * ([sounds count] / 5) + temp));
    scroller.delaysContentTouches = YES;
    
    for(int i = 0; i < [sounds count]; i++)
        {
        UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
        newButton.frame = CGRectMake(20.0, 20.0, 45.0, 45.0);
        int x = 40 + (60 * ( i % 5 ) );
        int y = 30 + (60 * ( (int) i / 5 ) );
        newButton.center = CGPointMake(x, y);
        
        [[newButton layer] setBorderWidth:.5f];
        [[newButton layer] setBorderColor:[UIColor grayColor].CGColor];
        
        [newButton setBackgroundColor: [UIColor redColor]];
        [newButton setTag:i];
        //[newButton addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
        [scroller addSubview:newButton];
        }
    }

/*- (IBAction)playSound:(id)sender
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
