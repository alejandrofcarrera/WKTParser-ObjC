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
        map.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(39.833333, -98.583333), MKCoordinateSpanMake(70, 50));
        map.delegate = self;
        [self.view addSubview:map];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *myNavBtn = [[UIBarButtonItem alloc] initWithTitle:
        @"Unit Tests" style:UIBarButtonItemStylePlain target:
        self action:@selector(myButtonClicked:)];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationItem setRightBarButtonItem:myNavBtn];
}

-(void)myButtonClicked:(id)sender{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Choose option"
        message:@"" delegate:self cancelButtonTitle:@"Cancel"
        otherButtonTitles:@"Point", @"MultiPoint", @"LineString",
        @"MultiLineString", @"Polygon", @"MultiPolygon", nil];
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
            case 6:
                [self doTestMULTIPOLYGON];
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
    NSArray *aPoints = [p toMapMultiAnnotation];
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

- (void)doTestMULTIPOLYGON
{
    NSArray *names = @[@"Massachusetts"];
    NSLog(@" - Data: MULTIPOLYGON (((-71.31932826280908 41.77219536636813,-71.339798262828154 41.784425366379523,-71.34548326283344 41.813161366406284,-71.334542262823248 41.857903366447957,-71.342493262830658 41.875783366464603,-71.333086262821894 41.896031366483463,-71.383953262869269 41.888439366476391,-71.382405262867834 41.979263366560978,-71.378644262864327 42.013713366593066,-71.497430262974959 42.009253366588908,-71.797831263254722 42.004274366584262,-71.802340263258927 42.017977366597037,-72.094971263531463 42.025799366604311,-72.13634626356999 42.026402366604884,-72.507572263915719 42.030766366608944,-72.571226263975007 42.030125366608345,-72.581907263984959 42.021607366600414,-72.60782526400908 42.02280036660153,-72.609526264010668 42.030536366608722,-72.755894264146988 42.033847366611809,-72.76757526415787 42.002167366582313,-72.817679264204529 41.997185366577668,-72.816451264203394 42.033507366611502,-73.006095264380008 42.036009366613825,-73.045632264416824 42.036310366614103,-73.4842302648253 42.047428366624459,-73.498840264838918 42.077460366652431,-73.350824264701046 42.504755367050379,-73.258060264614656 42.746058367275111,-73.019695264392681 42.740396367269838,-72.922997264302623 42.73736436726702,-72.455770263867478 42.725852367256287,-72.279917263703709 42.720467367251274,-71.930216263378 42.707209367238931,-71.900942263350757 42.70537836723723,-71.287194262779138 42.698603367230916,-71.252411262746762 42.7260693672565,-71.240479262735647 42.743555367272776,-71.186347262685231 42.738760367268313,-71.181061262680316 42.807317367332161,-71.120604262623999 42.818281367342379,-71.065564262572749 42.80431936732937,-71.025426262535362 42.851171367373006,-70.92133626243843 42.885149367404644,-70.898111262416791 42.886877367406257,-70.849740262371739 42.863429367384427,-70.81388026233833 42.867065367387809,-70.739695262269265 42.663523367198245,-70.593199262132828 42.646305367182201,-70.633452262170309 42.582642367122908,-70.813128262337642 42.5464363670892,-70.893604262412595 42.448068366997582,-70.960622262475013 42.432393366982993,-71.034162262543504 42.285628366846304,-70.923204262440152 42.234517366798698,-70.89267126241171 42.265766366827805,-70.824661262348386 42.260507366822907,-70.774595262301759 42.248640366811856,-70.686037262219287 42.153166366722942,-70.618703262156572 41.968189366550661,-70.540338262083594 41.930951366515977,-70.537705262081147 41.805762366399392,-70.423511261974795 41.743622366341519,-70.273834261835376 41.721663366321067,-70.341127261898066 41.711813366311901,-70.205259261771531 41.712573366312604,-70.01921426159825 41.781519366376806,-70.000448261580786 41.856350366446499,-70.100497261673965 42.002194366582323,-70.255148261817993 42.060119366636286,-70.135090261706182 42.072494366647803,-70.050471261627365 42.026298366604784,-69.964170261546997 41.904094366490973,-69.917780261503793 41.767653366363902,-69.954423261537912 41.671495366274335,-70.397616261950674 41.61257136621947,-70.432919261983557 41.569756366179597,-70.637139262173747 41.539804366151699,-70.664888262199582 41.556127366166905,-70.619761262157567 41.735636366334084,-70.839430262362143 41.626692366232618,-70.892128262411205 41.633912366239343,-71.001185262512791 41.520124366133373,-71.117132262620771 41.493062366108163,-71.141212262643194 41.655273366259237,-71.198808262696843 41.678500366280872,-71.228976262724942 41.707694366308061,-71.266628262759994 41.749743366347218,-71.31932826280908 41.77219536636813)),((-70.604331262143191 41.429663366049127,-70.567694262109072 41.464566366081627,-70.552831262095225 41.417388366037692,-70.575857262116671 41.410285366031076,-70.515157262060143 41.398660366020252,-70.486141262033115 41.341561365967067,-70.738676262268314 41.334155365960171,-70.769713262297216 41.298164365926652,-70.843920262366311 41.348599365973627,-70.782524262309153 41.352517365977278,-70.770926262298346 41.324980365951632,-70.751769262280504 41.382169366004888,-70.667488262202014 41.454937366072663,-70.605842262144591 41.474663366091036,-70.604331262143191 41.429663366049127)),((-70.031716261609901 41.311931365939465,-70.006508261586418 41.324774365951441,-70.02662026160516 41.337210365963017,-70.087633261661978 41.296848365925428,-70.034486261612486 41.349718365974667,-70.049264261626249 41.391961366014016,-69.96598026154868 41.294891365923604,-69.968444261550971 41.251816365883492,-70.103105261676376 41.238279365870881,-70.213268261778992 41.270205365900608,-70.207096261773216 41.294087365922863,-70.097872261671512 41.277631365907531,-70.031716261609901 41.311931365939465)))");
    NSLog(@" - Real Information: Massachusetts (New England");
    WKTPolygonM *p = (WKTPolygonM *)[WKTParser parseGeometry:@"MULTIPOLYGON (((-71.31932826280908 41.77219536636813,-71.339798262828154 41.784425366379523,-71.34548326283344 41.813161366406284,-71.334542262823248 41.857903366447957,-71.342493262830658 41.875783366464603,-71.333086262821894 41.896031366483463,-71.383953262869269 41.888439366476391,-71.382405262867834 41.979263366560978,-71.378644262864327 42.013713366593066,-71.497430262974959 42.009253366588908,-71.797831263254722 42.004274366584262,-71.802340263258927 42.017977366597037,-72.094971263531463 42.025799366604311,-72.13634626356999 42.026402366604884,-72.507572263915719 42.030766366608944,-72.571226263975007 42.030125366608345,-72.581907263984959 42.021607366600414,-72.60782526400908 42.02280036660153,-72.609526264010668 42.030536366608722,-72.755894264146988 42.033847366611809,-72.76757526415787 42.002167366582313,-72.817679264204529 41.997185366577668,-72.816451264203394 42.033507366611502,-73.006095264380008 42.036009366613825,-73.045632264416824 42.036310366614103,-73.4842302648253 42.047428366624459,-73.498840264838918 42.077460366652431,-73.350824264701046 42.504755367050379,-73.258060264614656 42.746058367275111,-73.019695264392681 42.740396367269838,-72.922997264302623 42.73736436726702,-72.455770263867478 42.725852367256287,-72.279917263703709 42.720467367251274,-71.930216263378 42.707209367238931,-71.900942263350757 42.70537836723723,-71.287194262779138 42.698603367230916,-71.252411262746762 42.7260693672565,-71.240479262735647 42.743555367272776,-71.186347262685231 42.738760367268313,-71.181061262680316 42.807317367332161,-71.120604262623999 42.818281367342379,-71.065564262572749 42.80431936732937,-71.025426262535362 42.851171367373006,-70.92133626243843 42.885149367404644,-70.898111262416791 42.886877367406257,-70.849740262371739 42.863429367384427,-70.81388026233833 42.867065367387809,-70.739695262269265 42.663523367198245,-70.593199262132828 42.646305367182201,-70.633452262170309 42.582642367122908,-70.813128262337642 42.5464363670892,-70.893604262412595 42.448068366997582,-70.960622262475013 42.432393366982993,-71.034162262543504 42.285628366846304,-70.923204262440152 42.234517366798698,-70.89267126241171 42.265766366827805,-70.824661262348386 42.260507366822907,-70.774595262301759 42.248640366811856,-70.686037262219287 42.153166366722942,-70.618703262156572 41.968189366550661,-70.540338262083594 41.930951366515977,-70.537705262081147 41.805762366399392,-70.423511261974795 41.743622366341519,-70.273834261835376 41.721663366321067,-70.341127261898066 41.711813366311901,-70.205259261771531 41.712573366312604,-70.01921426159825 41.781519366376806,-70.000448261580786 41.856350366446499,-70.100497261673965 42.002194366582323,-70.255148261817993 42.060119366636286,-70.135090261706182 42.072494366647803,-70.050471261627365 42.026298366604784,-69.964170261546997 41.904094366490973,-69.917780261503793 41.767653366363902,-69.954423261537912 41.671495366274335,-70.397616261950674 41.61257136621947,-70.432919261983557 41.569756366179597,-70.637139262173747 41.539804366151699,-70.664888262199582 41.556127366166905,-70.619761262157567 41.735636366334084,-70.839430262362143 41.626692366232618,-70.892128262411205 41.633912366239343,-71.001185262512791 41.520124366133373,-71.117132262620771 41.493062366108163,-71.141212262643194 41.655273366259237,-71.198808262696843 41.678500366280872,-71.228976262724942 41.707694366308061,-71.266628262759994 41.749743366347218,-71.31932826280908 41.77219536636813)),((-70.604331262143191 41.429663366049127,-70.567694262109072 41.464566366081627,-70.552831262095225 41.417388366037692,-70.575857262116671 41.410285366031076,-70.515157262060143 41.398660366020252,-70.486141262033115 41.341561365967067,-70.738676262268314 41.334155365960171,-70.769713262297216 41.298164365926652,-70.843920262366311 41.348599365973627,-70.782524262309153 41.352517365977278,-70.770926262298346 41.324980365951632,-70.751769262280504 41.382169366004888,-70.667488262202014 41.454937366072663,-70.605842262144591 41.474663366091036,-70.604331262143191 41.429663366049127)),((-70.031716261609901 41.311931365939465,-70.006508261586418 41.324774365951441,-70.02662026160516 41.337210365963017,-70.087633261661978 41.296848365925428,-70.034486261612486 41.349718365974667,-70.049264261626249 41.391961366014016,-69.96598026154868 41.294891365923604,-69.968444261550971 41.251816365883492,-70.103105261676376 41.238279365870881,-70.213268261778992 41.270205365900608,-70.207096261773216 41.294087365922863,-70.097872261671512 41.277631365907531,-70.031716261609901 41.311931365939465)))"];
    NSLog(@" - Data WKTGeometry");
    NSLog(@"   * Class: %@", [p class]);
    NSLog(@"   * Dimension: %d", p.dimensions);
    NSLog(@" - Data MKPolygonM");
    NSLog(@"   * WKTPolygonM Polygons number: %lu", (unsigned long)[p getPolygons].count);
    NSArray *k = [p toMapMultiPolygon];
    for(int i = 0; i < k.count; i++)
    {
        NSLog(@" - Data MKPolygon");
        NSLog(@"   * WKTPolygon (%d) Exterior points number: %lu", i, (unsigned long) [k[i] pointCount]);
        NSString *middlePoint = [NSString stringWithFormat:@"POINT (%f %f)", [k[i] coordinate].longitude,
            [k[i] coordinate].latitude];
        WKTPoint *pK = (WKTPoint *)[WKTParser parseGeometry:middlePoint];
        MKPointAnnotation *a = [pK toMapPointAnnotation];
        a.title = names[0];
        a.subtitle = middlePoint;
        NSLog(@" - Data MKPointAnnotation");
        NSLog(@"   * Title: %@ (%d)", a.title, i);
        NSLog(@"   * Subtitle: %@", a.subtitle);
        NSLog(@"   * Coordinates: %f, %f", a.coordinate.latitude, a.coordinate.longitude);
        [map addAnnotation:a];
        [map addOverlay:k[i]];
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

@end
