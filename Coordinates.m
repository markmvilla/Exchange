//
//  Coordinates.m
//  TCU Exchange
//
//  Created by Mark Villa on 1/17/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "Coordinates.h"

#define TCULATITUDE 32.70953039999999
#define TCULONGITUDE -97.36279479999996

@interface Coordinates ()<CLLocationManagerDelegate>{
    BOOL _didStartMonitoringRegion;
}

@end

@implementation Coordinates

- (void)startLocationManager {
    //NSLog(@"startLocationManager");
    self.locationManager = [[CLLocationManager alloc] init];
    [[self locationManager] setDelegate:self];
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if(authorizationStatus == kCLAuthorizationStatusAuthorized || authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse){
        [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
        _didStartMonitoringRegion = NO;
        [[self locationManager] startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        //NSLog(@"didChangeAuthorizationStatus");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = locations.lastObject;
    if (!_didStartMonitoringRegion) {
        _didStartMonitoringRegion = YES;
        self.coordinates = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:location.coordinate.latitude], [NSNumber numberWithDouble:location.coordinate.longitude], nil];
        self.isInRegion = true;
        /*
        self.longitude = location.coordinate.longitude;
        self.latitude = location.coordinate.latitude;
        CLLocationCoordinate2D coord1 = {TCULATITUDE,TCULONGITUDE};
        CLLocationCoordinate2D coord2 = {self.latitude,self.longitude};
        MKMapPoint p1 = MKMapPointForCoordinate(coord1);
        MKMapPoint p2 = MKMapPointForCoordinate(coord2);
        self.dist = MKMetersBetweenMapPoints(p1, p2);
        if (self.dist < 1500){
            self.isInRegion = NO;
        }
        else{
            self.isInRegion = YES;
        }
         */
    }
    [self.locationManager stopUpdatingLocation];
}

-(id)init {
    self = [super init];
    if (self) {
        self.isInRegion = NO;
    }
    return self;
}
@end
