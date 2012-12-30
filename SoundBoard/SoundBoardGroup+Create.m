//
//  SoundBoardGroup+Create.m
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import "SoundBoardGroup+Create.h"

@implementation SoundBoardGroup (Create)

+ (SoundBoardGroup *)groupWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    SoundBoardGroup * group = nil;
    group = [NSEntityDescription insertNewObjectForEntityForName:@"SoundBoardGroup" inManagedObjectContext:context];
    group.title = name;
    
    return group;
}

//This should work

@end
