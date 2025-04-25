//
//  AddViewController.h
//  Todo_App
//
//  Created by mac on 23/04/2025.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *myTitle;
@property (weak, nonatomic) IBOutlet UITextField *myDesc;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segumentPeriorty;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePiker;

@end

NS_ASSUME_NONNULL_END
