//
//  ViewController.m
//  CompassRedo
//
//  Created by DP Bhatt on 05/07/2018.
//  Copyright © 2018 ABC. All rights reserved.
//

#import "ViewController.h"
#import "CompassRedo-Swift.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headingInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.yourLocation = [[CLLocation alloc] initWithLatitude:90.0 longitude:0.0]; // North pole
    //self.yourLocation = [[CLLocation alloc] initWithLatitude:27.70179990 longitude:85.31950601]; // Kathmandu
    self.yourLocation = [[CLLocation alloc] initWithLatitude:40.753603 longitude:-73.990502]; // New York
    //self.yourLocation = [[CLLocation alloc] initWithLatitude:55.788906 longitude:12.590191]; // Any area
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingHeading];
    
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if(locations.lastObject!=nil && locations.lastObject.horizontalAccuracy > 0){
        self.latestLocation = locations.lastObject;
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    NSLog(@"trueHeading => %f", newHeading.trueHeading);
   
    
    CGFloat yourLocationBearing = [self.latestLocation bearingToLocationRadian:self.yourLocation];
    
    CGFloat originalHeading = yourLocationBearing - [self degreesToRadians: newHeading.trueHeading];
    CGFloat heading = originalHeading;
    NSLog(@"originalHeading => %f", [self radiansToDegrees: originalHeading]);
    switch (UIDevice.currentDevice.orientation) {
        case UIDeviceOrientationFaceDown:
            heading = -originalHeading;
            break;
        default:
            heading = originalHeading;
            break;
    }
    
    CGFloat adjAngle = [self getAdjustableAngle];
    
    heading = (CGFloat)[self degreesToRadians: adjAngle] + heading ;
   
    CGFloat headingInDegrees = [self radiansToDegrees:heading];
    NSLog(@"heading => %f headingInDegrees => %f", heading , headingInDegrees);
    
    
    if(headingInDegrees > 2){
        self.headingInfo.text = [NSString stringWithFormat:@"You are going in the wrong direction. Move right" ];
    }
    else if (headingInDegrees < -2 ){
        self.headingInfo.text = [NSString stringWithFormat:@"You are going in the wrong direction. Move left" ];
    } else{
        self.headingInfo.text = [NSString stringWithFormat:@"Continue walking"];
    }
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self->imageView.transform = CGAffineTransformMakeRotation(heading);
                     }];
    
}

-(CGFloat) getAdjustableAngle{
    //Adjustment according to device oorientation
    BOOL isFaceDown = NO;
    switch (UIDevice.currentDevice.orientation) {
        case UIDeviceOrientationFaceDown:
            isFaceDown = YES;
            break;
        default:
            isFaceDown = NO;
            break;
    }
    
    CGFloat adjAngle;
    switch (UIApplication.sharedApplication.statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            adjAngle = 90;
            break;
        case UIInterfaceOrientationLandscapeRight:
            adjAngle = -90;
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationUnknown:
            adjAngle = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            adjAngle = isFaceDown ? 180 : - 180;
        default:
            break;
    }
    return adjAngle;
}
- (IBAction)setNewLocation:(UIButton *)sender {
    self.yourLocation = self.locationManager.location;
}
-(CGFloat) degreesToRadians : (CGFloat) degrees{
    return  degrees * M_PI / 180;
}
-(CGFloat) radiansToDegrees : (CGFloat) radians{
    return  radians * 180 / M_PI;
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", error.localizedDescription);
}

@end
