//
//  ImportantPlaces.m
//  CabWala
//
//  Created by Sphinx Solution Pvt Ltd on 12/18/15.
//  Copyright © 2015 ananadmahajan. All rights reserved.
//

#import "ImportantPlaces.h"
#import "ImportantPlacesList.h"
@implementation ImportantPlaces

+ (NSValueTransformer*)listJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[ImportantPlacesList class]];
}
@end
