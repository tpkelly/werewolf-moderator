//
//  BallotTests.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 15/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "BallotManager.h"
#import "GameState.h"
#import "Player.h"
#import "Vote.h"
#import "Ballot.h"
#import "Role.h"

@interface BallotTests : XCTestCase

@property (nonatomic, strong) id mockGameState;
@property (nonatomic, strong) BallotManager *testBallot;

@property (nonatomic, strong) Player *seducer;
@property (nonatomic, strong) Player *juliet;
@property (nonatomic, strong) Player *romeo;
@property (nonatomic, strong) Player *angel;
@property (nonatomic, strong) Player *wolfPup;
@property (nonatomic, strong) Player *guarded;
@property (nonatomic, strong) Player *jester;
@property (nonatomic, strong) Player *vampire;
@property (nonatomic, strong) Player *igor;

@property (nonatomic, strong) NSArray *allPlayers;

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
    
    self.allPlayers = @[self.seducer, self.juliet, self.romeo, self.angel, self.guarded, self.wolfPup, self.jester, self.vampire, self.igor];
    [[[self.mockGameState stub] andReturn:self.allPlayers] playersAlive];
    [[[self.mockGameState stub] andReturn:self.romeo] romeoPlayer];
    [[[self.mockGameState stub] andReturn:self.guarded] guardedPlayer];

    self.testBallot = [[BallotManager alloc] initWithState:self.mockGameState];
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
    NSArray *observedBallot = [self.testBallot firstRoundResults:[Ballot ballotWithVotes:votes]];
    
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
    Player *burnedPlayer = [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
    //Then:
    XCTAssertEqual(self.jester, burnedPlayer);
}

-(void)testThatSecondRoundOfBallotKillsAPlayerIfNotATie
{
    // Given
    NSArray *votes = @[[Vote forPlayer:self.wolfPup voteCount:2],
                       [Vote forPlayer:self.jester voteCount:3],
                       [Vote forPlayer:self.angel voteCount:1]];
    
    //When
    [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
    //Then:
    XCTAssertFalse(self.jester.alive);
}

-(void)testThatNobodyDiesIfSecondRoundIsATie
{
    // Given
    NSArray *votes = @[[Vote forPlayer:self.wolfPup voteCount:3],
                       [Vote forPlayer:self.jester voteCount:3],
                       [Vote forPlayer:self.angel voteCount:1]];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
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
    Player *burnedPlayer = [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
    //Then:
    XCTAssertNil(burnedPlayer);
}

- (void)testThatBurningTheJesterCancelsNextBallot {
    // Given:
    NSArray *votes = @[[Vote forPlayer:self.jester voteCount:7]];
    
    //Expect
    [[self.mockGameState expect] setJesterBurnedLastNight:YES];
    
    //When:
    Player *burnedPlayer = [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
    //Then:
    XCTAssertEqual(self.jester, burnedPlayer);
}

-(void)testThatJesterWinsIfBurned
{
    // Given:
    NSArray *votes = @[[Vote forPlayer:self.jester voteCount:7]];
    
    //Expect
    [[[self.mockGameState stub] andReturn:@[@(MadmanFaction)]] winningFactions];
    [[self.mockGameState expect] setWinningFactions:@[@(MadmanFaction), @(JesterFaction)]];
    
    //When
    [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
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
    [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
}

-(void)testThatBurningJulietKillsRomeoAtNight
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.juliet voteCount:7]];
    
    //Expect
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[self.romeo]];
    
    //When
    [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
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
    [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
}

-(void)testThatGuardianAngelTakesPlaceOfGuardedOnBallot
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.guarded voteCount:7]];
    
    //Expect
    [[[self.mockGameState stub] andReturn:self.angel] playerWithRole:GuardianAngel inPlayerSet:OCMOCK_ANY];
    
    //When
    NSArray *firstBallot = [self.testBallot firstRoundResults:[Ballot ballotWithVotes:votes]];
    
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
    NSArray *firstBallot = [self.testBallot firstRoundResults:[Ballot ballotWithVotes:votes]];
    
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
    NSArray *firstBallot = [self.testBallot firstRoundResults:[Ballot ballotWithVotes:votes]];
    
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
    Player *burnedPlayer = [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
    //Then:
    XCTAssertEqualObjects(self.angel, burnedPlayer);
}

-(void)testThatMinionGuardianAngelDoesNotTakePlaceOfGuardedAboutToBeBurned
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.guarded voteCount:7]];
    self.angel.role = [[Role alloc] initWithRole:Minion];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
    //Then:
    XCTAssertEqualObjects(self.guarded, burnedPlayer);
}

-(void)testThatGuardedRomeoIsReplacedByAngelAsDestinedToDieIfJulietIsBurned
{
    //Given:
    NSArray *votes = @[[Vote forPlayer:self.juliet voteCount:5]];
    self.mockGameState = [OCMockObject niceMockForClass:[GameState class]];
    self.testBallot = [[BallotManager alloc] initWithState:self.mockGameState];
    
    //Expect
    [[[self.mockGameState stub] andReturn:self.allPlayers] playersAlive];
    [[[self.mockGameState stub] andReturn:self.romeo] romeoPlayer];
    [[[self.mockGameState stub] andReturn:self.romeo] guardedPlayer];
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[[self.mockGameState stub] andReturn:self.angel] playerWithRole:GuardianAngel inPlayerSet:OCMOCK_ANY];
    [[self.mockGameState expect] setDestinedToDie:@[self.angel]];
    
    
    //When
    [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
}

#pragma mark - Seducer

-(void)testThatSeducerVotesAreReducedOnFirstRoundBallot
{
    //Given:
    NSArray *votes = @[[Vote forPlayer:self.romeo voteCount:5],
                       [Vote forPlayer:self.angel voteCount:3],
                       [Vote forPlayer:self.seducer voteCount:4]];
    
    //When
    NSArray *ballot = [self.testBallot firstRoundResults:[Ballot ballotWithVotes:votes]];
    
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
    NSArray *ballot = [self.testBallot firstRoundResults:[Ballot ballotWithVotes:votes]];
    
    //Then
    NSArray *expectedBallot = @[self.romeo, self.seducer];
    XCTAssertEqualObjects(expectedBallot, ballot);
}

-(void)testThatVotesForSeducerAreNotDirectlyAlteredInFirstRound
{
    //Given:
    NSArray *votes = @[[Vote forPlayer:self.seducer voteCount:5]];
    
    //When
    [self.testBallot firstRoundResults:[Ballot ballotWithVotes:votes]];
    
    //Then
    Vote *firstVote = [votes firstObject];
    XCTAssertEqual(5, firstVote.voteCount);
}

-(void)testThatSeducerVotesAreReducedInSecondRound
{
    //Given:
    NSArray *votes = @[[Vote forPlayer:self.angel voteCount:6],
                       [Vote forPlayer:self.seducer voteCount:10]];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
    //Then
    XCTAssertEqualObjects(self.angel, burnedPlayer);
}

-(void)testThatSeducerCanStillBeKilledInSecondRound
{
    //Given:
    NSArray *votes = @[[Vote forPlayer:self.angel voteCount:5],
                       [Vote forPlayer:self.seducer voteCount:11]];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
    //Then
    XCTAssertEqualObjects(self.seducer, burnedPlayer);
}

-(void)testThatVotesForSeducerAreNotDirectlyAlteredInSecondRound
{
    //Given:
    NSArray *votes = @[[Vote forPlayer:self.seducer voteCount:5]];
    
    //When
    [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
    //Then
    Vote *firstVote = [votes firstObject];
    XCTAssertEqual(5, firstVote.voteCount);
}

#pragma mark - Wolf pup

-(void)testThatBurningTheWolfPupGivesWolvesTwoAttacks
{
    //Given
    NSArray *votes = @[[Vote forPlayer:self.wolfPup voteCount:7]];
    
    //Expect
    [[self.mockGameState expect] setWolvesAttackTwice:YES];
    
    //When
    [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
}

#pragma mark - Vampires

-(void)testThatVampireIsNotProtectedFromStakeByIgor
{
    // Given
    NSArray *votes = @[[Vote forPlayer:self.vampire voteCount:7]];
    
    //Expect
    [[[self.mockGameState stub] andReturn:self.igor] playerWithRole:Igor inPlayerSet:OCMOCK_ANY];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
    XCTAssertEqual(self.vampire, burnedPlayer);
}

-(void)testThatVampireIsBurnedIfIgorIsNotAlive
{
    // Given
    NSArray *votes = @[[Vote forPlayer:self.vampire voteCount:7]];
    
    //When
    Player *burnedPlayer = [self.testBallot secondRoundResults:[Ballot ballotWithVotes:votes]];
    
    XCTAssertEqual(self.vampire, burnedPlayer);
}

#pragma mark - Inquisition

-(void)testThatMysticsArePutOnTheBallotByTheInquisitor
{
    // Given
    Player *mystic = [[Player alloc] initWithName:@"Mystic" role:Healer];
    Ballot *ballot = [Ballot ballotWithVotes:@[[Vote forPlayer:self.vampire voteCount:3], [Vote forPlayer:self.igor voteCount:2]]];
    ballot.inquisitionTarget = mystic;
    
    // When
    NSArray *playersOnBallot = [self.testBallot firstRoundResults:ballot];
    
    // Then
    NSArray *expectedPlayers = @[self.vampire, self.igor, mystic];
    XCTAssertEqualObjects(expectedPlayers, playersOnBallot);
}

-(void)testThatInquisitorDoesNothingIfPlayerIsAlreadyOnBallot
{
    // Given
    Player *mystic = [[Player alloc] initWithName:@"Mystic" role:Healer];
    Ballot *ballot = [Ballot ballotWithVotes:@[[Vote forPlayer:self.vampire voteCount:3], [Vote forPlayer:mystic voteCount:2]]];
    ballot.inquisitionTarget = mystic;
    
    // When
    NSArray *playersOnBallot = [self.testBallot firstRoundResults:ballot];
    
    // Then
    NSArray *expectedPlayers = @[self.vampire, mystic];
    XCTAssertEqualObjects(expectedPlayers, playersOnBallot);
}

-(void)testThatShadowsAreNotPutOnTheBallotByTheInquisitor
{
    // Given
    Ballot *ballot = [Ballot ballotWithVotes:@[[Vote forPlayer:self.vampire voteCount:3], [Vote forPlayer:self.igor voteCount:2]]];
    ballot.inquisitionTarget = self.wolfPup;
    
    // When
    NSArray *playersOnBallot = [self.testBallot firstRoundResults:ballot];
    
    // Then
    NSArray *expectedPlayers = @[self.vampire, self.igor];
    XCTAssertEqualObjects(expectedPlayers, playersOnBallot);
}

-(void)testThatVillagersAreNotPutOnTheBallotByTheInquisitor
{
    // Given
    Ballot *ballot = [Ballot ballotWithVotes:@[[Vote forPlayer:self.vampire voteCount:3], [Vote forPlayer:self.igor voteCount:2]]];
    ballot.inquisitionTarget = self.seducer;
    
    // When
    NSArray *playersOnBallot = [self.testBallot firstRoundResults:ballot];
    
    // Then
    NSArray *expectedPlayers = @[self.vampire, self.igor];
    XCTAssertEqualObjects(expectedPlayers, playersOnBallot);
}

-(void)testThatMysticsAreKilledByTheExecutioner
{
    // Given
    Player *mystic = [[Player alloc] initWithName:@"Mystic" role:Healer];
    Ballot *ballot = [Ballot ballotWithVotes:@[[Vote forPlayer:self.igor voteCount:2], [Vote forPlayer:mystic voteCount:1]]];
    ballot.inquisitionTarget = mystic;
    
    // When
    Player *burnedPlayer = [self.testBallot secondRoundResults:ballot];
    
    // Then
    XCTAssertEqual(mystic, burnedPlayer);
}

-(void)testThatShadowsAreKilledByTheExecutioner
{
    // Given
    Ballot *ballot = [Ballot ballotWithVotes:@[[Vote forPlayer:self.igor voteCount:2], [Vote forPlayer:self.wolfPup voteCount:1]]];
    ballot.inquisitionTarget = self.wolfPup;
    
    // When
    Player *burnedPlayer = [self.testBallot secondRoundResults:ballot];
    
    // Then
    XCTAssertEqual(self.wolfPup, burnedPlayer);
}

-(void)testThatExecutionerDoesNotKillIfPlayerGotNoVotes
{
    // Given
    Ballot *ballot = [Ballot ballotWithVotes:@[[Vote forPlayer:self.igor voteCount:2]]];
    ballot.inquisitionTarget = self.wolfPup;
    
    // When
    Player *burnedPlayer = [self.testBallot secondRoundResults:ballot];
    
    // Then
    XCTAssertNil(burnedPlayer);

}

-(void)testThatVillagersAreNotKilledByTheExecutioner
{
    // Given
    Ballot *ballot = [Ballot ballotWithVotes:@[[Vote forPlayer:self.igor voteCount:2]]];
    ballot.inquisitionTarget = self.seducer;
    
    // When
    Player *burnedPlayer = [self.testBallot secondRoundResults:ballot];
    
    // Then
    XCTAssertEqual(self.igor, burnedPlayer);
}

-(void)testThatCountdownStartsIfInquisitorBurnedWithTemplarAndMysticsInPlay
{
    // Given:
    self.mockGameState = [OCMockObject niceMockForClass:[GameState class]];
    self.testBallot = [[BallotManager alloc] initWithState:self.mockGameState];
    
    Player *mystic = [[Player alloc] initWithName:@"Mystic" role:Clairvoyant];
    Player *templar = [[Player alloc] initWithName:@"Templar" role:Templar];
    Player *inquisitor = [[Player alloc] initWithName:@"Inquisitor" role:Inquisitor];
    Ballot *ballot = [Ballot ballotWithVotes:@[[Vote forPlayer:inquisitor voteCount:2]]];
    BOOL templarAlive = YES;

    //Expect:
    [[[self.mockGameState stub] andReturn:@[mystic, inquisitor, templar]] playersAlive];
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(templarAlive)] roleIsAlive:Templar];
    [[self.mockGameState expect] setCountdownClock:@1];
    
    // When:
    [self.testBallot secondRoundResults:ballot];
}

-(void)testThatCountdownDoesNotStartIfInquisitorBurnedWithNoMysticsInPlay
{
    // Given:
    self.mockGameState = [OCMockObject niceMockForClass:[GameState class]];
    self.testBallot = [[BallotManager alloc] initWithState:self.mockGameState];
    
    Player *templar = [[Player alloc] initWithName:@"Templar" role:Templar];
    Player *inquisitor = [[Player alloc] initWithName:@"Inquisitor" role:Inquisitor];
    Ballot *ballot = [Ballot ballotWithVotes:@[[Vote forPlayer:inquisitor voteCount:2]]];
    BOOL templarAlive = YES;

    //Expect:
    [[[self.mockGameState stub] andReturn:@[inquisitor, templar]] playersAlive];
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(templarAlive)] roleIsAlive:Templar];
    [[self.mockGameState reject] setCountdownClock:OCMOCK_ANY];
    
    // When:
    [self.testBallot secondRoundResults:ballot];
}

-(void)testThatCountdownDoesNotStartIfInquisitorBurnedWithNoTemplarInPlay
{
    // Given:
    self.mockGameState = [OCMockObject niceMockForClass:[GameState class]];
    self.testBallot = [[BallotManager alloc] initWithState:self.mockGameState];
    
    Player *mystic = [[Player alloc] initWithName:@"Mystic" role:Clairvoyant];
    Player *inquisitor = [[Player alloc] initWithName:@"Inquisitor" role:Inquisitor];
    Ballot *ballot = [Ballot ballotWithVotes:@[[Vote forPlayer:inquisitor voteCount:2]]];
    BOOL templarAlive = NO;

    //Expect:
    [[[self.mockGameState stub] andReturn:@[mystic, inquisitor]] playersAlive];
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(templarAlive)] roleIsAlive:Templar];
    [[self.mockGameState reject] setCountdownClock:OCMOCK_ANY];
    
    // When:
    [self.testBallot secondRoundResults:ballot];
}

@end
