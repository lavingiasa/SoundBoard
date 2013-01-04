//
//  Sound.m
//  SoundBoard
//
//  Created by Samir Lavingia on 12/30/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import "Sound.h"

@implementation Sound

@synthesize soundsArray = _soundsArray;

- (NSMutableArray *) getSoundsArray
    {
    return _soundsArray;
    }

@end

//This class will hold all the sounds in an array of NSDictionaries