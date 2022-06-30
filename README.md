# Meta University Project 3 - *Instagram*

**Instagram** is a photo sharing app using Parse as its backend.

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling
- [x] Show the username and creation time for each post
- [x] User can use a Tab Bar to switch between a Home Feed tab (all posts) and a Profile tab (only posts published by the current user)
- User Profiles:
  - [x] Allow the logged in user to add a profile photo
  - [x] Display the profile photo with each post
  - [x] Tapping on a post's username or profile photo goes to that user's profile page
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- [ ] User can comment on a post and see all comments for each post in the post details screen
- [x] User can like a post and see number of likes for each post in the post details screen
- [ ] Style the login page to look like the real Instagram login page
- [ ] Style the feed to look like the real Instagram feed
- [ ] Implement a custom camera view

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1.
2.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

| Sign Up / Log in / Log out | User persistence |
| -------------------------- | -----:|
| <img src="https://github.com/alicezhang030/Instagram/blob/main/Showcase/signup_login.gif" width=50% height=50%> | <img src="https://github.com/alicezhang030/Instagram/blob/main/Showcase/persistence.gif" width=50% height=50%> | 
| Post photo, take photo on phone, progress HUD | View last 20 posts, pull to refresh, details view, show username and creation time |
| <img src="https://github.com/alicezhang030/Instagram/blob/main/Showcase/take%20and%20upload%20photo.gif" width=50% height=50%> | <img src="https://github.com/alicezhang030/Instagram/blob/main/Showcase/view%20last%2020%20posts%20pull%20to%20refresh%20details%20view.gif" width=50% height=50%> | 
| Infinite scrolling | User profiles |
| <img src="https://github.com/alicezhang030/Instagram/blob/main/Showcase/infinite%20scroll.gif" width=50% height=50%> | <img src="https://github.com/alicezhang030/Instagram/blob/main/Showcase/user%20profiles.gif" width=50% height=50%> | 
| Likes | -- |
| <img src="https://github.com/alicezhang030/Instagram/blob/main/Showcase/likes.gif" width=50% height=50%> | -- | 


## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [DateTools](https://github.com/MatthewYork/DateTools) - date formatting library
- [SVPullToRefresh + SVInfiniteScrolling
](https://github.com/samvermette/SVPullToRefresh) - assist with infinite scrolling

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [2022] [Jinyang Zhang]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
