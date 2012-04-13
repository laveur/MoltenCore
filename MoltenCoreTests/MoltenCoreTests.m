//
//  MoltenCoreTests.m
//  MoltenCoreTests
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <MoltenCore/MoltenCore.h>
#import "MoltenCoreTests.h"
#import "TestJSONDataModel.h"
#import "TestXMLDataModel.h"
#import "TestXMLTreeDataModel.h"

@implementation MoltenCoreTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testParseQueryString {
	NSString *queryString = [NSString stringWithString:@"key1=value1&key2=value2"];
	NSDictionary *parsedQuery = [MVSQueryString parseQueryString:queryString];
	
	STAssertNotNil([parsedQuery objectForKey:@"key1"], @"Lookup of key1 failed: Value nil");
	STAssertNotNil([parsedQuery objectForKey:@"key2"], @"Lookup of key2 failed: Value nil");
	STAssertEqualObjects([parsedQuery objectForKey:@"key1"], @"value1", @"Returned Value of key1 does not match: %@ != %@", [parsedQuery objectForKey:@"key1"], @"value1");
	STAssertEqualObjects([parsedQuery objectForKey:@"key2"], @"value2", @"Returned Value of key1 does not match: %@ != %@", [parsedQuery objectForKey:@"key2"], @"value1");
	STAssertNil([parsedQuery objectForKey:@"undefined"], @"Lookup of undefined key failed, key exists.");
}

- (void)testSerializeQueryString {
	NSString *expected = [NSString stringWithString:@"key1=value1&key2=value2"];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"value1", @"key1", @"value2", @"key2", nil];
	NSString *serialized = [MVSQueryString serializeDictionary:params];
	STAssertEqualObjects(expected, serialized, @"Query String  Serialization Failed: %@ != %@", serialized, expected);
}

- (void)testJSONDataModelSimple {
	NSString *jsonString = @"{\"key1\": \"value1\", \"key2\": 1, \"isTrue\": true, \"isFalse\": false}";
	NSDictionary *decoded = [jsonString objectFromJSONString];
	TestJSONDataModel *testDataModel = [[TestJSONDataModel alloc] initWithDictionary:decoded];
	
	STAssertEqualObjects([testDataModel key1], @"value1", @"Returned value of key1 does not match: %@ != %@", [testDataModel key1], @"value1");
	STAssertEqualObjects([testDataModel key2], [NSNumber numberWithInt:1], @"Returned value for key2 does not match: %@ != %@", [testDataModel key2], [NSNumber numberWithInt:1]);
	STAssertEquals([testDataModel isTrue], YES, @"Returned value of isTrue does not match: %d != %d", [testDataModel isTrue], YES);
	STAssertEquals([testDataModel isFalse], NO, @"Returned value of isFalse does not match: %d != %d", [testDataModel isFalse], NO);
}

- (void)testXMLDataModelSimple {
	NSString *xmlString = @"<node key1=\"value1\" key2=\"value2\" />";
	NSError *error;
	NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:xmlString options:NSXMLDocumentTidyXML error:&error];
	
	if(error) {
		return;
	}
	
	TestXMLDataModel *testDataModel = [[TestXMLDataModel alloc] initWithXMLElement:[doc rootElement]];
	
	STAssertEqualObjects([testDataModel key1], @"value1", @"Returned value of key1 does not match: %@ != %@", [testDataModel key1], @"value1");
	STAssertEqualObjects([testDataModel key2], @"value2", @"Returned value for key2 does not match: %@ != %@", [testDataModel key2], @"value2");
}

- (void)testXMLDataModelTree {
	NSString *xmlString = @"<root><subNode key1=\"value1\" key2=\"value2\" /></root>";
	NSError *error;
	NSXMLDocument *doc = [[NSXMLDocument alloc] initWithXMLString:xmlString options:NSXMLDocumentTidyXML error:&error];
	
	if(error) {
		return;
	}
	
	TestXMLTreeDataModel *testDataModel = [[TestXMLTreeDataModel alloc] initWithXMLElement:[doc rootElement]];
	
	STAssertNotNil(testDataModel.subNode, @"subNode is nil");
	STAssertEqualObjects(testDataModel.subNode.key1, @"value1", @"Returned value of key1 does not match: %@ != %@", testDataModel.subNode.key1, @"value1");
	STAssertEqualObjects(testDataModel.subNode.key2, @"value2", @"Returned value of key1 does not match: %@ != %@", testDataModel.subNode.key2, @"value2");
}

- (void)testStringMD5Sum {
	NSString *hello = @"hello world";
	NSString *md5 = [hello md5Sum];
	
	STAssertEqualObjects(md5, @"5eb63bbbe01eeed093cb22bb8f5acdc3", @"MD5 Sums do not match: %@ != %@", md5, @"5eb63bbbe01eeed093cb22bb8f5acdc3");
	
}

- (void)testJSONRPCResponseError {
	NSString *jsonString = @"{\"jsonrpc\": \"2.0\", \"error\": {\"code\": -32601, \"message\": \"Procedure not found.\"}, \"id\": \"1\"}";
	MVSJSONRPCResponse *response = [[MVSJSONRPCResponse alloc] initWithDictionary:[jsonString objectFromJSONString]];
	
	STAssertNotNil(response, @"Response is nil");
	STAssertEqualObjects(response.jsonrpc, @"2.0", @"response.jsonrpc != \"2.0\"");
	STAssertNotNil(response.error, @"response.error is nil");
	STAssertEqualObjects(response.error.code, [NSNumber numberWithInt:-32601], @"Value of response.error.code do not match: %@ != %@", response.error.code, [NSNumber numberWithInt:-32601]);
	STAssertEqualObjects(response.error.message, @"Procedure not found.", @"Value of response.error.message does not match: %@ != %@", response.error.message, @"Procedure not found.");
	STAssertEqualObjects(response.id, @"1", @"Value of response.id does not match: %@ != %@", response.id, @"1");
}

- (void)testUUIDV3 {
	CFUUIDRef namespace = CFUUIDCreateFromString(nil, (CFStringRef)@"250c06c2-8ddc-11e0-8cbc-43646d9ef131");
	CFUUIDRef expected = CFUUIDCreateFromString(nil, (CFStringRef)@"d76e878b-b5b6-34ac-a46b-03ee5dd897eb");
	
	CFUUIDRef result = CFUUIDCreateVersion3(namespace, (CFStringRef)@"Nick");
	
	STAssertTrue(CFEqual(result, expected), @"Version 3 UUID Does not match expected result: %@ != %@", (NSString *)CFUUIDCreateString(nil, result), CFUUIDCreateString(nil, expected));
	
}

- (void)testUUIDV5 {
	CFUUIDRef namespace = CFUUIDCreateFromString(nil, (CFStringRef)@"250c06c2-8ddc-11e0-8cbc-43646d9ef131");
	CFUUIDRef expected = CFUUIDCreateFromString(nil, (CFStringRef)@"7319034b-84b2-5b10-8678-2afac835192f");
	
	CFUUIDRef result = CFUUIDCreateVersion5(namespace, (CFStringRef)@"Nick");
	
	STAssertTrue(CFEqual(result, expected), @"Version 5 UUID Does not match expected result: %@ != %@", (NSString *)CFUUIDCreateString(nil, result), CFUUIDCreateString(nil, expected));
	
}

- (void)testSharedObjectCache {
	[[MVSSharedObjectCache sharedObjectCache] cacheObject:@"Test" withName:@"test"];
	
	NSString *testResult = [[MVSSharedObjectCache sharedObjectCache] cachedItemForName:@"test"];
	
	STAssertNotNil(testResult, @"testResult is nil");
	STAssertEquals(testResult, @"Test", @"testResult does not match expected values: %@ != %@", testResult, @"Test");
	
}

@end
