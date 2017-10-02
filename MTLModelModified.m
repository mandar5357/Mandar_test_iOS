//
//  MTLModelModified.m
//
//
//  Created by Admin on 22/07/14.
//
//

#import "MTLModelModified.h"


@implementation MTLModelModified

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // override this in the model if property names in JSON don't match model
    return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

+ (NSArray*)arrayOfInstancesFromArray:(NSArray*)ls
{
    NSError* error;
    Class klass = [self class];
    NSArray *list = [MTLJSONAdapter modelsOfClass:klass.class fromJSONArray:ls error:&error];
    
    if (error!=nil) {
       SSLog(@"JSON: %@, \n\n Error: %@", ls, error);
    }
    
    return list;
    
}

+ (instancetype)instanceFromDict:(NSDictionary*)dict
{
    NSError* error;
    Class klass = [self class];
    MTLModelModified *instance = [MTLJSONAdapter modelOfClass:klass.class fromJSONDictionary:dict error:&error];
    if (error!=nil) {
      SSLog(@"JSON: %@, \n\n Error: %@", dict, error);
    }
    return instance;
}
//https://github.com/Mantle/Mantle/issues/492
+ (NSValueTransformer<MTLTransformerErrorHandling> *)integerTransformer {
    return [MTLValueTransformer
            transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
                return value;
            } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
                return value;
            }];
}

-(NSDictionary*)toDictionary
{
    NSError* error;
    
    NSDictionary *dict= [MTLJSONAdapter JSONDictionaryFromModel:self error:&error];
    if (error!=nil) {
       // SSLog(@"JSON:  \n\n Error: %@", error);
    }
    return dict;
}

- (NSUInteger)hash {
    NSUInteger value = 0;
    
    for (NSString *key in self.class.propertyKeys) {
        value ^= [[self valueForKey:key] hash];
    }
    
    return value;
}

- (BOOL)isEqual:(MTLModel *)model {
    if (self == model) return YES;
    if (![model isMemberOfClass:self.class]) return NO;
    
    for (NSString *key in self.class.propertyKeys) {
        id selfValue  = [self valueForKey:key];
        id modelValue = [model valueForKey:key];
        
        BOOL valuesEqual = (selfValue == nil && modelValue == nil);
        
        if ([selfValue isKindOfClass:[NSNumber class]]) {
            valuesEqual = valuesEqual || [(NSNumber*)selfValue isEqualToNumber:(NSNumber*)modelValue];
        }
        if ([selfValue isKindOfClass:[NSString class]]) {
            valuesEqual = valuesEqual ||  [(NSString*)selfValue isEqualToString:(NSString*)modelValue];
        }
        if ([selfValue isKindOfClass:[NSDate class]]) {
            valuesEqual = valuesEqual || [(NSDate*)selfValue isEqualToDate:(NSDate*)modelValue];
        }
        if ([selfValue isKindOfClass:[NSValue class]]) {
            valuesEqual = valuesEqual ||  [(NSValue*)selfValue isEqualToValue:(NSValue*)modelValue];
        }
        else {
            valuesEqual = valuesEqual ||  [selfValue isEqual:modelValue];
        }
        
        if (!valuesEqual) return NO;
    }
    
    return YES;
}

@end