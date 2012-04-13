//
//  MyClass.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MVSQueryString : NSObject {
@private
    
}

+ (NSDictionary *)parseQueryString:(NSString *)queryString;
+ (NSString *)serializeDictionary:(NSDictionary *)dict;
+ (NSString *)escapeString:(NSString *)str;

@end
