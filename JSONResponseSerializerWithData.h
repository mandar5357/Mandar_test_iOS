//
//  JSONResponseSerializerWithData.h
//  
//
//  Created by Admin on 08/08/14.
//
//

/*
 From http://blog.gregfiumara.com/archives/239
*/

#import "AFURLResponseSerialization.h"

/// NSError userInfo key that will contain response data
static NSString * const JSONResponseSerializerWithDataKey = @"JSONResponseSerializerWithDataKey";

@interface JSONResponseSerializerWithData : AFJSONResponseSerializer

@end
