//
//  SoundBoardGroup.h
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SoundButton;

@interface SoundBoardGroup : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *contains;
@end

@interface SoundBoardGroup (CoreDataGeneratedAccessors)

- (void)addContainsObject:(SoundButton *)value;
- (void)removeContainsObject:(SoundButton *)value;
- (void)addContains:(NSSet *)values;
- (void)removeContains:(NSSet *)values;

@end
