//
//  DetailsViewController.m
//  twitter
//
//  Created by Sergio Santoyo on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshData];
    
}


-(void)refreshData{
    
    self.authorLabel.text = self.tweet.user.name;
    self.dateLabel.text = self.tweet.createdAtString;
    self.tweetLabel.text = self.tweet.text;
    
    NSString *handle = self.tweet.user.screenName;
       NSString *fullHandle = [@"@" stringByAppendingString:handle];
       self.handleLabel.text = fullHandle;
       
    NSURL *propicURL = [NSURL URLWithString:self.tweet.user.profilePicture];
       [self.profileImage setImageWithURL:propicURL];
    
    [self.favoriteButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.favoriteCount] forState:UIControlStateNormal];
    [self.retweetButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.retweetCount] forState:UIControlStateNormal];

    
    
}


- (IBAction)didTapFavorite:(id)sender {
    if(!self.tweet.favorited){
    
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    //[self refreshData];
    
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            
        }
        else{
            [self.favoriteButton setTitle:[NSString stringWithFormat:@"%i", tweet.favoriteCount] forState:UIControlStateNormal];
            [self.favoriteButton.imageView setImage:[UIImage imageNamed:@"favor-icon-red"]];
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
    }else{
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        //[self refreshData];
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                [self.favoriteButton setTitle:[NSString stringWithFormat:@"%i", tweet.favoriteCount] forState:UIControlStateNormal];
                [self.favoriteButton.imageView setImage:[UIImage imageNamed:@"favor-icon"]];
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}

    


- (IBAction)didTapRetweet:(id)sender {
    if(!self.tweet.retweeted){
       
       self.tweet.retweeted = YES;
       self.tweet.retweetCount += 1;
       //[self refreshData];
           NSLog(@"%d +1",self.tweet.retweetCount);
       [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
           if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
               
           }
           else{
               [self.retweetButton setTitle:[NSString stringWithFormat:@"%i", tweet.retweetCount] forState:UIControlStateNormal];
               [self.retweetButton.imageView setImage:[UIImage imageNamed:@"retweet-icon-green"]];
               NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
           }
       }];
       }else{
           self.tweet.retweeted = NO;
           self.tweet.retweetCount -= 1;
           //[self refreshData];
           NSLog(@"%d -1",self.tweet.retweetCount);
           [[APIManager shared] unretweet:self.tweet completion:^(Tweet *newtweet, NSError *error) {
               if(error){
                    NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
               }
               else{
                   NSLog(@"%i",self.tweet.retweetCount);
                   [self.retweetButton setTitle:[NSString stringWithFormat:@"%i", newtweet.retweetCount] forState:UIControlStateNormal];
                   [self.retweetButton.imageView setImage:[UIImage imageNamed:@"retweet-icon"]];
                   NSLog(@"Successfully unretweet the following Tweet: %@", newtweet.text);
               }
           }];
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
