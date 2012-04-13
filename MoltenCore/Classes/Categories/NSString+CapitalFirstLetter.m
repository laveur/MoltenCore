//
//  NSString+CapitalFirstLetter.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+CapitalFirstLetter.h"


@implementation NSString (NSString_CapitalFirstLetter)

- (NSString *)capitalizedFirstLetterString {
	NSRange firstCharRange = NSMakeRange(0,1);
	NSString* firstCharacter = [self substringWithRange:firstCharRange];
	NSString* uppercaseFirstChar = [firstCharacter uppercaseString];
	NSMutableString* capitalisedSentence = [self mutableCopy];
	[capitalisedSentence replaceCharactersInRange:firstCharRange withString:uppercaseFirstChar];
	
	return [capitalisedSentence autorelease];
}

@end
