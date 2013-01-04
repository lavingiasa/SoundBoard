//
//  SoundBoardGroup+Create.h
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import "SoundBoardGroup.h"

@interface SoundBoardGroup (Create)

+ (SoundBoardGroup *)groupWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context;



@end
