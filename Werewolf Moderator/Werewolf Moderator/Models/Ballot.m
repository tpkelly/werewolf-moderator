//
//  Ballot.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 23/05/2015.
//  Copyright (c) 2015 TKGames. All rights reserved.
//

#import "Ballot.h"

@implementation Ballot

+(instancetype)ballotWithVotes:(NSArray*)votes;
{
    Ballot *ballot = [Ballot new];
    ballot.votes = votes;
    return ballot;
}

@end
