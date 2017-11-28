//
//  Coordinates.h
//  TCU Exchange
//
//  Created by Mark Villa on 1/17/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "QuestionViewController.h"

@interface Coordinates : NSObject
- (void)startLocationManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *coordinates;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic) double dist;
@property (nonatomic) BOOL isInRegion;

@end
