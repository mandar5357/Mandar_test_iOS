//
//  MTLModelModified.h
//
//
//  Created by Admin on 22/07/14.
//
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "MTLValueTransformer.h"
#import "NSDictionary+MTLMappingAdditions.h"
#import "NSDictionary+MTLManipulationAdditions.h"


@interface MTLModelModified : MTLModel <MTLJSONSerializing>
@property(nonatomic) NSString *status;
@property(nonatomic) NSInteger next_offset;
@property(nonatomic,strong) NSString *message;
+ (instancetype)instanceFromDict:(NSDictionary*)dict;
- (NSDictionary*)toDictionary;
+ (NSArray*)arrayOfInstancesFromArray:(NSArray*)ls;
+ (NSValueTransformer<MTLTransformerErrorHandling> *)integerTransformer;
@end