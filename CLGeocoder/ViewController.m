//
//  ViewController.m
//  CLGeocoder
//
//  Created by YangJing on 2018/7/30.
//  Copyright © 2018年 YangJing. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *lngTextFile;
@property (weak, nonatomic) IBOutlet UITextField *latTextFile;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.geocoder = [[CLGeocoder alloc] init];
//     https://nominatim.openstreetmap.org/reverse?format=xml&lat=52.5487429714954&lon=-1.81602098644987&zoom=18&addressdetails=1
    self.lngTextFile.text = @"-1.81602098644987";
    self.latTextFile.text = @"52.5487429714954";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction:(id)sender {
    if ([self.lngTextFile isEditing]) {
        [self.lngTextFile resignFirstResponder];
    }
    
    if ([self.latTextFile isEditing]) {
        [self.latTextFile resignFirstResponder];
    }
}

- (IBAction)confirmAction:(id)sender {

    // 1.获取用户输入的经纬度
    NSString *longtitude = self.lngTextFile.text;
    NSString *latitude = self.latTextFile.text;
    if (longtitude.length == 0 ||
        longtitude == nil ||
        latitude.length == 0 ||
        latitude == nil) {
        NSLog(@"请输入经纬度");
        return;
    }
    
    // 2.根据用户输入的经纬度创建CLLocation对象
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue]  longitude:[longtitude doubleValue]];
    // 116.403857,39.915285
    
    // 3.根据CLLocation对象获取对应的地标信息
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error) {
            self.resultTextView.text = [NSString stringWithFormat:@"code:%ld,\n description:%@,\n reason:%@,\n suggestion:%@", (long)error.code, error.localizedDescription, error.localizedFailureReason, error.localizedRecoverySuggestion];
            return;
        }
        
        for (CLPlacemark *placemark in placemarks) {
            self.resultTextView.text = [NSString stringWithFormat:@"name=%@\n thoroughfare=%@\n subThoroughfare=%@\n locality=%@\n subLocality=%@\n administrativeArea=%@\n subAdministrativeArea=%@\n postalCode=%@\n ISOcountryCode=%@\n country=%@\n inlandWater=%@\n ocean=%@", placemark.name, placemark.thoroughfare, placemark.subThoroughfare, placemark.locality, placemark.subLocality, placemark.administrativeArea, placemark.subAdministrativeArea, placemark.postalCode, placemark.ISOcountryCode, placemark.country, placemark.inlandWater, placemark.ocean];
        }
    }];
}

@end
