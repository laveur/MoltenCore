//
//  TestXMLSubDataModel.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestXMLSubDataModel.h"


@implementation TestXMLSubDataModel
@synthesize key1;
@synthesize key2;

- (id)initWithXMLElement:(NSXMLNode *)node {
    if((self = [super initWithXMLElement:node])) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
