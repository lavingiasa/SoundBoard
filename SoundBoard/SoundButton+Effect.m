//
//  SoundButton+Effect.m
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import "SoundButton+Effect.h"
#import "SoundBoardGroup+Create.h"

@implementation SoundButton (Effect)
//add the sound button
- (SoundButton *) addSoundButtonWithImage:(id)image andSound:(id)sound andTitle:(NSString *) title inManagedObjectContext:(NSManagedObjectContext *) context
    {
    //add implimentation to return button here.
    SoundButton * button = nil;
    button = [NSEntityDescription insertNewObjectForEntityForName:@"SoundButton" inManagedObjectContext:context];
    button.image = image; //This obviously will not work
    button.title = title;
    button.sound = sound; //This obviously will not work
    //button.partOf = title; //Not sure how to do this one
    
    return button;

    }
//edit the sound button
- (SoundButton *) editSoundsButton: (SoundButton *) button WithTitle:(NSString *) title andPartOf:(NSString *) partOf inManagedObjectContext:context withSound: (NSString *) sound andImage: (NSString *) image;//I don't know what file types sound and image are :P
{
    button.title = title;
    button.partOf = [SoundBoardGroup groupWithName:partOf inManagedObjectContext:context];
    button.image = [UIImage imageNamed:image];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:sound ofType:@"mp3"];
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    button.sound = myData;
    
    return button;
}
//another of the sameish function. Can't remember which one we use
- (SoundButton *) editSoundsButtonRecord: (SoundButton *) button WithTitle:(NSString *) title andPartOf:(NSString *) partOf inManagedObjectContext:context withSound: (NSURL *) sound andImage: (UIImage *) image
{
    button.title = title;
    button.partOf = [SoundBoardGroup groupWithName:partOf inManagedObjectContext:context];
    button.image = image;
    
    NSData *myData = [NSData dataWithContentsOfURL:sound];
    button.sound = myData;
    
    return button;
}


@end
