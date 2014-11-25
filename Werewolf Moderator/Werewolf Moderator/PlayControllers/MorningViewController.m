//
//  MorningViewController.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 25/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import "MorningViewController.h"
#import "SingleGame.h"
#import "Game.h"
#import "MorningNews.h"
#import "Player.h"

@interface MorningViewController ()

@property (nonatomic, strong) NSDate *entryTime;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MorningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MorningNews *news = [[SingleGame game] transitionToMorning];
    
    //Set off a timer to count how long we've been in the morning state
    self.entryTime = [NSDate date];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    
    //Get news from the Inn
    switch (news.news)
    {
        case NoNews: self.newsFromTheInn.text = @"No news";
            break;
        case FoundCorrupt: self.newsFromTheInn.text = @"A Corrupt was found";
            break;
        case FoundNonCorrupt: self.newsFromTheInn.text = @"A Non-corrupt was found";
            break;
    }
    
    //Deal with obituaries
    for (Player *deadPlayer in news.diedLastNight)
    {
        self.diedLastNight.text = [self.diedLastNight.text stringByAppendingString:[NSString stringWithFormat:@"%@\n", deadPlayer.name]];
    }
}

-(void)timerTick:(NSTimer*)timer
{
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"mm:ss";
    }
    
    NSTimeInterval timeInterval = -[self.entryTime timeIntervalSinceNow];
    self.morningtime.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

- (IBAction)ballotTime:(id)sender {
    NSLog(@"Ballot");
}
@end
