//
//  ImportantPlacesList.m
//  CabWala
//
//  Created by Sphinx Solution Pvt Ltd on 12/18/15.
//  Copyright © 2015 ananadmahajan. All rights reserved.
//

#import "ImportantPlacesList.h"
#import "Place.h"
@implementation ImportantPlacesList

+ (NSValueTransformer*)airportJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Place class]];
}

+ (NSValueTransformer*)railwayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Place class]];
}

+ (NSValueTransformer*)busJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Place class]];
}
@end
