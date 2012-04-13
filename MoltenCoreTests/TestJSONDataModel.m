//
//  TestDataModel.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestJSONDataModel.h"


@implementation TestJSONDataModel
@synthesize key1;
@synthesize key2;
@synthesize isTrue;
@synthesize isFalse;

- (id)initWithDictionary:(NSDictionary *)dict {
    if((self = [super initWithDictionary:dict])) {
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
