//
//  MVSXMLDataModel.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSXMLDataModel.h"
#import "NSString+CapitalFirstLetter.h"

@interface MVSXMLDataModel (Private)

- (void)setDataWithXMLElement:(NSXMLElement *)node;

@end

@implementation MVSXMLDataModel

- (id)initWithXMLElement:(NSXMLElement *)node {
    if((self = [super init])) {
		[self setDataWithXMLElement:node];
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark Private Methods
- (void)setDataWithXMLElement:(NSXMLElement *)node {
	NSArray *props = [node attributes];
	NSArray *children = [node children];
	
	for(NSXMLNode *prop in props) {
		[self setValue:[prop objectValue] forKey:[prop name]];
	}
	
	for(NSXMLElement *child in children) {
		NSString *selectortString = [NSString stringWithFormat:@"setXMLElementValueFor%@:", [[child name] capitalizedFirstLetterString]];
		SEL selector = NSSelectorFromString(selectortString);
		
		[self performSelector:selector withObject:child];
	}
}

@end
