//
//  TweetCellTableViewCell.m
//  twitter
//
//  Created by Sergio Santoyo on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshData{
    
    self.authorLabel.text = self.tweet.user.name;
    self.dateLabel.text = self.tweet.createdAtString;
    self.tweetLabel.text = self.tweet.text;
    
    [self.favoriteButton setTitle:[NSString stringWithFormat:@"%i", self.tweet.favoriteCount] forState:UIControlStateNormal];
    
    
    
}



- (IBAction)didTapFavorite:(id)sender {
   
    if(!self.tweet.favorited){
        
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self refreshData];
        
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
            [self refreshData];
            
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




@end
