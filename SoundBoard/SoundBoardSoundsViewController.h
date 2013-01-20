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
    {
        IBOutlet UIScrollView *scroller;

    }

@property (nonatomic, strong) SoundBoardGroup *board;
@property (nonatomic, strong) AVAudioPlayer* theAudio;
@property (nonatomic, strong) UIImage * imageFromCamera;
@property (nonatomic, strong) NSNumber * numPick;
- (void)pushRecordController;
- (NSString *) sendNameOfButton:(SoundButton *) button;
- (UIImage *) getImage;
- (NSString *) getTitle;
- (void) addToDocWithName: (NSString *)name soundURL:(NSURL*)url andImage:(UIImage *) image;


@end
