//
//  SoundBoardsTableViewController.m
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import "SoundBoardsTableViewController.h"
#import "Sound.h"
#import "SoundButton.h"

@interface SoundBoardsTableViewController ()

@end

@implementation SoundBoardsTableViewController

@synthesize soundButtonDatabase = _soundButtonDatabase;
@synthesize soundsArray = _soundsArray;


- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
    {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SoundBoardGroup"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.soundButtonDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    }
- (void)addSampleData
{
    SoundButton * test;
    [test editSoundsButton:test WithTitle:@"test title" andPartOf:@"Default" inManagedObjectContext:self.soundButtonDatabase.managedObjectContext];
}

- (void)fetchDataIntoDocument:(UIManagedDocument *)document
    {
    
    [self addSampleData];
    dispatch_queue_t fetchQ = dispatch_queue_create("Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        //NSArray *sounds = [Sound getSoundsArray];
        NSArray * sounds;
        sounds = _soundsArray;
        [document.managedObjectContext performBlock:^{ // perform in the NSMOC's safe thread (main thread)
        
        for (int i = 0; i < [sounds count]; i++)
            {
            SoundButton* object = sounds[i];
            [object addToDoc:object inManagedObjectContext:[document managedObjectContext]];
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
            // [self fetchSoundDataIntoDocument:self.soundButtonDatabase];
         }];
        }
    else if(self.soundButtonDatabase.documentState == UIDocumentStateClosed)
        {
        [self.soundButtonDatabase openWithCompletionHandler:^(BOOL success)
            {
            [self setupFetchedResultsController];
            //[self fetchSoundDataIntoDocument:self.soundButtonDatabase];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {   
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
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
    cell.textLabel.text = [group title];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d sounds", [[group contains] count]];
    
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

@end
