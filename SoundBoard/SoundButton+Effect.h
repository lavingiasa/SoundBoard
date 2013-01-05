//
//  SoundButton+Effect.h
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import "SoundButton.h"

@interface SoundButton (Effect)

- (SoundButton *) addSoundButtonWithImage:(id)image andSound:(id)sound andTitle:(NSString *) title inManagedObjectContext:(NSManagedObjectContext *) context;//I don't know what file types sound and image are :P
- (SoundButton *) addToDoc:(SoundButton *)soundButton inManagedObjectContext:(NSManagedObjectContext *) context;

@end
