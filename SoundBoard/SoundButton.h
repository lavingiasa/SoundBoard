//
//  SoundButton.h
//  SoundBoard
//
//  Created by Samir Lavingia on 12/29/12.
//  Copyright (c) 2012 SAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SoundBoardGroup;

@interface SoundButton : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSData * sound;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) SoundBoardGroup *partOf;

@end
