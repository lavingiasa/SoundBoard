//
//  SoundBoardsTableViewController.m
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import "SoundBoardsTableViewController.h"


@interface SoundBoardsTableViewController ()

@end

@implementation SoundBoardsTableViewController

@synthesize soundButtonDatabase = _soundButtonDatabase;
@synthesize names = _names;
@synthesize sounds = _sounds;
@synthesize images = _images;
//@synthesize soundsArray = _soundsArray;


@synthesize numTimesOpened = _numTimesOpened;


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
    {
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

- (SoundButton *) addSoundButton:(SoundButton *)soundButton toArray:(NSMutableArray *) array
{
    [array addObject:soundButton];
    return soundButton;
}



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

- (SoundButton *)addButtonwithName:(NSString *) name withSound:(NSString *) sound withImage: (NSString *) image inBoard:(NSString*) board
{
    SoundButton * button = [[SoundButton alloc] initWithEntity:[NSEntityDescription entityForName:@"SoundButton" inManagedObjectContext:self.soundButtonDatabase.managedObjectContext] insertIntoManagedObjectContext:self.soundButtonDatabase.managedObjectContext];
    [button editSoundsButton:button WithTitle:name andPartOf:board inManagedObjectContext:self.soundButtonDatabase.managedObjectContext withSound:sound andImage:image];
    [self addToDoc:button inManagedObjectContext:self.soundButtonDatabase.managedObjectContext];
    
    return button;
}

- (void)fetchDataIntoDocument:(UIManagedDocument *)document
    {
        
    dispatch_queue_t fetchQ = dispatch_queue_create("Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        //NSArray *sounds = [Sound getSoundsArray];
        NSArray * sounds;
       // sounds = _soundsArray;
        [document.managedObjectContext performBlock:^{ // perform in the NSMOC's safe thread (main thread)
        
        for (int i = 0; i < [sounds count]; i++)
            {
            SoundButton* object = sounds[i];
            [self addToDoc:object inManagedObjectContext:document.managedObjectContext];
            }
            // should probably saveToURL:forSaveOperation:(UIDocumentSaveForOverwriting)completionHandler: here!
            // we could decide to rely on UIManagedDocument's autosaving, but explicit saving would be better
            // because if we quit the app before autosave happens, then it'll come up blank next time we run
            // this is what it would look like (ADDED AFTER LECTURE) ...
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            // note that we don't do anything in the completion handler this time
        }];
    });
    }

/* Some sample code
 - (void)fetchFlickrDataIntoDocument:(UIManagedDocument *)document
 {
 dispatch_queue_t fetchQ = dispatch_queue_create("Flickr fetcher", NULL);
 dispatch_async(fetchQ, ^{
 NSArray *photos = [FlickrFetcher recentGeoreferencedPhotos];
 [document.managedObjectContext performBlock:^{ // perform in the NSMOC's safe thread (main thread)
 for (NSDictionary *flickrInfo in photos) {
 [Photo photoWithFlickrInfo:flickrInfo inManagedObjectContext:document.managedObjectContext];
 // table will automatically update due to NSFetchedResultsController's observing of the NSMOC
 }
 // should probably saveToURL:forSaveOperation:(UIDocumentSaveForOverwriting)completionHandler: here!
 // we could decide to rely on UIManagedDocument's autosaving, but explicit saving would be better
 // because if we quit the app before autosave happens, then it'll come up blank next time we run
 // this is what it would look like (ADDED AFTER LECTURE) ...
 [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
 // note that we don't do anything in the completion handler this time
 }];
 });
 dispatch_release(fetchQ);
 }
 */


- (id)initWithStyle:(UITableViewStyle)style
    {
    self = [super initWithStyle:style];
 
    if (self)
        {
        // Custom initialization
        }
    return self;
    }



- (void)viewDidLoad
    {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    static NSString *CellIdentifier = @"Soundboard Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    SoundBoardGroup* group = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Then configure the cell using it ...
    cell.textLabel.text = group.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d sounds", [group.contains count]];
    
    return cell;
    }


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
    }*/

/*
// Override to support conditional editing of the table view.

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
    {
    // Return NO if you do not want the specified item to be editable.
    return YES;
    }
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
    {
    if (editingStyle == UITableViewCellEditingStyleDelete)
        {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
        {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }   
    }
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
    {
    }
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    SoundBoardGroup *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // be somewhat generic here (slightly advanced usage)
    // we'll segue to ANY view controller that has a photographer @property
    if ([segue.destinationViewController respondsToSelector:@selector(setGroup:)]) {
        // use performSelector:withObject: to send without compiler checking
        // (which is acceptable here because we used introspection to be sure this is okay)
        [segue.destinationViewController performSelector:@selector(setGroup:) withObject:group];
    }
}

@end
