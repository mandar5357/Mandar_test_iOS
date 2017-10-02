//
//  ImportantPlacesList.h
//  CabWala
//
//  Created by Sphinx Solution Pvt Ltd on 12/18/15.
//  Copyright © 2015 ananadmahajan. All rights reserved.
//

#import "MTLModelModified.h"

@interface ImportantPlacesList : MTLModelModified
@property(nonatomic,strong) NSArray *airport;
@property(nonatomic,strong) NSArray *railway;
@property(nonatomic,strong) NSArray *bus;


@end
