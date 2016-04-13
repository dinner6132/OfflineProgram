//
//  ViewController.h
//  TestNotification
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSTimer *timer;
    NSTimer *timer2;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *fileTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dirTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *HeadingTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *ScanStatus;
@property (weak, nonatomic) IBOutlet UILabel *dirLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *PathLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *dBmSegmentedControll;

- (IBAction)button01:(id)sender;
- (IBAction)button02:(id)sender;
- (IBAction)segmentValueChanged:(id)sender;
- (IBAction)dBmSegmentValueChanged:(id)sender;




@end

