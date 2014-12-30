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
                 @"MultiLineString", @"Polygon", nil];
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
            case 5:
                [self doTestPOLYGON];
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

- (void)doTestPOLYGON
{
    NSArray *names = @[@"South Dakota"];
    NSLog(@" - Data: POLYGON ((-102.78838429211693 42.995303367507233,-103.005875292319473 42.999354367511017,-103.501464292781037 42.998618367510332,-104.056199293297666 43.003062367514467,-104.05915729330043 43.47913436795784,-104.057914293299277 43.503712367980732,-104.059479293300711 43.852906368305938,-104.059731293300956 44.145825368578748,-104.06103629330218 44.181825368612273,-104.059465293300718 44.574352368977841,-104.05984229330106 44.99733636937178,-104.043072293285448 44.997805369372216,-104.043851293286167 45.212875369572515,-104.049517293291444 45.883052370196665,-104.048906293290884 45.942993370252495,-102.994823292309192 45.941115370250742,-102.946397292264095 45.941665370251258,-102.002775291385262 45.942505370252036,-100.514406289999101 45.940388370250062,-99.875783289404339 45.943547370253008,-99.717345289256798 45.942761370252271,-99.006833288595075 45.939555370249288,-98.730437288337669 45.938271370248088,-98.014709287671081 45.931498370241783,-97.978722287637581 45.93082237024116,-97.233310286943365 45.936502370246444,-96.566921286322724 45.934110370244213,-96.587955286342307 45.817854370135947,-96.60461028635784 45.808264370127013,-96.657391286406991 45.738970370062475,-96.832796286570357 45.650687369980261,-96.854990286591004 45.609122369941545,-96.84308728657993 45.584090369918236,-96.769246286511148 45.5174783698562,-96.738032286482095 45.458195369800983,-96.693169286440323 45.410638369756697,-96.605084286358277 45.396524369743553,-96.532549286290731 45.37513236972363,-96.477592286239542 45.328509369680205,-96.457602286220933 45.298850369652584,-96.454496286218031 45.275195369630552,-96.456080286219503 44.971994369348181,-96.455217286218712 44.801347369189244,-96.456718286220109 44.628808369028555,-96.455106286218609 44.538343368944311,-96.45739728622074 44.199061368628328,-96.45660228621999 43.848741368302065,-96.46045428622358 43.49971836797701,-96.598315286351962 43.499849367977127,-96.583796286338455 43.481920367960441,-96.589113286343405 43.435539367917244,-96.557708286314153 43.400727367884819,-96.52505328628375 43.384225367869448,-96.522894286281741 43.356966367844066,-96.540563286298195 43.307659367798145,-96.579131286334103 43.29007436778177,-96.570722286326273 43.263612367757112,-96.559567286315897 43.253263367747479,-96.566991286322803 43.23963336773479,-96.558605286315 43.225489367721622,-96.487245286248537 43.217909367714554,-96.473114286235372 43.209082367706337,-96.451505286215237 43.126308367629242,-96.460805286223916 43.087872367593448,-96.46209428622511 43.075582367582001,-96.479573286241376 43.061884367569242,-96.520010286279046 43.051508367559585,-96.49902028625948 43.012050367522832,-96.517148286276381 42.986458367498997,-96.514935286274323 42.952382367467258,-96.544263286301643 42.913866367431396,-96.537511286295342 42.896906367415596,-96.55621128631276 42.846660367368806,-96.573126286328517 42.834347367357338,-96.587645286342024 42.835381367358295,-96.600875286354366 42.799558367324934,-96.632980286384267 42.776835367303775,-96.640709286391456 42.748603367277482,-96.626540286378258 42.708354367239998,-96.563039286319125 42.668513367202891,-96.541165286298749 42.662405367197209,-96.512844286272369 42.629755367166794,-96.488498286249694 42.580480367120899,-96.500942286261278 42.573885367114762,-96.489337286250489 42.564028367105578,-96.480243286242001 42.51713036706191,-96.439394286203964 42.489240367035933,-96.494701286255477 42.488459367035205,-96.547215286304393 42.520499367065042,-96.58475328633935 42.518287367062982,-96.605467286358632 42.507236367052691,-96.629294286380826 42.522693367067085,-96.636672286387693 42.550731367093199,-96.714059286459772 42.612302367150541,-96.715273286460899 42.621907367159487,-96.694596286441637 42.64116336717742,-96.6990602864458 42.657715367192836,-96.722658286467762 42.668592367202962,-96.799344286539196 42.670019367204283,-96.810437286549529 42.681341367214834,-96.810140286549256 42.704084367236021,-96.908234286640607 42.73169936726174,-96.970773286698858 42.721147367251916,-96.977869286705456 42.727308367257642,-96.97000328669813 42.752065367280707,-96.979593286707072 42.758313367286526,-97.015139286740165 42.759542367287665,-97.130469286847585 42.773923367301066,-97.161422286876416 42.798619367324065,-97.211831286923356 42.812573367337059,-97.224443286935099 42.841202367363721,-97.243189286952557 42.851826367373619,-97.271457286978887 42.850014367371926,-97.311414287016106 42.861771367382879,-97.38930628708863 42.867433367388152,-97.457263287151932 42.850443367372328,-97.483159287176051 42.857157367378576,-97.506132287197431 42.860136367381358,-97.57065428725754 42.847990367370045,-97.634970287317429 42.861285367382422,-97.685752287364735 42.836837367359649,-97.725250287401522 42.858008367379369,-97.772186287445223 42.846164367368345,-97.797028287468351 42.849597367371544,-97.818643287488499 42.866587367387361,-97.888659287553708 42.855807367377324,-97.88994128755489 42.831271367354475,-97.929477287591723 42.792324367318201,-97.963558287623457 42.773690367300844,-97.995144287652877 42.766812367294442,-98.033140287688255 42.769192367296647,-98.121820287770831 42.808360367333137,-98.123117287772061 42.820223367344184,-98.144869287792318 42.835794367358687,-98.167826287813696 42.839571367362197,-98.31033928794642 42.881794367401525,-98.39120428802174 42.920135367437233,-98.457444288083423 42.937160367453089,-98.497651288120863 42.991778367503954,-99.253971288825255 42.992389367504529,-99.532790289084915 42.992335367504467,-100.198142289704577 42.99109536750332,-101.231737290667184 42.986843367499354,-102.086701291463442 42.989887367502192,-102.78838429211693 42.995303367507233))");
    NSLog(@" - Real Information: South Dakota (West North Central");
    WKTPolygon *p = (WKTPolygon *)[WKTParser parseGeometry:@"POLYGON ((-102.78838429211693 42.995303367507233,-103.005875292319473 42.999354367511017,-103.501464292781037 42.998618367510332,-104.056199293297666 43.003062367514467,-104.05915729330043 43.47913436795784,-104.057914293299277 43.503712367980732,-104.059479293300711 43.852906368305938,-104.059731293300956 44.145825368578748,-104.06103629330218 44.181825368612273,-104.059465293300718 44.574352368977841,-104.05984229330106 44.99733636937178,-104.043072293285448 44.997805369372216,-104.043851293286167 45.212875369572515,-104.049517293291444 45.883052370196665,-104.048906293290884 45.942993370252495,-102.994823292309192 45.941115370250742,-102.946397292264095 45.941665370251258,-102.002775291385262 45.942505370252036,-100.514406289999101 45.940388370250062,-99.875783289404339 45.943547370253008,-99.717345289256798 45.942761370252271,-99.006833288595075 45.939555370249288,-98.730437288337669 45.938271370248088,-98.014709287671081 45.931498370241783,-97.978722287637581 45.93082237024116,-97.233310286943365 45.936502370246444,-96.566921286322724 45.934110370244213,-96.587955286342307 45.817854370135947,-96.60461028635784 45.808264370127013,-96.657391286406991 45.738970370062475,-96.832796286570357 45.650687369980261,-96.854990286591004 45.609122369941545,-96.84308728657993 45.584090369918236,-96.769246286511148 45.5174783698562,-96.738032286482095 45.458195369800983,-96.693169286440323 45.410638369756697,-96.605084286358277 45.396524369743553,-96.532549286290731 45.37513236972363,-96.477592286239542 45.328509369680205,-96.457602286220933 45.298850369652584,-96.454496286218031 45.275195369630552,-96.456080286219503 44.971994369348181,-96.455217286218712 44.801347369189244,-96.456718286220109 44.628808369028555,-96.455106286218609 44.538343368944311,-96.45739728622074 44.199061368628328,-96.45660228621999 43.848741368302065,-96.46045428622358 43.49971836797701,-96.598315286351962 43.499849367977127,-96.583796286338455 43.481920367960441,-96.589113286343405 43.435539367917244,-96.557708286314153 43.400727367884819,-96.52505328628375 43.384225367869448,-96.522894286281741 43.356966367844066,-96.540563286298195 43.307659367798145,-96.579131286334103 43.29007436778177,-96.570722286326273 43.263612367757112,-96.559567286315897 43.253263367747479,-96.566991286322803 43.23963336773479,-96.558605286315 43.225489367721622,-96.487245286248537 43.217909367714554,-96.473114286235372 43.209082367706337,-96.451505286215237 43.126308367629242,-96.460805286223916 43.087872367593448,-96.46209428622511 43.075582367582001,-96.479573286241376 43.061884367569242,-96.520010286279046 43.051508367559585,-96.49902028625948 43.012050367522832,-96.517148286276381 42.986458367498997,-96.514935286274323 42.952382367467258,-96.544263286301643 42.913866367431396,-96.537511286295342 42.896906367415596,-96.55621128631276 42.846660367368806,-96.573126286328517 42.834347367357338,-96.587645286342024 42.835381367358295,-96.600875286354366 42.799558367324934,-96.632980286384267 42.776835367303775,-96.640709286391456 42.748603367277482,-96.626540286378258 42.708354367239998,-96.563039286319125 42.668513367202891,-96.541165286298749 42.662405367197209,-96.512844286272369 42.629755367166794,-96.488498286249694 42.580480367120899,-96.500942286261278 42.573885367114762,-96.489337286250489 42.564028367105578,-96.480243286242001 42.51713036706191,-96.439394286203964 42.489240367035933,-96.494701286255477 42.488459367035205,-96.547215286304393 42.520499367065042,-96.58475328633935 42.518287367062982,-96.605467286358632 42.507236367052691,-96.629294286380826 42.522693367067085,-96.636672286387693 42.550731367093199,-96.714059286459772 42.612302367150541,-96.715273286460899 42.621907367159487,-96.694596286441637 42.64116336717742,-96.6990602864458 42.657715367192836,-96.722658286467762 42.668592367202962,-96.799344286539196 42.670019367204283,-96.810437286549529 42.681341367214834,-96.810140286549256 42.704084367236021,-96.908234286640607 42.73169936726174,-96.970773286698858 42.721147367251916,-96.977869286705456 42.727308367257642,-96.97000328669813 42.752065367280707,-96.979593286707072 42.758313367286526,-97.015139286740165 42.759542367287665,-97.130469286847585 42.773923367301066,-97.161422286876416 42.798619367324065,-97.211831286923356 42.812573367337059,-97.224443286935099 42.841202367363721,-97.243189286952557 42.851826367373619,-97.271457286978887 42.850014367371926,-97.311414287016106 42.861771367382879,-97.38930628708863 42.867433367388152,-97.457263287151932 42.850443367372328,-97.483159287176051 42.857157367378576,-97.506132287197431 42.860136367381358,-97.57065428725754 42.847990367370045,-97.634970287317429 42.861285367382422,-97.685752287364735 42.836837367359649,-97.725250287401522 42.858008367379369,-97.772186287445223 42.846164367368345,-97.797028287468351 42.849597367371544,-97.818643287488499 42.866587367387361,-97.888659287553708 42.855807367377324,-97.88994128755489 42.831271367354475,-97.929477287591723 42.792324367318201,-97.963558287623457 42.773690367300844,-97.995144287652877 42.766812367294442,-98.033140287688255 42.769192367296647,-98.121820287770831 42.808360367333137,-98.123117287772061 42.820223367344184,-98.144869287792318 42.835794367358687,-98.167826287813696 42.839571367362197,-98.31033928794642 42.881794367401525,-98.39120428802174 42.920135367437233,-98.457444288083423 42.937160367453089,-98.497651288120863 42.991778367503954,-99.253971288825255 42.992389367504529,-99.532790289084915 42.992335367504467,-100.198142289704577 42.99109536750332,-101.231737290667184 42.986843367499354,-102.086701291463442 42.989887367502192,-102.78838429211693 42.995303367507233))"];
    NSLog(@" - Data WKTGeometry");
    NSLog(@"   * Class: %@", [p class]);
    NSLog(@"   * Dimension: %d", p.dimensions);
    NSLog(@" - Data MKPolygon");
    NSLog(@"   * WKTPolygon Polygons number: %lu", (unsigned long)[p getPolygon].count);
    MKPolygon *k = [p toMapPolygon];
    NSLog(@"   * WKTPolygon Exterior points number: %lu", (unsigned long)k.pointCount);
    NSString *middlePoint = [NSString stringWithFormat:@"POINT (%f %f)", k.coordinate.longitude, k.coordinate.latitude];
    WKTPoint *pK = (WKTPoint *)[WKTParser parseGeometry:middlePoint];
    MKPointAnnotation *a = [pK toMapPointAnnotation];
    a.title = names[0];
    a.subtitle = middlePoint;
    NSLog(@" - Data MKPointAnnotation");
    NSLog(@"   * Title: %@", a.title);
    NSLog(@"   * Subtitle: %@", a.subtitle);
    NSLog(@"   * Coordinates: %f, %f", a.coordinate.latitude, a.coordinate.longitude);
    [map addAnnotation:a];
    [map addOverlay:k];
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
    else if([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonRenderer *p = [[MKPolygonRenderer alloc] initWithPolygon: (MKPolygon *)overlay];
        p.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.25];
        p.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
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
    else if([ovl isKindOfClass:[MKPolygon class]])
    {
        MKPolygonView *p = [[MKPolygonView alloc] initWithPolygon: (MKPolygon *) ovl];
        p.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.25];
        p.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
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
