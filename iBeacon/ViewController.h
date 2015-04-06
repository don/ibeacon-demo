//
//  ViewController.h
//  iBeacon
//
//  Created by Don Coleman on 4/5/15.
//  Copyright (c) 2015 Don Coleman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
    @property (weak, nonatomic) IBOutlet UILabel *regionLabel;
    @property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
@end

