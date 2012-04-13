//
//  MVSJSONDataModel.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSJSONDataModel.h"
#import "MVSSlowKeyDictionaryProxy.h"
#import "NSString+CapitalFirstLetter.h"

@interface MVSJSONDataModel (Private)

- (void)insertValuesInArray:(NSArray *)anArray forKey:(NSString *)aKey;
- (void)insertValuesInSet:(NSSet *)aSet forKey:(NSString *)aKey;
- (void)insertValuesInDictionary:(NSDictionary *)dictionary forKey:(NSString *)aKey;

- (id)mutableDictionaryForKey:(NSString *)aKey;

@end

@implementation MVSJSONDataModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if((self = [super init])) {
		[self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

- (id)initWithArray:(NSArray *)array {
	if((self = [super init])) {
		for(id obj in array) {
		}
	}
	
	return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Inherited Methods
- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues {
	NSEnumerator *enumerator = [keyedValues keyEnumerator];
	id dictKey, dictValue;
	
	while((dictKey = [enumerator nextObject])) {
		dictValue = [keyedValues objectForKey:dictKey];
		
		if([dictValue isKindOfClass:[NSArray class]]) {
			[self insertValuesInArray:dictValue forKey:dictKey];
		} else if([dictValue isKindOfClass:[NSSet class]]) {
			[self insertValuesInSet:dictValue forKey:dictKey];
		} else if([dictValue isKindOfClass:[NSDictionary class]]) {
			NSString *setSelectorString = [NSString stringWithFormat:@"setObjectIn%@:forKey:", [dictKey capitalizedFirstLetterString]];
			NSString *removeSelectorString = [NSString stringWithFormat:@"removeObjectFrom%@ForKey:", [dictKey capitalizedFirstLetterString]];
			NSString *setDictionarySelectorString = [NSString stringWithFormat:@"setDictionaryValueFor%@:", [dictKey capitalizedFirstLetterString]];
			SEL aSetSelector = NSSelectorFromString(setSelectorString);
			SEL aRemoveSelector = NSSelectorFromString(removeSelectorString);
			SEL aSetDictionarySelector = NSSelectorFromString(setDictionarySelectorString);
			
			if([self respondsToSelector:aSetSelector] && [self respondsToSelector:aRemoveSelector]) {
				[self insertValuesInDictionary:dictValue forKey:dictKey];
			} else if([self respondsToSelector:aSetDictionarySelector]) {
				[self performSelector:aSetDictionarySelector withObject:dictValue];
			} else {
				[self setValue:dictValue forKey:dictKey];
			}
		} else {
			[self setValue:dictValue forKey:dictKey];
		}
	}
}

- (void)insertValuesInArray:(NSArray *)anArray forKey:(NSString *)aKey {
	if([self valueForKey:aKey] == nil) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setValue:array forKey:aKey];
		[array release];
	}
	
	id arrayProxy = [self mutableArrayValueForKey:aKey];
	
	for(int i = 0; i < [anArray count]; i++) {
		[arrayProxy insertObject:[anArray objectAtIndex:i] atIndex:i];
	}
}

- (void)insertValuesInSet:(NSSet *)aSet forKey:(NSString *)aKey {
	id setProxy = [self mutableSetValueForKey:aKey];
	
	for(id anObject in aSet) {
		[setProxy addObject:anObject];
	}
}

- (void)insertValuesInDictionary:(NSDictionary *)dictionary forKey:(NSString *)aKey {
	id proxyDictionary = [self mutableDictionaryForKey:aKey];
	NSEnumerator *keyEnumerator = [dictionary keyEnumerator];
	id key;
	
	while ((key = [keyEnumerator nextObject])) {
		[proxyDictionary setObject:[dictionary objectForKey:key] forKey:key];
	}
}

- (id)mutableDictionaryForKey:(NSString *)aKey {
	MVSSlowKeyDictionaryProxy *proxy = [[MVSSlowKeyDictionaryProxy alloc] initWithKey:aKey andTarget:self];
	
	return [proxy autorelease];
}

- (void)setValue:(id)object forUndefinedKey:(NSString *)key {
	NSLog(@"Setting Value for key: %@", key);
}

@end
