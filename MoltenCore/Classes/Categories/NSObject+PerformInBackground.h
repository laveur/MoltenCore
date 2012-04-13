//
//  NSObject+PerformInBackground.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 5/20/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (PerformInBackground)

- (void)performSelectorInBackground:(SEL)aSelector withValues:(void *)context, ...;

@end
