//
//  ViewController.m
//  iBeacon
//
//  Created by Don Coleman on 4/5/15.
//  Copyright (c) 2015 Don Coleman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

CLLocationManager *locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"iBeacon Demo");
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    // Estimote
    //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"b9407f30-f5f8-466e-aff9-25556b57fe6d"];
    
    // AT+BLEBEACON=0x004C,12-34-56-78-AA-AA-BB-BB-CC-CC-12-34-56-78-9A-BC,0x0000,0x0000,-59
    // ATZ
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"12345678-AAAA-BBBB-CCCC-123456789ABC"];
        
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"iBeacon"];
    
    region.notifyOnEntry = TRUE;
    region.notifyOnExit = TRUE;
    region.notifyEntryStateOnDisplay = TRUE;
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startMonitoringForRegion:region];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"%@", @"didDetermineState:forRegion:");
    // A user can transition in or out of a region while the application is not running.
    // When this happens CoreLocation will launch the application momentarily and call this delegate method
    
    if(state == CLRegionStateInside)
    {
        NSLog(@"%@", @"You're inside the region. Commence monitoring.");
        
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [locationManager startRangingBeaconsInRegion:beaconRegion];
        [_regionLabel setText:@"Inside Region"];
        [_rangeLabel setText:@""];
    }
    else if(state == CLRegionStateOutside)
    {
        NSLog(@"%@", @"You're outside the region. Stopping monitoring.");
        
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [locationManager stopRangingBeaconsInRegion:beaconRegion];
        [_regionLabel setText:@"Outside Region"];
        [_rangeLabel setText:@""];
    }
    else if (state == CLRegionStateUnknown)
    {
        NSLog(@"%@", @"Region State is Unknown.");
        [_regionLabel setText:@"Unknown Region State"];
    }
    else
    {
        // this shouldn't happen
        NSLog(@"ERROR: Unexpected Region State %d", state);
        [NSString stringWithFormat:@"%d", state];
        [_regionLabel setText:@"Error"];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"%@", @"didRangeBeacons:inRegion:");
    
    // Assuming 1 beacon for this demo
    if ([beacons count] > 1) {
        NSLog(@"WARNING: Expecting 1 beacon for this demo, but found %lu beacons", (unsigned long)[beacons count]);
    }
    
    NSString *proximity;

    CLBeacon *beacon = [beacons firstObject];
    // TODO log uuid, major, minor
    
    switch (beacon.proximity) {
        case CLProximityImmediate:
            [[self rangeLabel] setText:@"Immediate"];
            break;
        case CLProximityNear:
            [[self rangeLabel] setText:@"Near"];
            break;
        case CLProximityFar:
            [[self rangeLabel] setText:@"Far"];
            break;
        case CLProximityUnknown:
            [[self rangeLabel] setText:@"Unknown"];
            break;
        default:
            // this shouldn't happen
            proximity = [NSString stringWithFormat:@"%d", beacon.proximity];
            [[self rangeLabel] setText:proximity];
    }
    
}


@end
