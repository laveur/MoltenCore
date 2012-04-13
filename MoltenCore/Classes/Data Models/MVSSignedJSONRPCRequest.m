//
//  MVSSignedJSONRPCRequest.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 5/23/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//
#import "NSString+HMAC.h"
#import "MVSSignedJSONRPCRequest.h"

@interface MVSSignedJSONRPCRequest (Private)

- (NSString *)signatureWithSecret:(NSString *)secret forDictionary:(NSDictionary *)dictionary;

@end

@implementation MVSSignedJSONRPCRequest

#pragma mark - Synthesized Properties
@synthesize nonce;
@synthesize hash;

#pragma mark - Initialization Methods
- (id)initWithSecret:(NSString *)theSecret JSONRPC:(NSString *)version rpcMethod:(NSString *)theMethod methodParameters:(id)theParams methodID:(id)anID {
	if((self = [super initWithJSONRPC:version rpcMethod:theMethod methodParameters:theParams methodID:anID])) {
		self->secret = [theSecret copy];
	}
	
	return self;
}

- (void)dealloc {
	[self->secret release];
	
	[super dealloc];
}

#pragma mark - Property Override Methods
- (NSString *)nonce {
	if(self->nonce == nil) {
		self.nonce = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
	}
	
	return self->nonce;
}

#pragma mark - Inherited
- (id)valueForUndefinedKey:(NSString *)key {
	if([key isEqualToString:@"!nonce"]) {
		return self.nonce;
	} else if([key isEqualToString:@"!hash"]) {
		return self.hash;
	} else {
		[super valueForUndefinedKey:key];
	}
	
	return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	if([key isEqualToString:@"!nonce"]) {
		self.nonce = value;
	} else if([key isEqualToString:@"!hash"]) {
		self.hash = value;
	} else {
		[super setValue:value forUndefinedKey:key];
	}
}

#pragma mark - Instance Methods
- (NSDictionary *)serializeRequest {
	NSArray *keys = [NSArray arrayWithObjects:@"jsonrpc", @"method", @"id", @"!nonce", nil];
	NSMutableDictionary *values = [[self dictionaryWithValuesForKeys:keys] mutableCopy];
	NSString *signature = [self signatureWithSecret:self->secret forDictionary:values];
	[values setValue:signature forKey:@"!hash"];
	[values setValue:self.params forKey:@"params"];

	return [values autorelease];
}

#pragma mark - Private Methods
- (NSString *)signatureWithSecret:(NSString *)theSecret forDictionary:(NSDictionary *)dictionary {
	NSMutableString *signatureString = [NSMutableString string];
	NSArray *keys = [dictionary allKeys];
	keys = [keys sortedArrayUsingSelector:@selector(localizedCompare:)];
	NSUInteger total = [keys count];
	
	for(NSUInteger i = 0; i < total; i++) {
		NSString *key = [keys objectAtIndex:i];
		[signatureString appendFormat:@"%@=%@", key, [dictionary objectForKey:key]];
		
		if((i + 1) < total) {
			[signatureString appendString:@"&"];
		}
	}
	
	NSString *signature = [signatureString hmacSHA1SignatureWithKey:secret];
	
	return signature;
}

@end
