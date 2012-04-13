//
//  MVSSignedJSONRPCRequest.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 5/23/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVSJSONRPCRequest.h"

@interface MVSSignedJSONRPCRequest : MVSJSONRPCRequest {
@private
	NSString *nonce;
	NSString *hash;
	NSString *secret;
}
@property (nonatomic, copy) NSString *nonce;
@property (nonatomic, copy) NSString *hash;

- (id)initWithSecret:(NSString *)secret JSONRPC:(NSString *)version rpcMethod:(NSString *)theMethod methodParameters:(id)theParams methodID:(id)anID;

@end
