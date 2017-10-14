//
//  ZNDrawPolylineClass.h
//  Zenith
//
//  Created by Suresh patel on 22/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ZNDrawPolylineClass : NSObject

-(NSMutableArray *)drawRouteBetweenSource:(NSString*)source andDestination:(NSString*)destination onController:(UIViewController *)controller;

@end
