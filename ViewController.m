#import "ViewController.h"
#import "AddViewController.h"
#import "DetailsViewController.h"

@interface ViewController ()
@end

@implementation ViewController {
    NSMutableArray *items;
    NSMutableArray *filteredItems;
    NSString *currentFilter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    items = [[defaults arrayForKey:@"tasks"] mutableCopy] ?: [NSMutableArray array];
    filteredItems = [items mutableCopy];
    currentFilter = @"All";
    
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    

    self.mySearch.delegate = self;
    
    
    [self.myFilter addTarget:self action:@selector(filterChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    items = [[defaults arrayForKey:@"tasks"] mutableCopy] ?: [NSMutableArray array];
    [self applyFilterAndSearch];
}

- (IBAction)addButton:(id)sender {
    AddViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"vc_add_controller"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)filterChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0: currentFilter = @"All"; break;
        case 1: currentFilter = @"Low"; break;
        case 2: currentFilter = @"Medium"; break;
        case 3: currentFilter = @"High"; break;
        default: currentFilter = @"All"; break;
    }
    [self applyFilterAndSearch];
}


- (void)applyFilterAndSearch {
    NSString *searchText = self.mySearch.text.lowercaseString;
    filteredItems = [NSMutableArray array];
    
    for (NSDictionary *task in items) {
        BOOL matchesFilter = [currentFilter isEqualToString:@"All"] || [task[@"priority"] isEqualToString:currentFilter];
        BOOL matchesSearch = [searchText length] == 0 || [[task[@"title"] lowercaseString] rangeOfString:searchText].location != NSNotFound;
        
        if (matchesFilter && matchesSearch) {
            [filteredItems addObject:task];
        }
    }
    
    [self.myTableView reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filteredItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *task = filteredItems[indexPath.row];
    cell.textLabel.text = task[@"title"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:22];

    cell.detailTextLabel.text = task[@"date"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];

    NSString *priority = task[@"priority"];
    UIImage *image = nil;
    if ([priority isEqualToString:@"Low"]) {
        image = [UIImage imageNamed:@"green"];
    } else if ([priority isEqualToString:@"Medium"]) {
        image = [UIImage imageNamed:@"yellow"];
    } else if ([priority isEqualToString:@"High"]) {
        image = [UIImage imageNamed:@"red"];
    }

    
    CGSize itemSize = CGSizeMake(60, 60);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();


    cell.imageView.layer.cornerRadius = 8;
    cell.imageView.clipsToBounds = YES;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Confirmation" message:@"Are you sure you want to delete this task?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
            NSDictionary *taskToDelete = filteredItems[indexPath.row];
            [filteredItems removeObjectAtIndex:indexPath.row];
            [items removeObject:taskToDelete];
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:items forKey:@"tasks"];
            [defaults synchronize];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"vc_details_controller"];
    vc.task = filteredItems[indexPath.row];
    vc.taskIndex = [items indexOfObject:filteredItems[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self applyFilterAndSearch];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

@end
