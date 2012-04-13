//
//  TestXMLTreeDataModel.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MoltenCore/MoltenCore.h>
#import "TestXMLSubDataModel.h"

@interface TestXMLTreeDataModel : MVSXMLDataModel {
@private
    TestXMLSubDataModel *subNode;
}
@property (nonatomic, copy) TestXMLSubDataModel *subNode;

@end
