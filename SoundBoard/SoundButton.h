//
//  SoundButton.h
//  SoundBoard
//
//  Created by Samir Lavingia on 06/01/2013.
//  Copyright (c) 2013 SAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SoundBoardGroup;

@interface SoundButton : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSData * sound;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) SoundBoardGroup *partOf;

@end
