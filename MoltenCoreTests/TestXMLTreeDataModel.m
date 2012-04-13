//
//  TestXMLTreeDataModel.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestXMLTreeDataModel.h"

@implementation TestXMLTreeDataModel
@synthesize subNode;

- (id)initWithXMLElement:(NSXMLNode *)node {
    if((self = [super initWithXMLElement:node])) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)setXMLElementValueForSubNode:(NSXMLNode *)node {
	self->subNode = [[TestXMLSubDataModel alloc] initWithXMLElement:node];
}

@end
