//
//  SoundBoardAddViewController.h
//  SoundBoard
//
//  Created by Samir Lavingia on 31/01/2013.
//  Copyright (c) 2013 SAM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SoundBoardAddViewController;

@protocol SoundBoardAddViewControllerDelegate <NSObject>
- (void)askerViewController:(SoundBoardAddViewController *)sender
             didAskQuestion:(NSString *)question
               andGotAnswer:(NSString *)answer;
@end



@interface SoundBoardAddViewController : UIViewController

@property (nonatomic, copy) NSString *question;
@property (nonatomic, copy) NSString *answer;

@property (nonatomic, weak) id <SoundBoardAddViewControllerDelegate> delegate;
@end
