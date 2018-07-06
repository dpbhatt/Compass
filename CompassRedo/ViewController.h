//
//  ViewController.h
//  CompassRedo
//
//  Created by DP Bhatt on 05/07/2018.
//  Copyright © 2018 ABC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
    IBOutlet UIImageView *imageView;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *latestLocation;
@property (nonatomic, strong) CLLocation *yourLocation; // The location to point out

@end

