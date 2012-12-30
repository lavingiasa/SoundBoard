//
//  SoundBoardsTableViewController.h
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"


@interface SoundBoardsTableViewController : CoreDataTableViewController

@property (nonatomic, strong) UIManagedDocument *soundButtonDatabase;

@end
