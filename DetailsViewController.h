//
//  DetailsViewController.h
//  Todo_App
//
//  Created by mac on 23/04/2025.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *myTitle;
@property (weak, nonatomic) IBOutlet UITextField *myDesc;
@property (weak, nonatomic) IBOutlet UISegmentedControl *myPeriorty;
@property (weak, nonatomic) IBOutlet UISegmentedControl *myChooseView;
@property (nonatomic, strong) NSDictionary *task;
@property (nonatomic, assign) NSUInteger taskIndex;
@property (nonatomic, strong) NSString *sourceController;
@end

NS_ASSUME_NONNULL_END
