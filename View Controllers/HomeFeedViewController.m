//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by Alice Zhang on 6/27/22.
//

#import "HomeFeedViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h" // Needed for didTagLogOut
#import "LoginViewController.h" // Needed for didTagLogOut
#import "PostCell.h" // Needed for TableView
#import "InsPost.h" // Needed for TableView

@interface HomeFeedViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayOfPosts;

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self fetchPosts];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell =[tableView dequeueReusableCellWithIdentifier: @"PostCell"];
    InsPost *post = self.arrayOfPosts[indexPath.row];
    
    // Set the cell's caption
    cell.captionLabel.text = post[@"caption"];
    
    // TODO: Set the cell's image
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"InsPost"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapLogOut:(id)sender {
    NSLog(@"User tapped log out");
    
    // Reset view to the log in screen
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.view.window.rootViewController = loginViewController;

    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
