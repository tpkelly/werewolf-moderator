//
//  BallotTests.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 15/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "Ballot.h"
#import "GameState.h"
#import "Player.h"
#import "Vote.h"

@interface BallotTests : XCTestCase

@property (nonatomic, strong) id mockGameState;
@property (nonatomic, strong) Ballot *testBallot;

@property (nonatomic, strong) Player *seducer;
@property (nonatomic, strong) Player *juliet;
@property (nonatomic, strong) Player *romeo;
@property (nonatomic, strong) Player *angel;
@property (nonatomic, strong) Player *wolfPup;
@property (nonatomic, strong) Player *guarded;
@property (nonatomic, strong) Player *jester;

@end

@implementation BallotTests

- (void)setUp {
    [super setUp];
    
    self.seducer = [[Player alloc] initWithName:@"Seducer" role:Seducer];
    self.juliet = [[Player alloc] initWithName:@"Juliet" role:Juliet];
    self.romeo = [[Player alloc] initWithName:@"Romeo" role:Farmer];
    self.angel = [[Player alloc] initWithName:@"Angel" role:GuardianAngel];
    self.wolfPup = [[Player alloc] initWithName:@"Wolf Pup" role:WolfPup];
    self.guarded = [[Player alloc] initWithName:@"Guarded" role:Farmer];
    self.jester = [[Player alloc] initWithName:@"Jester" role:Jester];
    
    self.mockGameState = [OCMockObject niceMockForClass:[GameState class]];
    self.testBallot = [[Ballot alloc] initWithState:self.mockGameState];
    
    NSArray *allPlayers = @[self.seducer, self.juliet, self.romeo, self.angel, self.guarded, self.wolfPup, self.jester];
    [[[self.mockGameState stub] andReturn:allPlayers] playersAlive];
    [[[self.mockGameState stub] andReturn:self.romeo] romeoPlayer];
    [[[self.mockGameState stub] andReturn:self.guarded] guardedPlayer];
}

- (void)tearDown {
    [self.mockGameState verify];
    
    [super tearDown];
}

#pragma mark - General Voting

#pragma mark - Jester tests

- (void)testThatBallotIsCancelledIfJesterWasBurned {
    // Given:
    NSArray *votes = @[[Vote forPlayer:self.wolfPup voteCount:7]];
    
    //Expect
    BOOL jesterBurned = YES;
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(jesterBurned)] jesterBurnedLastNight];
    [[self.mockGameState expect] setJesterBurnedLastNight:NO];

    //When:
    Player *burnedPlayer = [self.testBallot secondRoundResults:votes];
    
    //Then:
    XCTAssertNil(burnedPlayer);
}

- (void)testThatBurningTheJesterCancelsNextBallot {
    // Given:
    NSArray *votes = @[[Vote forPlayer:self.jester voteCount:7]];
    
    //Expect
    [[self.mockGameState expect] setJesterBurnedLastNight:YES];
    
    //When:
    Player *burnedPlayer = [self.testBallot secondRoundResults:votes];
    
    //Then:
    XCTAssertEqual(self.jester, burnedPlayer);
}

@end
