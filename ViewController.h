#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *myFilter;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearch;

- (IBAction)addButton:(id)sender;

@end
