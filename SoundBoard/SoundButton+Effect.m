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

- (SoundButton *) addToDoc:(SoundButton *)soundButton inManagedObjectContext:(NSManagedObjectContext *) context;
{
    SoundButton *button = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SoundButton"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        button = [NSEntityDescription insertNewObjectForEntityForName:@"SoundButton" inManagedObjectContext:context];
        button = soundButton;
    } else {
        button = [matches lastObject];
    }
    
    return button;
}
/*
- (SoundButton *) editSoundsButton: (SoundButton *) button WithTitle:(NSString *) title andPartOf:(NSString *) partOf inManagedObjectContext:context;//I don't know what file types sound and image are :P
{
    button.title = title;
    button.partOf = [SoundBoardGroup groupWithName:partOf inManagedObjectContext:context];
    //photo.whoTook = [Photographer photographerWithName:[flickrInfo objectForKey:FLICKR_PHOTO_OWNER] inManagedObjectContext:context];
    
    return button;
}
*/

@end
