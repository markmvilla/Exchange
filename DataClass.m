//
//  DataClass.m
//  TCUExchange
//
//  Created by Mark Villa on 5/20/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass
@synthesize initialLaunch;
@synthesize str;

static DataClass *instance = nil;

+(DataClass *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [DataClass new];
        }
    }
    return instance;
}
@end
