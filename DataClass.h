//
//  DataClass.h
//  TCUExchange
//
//  Created by Mark Villa on 5/20/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataClass : NSObject{
    int *initialLaunch;
    NSString *str;
}

@property int *initialLaunch;
@property(nonatomic,retain)NSString *str;

+(DataClass*)getInstance;
@end
