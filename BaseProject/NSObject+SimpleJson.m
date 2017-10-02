//
//  NSObject+SimpleJson.m
//  VivinoV2
//
//  Created by Ajay Dalvi on 27/11/14.
//
//

#import "NSObject+SimpleJson.h"

@implementation NSObject (SimpleJson)

- (NSString*)JSONRepresentation {
    
    if(![NSJSONSerialization isValidJSONObject:self])
        return nil;
    
    //write ourself to a JSON string; only works if we're a type that 'NSJSONSerialization' supports
    NSError* error = nil;
    NSData* tempData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
}


- (id) JSONValue {
    //converts from a string back into a proper object; only works if we're an NSString or NSData instance
    if (! [self isKindOfClass:[NSString class]] && ! [self isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    NSData* jsonData = nil;
    if ([self isKindOfClass:[NSData class]]) {
        jsonData = (NSData*)self;
    }
    else {
        //we must be an NSString
        jsonData = [((NSString*)self) dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
}

@end
