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
#import "Role.h"

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
@property (nonatomic, strong) Player *vampire;
@property (nonatomic, strong) Player *igor;

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
    self.vampire = [[Player alloc] initWithName:@"Vampire" role:Vampire];
    self.igor = [[Player alloc] initWithName:@"Igor" role:Igor];
    
    self.mockGameState = [OCMockObject niceMockForClass:[GameState class]];
    
    NSArray *allPlayers = @[self.seducer, self.juliet, self.romeo, self.angel, self.guarded, self.wolfPup, self.jester, self.vampire, self.igor];
    [[[self.mockGameState stub] andReturn:allPlayers] playersAlive];
    [[[self.mockGameState stub] andReturn:self.romeo] romeoPlayer];
    [[[self.mockGameState stub] andReturn:self.guarded] guardedPlayer];

    self.testBallot = [[Ballot alloc] initWithState:self.mockGameState];
}

- (void)tearDown {
    [self.mockGameState verify];
    
    [super tearDown];
}

#pragma mark - General Voting

-(void)testThatFirstRoundOfVotingSelectsTopTwoScores
{
    // Given
    NSArray *votes = @[[Vote forPlayer:self.wolfPup voteCount:2],
                       [Vote forPlayer:self.jester voteCount:3],
                       [Vote forPlayer:self.angel voteCount:1],
                       [Vote forPlayer:self.romeo voteCount:3],
                       [Vote forPlayer:self.juliet voteCount:2],
                       [Vote forPlayer:self.guarded voteCount:0],
                       [Vote forPlayer:self.seducer voteCount:0]];
    // When
    NSArray *observedBallot = [self.testBallot firstRoundResults:votes];
    
    // Then
    NSArray *expectedBallot = @[self.jester, self.romeo, self.wolfPup, self.juliet];
    XCTAssertEqualObjects(expectedBallot, observedBallot);
}

-(void)testThatSecondRoundOfBallotPicksTopVotedPlayer
{
    // Given
    NSArray *votes = @[[Vote forPlayer:self.wolfPup voteCount:2],
                       [Vote forPlayer:self.jester voteCount:3],
                       [Vote forPlayer:self.angel voteCount:1]];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:votes];
    
    //Then:
    XCTAssertEqual(self.jester, burnedPlayer);
}

-(void)testThatNobodyDiesIfSecondRoundIsATie
{
    // Given
    NSArray *votes = @[[Vote forPlayer:self.wolfPup voteCount:3],
                       [Vote forPlayer:self.jester voteCount:3],
                       [Vote forPlayer:self.angel voteCount:1]];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:votes];
    
    //Then:
    XCTAssertNil(burnedPlayer);
}

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

#pragma mark - Lover tests

-(void)testThatBurningRomeoKillsJulietAtNight
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.romeo voteCount:7]];
    
    //Expect
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[[self.mockGameState stub] andReturn:self.juliet] playerWithRole:Juliet inPlayerSet:OCMOCK_ANY];
    [[self.mockGameState expect] setDestinedToDie:@[self.juliet]];
    
    //When
    [self.testBallot secondRoundResults:votes];
}

-(void)testThatBurningJulietKillsRomeoAtNight
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.juliet voteCount:7]];
    
    //Expect
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[self.romeo]];
    
    //When
    [self.testBallot secondRoundResults:votes];
}

-(void)testThatBurningRomeoDoesNotKillMinionJulietAtNight
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.romeo voteCount:7]];
    self.juliet.role = [[Role alloc] initWithRole:Minion];
    
    //Expect
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState reject] setDestinedToDie:@[self.juliet]];
    
    //When
    [self.testBallot secondRoundResults:votes];
}

-(void)testThatGuardianAngelTakesPlaceOfGuardedOnBallot
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.guarded voteCount:7]];
    
    //Expect
    [[[self.mockGameState stub] andReturn:self.angel] playerWithRole:GuardianAngel inPlayerSet:OCMOCK_ANY];
    
    //When
    NSArray *firstBallot = [self.testBallot firstRoundResults:votes];
    
    //Then:
    NSArray *expectedBallot = @[self.angel];
    XCTAssertEqualObjects(expectedBallot, firstBallot);
}

-(void)testThatMinionGuardianAngelDoesNotTakePlaceOfGuardedOnBallot
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.guarded voteCount:7]];
    self.angel.role = [[Role alloc] initWithRole:Minion];
    
    //When
    NSArray *firstBallot = [self.testBallot firstRoundResults:votes];
    
    //Then:
    NSArray *expectedBallot = @[self.guarded];
    XCTAssertEqualObjects(expectedBallot, firstBallot);
}

-(void)testThatGuardianAngelDoesNotTakePlaceOfGuardedOnBallotIfAngelAlreadyOnBallot
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.guarded voteCount:7], [Vote forPlayer:self.angel voteCount:1]];
    
    //Expect
    [[[self.mockGameState stub] andReturn:self.angel] playerWithRole:GuardianAngel inPlayerSet:OCMOCK_ANY];
    
    //When
    NSArray *firstBallot = [self.testBallot firstRoundResults:votes];
    
    //Then:
    NSArray *expectedBallot = @[self.guarded, self.angel];
    XCTAssertEqualObjects(expectedBallot, firstBallot);
}

-(void)testThatGuardianAngelTakesPlaceOfGuardedIfGuardedAboutToBeBurned
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.guarded voteCount:7], [Vote forPlayer:self.angel voteCount:1]];
    
    //Expect
    [[[self.mockGameState stub] andReturn:self.angel] playerWithRole:GuardianAngel inPlayerSet:OCMOCK_ANY];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:votes];
    
    //Then:
    XCTAssertEqualObjects(self.angel, burnedPlayer);
}

-(void)testThatMinionGuardianAngelDoesNotTakePlaceOfGuardedAboutToBeBurned
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.guarded voteCount:7]];
    self.angel.role = [[Role alloc] initWithRole:Minion];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:votes];
    
    //Then:
    XCTAssertEqualObjects(self.guarded, burnedPlayer);
}

#pragma mark - Seducer

-(void)testThatSeducerVotesAreReducedOnFirstRoundBallot
{
    //Given:
    NSArray *votes = @[[Vote forPlayer:self.romeo voteCount:5],
                       [Vote forPlayer:self.angel voteCount:3],
                       [Vote forPlayer:self.seducer voteCount:4]];
    
    //When
    NSArray *ballot = [self.testBallot firstRoundResults:votes];
    
    //Then
    NSArray *expectedBallot = @[self.romeo, self.angel];
    XCTAssertEqualObjects(expectedBallot, ballot);
}

-(void)testThatSeducerVotesAreRoundedUpOnFirstBallot
{
    //Given:
    NSArray *votes = @[[Vote forPlayer:self.romeo voteCount:5],
                       [Vote forPlayer:self.angel voteCount:2],
                       [Vote forPlayer:self.seducer voteCount:5]];
    
    //When
    NSArray *ballot = [self.testBallot firstRoundResults:votes];
    
    //Then
    NSArray *expectedBallot = @[self.romeo, self.seducer];
    XCTAssertEqualObjects(expectedBallot, ballot);
}

-(void)testThatSeducerVotesAreReducedInSecondRound
{
    //Given:
    NSArray *votes = @[[Vote forPlayer:self.angel voteCount:6],
                       [Vote forPlayer:self.seducer voteCount:10]];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:votes];
    
    //Then
    XCTAssertEqualObjects(self.angel, burnedPlayer);
}

-(void)testThatSeducerCanStillBeKilledInSecondRound
{
    //Given:
    NSArray *votes = @[[Vote forPlayer:self.angel voteCount:5],
                       [Vote forPlayer:self.seducer voteCount:11]];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:votes];
    
    //Then
    XCTAssertEqualObjects(self.seducer, burnedPlayer);
}

#pragma mark - Wolf pup

-(void)testThatBurningTheWolfPupGivesWolvesTwoAttacks
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.wolfPup voteCount:7]];
    
    //Expect
    [[self.mockGameState expect] setWolvesAttackTwice:YES];
    
    //When
    [self.testBallot secondRoundResults:votes];
}

#pragma mark - Vampires

-(void)testThatVampireIsProtectedFromStakeByIgor
{
    // Given
    NSArray *votes = @[[Vote forPlayer:self.vampire voteCount:7]];
    
    //Expect
    [[[self.mockGameState stub] andReturn:self.igor] playerWithRole:Igor inPlayerSet:OCMOCK_ANY];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:votes];
    
    XCTAssertEqual(self.igor, burnedPlayer);
}

-(void)testThatVampireIsBurnedIfIgorIsNotAlive
{
    // Given
    NSArray *votes = @[[Vote forPlayer:self.vampire voteCount:7]];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:votes];
    
    XCTAssertEqual(self.vampire, burnedPlayer);
}

@end
