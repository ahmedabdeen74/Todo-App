#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InprogressViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *myFilter;

@end

NS_ASSUME_NONNULL_END
