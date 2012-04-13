//
//  TestXMLDataModel.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestXMLDataModel.h"


@implementation TestXMLDataModel
@synthesize key1;
@synthesize key2;


- (id)initWithXMLElement:(NSXMLElement *)node {
    if ((self = [super initWithXMLElement:node])) {
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
