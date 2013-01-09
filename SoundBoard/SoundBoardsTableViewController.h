//
//  SoundBoardsTableViewController.h
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Sound.h"
#import "SoundBoardGroup.h"
#import "SoundButton.h"
#import "SoundButton+Effect.h"


@interface SoundBoardsTableViewController : CoreDataTableViewController

//@property (nonatomic, strong) NSMutableArray *soundsArray;
@property (nonatomic, strong) UIManagedDocument *soundButtonDatabase;
@property (nonatomic, strong) NSNumber *numTimesOpened;
@property (nonatomic, strong) NSMutableArray* names;
@property (nonatomic, strong) NSMutableArray* sounds;
@property (nonatomic, strong) NSMutableArray* images;

- (SoundButton *) addToDoc:(SoundButton *)soundButton inManagedObjectContext:(NSManagedObjectContext *) context;

- (NSManagedObjectContext *) getContext;

- (void) addToDocWithName: (NSString *)name soundURL:(NSURL*)url andImage:(UIImage *) image inBoard:(NSString *) board;

@end
