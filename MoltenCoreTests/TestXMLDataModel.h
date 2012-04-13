//
//  TestXMLDataModel.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MoltenCore/MoltenCore.h>

@interface TestXMLDataModel : MVSXMLDataModel {
@private
    NSString *key1;
	NSString *key2;
}
@property (nonatomic, copy) NSString *key1;
@property (nonatomic, copy) NSString *key2;

@end
