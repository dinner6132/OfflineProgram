//
//  ViewController.m
//  TestNotification
//

#import "ViewController.h"

#import <EstimoteSDK/EstimoteSDK.h>

#define BEACON_1_UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define BEACON_1_MAJOR 1
#define BEACON_1_MINOR 299

#define BEACON_2_UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define BEACON_2_MAJOR 2
#define BEACON_2_MINOR 26532

#define BEACON_3_UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define BEACON_3_MAJOR 3
#define BEACON_3_MINOR 299

#define BEACON_4_UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define BEACON_4_MAJOR 4
#define BEACON_4_MINOR 299

#define BEACON_5_UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define BEACON_5_MAJOR 5
#define BEACON_5_MINOR 38209

#define BEACON_6_UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define BEACON_6_MAJOR 6
#define BEACON_6_MINOR 28798

#define BEACON_7_UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define BEACON_7_MAJOR 7
#define BEACON_7_MINOR 16651

#define BEACON_8_UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define BEACON_8_MAJOR 8
#define BEACON_8_MINOR 1357

#define BEACON_9_UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define BEACON_9_MAJOR 9
#define BEACON_9_MINOR 35171

#define BEACON_10_UUID @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"
#define BEACON_10_MAJOR 10
#define BEACON_10_MINOR 299

BOOL isBeaconWithUUIDMajorMinor(CLBeacon *beacon, NSString *UUIDString, CLBeaconMajorValue major, CLBeaconMinorValue minor) {
    return [beacon.proximityUUID.UUIDString isEqualToString:UUIDString] && beacon.major.unsignedShortValue == major && beacon.minor.unsignedShortValue == minor;
}

@interface ViewController () <ESTBeaconManagerDelegate ,CLLocationManagerDelegate>

@property (nonatomic) ESTBeaconManager *beaconManager;

@property (nonatomic) CLBeaconRegion *beaconRegion1;
@property (nonatomic) CLBeaconRegion *beaconRegion2;
@property (nonatomic) CLBeaconRegion *beaconRegion3;
@property (nonatomic) CLBeaconRegion *beaconRegion4;
@property (nonatomic) CLBeaconRegion *beaconRegion5;
@property (nonatomic) CLBeaconRegion *beaconRegion6;
@property (nonatomic) CLBeaconRegion *beaconRegion7;
@property (nonatomic) CLBeaconRegion *beaconRegion8;
@property (nonatomic) CLBeaconRegion *beaconRegion9;
@property (nonatomic) CLBeaconRegion *beaconRegion10;
@property (nonatomic, strong) NSArray *beaconsArray;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLHeading *currentHeading;
//@property (nonatomic) NSString * dBm_setting;

@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@interface ESTTableViewCell : UITableViewCell

@end
@implementation ESTTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}
@end

static float x_value,y_value;
static int file_count = 1;
static int dir_count =1;
static NSString *dBm_set = @"4dBm";
static NSString *direction_dir = @"東";

@implementation ViewController


- (IBAction)button01:(id)sender {
//    [self WriteToFile];

    if ([timer isValid]) {
        [timer invalidate];
        self.ScanStatus.text = [NSString stringWithFormat:@"Stop scan"];
    }else{
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(WriteToFile)
                                               userInfo:nil
                                                repeats:YES];
        self.ScanStatus.text = [NSString stringWithFormat:@"Scanning"];
    }

}

- (IBAction)button02:(id)sender {
    dir_count ++;
    self.dirTextLabel.text = [NSString stringWithFormat:@"%d",dir_count];
    file_count = 1;
    self.fileTextLabel.text = @"準備開始";
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            direction_dir = @"東";
            NSLog(@"direction = %@",direction_dir);
            break;
        case 1:
            direction_dir = @"南";
            NSLog(@"direction = %@",direction_dir);
            break;
        case 2:
            direction_dir = @"西";
            NSLog(@"direction = %@",direction_dir);
            break;
        case 3:
            direction_dir = @"北";
            NSLog(@"direction = %@",direction_dir);
            break;
            
        default:
            break;
    }
    
}

- (IBAction)dBmSegmentValueChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            dBm_set = @"4dBm";
            self.dirLabel.text = @"4dBm";
            break;
        case 1:
            dBm_set = @"0dBm";
            self.dirLabel.text = @"0dBm";
            break;
        case 2:
            dBm_set = @"-4dBm";
            self.dirLabel.text = @"-4dBm";
            break;
            
        default:
            break;
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.beaconManager = [ESTBeaconManager new];
    self.beaconManager.delegate = self;
    self.beaconManager.returnAllRangedBeaconsAtOnce = YES;

    [self.beaconManager requestWhenInUseAuthorization];
    
    self.beaconRegion1 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BEACON_1_UUID] major:BEACON_1_MAJOR minor:BEACON_1_MINOR identifier:@"beaconRegion1"];
    self.beaconRegion2 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BEACON_2_UUID] major:BEACON_2_MAJOR minor:BEACON_2_MINOR identifier:@"beaconRegion2"];
    self.beaconRegion3 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BEACON_3_UUID] major:BEACON_3_MAJOR minor:BEACON_3_MINOR identifier:@"beaconRegion3"];
    self.beaconRegion4 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BEACON_4_UUID] major:BEACON_4_MAJOR minor:BEACON_4_MINOR identifier:@"beaconRegion4"];
    self.beaconRegion5 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BEACON_5_UUID] major:BEACON_5_MAJOR minor:BEACON_5_MINOR identifier:@"beaconRegion5"];
    self.beaconRegion6 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BEACON_6_UUID] major:BEACON_6_MAJOR minor:BEACON_6_MINOR identifier:@"beaconRegion6"];
    self.beaconRegion7 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BEACON_7_UUID] major:BEACON_7_MAJOR minor:BEACON_7_MINOR identifier:@"beaconRegion7"];
    self.beaconRegion8 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BEACON_8_UUID] major:BEACON_8_MAJOR minor:BEACON_8_MINOR identifier:@"beaconRegion8"];
    self.beaconRegion9 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BEACON_9_UUID] major:BEACON_9_MAJOR minor:BEACON_9_MINOR identifier:@"beaconRegion9"];
    self.beaconRegion10 = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BEACON_10_UUID] major:BEACON_10_MAJOR minor:BEACON_10_MINOR identifier:@"beaconRegion10"];
    
    self.currentHeading = [[CLHeading alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.headingFilter = 1;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingHeading];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion1];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion2];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion3];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion4];
    //[self.beaconManager startRangingBeaconsInRegion:self.beaconRegion5];
    //[self.beaconManager startRangingBeaconsInRegion:self.beaconRegion6];
    //[self.beaconManager startRangingBeaconsInRegion:self.beaconRegion7];
    //[self.beaconManager startRangingBeaconsInRegion:self.beaconRegion8];
    //[self.beaconManager startRangingBeaconsInRegion:self.beaconRegion9];
    //[self.beaconManager startRangingBeaconsInRegion:self.beaconRegion10];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion1];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion2];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion3];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion4];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion5];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion6];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion7];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion8];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion9];
    [self.beaconManager stopRangingBeaconsInRegion:self.beaconRegion10];

}

- (void)beaconManager:(id)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    CLBeacon *nearestBeacon = [beacons firstObject];
    
    self.beaconsArray = beacons;
    [self.tableView reloadData];
    self.PathLabel.text = [NSString stringWithFormat:@"%@/%@/point",dBm_set,direction_dir];
    NSLog(@"%@/%@/point",dBm_set,direction_dir);
    
    switch (nearestBeacon.proximity) {
        case CLProximityUnknown:
            NSLog(@"Unknown");
            break;
        case CLProximityFar:
            //NSLog(@"Far");
            break;
        case CLProximityNear:
            //NSLog(@"Near");
            break;
        case CLProximityImmediate:
            //NSLog(@"Immediate");
            break;
        default:
            break;
    }
    
    if (nearestBeacon) {
        if (isBeaconWithUUIDMajorMinor(nearestBeacon, BEACON_2_UUID, BEACON_2_MAJOR, BEACON_2_MINOR)) {
            // beacon #2
            self.label.text = @"beacon #2";
        } else if (isBeaconWithUUIDMajorMinor(nearestBeacon, BEACON_3_UUID, BEACON_3_MAJOR, BEACON_3_MINOR)) {
            // beacon #3
            self.label.text = @"beacon #3";
        } else if (isBeaconWithUUIDMajorMinor(nearestBeacon, BEACON_4_UUID, BEACON_4_MAJOR, BEACON_4_MINOR)) {
            // beacon #4
            self.label.text = @"beacon #4";
        } else if (isBeaconWithUUIDMajorMinor(nearestBeacon, BEACON_5_UUID, BEACON_5_MAJOR, BEACON_5_MINOR)) {
            // beacon #5
            self.label.text = @"beacon #5";
        }else if (isBeaconWithUUIDMajorMinor(nearestBeacon, BEACON_1_UUID, BEACON_1_MAJOR, BEACON_1_MINOR)) {
            // beacon #1
            self.label.text = @"beacon #1";
        }else if (isBeaconWithUUIDMajorMinor(nearestBeacon, BEACON_6_UUID, BEACON_6_MAJOR, BEACON_6_MINOR)) {
            // beacon #6
            self.label.text = @"beacon #6";
        }else if (isBeaconWithUUIDMajorMinor(nearestBeacon, BEACON_7_UUID, BEACON_7_MAJOR, BEACON_7_MINOR)) {
            // beacon #7
            self.label.text = @"beacon #7";
        }else if (isBeaconWithUUIDMajorMinor(nearestBeacon, BEACON_8_UUID, BEACON_8_MAJOR, BEACON_8_MINOR)) {
            // beacon #8
            self.label.text = @"beacon #8";
        }else if (isBeaconWithUUIDMajorMinor(nearestBeacon, BEACON_9_UUID, BEACON_9_MAJOR, BEACON_9_MINOR)) {
            // beacon #9
            self.label.text = @"beacon #9";
        }else if (isBeaconWithUUIDMajorMinor(nearestBeacon, BEACON_10_UUID, BEACON_10_MAJOR, BEACON_10_MINOR)) {
            // beacon #10
            self.label.text = @"beacon #10";
        }else
        {
        // no beacons found
        self.label.text = @"There are no beacons nearby";
        }
    }
}

- (void)beaconManager:(id)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        NSLog(@"Location Services authorization denied, can't range");
    }
}

- (void)beaconManager:(id)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"Ranging beacons failed for region '%@'\n\nMake sure that Bluetooth and Location Services are on, and that Location Services are allowed for this app. Also note that iOS simulator doesn't support Bluetooth.\n\nThe error was: %@", region.identifier, error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)TriangulationOfMethod {
    
    float x[[self.beaconsArray count]];
    float y[[self.beaconsArray count]];
    float d[[self.beaconsArray count]];
    float temp = 0;
    float Amat[2][2]; float Bmat[2][1]; float InrAmat[2][2]; float Solmat[2][1];
    
    //NSLog(@"count=%lu",(unsigned long)self.beaconsArray.count);
    
    for (int i=0; i < [self.beaconsArray count]; i++) {
        CLBeacon *beacon = [self.beaconsArray objectAtIndex:i];
        
        if (isBeaconWithUUIDMajorMinor(beacon, BEACON_2_UUID, BEACON_2_MAJOR, BEACON_2_MINOR)) {
            
//            d[0] = beacon.accuracy; x[0] = 4.5; y[0] = 9;
            d[0] = 10; x[0] = 0; y[0] = 1;
            
            if (d[0] == 0) {
                d[0] = 100;
            }
            
            //NSLog(@"original x[0]=%.1f , y[0]=%.1f d[0]=%.1f",x[0],y[0],d[0]);
        }else if (isBeaconWithUUIDMajorMinor(beacon, BEACON_3_UUID, BEACON_3_MAJOR, BEACON_3_MINOR)) {
            
//            d[1] = beacon.accuracy; x[1] = 9; y[1] = 6;
            d[1] = 5.1; x[1] = 15; y[1] = 2;
            
            if (d[1] == 0) {
                d[1] = 100;
            }
            //NSLog(@"original x[1]=%.1f , y[1]=%.1f d[1]=%.1f",x[1],y[1],d[1]);
        }else if (isBeaconWithUUIDMajorMinor(beacon, BEACON_4_UUID, BEACON_4_MAJOR, BEACON_4_MINOR)) {
            
//            d[2] = beacon.accuracy; x[2] = 4.5; y[2] = 0;
            d[2] = 25; x[2] = 35; y[2] = 1;
            
            if (d[2] == 0) {
                d[2] = 100;
            }
            //NSLog(@"original x[2]=%.1f , y[2]=%.1f d[2]=%.1f",x[2],y[2],d[2]);
        }else if (isBeaconWithUUIDMajorMinor(beacon, BEACON_5_UUID, BEACON_5_MAJOR, BEACON_5_MINOR)) {
            
//            d[3] = beacon.accuracy; x[3] = 0; y[3] = 6;
            d[3] = 5.1; x[3] = 15; y[3] = 0;
            
            if (d[3] == 0) {
                d[3] = 100;
            }
            
            //NSLog(@"original x[3]=%.1f , y[3]=%.1f d[3]=%.1f",x[3],y[3],d[3]);
        }
    }
    //排序 由小到大 (4顆beacon)
    for (int i=0; i< 4; i++) {
        for (int j=0; j<4; j++) {
            if (d[j] > d[i]) {
                temp = d[j];
                d[j] = d[i];
                d[i] = temp;
            }
        }
    }
    //    for(int i = 0; i < [self.beaconsArray count]; i++ ) {
    //        NSLog(@"x[%d]=%.1f y[%d]=%.1f ",i,x[i],i,y[i]);
    //        NSLog(@"d[%d]=%.1f",i,d[i]);
    //    }
    
    
    Amat[0][0] = -2 * ( x[0] - x[1] );
    Amat[0][1] = -2 * ( y[0] - y[1] );
    Amat[1][0] = -2 * ( x[0] - x[2] );
    Amat[1][1] = -2 * ( y[0] - y[2] );
    Bmat[0][0] = -((x[0]*x[0])-(x[1]*x[1])+(y[0]*y[0])-(y[1]*y[1])-(d[0]*d[0])+(d[1]*d[1]));
    Bmat[1][0] = -((x[0]*x[0])-(x[2]*x[2])+(y[0]*y[0])-(y[2]*y[2])-(d[0]*d[0])+(d[2]*d[2]));
    InrAmat[0][0] = Amat[1][1];
    InrAmat[0][1] = -Amat[0][1];
    InrAmat[1][0] = -Amat[1][0];
    InrAmat[1][1] = Amat[0][0];
    
    for(int i=0;i<2;i++){
        for (int k=0; k<2; k++) {
            InrAmat[i][k] = InrAmat[i][k] / (Amat[0][0] * Amat[1][1] - Amat[1][0] * Amat[0][1]);
        }
        for (int j=0; j<2; j++) {
            Solmat[j][0] = InrAmat[j][0] * Bmat[0][0] + InrAmat[j][1] * Bmat[1][0];
        }
    }
    x_value = Solmat[0][0];
    y_value = Solmat[1][0];
    
//    NSLog(@"x= %.3f",x_value);
//    NSLog(@"y= %.3f",y_value);
//    NSLog(@"(%.3f,%.3f)",x_value,y_value);
    
//    self.x_label.text = [NSString stringWithFormat:@"%.3f",x_value];
//    self.y_label.text = [NSString stringWithFormat:@"%.3f",y_value];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    self.currentHeading = newHeading;
    NSLog(@"%d",(int)newHeading.magneticHeading);
    
    if (newHeading.magneticHeading >= 315 || newHeading.magneticHeading < 45 ) {
        self.HeadingTextLabel.text = @"北";
    }else if( newHeading.magneticHeading >=45 && newHeading.magneticHeading < 135 ){
        self.HeadingTextLabel.text = @"東";
    }else if( newHeading.magneticHeading >= 135 && newHeading.magneticHeading < 225 ){
        self.HeadingTextLabel.text = @"南";
    }else if( newHeading.magneticHeading >= 225 && newHeading.magneticHeading < 315 ){
        self.HeadingTextLabel.text = @"西";
    }
    
    
    
}

-(void)WriteToFile {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    //Create 目錄
    NSString *dir;
    /*if (self.currentHeading.magneticHeading >= 315 || self.currentHeading.magneticHeading < 45 ){
        dir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/North/point_%d",dir_count];
    }else if( self.currentHeading.magneticHeading >=45 && self.currentHeading.magneticHeading < 135 ){
        dir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/East/point_%d",dir_count];
    }else if( self.currentHeading.magneticHeading >= 135 && self.currentHeading.magneticHeading < 225 ){
        dir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/South/point_%d",dir_count];
    }else if( self.currentHeading.magneticHeading >= 225 && self.currentHeading.magneticHeading < 315 ){
        dir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/West/point_%d",dir_count];
    }*/
    dir = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@/%@/point_%d",dBm_set,direction_dir,dir_count];
    //Create file
    NSString *file = [dir stringByAppendingFormat:@"/point_data.txt"];
    NSError *error;
    NSString *filedata;
    NSFileHandle *update = [NSFileHandle fileHandleForWritingAtPath:file];
    NSData *data;
    
    BOOL success = [fm createDirectoryAtPath:
                    dir withIntermediateDirectories:YES attributes:nil error:&error];
    if (success) {
        NSLog(@"目錄建立成功");
    }else {
        NSLog(@"目錄建立失敗");
    }
    for (int i=0; i < [self.beaconsArray count]; i++) {
        CLBeacon *beacon = [self.beaconsArray objectAtIndex:i];
        NSString *major = [NSString stringWithFormat:@"%@",beacon.major];
        NSString *rssi = [NSString stringWithFormat:@"%ld",(long)beacon.rssi];
        NSString *distance = [NSString stringWithFormat:@"%.2f",beacon.accuracy];
        filedata = [NSString stringWithFormat:@"major= %@ , rssi= %@\n",major,rssi];
        //filedata = [NSString stringWithFormat:@"rssi= %@\n",rssi];

        NSString *strDate = [NSString stringWithFormat:@"major,rssi \n"];
        
        data = [strDate dataUsingEncoding:NSUTF8StringEncoding];
    }
    if (file_count < 31) {
        
        if ([fm fileExistsAtPath:file])  {
            NSLog(@"檔案存在，寫入檔案");
            for (int i=0; i < [self.beaconsArray count]; i++) {
                CLBeacon *beacon = [self.beaconsArray objectAtIndex:i];
                NSString *major = [NSString stringWithFormat:@"%@",beacon.major];
                NSString *rssi = [NSString stringWithFormat:@"%ld",(long)beacon.rssi];
                NSString *distance = [NSString stringWithFormat:@"%f",beacon.accuracy];
                //filedata = [NSString stringWithFormat:@"%@    ,%@ ,%@ \n",major,rssi,distance];
                filedata = [NSString stringWithFormat:@"%@    ,%@  \n",major,rssi];
                //filedata = [NSString stringWithFormat:@"%@\n",rssi];
                data = [filedata dataUsingEncoding:NSUTF8StringEncoding];
                [update seekToEndOfFile];
                [update writeData:data];
            }
            NSString *n = @"--------------------\n";
            data = [n dataUsingEncoding:NSUTF8StringEncoding];
            [update seekToEndOfFile];
            [update writeData:data];
            file_count ++;
            
        }else{
            NSLog(@"檔案不存在，新增檔案並寫入");
            success = [fm createFileAtPath:file contents:data attributes:nil];
            if (success) {
                NSLog(@"Create File success");
            }else{
                NSLog(@"Create File ERROR");
            }
            file_count ++;
        }
    }else{
        NSLog(@"資料搜集完畢");
    }
    [update closeFile];
    if (file_count < 31) {
        self.fileTextLabel.text = [NSString stringWithFormat:@"%d",file_count-1];
    }else{
        self.fileTextLabel.text = @"下一個點";
    }
    
    
}

#pragma mark - ESTBeaconManager delegate

/*- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    self.beaconsArray = beacons;
    [self.tableView reloadData];
}

- (void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    self.beaconsArray = beacons;
    [self.tableView reloadData];
}*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.beaconsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"myCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    ESTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    
    CLBeacon *beacon = [self.beaconsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Major: %@ R: %ld", beacon.major, (long)beacon.rssi];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI: %ld", (long)beacon.rssi];
    
    //[self TriangulationOfMethod];
    
    return cell;
}


@end
