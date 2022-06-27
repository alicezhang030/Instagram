//
//  LoginViewController.m
//  Instagram
//
//  Created by Alice Zhang on 6/27/22.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)loginUser:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [self checkEmptyField];
    
    /* logInWithUsernameInBackground - Makes an asynchronous request to log in a user with specified credentials. Returns an instance of the successfully logged in PFUser. This also caches the user locally so that calls to PFUser.current() (in Objective-C, [PFUser current]) will use the latest logged in user.
     */
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            // Display view controller that needs to shown after successful login
        }
    }];
}

- (IBAction)signupUser:(id)sender {
    // Initialize a user object
    PFUser *newUser = [PFUser user];
        
    // Set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [self checkEmptyField];
    
    // Call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            //[self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void) checkEmptyField {
    NSString *title = @"";
    NSString *message = @"Please enter a ";
    
    if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        if([self.usernameField.text isEqual:@""] && [self.passwordField.text isEqual:@""]) {
            title = @"Username & Password Required";
            [message stringByAppendingString:@"username and password and try again."];
        } else if([self.usernameField.text isEqual:@""]) { // only username is empty
            title = @"Username Required";
            [message stringByAppendingString:@"username and try again."];
        } else if([self.passwordField.text isEqual:@""]) { // only password is empty
            title = @"Password Required";
            [message stringByAppendingString:@"password and try again."];
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                    message:message
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        // Create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {}];
        
        // Add the OK action to the alert controller
        [alert addAction:okAction];
        
        // Present the alert
        [self presentViewController:alert animated:YES completion:^{}];
    }
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
