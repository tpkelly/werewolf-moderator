//
//  GameTests.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 15/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "Game.h"
#import "GameState.h"
#import "Player.h"

@interface GameTests : XCTestCase

@property (nonatomic, strong) id mockGameState;
@property (nonatomic, strong) Game *testGame;

@end

@implementation GameTests

- (void)setUp {
    [super setUp];
    
    self.mockGameState = [OCMockObject niceMockForClass:[GameState class]];
    self.testGame = [[Game alloc] initWithState:self.mockGameState];
}

- (void)tearDown {
    [self.mockGameState verify];
    
    [super tearDown];
}

#pragma mark - Mystics

-(void)testThatClairvoyantChecksForCorruption
{
    // Given:
    Player *corruptPlayer = [[Player alloc] initWithName:@"Bob" role:AlphaWolf];
    Player *noncorruptPlayer = [[Player alloc] initWithName:@"Bob" role:Farmer];
    
    //Then:
    XCTAssertTrue([self.testGame clairvoyantChecksPlayer:corruptPlayer]);
    XCTAssertFalse([self.testGame clairvoyantChecksPlayer:noncorruptPlayer]);
}

-(void)testThatMediumChecksForCorruption
{
    // Given:
    Player *corruptPlayer = [[Player alloc] initWithName:@"Bob" role:AlphaWolf];
    Player *noncorruptPlayer = [[Player alloc] initWithName:@"Bob" role:Farmer];
    
    //Then:
    XCTAssertTrue([self.testGame mediumChecksPlayer:corruptPlayer]);
    XCTAssertFalse([self.testGame mediumChecksPlayer:noncorruptPlayer]);
}

-(void)testThatWizardChecksForMysticism
{
    // Given:
    Player *mysticPlayer = [[Player alloc] initWithName:@"Bob" role:Healer];
    Player *regularPlayer = [[Player alloc] initWithName:@"Bob" role:Farmer];
    
    //Then:
    XCTAssertTrue([self.testGame wizardChecksPlayer:mysticPlayer]);
    XCTAssertFalse([self.testGame wizardChecksPlayer:regularPlayer]);
}

-(void)testThatClairvoyantFindingCorruptionUpdatesNewsForTheVillage
{
    // Given:
    Player *corruptPlayer = [[Player alloc] initWithName:@"Wolf" role:AlphaWolf];
    
    // Expect:
    BOOL innkeeperIsAlive = YES;
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(innkeeperIsAlive)] roleIsAlive:Innkeeper];
    [[self.mockGameState expect] setNewsFromTheInn:FoundCorrupt];
    
    //When:
    [self.testGame clairvoyantChecksPlayer:corruptPlayer];
}

-(void)testThatClairvoyantFindingNoCorruptionUpdatesNewsForTheVillage
{
    // Given:
    Player *noncorruptPlayer = [[Player alloc] initWithName:@"Farmer" role:Farmer];
    
    // Expect:
    BOOL bardIsAlive = YES;
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(bardIsAlive)] roleIsAlive:Bard];
    [[self.mockGameState expect] setNewsFromTheInn:FoundNonCorrupt];
    
    //When:
    [self.testGame clairvoyantChecksPlayer:noncorruptPlayer];
}

-(void)testThatNoNewsForTheVillageIfCorruptionFoundButInnkeeperIsGone
{
    // Given:
    Player *corruptPlayer = [[Player alloc] initWithName:@"Wolf" role:AlphaWolf];
    
    // Expect:
    BOOL innkeeperIsAlive = NO;
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(innkeeperIsAlive)] roleIsAlive:Innkeeper];
    [[self.mockGameState expect] setNewsFromTheInn:NoNews];
    
    //When:
    [self.testGame clairvoyantChecksPlayer:corruptPlayer];
}

-(void)testThatNoNewsForTheVillageIfNoCorruptionFoundButBardIsGone
{
    // Given:
    Player *noncorruptPlayer = [[Player alloc] initWithName:@"Farmer" role:Farmer];
    
    // Expect:
    BOOL bardIsAlive = NO;
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(bardIsAlive)] roleIsAlive:Bard];
    [[self.mockGameState expect] setNewsFromTheInn:NoNews];
    
    //When:
    [self.testGame clairvoyantChecksPlayer:noncorruptPlayer];
}

-(void)testThatWitchGivesTemporaryProtectionToTargetPlayer
{
    // Given:
    Player *player = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    
    // When:
    [self.testGame witchProtectPlayer:player];
    
    // Then:
    XCTAssertTrue(player.temporaryProtection);
}

-(void)testThatHealerBringsPlayerBackFromBrinkOfDeath
{
    // Given:
    Player *chosenToDie = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    Player *otherPlayer = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    NSArray *destinedToDie = @[chosenToDie, otherPlayer];
    
    // Expect:
    BOOL healerHasPowers = YES;
    NSArray *expectedNewArray = @[otherPlayer];
    [[[self.mockGameState stub] andReturn:destinedToDie] destinedToDie];
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(healerHasPowers)] healerHasPowers];
    [[self.mockGameState expect] setDestinedToDie:expectedNewArray];
    
    // When
    [self.testGame healerSavesPlayer:chosenToDie];
}

-(void)testThatHealerWithoutPowersCannotBringBackFromTheDead
{
    // Given:
    Player *chosenToDie = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    Player *otherPlayer = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    NSArray *destinedToDie = @[chosenToDie, otherPlayer];
    
    // Expect:
    BOOL healerHasPowers = NO;
    [[[self.mockGameState stub] andReturn:destinedToDie] destinedToDie];
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(healerHasPowers)] healerHasPowers];
    [[self.mockGameState reject] setDestinedToDie:OCMOCK_ANY];
    
    // When
    [self.testGame healerSavesPlayer:chosenToDie];
}

-(void)testThatHealerCannotUsePowersIfHealerIsDestinedToDie
{
    // Given:
    Player *chosenToDie = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    Player *otherPlayer = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    Player *healer = [[Player alloc] initWithName:@"Healer Bob" role:Healer];
    NSArray *destinedToDie = @[chosenToDie, otherPlayer, healer];
    
    // Expect:
    BOOL healerHasPowers = YES;
    [[[self.mockGameState stub] andReturn:destinedToDie] destinedToDie];
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(healerHasPowers)] healerHasPowers];
    [[[self.mockGameState stub] andReturn:healer] playerWithRole:Healer inPlayerSet:OCMOCK_ANY];
    [[self.mockGameState reject] setDestinedToDie:OCMOCK_ANY];
    
    // When
    [self.testGame healerSavesPlayer:chosenToDie];
}

-(void)testThatSuccessfulHealingCanOnlyBeUsedOncePerGame
{
    // Given:
    Player *chosenToDie = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    NSArray *destinedToDie = @[chosenToDie];
    
    // Expect:
    BOOL healerHasPowers = YES;
    [[[self.mockGameState stub] andReturn:destinedToDie] destinedToDie];
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(healerHasPowers)] healerHasPowers];
    [[self.mockGameState stub] setDestinedToDie:OCMOCK_ANY];
    [[self.mockGameState expect] setHealerHasPowers:NO];
    
    // When
    [self.testGame healerSavesPlayer:chosenToDie];
}

@end
