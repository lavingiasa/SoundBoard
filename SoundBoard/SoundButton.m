//
//  SoundButton.m
//  SoundBoard
//
//  Created by Samir Lavingia on 06/01/2013.
//  Copyright (c) 2013 SAM. All rights reserved.
//

#import "SoundButton.h"
#import "SoundBoardGroup.h"


@implementation SoundButton

@dynamic image;
@dynamic sound;
@dynamic title;
@dynamic partOf;


+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSData class];
}


- (id)transformedValue:(id)value {
    NSData *data = UIImagePNGRepresentation(value);
    return data;
}


- (id)reverseTransformedValue:(id)value {
    UIImage *uiImage = [[UIImage alloc] initWithData:value];
    return [uiImage autorelease];
}


@end
