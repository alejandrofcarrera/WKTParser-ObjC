//
//  ViewController.m
//
//  WKTParser View Controller
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Alejandro Fdez Carrera
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        map = [[MKMapView alloc] initWithFrame:self.view.frame];
        map.delegate = self;
        [self.view addSubview:map];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *myNavBtn = [[UIBarButtonItem alloc] initWithTitle:
         @"Unit Tests" style:UIBarButtonItemStyleBordered target:
         self action:@selector(myButtonClicked:)];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationItem setRightBarButtonItem:myNavBtn];
}

-(void)myButtonClicked:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Choose option"
                 message:@"" delegate:self cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@"Point", @"MultiPoint", @"LineString",
                 @"MultiLineString", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != 0)
    {
        [map removeOverlays:map.overlays];
        [map removeAnnotations:map.annotations];
        
        NSLog(@"---------- S: %@ ----------", [alertView buttonTitleAtIndex:buttonIndex]);
        
        switch (buttonIndex) {
            case 1:
                [self doTestPOINT];
                break;
            case 2:
                [self doTestMULTIPOINT];
                break;
            case 3:
                [self doTestLINESTRING];
                break;
            case 4:
                [self doTestMULTILINESTRING];
                break;
            default:
                break;
        }
        
        NSLog(@"---------- F: %@ ----------", [alertView buttonTitleAtIndex:buttonIndex]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)doTestPOINT
{
    NSLog(@" - Data: POINT (-73.995 41.145556)");
    NSLog(@" - Real Information: New York City coordinates");
    WKTPoint *p = (WKTPoint *)[WKTParser parseGeometry:@"POINT (-73.995 41.145556)"];
    NSLog(@" - Data WKTGeometry");
    NSLog(@"   * Class: %@", [p class]);
    NSLog(@"   * Dimension: %d", p.dimensions);
    NSLog(@"   * Dimension X: %f", p.dimensionX);
    NSLog(@"   * Dimension Y: %f", p.dimensionY);
    NSLog(@"   * Dimension Z: %f", p.dimensionZ);
    MKPointAnnotation *a = [p toMapPointAnnotation];
    a.title = @"New York City";
    a.subtitle = @"POINT (41.145556 -73.995)";
    NSLog(@" - Data MKPointAnnotation");
    NSLog(@"   * Title: %@", a.title);
    NSLog(@"   * Subtitle: %@", a.subtitle);
    NSLog(@"   * Coordinates: %f, %f", a.coordinate.latitude, a.coordinate.longitude);
    [map addAnnotation:a];
}

- (void)doTestMULTIPOINT
{
    NSArray *names = @[@"Alabama State Capitol", @"Alaska State Capitol", @"Arizona State Capitol"];
    NSLog(@" - Data: MULTIPOINT (-86.300942 32.377447, -134.410467 58.302197, -112.097094 33.448097)");
    NSLog(@" - Real Information: Alabama, Alaska and Arizona");
    WKTPointM *p = (WKTPointM *)[WKTParser parseGeometry:@"MULTIPOINT (-86.300942 32.377447, \
          -134.410467 58.302197, -112.097094 33.448097)"];
    NSLog(@" - Data WKTGeometry");
    NSLog(@"   * Class: %@", [p class]);
    NSLog(@"   * Dimension: %d", p.dimensions);
    NSLog(@"   * WKTPoint number: %lu", (unsigned long)[p getListPoints].count);
    NSArray *aPoints = [p toMapMultiPoint];
    for(int i = 0; i < aPoints.count; i++)
    {
        MKPointAnnotation *p = aPoints[i];
        p.title = names[i];
        p.subtitle = [NSString stringWithFormat:@"POINT (%f %f)", p.coordinate.latitude, p.coordinate.longitude];
        NSLog(@" - Data MKPointAnnotation");
        NSLog(@"   * Title: %@", p.title);
        NSLog(@"   * Subtitle: %@", p.subtitle);
        NSLog(@"   * Coordinates: %f, %f", p.coordinate.latitude, p.coordinate.longitude);
        [map addAnnotation:p];
    }
}

- (void)doTestLINESTRING
{
    NSArray *names = @[@"Alabama State Capitol", @"Alaska State Capitol", @"Arizona State Capitol"];
    NSLog(@" - Data: LINESTRING (-86.300942 32.377447, -134.410467 58.302197, -112.097094 33.448097)");
    NSLog(@" - Real Information: Alabama, Alaska and Arizona");
    WKTLine *p = (WKTLine *)[WKTParser parseGeometry:@"LINESTRING (-86.300942 32.377447, \
          -134.410467 58.302197, -112.097094 33.448097)"];
    NSLog(@" - Data WKTGeometry");
    NSLog(@"   * Class: %@", [p class]);
    NSLog(@"   * Dimension: %d", p.dimensions);
    NSLog(@"   * WKTPoint number: %lu", (unsigned long)[p getListPoints].count);
    NSArray *aPoints = [p getListPoints];
    for(int i = 0; i < aPoints.count; i++)
    {
        MKPointAnnotation *p = [(WKTPoint *) aPoints[i] toMapPointAnnotation];
        p.title = names[i];
        p.subtitle = [NSString stringWithFormat:@"POINT (%f %f)", p.coordinate.latitude, p.coordinate.longitude];
        NSLog(@" - Data MKPointAnnotation");
        NSLog(@"   * Title: %@", p.title);
        NSLog(@"   * Subtitle: %@", p.subtitle);
        NSLog(@"   * Coordinates: %f, %f", p.coordinate.latitude, p.coordinate.longitude);
        [map addAnnotation:p];
    }
    MKPolyline *k = [p toMapLine];
    NSLog(@" - Data MKPolyline");
    NSLog(@"   * Points number: %lu", (unsigned long)k.pointCount);
    for(int i = 0 ; i < k.pointCount; i++)
    {
        NSLog(@"   * Point %d: %f, %f", i, k.points[i].x, k.points[i].y);
    }
    [map addOverlay:k];
}

- (void)doTestMULTILINESTRING
{
    NSArray *names = @[@"Alabama State Capitol", @"Alaska State Capitol", @"Arizona State Capitol",\
                       @"Arkansas State Capitol", @"California State Capitol", @"Colorado State Capitol"];
    NSLog(@" - Data: MULTILINESTRING ((-86.300942 32.377447, -134.410467 58.302197, -112.097094 33.448097),\
          (-92.288761 34.746758, -121.493411 38.576572, -104.984897 39.739094))");
    NSLog(@" - Real Information: Alabama, Alaska, Arizona, Arkansas, California and Colorado");
    WKTLineM *p = (WKTLineM *)[WKTParser parseGeometry:@"MULTILINESTRING ((-86.300942 32.377447, -134.410467 58.302197,\
          -112.097094 33.448097), (-92.288761 34.746758, -121.493411 38.576572, -104.984897 39.739094))"];
    NSLog(@" - Data WKTGeometry");
    NSLog(@"   * Class: %@", [p class]);
    NSLog(@"   * Dimension: %d", p.dimensions);
    NSLog(@"   * WKTLine number: %lu", (unsigned long)[p getListLines].count);
    NSArray *aLines = [p getListLines];
    int indexName = 0;
    for(int i = 0; i < aLines.count; i++)
    {
        NSArray *lPoints = [aLines[i] getListPoints];
        for(int j = 0; j < lPoints.count; j++)
        {
            MKPointAnnotation *p = [(WKTPoint *) lPoints[j] toMapPointAnnotation];
            p.title = names[indexName++];
            p.subtitle = [NSString stringWithFormat:@"POINT (%f %f)", p.coordinate.latitude, p.coordinate.longitude];
            NSLog(@" - Data MKPointAnnotation");
            NSLog(@"   * Title: %@", p.title);
            NSLog(@"   * Subtitle: %@", p.subtitle);
            NSLog(@"   * Coordinates: %f, %f", p.coordinate.latitude, p.coordinate.longitude);
            [map addAnnotation:p];
        }
        MKPolyline *k = [aLines[i] toMapLine];
        NSLog(@" - Data MKPolyline");
        NSLog(@"   * Points number: %lu", (unsigned long)k.pointCount);
        for(int i = 0 ; i < k.pointCount; i++)
        {
            NSLog(@"   * Point %d: %f, %f", i, k.points[i].x, k.points[i].y);
        }
        [map addOverlay:k];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *defaultPin = @"StandardIdentifier";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:defaultPin];
    if (pinView == nil)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                  reuseIdentifier:defaultPin];
        pinView.pinColor = MKPinAnnotationColorRed;
    }
    pinView.enabled = YES;
    pinView.canShowCallout = YES;
    return pinView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *p = [[MKPolylineRenderer alloc] initWithPolyline: (MKPolyline *) overlay];
        p.fillColor = [[UIColor redColor] colorWithAlphaComponent:1.0];
        p.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
        p.lineWidth = 2.5f;
        return p;
    }
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)ovl {
    if([ovl isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *p = [[MKPolylineView alloc] initWithPolyline: (MKPolyline *) ovl];
        p.fillColor = [[UIColor redColor] colorWithAlphaComponent:1.0];
        p.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
        p.lineWidth = 2.5f;
        return p;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
