//
//  SoundBoardGroup+Create.m
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import "SoundBoardGroup+Create.h"

@implementation SoundBoardGroup (Create)
//makes the group with the name in a context
+ (SoundBoardGroup *)groupWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
    {
    SoundBoardGroup * group = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SoundBoardGroup"];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

    NSError *error = nil;
    NSArray *soundBoardGroups = [context executeFetchRequest:request error:&error];

    if (!soundBoardGroups || [soundBoardGroups count] >1)
    {
        //handle error
    }else if (![soundBoardGroups count]){
        group = [NSEntityDescription insertNewObjectForEntityForName:@"SoundBoardGroup" inManagedObjectContext:context];
        group.title = name;
    }else{
        group = [soundBoardGroups lastObject];
    }
    return group;
      
    }

//This should work

@end
