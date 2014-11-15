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

@end
