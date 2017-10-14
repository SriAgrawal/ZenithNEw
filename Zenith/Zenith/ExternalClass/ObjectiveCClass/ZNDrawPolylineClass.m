//
//  ZNDrawPolylineClass.m
//  Zenith
//
//  Created by Suresh patel on 22/06/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

#import "ZNDrawPolylineClass.h"

@implementation ZNDrawPolylineClass

-(NSMutableArray *)drawRouteBetweenSource:(NSString*)source andDestination:(NSString*)destination onController:(UIViewController *)controller{
    
    NSString *strUrl;
    strUrl= [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false&mode=driving", source, destination];
    strUrl=[strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
    NSError* error;
    if (data) {
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data //1
                              options:kNilOptions
                              error:&error];
        NSArray *arrRouts=[json objectForKey:@"routes"];
        if ([arrRouts isKindOfClass:[NSArray class]]&&arrRouts.count==0) {
            [self ShowAlert:@"didn't find direction" onController:controller];
            return nil;
        }
        NSArray* arrpolyline = [[[json valueForKeyPath:@"routes.legs.steps.polyline.points"] objectAtIndex:0] objectAtIndex:0]; //2
        
        NSMutableArray *polyLinesArray =[[NSMutableArray alloc]initWithCapacity:0];
        
        for (int i = 0; i < [arrpolyline count]; i++)
        {
            NSString* encodedPoints = [arrpolyline objectAtIndex:i] ;
            MKPolyline *route = [self polylineWithEncodedString:encodedPoints];
            [polyLinesArray addObject:route];
        }
        
        return polyLinesArray;
        //[self zoomToFitMapAnnotations:self.mapShow];
    }else{
        [self ShowAlert:@"didn't find direction" onController:controller];
    }
    
    return nil;
}

-(void)ShowAlert:(NSString*)AlertMessage onController:(UIViewController *)controller
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Error!" message:AlertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:yesButton];
    [controller presentViewController:alert animated:YES completion:nil];
}

#pragma mark - decode map polyline

- (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-5;
        float finalLon = longitude * 1E-5;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordIdx];
    free(coords);
    
    return polyline;
}

@end
