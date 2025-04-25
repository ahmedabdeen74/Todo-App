#import "DetailsViewController.h"

@interface DetailsViewController ()
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myTitle.text = self.task[@"title"];
    self.myDesc.text = self.task[@"description"];
    
    NSString *priority = self.task[@"priority"];
    if ([priority isEqualToString:@"Low"]) {
        self.myPeriorty.selectedSegmentIndex = 0;
    } else if ([priority isEqualToString:@"Medium"]) {
        self.myPeriorty.selectedSegmentIndex = 1;
    } else if ([priority isEqualToString:@"High"]) {
        self.myPeriorty.selectedSegmentIndex = 2;
    }
    

    if ([self.sourceController isEqualToString:@"todo"]) {
        self.myChooseView.selectedSegmentIndex = 0;
    } else if ([self.sourceController isEqualToString:@"inprogress"]) {
        self.myChooseView.selectedSegmentIndex = 1;
    }
}

- (IBAction)editDone:(id)sender {
    
    if ([self.myTitle.text length] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"message:@"Please Enter Your Title" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Edit Confirmation" message:@"Are you sure do you want to save edits?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self performTaskUpdate];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)performTaskUpdate {
    
    NSString *priority;
    switch (self.myPeriorty.selectedSegmentIndex) {
        case 0: priority = @"Low"; break;
        case 1: priority = @"Medium"; break;
        case 2: priority = @"High"; break;
        default: priority = @"Low"; break;
    }

    
    NSDictionary *updatedTask = @{
        @"title": self.myTitle.text,
        @"description": self.myDesc.text ?: @"",
        @"date": self.task[@"date"],
        @"priority": priority
    };

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch (self.myChooseView.selectedSegmentIndex) {
        case 0: {
            NSMutableArray *todoTasks = [[defaults arrayForKey:@"tasks"] mutableCopy] ?: [NSMutableArray array];
            if ([self.sourceController isEqualToString:@"todo"]) {

                [todoTasks replaceObjectAtIndex:self.taskIndex withObject:updatedTask];
            } else {
                NSMutableArray *inprogressTasks = [[defaults arrayForKey:@"inprogress_tasks"] mutableCopy];
                [inprogressTasks removeObjectAtIndex:self.taskIndex];
                [defaults setObject:inprogressTasks forKey:@"inprogress_tasks"];
                [todoTasks addObject:updatedTask];
            }
            [defaults setObject:todoTasks forKey:@"tasks"];
            break;
        }
        case 1: {
            NSMutableArray *inprogressTasks = [[defaults arrayForKey:@"inprogress_tasks"] mutableCopy] ?: [NSMutableArray array];
            if ([self.sourceController isEqualToString:@"inprogress"]) {
    
                [inprogressTasks replaceObjectAtIndex:self.taskIndex withObject:updatedTask];
            } else {
                NSMutableArray *todoTasks = [[defaults arrayForKey:@"tasks"] mutableCopy];
                [todoTasks removeObjectAtIndex:self.taskIndex];
                [defaults setObject:todoTasks forKey:@"tasks"];
                [inprogressTasks addObject:updatedTask];
            }
            [defaults setObject:inprogressTasks forKey:@"inprogress_tasks"];
            break;
        }
        case 2: {
            NSMutableArray *doneTasks = [[defaults arrayForKey:@"done_tasks"] mutableCopy] ?: [NSMutableArray array];
            if ([self.sourceController isEqualToString:@"todo"]) {
                NSMutableArray *todoTasks = [[defaults arrayForKey:@"tasks"] mutableCopy];
                [todoTasks removeObjectAtIndex:self.taskIndex];
                [defaults setObject:todoTasks forKey:@"tasks"];
            } else {
                NSMutableArray *inprogressTasks = [[defaults arrayForKey:@"inprogress_tasks"] mutableCopy];
                [inprogressTasks removeObjectAtIndex:self.taskIndex];
                [defaults setObject:inprogressTasks forKey:@"inprogress_tasks"];
            }
            [doneTasks addObject:updatedTask];
            [defaults setObject:doneTasks forKey:@"done_tasks"];
            break;
        }
    }
    
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
