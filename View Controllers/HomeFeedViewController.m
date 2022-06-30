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
#import "DetailsViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ProfileViewController.h"

@interface HomeFeedViewController () <UITableViewDataSource, UITableViewDelegate, PostCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayOfPosts;
@property (nonatomic, strong) UIRefreshControl *refreshControl; //pull down and refresh the page

@end

@implementation HomeFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self fetchPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    /*
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        // append data to data source, insert new cells at the end of table view
        // call [tableView.infiniteScrollingView stopAnimating] when done
    }];*/
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchPosts];
}

- (void)postCell:(PostCell *) postCell didTap: (PFUser *)user {
    [self performSegueWithIdentifier:@"ProfileSegue" sender:user];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell =[tableView dequeueReusableCellWithIdentifier: @"PostCell"];
    InsPost *post = self.arrayOfPosts[indexPath.row];
    [cell setPost:post];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfPosts.count;
}

- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"InsPost"];
    [query includeKey:@"author"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            self.arrayOfPosts = posts;
            [self.tableView reloadData];
            
            //stop the pull down refresher
            [self.refreshControl endRefreshing];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString: @"TweetTapSegue"]) {
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell: (PostCell*) sender];
        InsPost *dataToPass = self.arrayOfPosts[myIndexPath.row];
        DetailsViewController *detailVC = [segue destinationViewController];
        detailVC.detailPost = dataToPass;
    }
    
    if([segue.identifier isEqualToString:@"ProfileSegue"]) {
        ProfileViewController *profileVC = [segue destinationViewController];
        profileVC.userToDisplay = sender;
    }
}


@end
