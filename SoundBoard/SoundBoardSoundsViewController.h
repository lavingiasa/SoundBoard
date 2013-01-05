//
//  SoundBoardSoundsViewController.h
//  SoundBoard
//
//  Created by Samir Lavingia on 12/30/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SoundBoardsTableViewController.h"
#import "SoundBoardGroup.h"
#import "SoundButton.h"


@interface SoundBoardSoundsViewController : UIViewController <AVAudioPlayerDelegate>

@property (nonatomic, strong) SoundBoardGroup *board;

@end
