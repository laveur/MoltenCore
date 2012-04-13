//
//  MVSUUID.c
//  MoltenCore
//
//  Created by Nicholas Bourey on 6/3/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//
#include <stdio.h>
#include <CommonCrypto/CommonDigest.h>
#include "MVSUUID.h"

typedef struct {
	uint32_t time_low;
	uint16_t time_mid;
	uint16_t time_hi_and_version;
	uint8_t clock_seq_hi_and_reserved;
	uint8_t clock_seq_low;
	unsigned char node[6];

} UUIDBase;

static void CFUUIDFormatV3or5(UUIDBase *uuid, unsigned char hash[16], int version) {
	memcpy(uuid, hash, sizeof(UUIDBase));
	
	uuid->time_hi_and_version = ntohs(uuid->time_hi_and_version);
	
	uuid->time_hi_and_version &= 0x0FFF;
	uuid->time_hi_and_version |= (version << 12);
	
	uuid->time_hi_and_version = ((uuid->time_hi_and_version >> 8 ) & 0xFF) + (( uuid->time_hi_and_version & 0xFF) << 8 );
	
	uuid->clock_seq_hi_and_reserved &= 0x3F;
	uuid->clock_seq_hi_and_reserved |= 0x80;
}

CFUUIDRef CFUUIDCreateVersion3(CFUUIDRef namespaceUUID, CFStringRef name) {
	CC_MD5_CTX ctx;
	unsigned char hash[CC_MD5_DIGEST_LENGTH];
	UUIDBase uuid;
	CFUUIDBytes cfBytes = CFUUIDGetUUIDBytes(namespaceUUID);
	UUIDBase *nsBytes = (UUIDBase *)&cfBytes;
	char *nameCStr = malloc(CFStringGetLength(name) + 1);
	
	CFStringGetCString(name, nameCStr, CFStringGetLength(name) + 1, kCFStringEncodingUTF8);
	
	CC_MD5_Init(&ctx);
	CC_MD5_Update(&ctx, nsBytes, sizeof(UUIDBase));
	CC_MD5_Update(&ctx, nameCStr, (CC_LONG)CFStringGetLength(name));
	CC_MD5_Final(hash, &ctx);
	
	free(nameCStr);
	
	bzero(&uuid, sizeof(UUIDBase));
	
	CFUUIDFormatV3or5(&uuid, hash, 3);
	
	CFUUIDRef retVal = CFUUIDCreateFromUUIDBytes(nil, *((CFUUIDBytes *)&uuid));
	
	return retVal;
}

CFUUIDRef CFUUIDCreateVersion5(CFUUIDRef namespaceUUID, CFStringRef name) {
	CC_SHA1_CTX ctx;
	unsigned char hash[CC_SHA1_DIGEST_LENGTH];
	UUIDBase uuid;
	CFUUIDBytes cfBytes = CFUUIDGetUUIDBytes(namespaceUUID);
	UUIDBase *nsBytes = (UUIDBase *)&cfBytes;
	char *nameCStr = malloc(CFStringGetLength(name) + 1);
	
	CFStringGetCString(name, nameCStr, CFStringGetLength(name) + 1, kCFStringEncodingUTF8);
	
	CC_SHA1_Init(&ctx);
	CC_SHA1_Update(&ctx, nsBytes, sizeof(UUIDBase));
	CC_SHA1_Update(&ctx, nameCStr, (CC_LONG)CFStringGetLength(name));
	CC_SHA1_Final(hash, &ctx);
	
	free(nameCStr);
	
	bzero(&uuid, sizeof(UUIDBase));
	
	CFUUIDFormatV3or5(&uuid, hash, 5);
	
	CFUUIDRef retVal = CFUUIDCreateFromUUIDBytes(nil, *((CFUUIDBytes *)&uuid));
	
	return retVal;
}