//
//  CabsAPI.h
//  CabWala
//
//  Created by Sphinx Solution Pvt Ltd on 12/18/15.
//  Copyright © 2015 ananadmahajan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImportantPlaces;
@interface CabsAPI : NSObject

-(void) getImportantPlacesWithSuccess:(void (^)(ImportantPlaces* objPlacesList))success
                              failure:(void (^)(NSError* error))failure;


@end
