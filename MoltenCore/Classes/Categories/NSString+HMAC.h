//
//  NSString+HMAC.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 5/23/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_HMAC)

- (NSString *)hmacSHA1SignatureWithKey:(NSString *)key;

@end
