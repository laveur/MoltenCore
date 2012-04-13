//
//  TestDataModel.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MoltenCore/MoltenCore.h>

@interface TestJSONDataModel : MVSJSONDataModel {
@private
    NSString *key1;
	NSNumber *key2;
	BOOL isTrue;
	BOOL isFalse;
}
@property (nonatomic, copy) NSString *key1;
@property (nonatomic, copy) NSNumber *key2;
@property (nonatomic, assign) BOOL isTrue;
@property (nonatomic, assign) BOOL isFalse;

@end
