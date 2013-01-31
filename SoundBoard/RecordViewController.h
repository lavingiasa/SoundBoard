//
//  RecordViewController.h
//  SoundBoard
//
//  Created by Samir Lavingia on 08/01/2013.
//  Copyright (c) 2013 SAM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class RecordViewController;

@protocol RecordViewControllerDelegate <NSObject>

- (void)askerViewController:(RecordViewController *)sender
             didAskQuestion:(NSString *)question
               andGotAnswer:(NSString *)answer;

@end

@interface RecordViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;

}
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UIButton *confirmButton;

@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *answer;

@property (nonatomic, weak) id <RecordViewControllerDelegate> delegate;

@end
