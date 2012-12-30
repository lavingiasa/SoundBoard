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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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

- (void)setupFetchedResultsController
{
    //
}

- (void) fetchSoundDataIntoDocument: (UIManagedDocument *)document
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Sound fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *soundButtons = ;//array of NSDictionaries of sound buttons
        [document.managedObjectContext performBlock:^{
           for (NSDictionary *soundButtonInfo in soundButtons)
           {
               
           }
        }];
    });
}

- (void) useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.soundButtonDatabase.fileURL path]])
    {
        [self.soundButtonDatabase saveToURL:self.soundButtonDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             [self setupFetchedResultsController];
             [self fetchSoundDataIntoDocument:self.soundButtonDatabase];
         }];
        
    }else if(self.soundButtonDatabase.documentState == UIDocumentStateClosed)
    {
        [self.soundButtonDatabase openWithCompletionHandler:^(BOOL success)
        {
            [self setupFetchedResultsController];
            [self fetchSoundDataIntoDocument:self.soundButtonDatabase];
        }];
    }else if(self.soundButtonDatabase.documentState == UIDocumentStateNormal){
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
