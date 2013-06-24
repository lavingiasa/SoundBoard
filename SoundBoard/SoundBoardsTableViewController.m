//
//  SoundBoardsTableViewController.m
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import "SoundBoardsTableViewController.h"
#import "SoundBoardAddViewController.h"


@interface SoundBoardsTableViewController ()

@end

@implementation SoundBoardsTableViewController

@synthesize soundButtonDatabase = _soundButtonDatabase;
@synthesize names = _names;
@synthesize sounds = _sounds;
@synthesize images = _images;


@synthesize numTimesOpened = _numTimesOpened;

//get the data
- (void)setupFetchedResultsController     {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SoundBoardGroup"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.soundButtonDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    }

- (NSManagedObjectContext *) getContext
{
    return self.soundButtonDatabase.managedObjectContext;
}
//add the sound to the document in the object context
- (SoundButton *) addToDoc:(SoundButton *)soundButton inManagedObjectContext:(NSManagedObjectContext *) context;
{
    SoundButton *button = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SoundButton"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        button = [NSEntityDescription insertNewObjectForEntityForName:@"SoundButton" inManagedObjectContext:context];
        button = soundButton;
    } else {
        button = [matches lastObject];
    }
    
    return button;
}

//add the sound button
- (SoundButton *) addSoundButton:(SoundButton *)soundButton toArray:(NSMutableArray *) array
{
    [array addObject:soundButton];
    return soundButton;
}


//add the sample data
- (void)addSampleData
    {
        _names = [[NSMutableArray alloc] init];
        _sounds = [[NSMutableArray alloc] init];
        _images = [[NSMutableArray alloc] init];

        for (int i = 0; i < 24; i++)
        {
            _names[i] = [NSString stringWithFormat:@"%s %i", "test:", i];
            _images[i] = [NSString stringWithFormat:@"%s", "thumb"];
            if (i % 2 == 0)
            {
                _sounds[i] = [NSString stringWithFormat:@"%s", "matches-1"];
            }else{
                _sounds[i] = [NSString stringWithFormat:@"%s", "Rol"];
            }
        }
        
        for (int i = 0; i < 24; i++)
        {
            SoundButton * sound = [self addButtonwithName: _names[i] withSound:_sounds[i] withImage:_images[i] inBoard:@"Woo it works!"];
        }
        
    }

//add the button with sound, image, in the named board
- (SoundButton *)addButtonwithName:(NSString *) name withSound:(NSString *) sound withImage: (NSString *) image inBoard:(NSString*) board
{
    SoundButton * button = [[SoundButton alloc] initWithEntity:[NSEntityDescription entityForName:@"SoundButton" inManagedObjectContext:self.soundButtonDatabase.managedObjectContext] insertIntoManagedObjectContext:self.soundButtonDatabase.managedObjectContext];
    [button editSoundsButton:button WithTitle:name andPartOf:board inManagedObjectContext:self.soundButtonDatabase.managedObjectContext withSound:sound andImage:image];
    [self addToDoc:button inManagedObjectContext:self.soundButtonDatabase.managedObjectContext];
    
    return button;
}

//get the database
-(UIManagedDocument *)getDatabase
    {
    return _soundButtonDatabase;
    }

//get the data into the document
- (void)fetchDataIntoDocument:(UIManagedDocument *)document
    {
        
    dispatch_queue_t fetchQ = dispatch_queue_create("Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSArray * sounds;
        [document.managedObjectContext performBlock:^{ 
        
        for (int i = 0; i < [sounds count]; i++)
            {
            SoundButton* object = sounds[i];
            [self addToDoc:object inManagedObjectContext:document.managedObjectContext];
            }

            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        }];
    });
    }



- (id)initWithStyle:(UITableViewStyle)style
    {
    self = [super initWithStyle:style];
 
    if (self)
        {
        }
    return self;
    }



- (void)viewDidLoad
    {
    [super viewDidLoad];
    
    }
//use a certain document
- (void) useDocument
    {
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.soundButtonDatabase.fileURL path]])
        {
        [self.soundButtonDatabase saveToURL:self.soundButtonDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             [self setupFetchedResultsController];
             [self fetchDataIntoDocument:self.soundButtonDatabase];
             if(_numTimesOpened == 0)
             {
                 [self addSampleData];
                 _numTimesOpened = [[NSNumber alloc] initWithInt:5];
             }
         }];
        }
    else if(self.soundButtonDatabase.documentState == UIDocumentStateClosed)
        {
        [self.soundButtonDatabase openWithCompletionHandler:^(BOOL success)
            {
            [self setupFetchedResultsController];
            [self fetchDataIntoDocument:self.soundButtonDatabase];
        }];
        }
    else if(self.soundButtonDatabase.documentState == UIDocumentStateNormal)
        {
        [self setupFetchedResultsController];
            
        }
    }
//set the database
- (void) setSoundButtonDatabase:(UIManagedDocument *)soundButtonDatabase
    {
    if (_soundButtonDatabase != soundButtonDatabase)
        {
        _soundButtonDatabase = soundButtonDatabase;
        [self useDocument];
        }
    }

- (void) viewWillAppear:(BOOL)animated
    {
    [super viewWillAppear:animated];
    
    if (!self.soundButtonDatabase)
        {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
        url = [url URLByAppendingPathComponent:@"Default Sounds Database"];
        self.soundButtonDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        }
        


    }


- (void)didReceiveMemoryWarning
    {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }
//set up the table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    static NSString *CellIdentifier = @"Soundboard Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
    SoundBoardGroup* group = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = group.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d sounds", [group.contains count]];
    
    return cell;
    }
//add the name, sound, image, board into the document
- (void) addToDocWithName: (NSString *)name soundURL:(NSURL*)url andImage:(UIImage *) image inBoard:(NSString *) board
{
    SoundButton * button = [[SoundButton alloc] initWithEntity:[NSEntityDescription entityForName:@"SoundButton" inManagedObjectContext:_soundButtonDatabase.managedObjectContext] insertIntoManagedObjectContext:self.soundButtonDatabase.managedObjectContext];
    [button editSoundsButtonRecord:button WithTitle:name andPartOf:board inManagedObjectContext:self.soundButtonDatabase.managedObjectContext withSound:url andImage:image];
    [self addToDoc:button inManagedObjectContext:self.soundButtonDatabase.managedObjectContext];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
    {
    return YES;
    }


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_soundButtonDatabase.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![_soundButtonDatabase.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    SoundBoardGroup *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Groups" style:UIBarButtonItemStyleBordered target:nil action:nil];

    if ([segue.destinationViewController respondsToSelector:@selector(setGroup:)]) {
        [segue.destinationViewController performSelector:@selector(setGroup:) withObject:group];
    }
    
    if ([segue.identifier hasPrefix:@"Add Board"]) {
        SoundBoardAddViewController *asker = (SoundBoardAddViewController *)segue.destinationViewController;
        asker.question = @"What do you want your label to say?";
        asker.answer = @"Label Text";
        asker.delegate = self;
    }
}

- (void)askerViewController:(SoundBoardAddViewController *)sender didAskQuestion:(NSString *)question andGotAnswer:(NSString *)answer
{
    SoundBoardGroup * board = [[SoundBoardGroup alloc] initWithEntity:[NSEntityDescription entityForName:@"SoundBoardGroup" inManagedObjectContext:self.soundButtonDatabase.managedObjectContext]
    insertIntoManagedObjectContext:self.soundButtonDatabase.managedObjectContext];
    board.title = answer;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
