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


@interface SoundBoardSoundsViewController : UIViewController <AVAudioPlayerDelegate, UIActionSheetDelegate,UIAlertViewDelegate>
    {
        IBOutlet UIScrollView *scroller;
        AVAudioPlayer *audioPlayer;


    }

@property (nonatomic, strong) SoundBoardGroup *board;
@property (nonatomic, strong) AVAudioPlayer* theAudio;
@property (nonatomic, strong) UIImage * imageFromCamera;
@property (nonatomic, strong) NSFetchRequest * fetchRequest;
@property (nonatomic, strong) NSFetchedResultsController * fetchedController;
@property (nonatomic, strong) NSString * soundName;
@property (nonatomic, strong) UIView* viewToDelte;

- (void)pushRecordController;
- (NSString *) sendNameOfButton:(SoundButton *) button;
- (UIImage *) getImage;
- (NSString *) getTitle;
- (void) addToDocWithName: (NSString *)name soundURL:(NSURL*)url andImage:(UIImage *) image;


@end
