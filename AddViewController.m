#import "AddViewController.h"

@interface AddViewController ()
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)addTask:(id)sender {

    if ([self.myTitle.text length] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please Enter Title For Task" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    
    NSString *priority;
    switch (self.segumentPeriorty.selectedSegmentIndex) {
        case 0:
            priority = @"Low";
            break;
        case 1:
            priority = @"Medium";
            break;
        case 2:
            priority = @"High";
            break;
        default:
            priority = @"Low";
            break;
    }

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:self.myDatePiker.date];

    NSDictionary *task = @{
        @"title": self.myTitle.text,
        @"description": self.myDesc.text ?: @"",
        @"date": dateString,
        @"priority": priority
    };


    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tasks = [[defaults arrayForKey:@"tasks"] mutableCopy] ?: [NSMutableArray array];

    [tasks addObject:task];
    
    
    [defaults setObject:tasks forKey:@"tasks"];
    [defaults synchronize];

    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
