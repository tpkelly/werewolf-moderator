//
//  GameStateTests.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 13/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GameState.h"
#import "RoleType.h"
#import "Player.h"
#import "Role.h"

@interface GameStateTests : XCTestCase

@property (nonatomic, strong) GameState *gameState;

@end

@implementation GameStateTests

- (void)setUp {
    [super setUp];
    self.gameState = [GameState new];
}

#pragma mark - Initial State

- (void)testThatGameStartsWithNoNewsFromTheInn {
    XCTAssertEqual(NoNews, self.gameState.newsFromTheInn);
}

- (void)testThatGameStartsWithJesterUnburned {
    XCTAssertFalse(self.gameState.jesterBurnedLastNight);
}

- (void)testThatGameStartsWithMadmanUnmauled {
    XCTAssertFalse(self.gameState.madmanMauledLastNight);
}

- (void)testThatGameStartsWithHealerPowersAvailable {
    XCTAssertTrue(self.gameState.healerHasPowers);
}

- (void)testThatGameStartsWithNobodyDestinedToDie {
    XCTAssertEqualObjects([NSArray array], self.gameState.destinedToDie);
}

- (void)testThatGameStartsWithNobodyDead {
    XCTAssertEqualObjects([NSArray array], self.gameState.playersDead);
}

- (void)testThatGameStartsWithNobodyAlive {
    XCTAssertEqualObjects([NSArray array], self.gameState.playersAlive);
}

- (void)testThatGameStartsWithNobodyGuarded {
    XCTAssertNil(self.gameState.guardedPlayer);
}

- (void)testThatGameStartsWithNoRomeo {
    XCTAssertNil(self.gameState.romeoPlayer);
}

- (void)testThatGameStartsWithAllRolesUnassigned {
    // Given
    NSSet *allRoles = [NSCountedSet setWithArray:@[@(AlphaWolf), @(PackWolf), @(WolfPup), @(Defector), @(Clairvoyant), @(Medium), @(Wizard), @(Witch), @(Healer), @(Farmer), @(Farmer), @(Hermit), @(Bard), @(Innkeeper), @(Monk), @(Priest), @(Sinner), @(Seducer), @(Madman), @(Jester), @(Juliet), @(GuardianAngel), @(Vampire), @(Igor), @(VampireHunter)]];
    
    // Then
    XCTAssertEqualObjects(allRoles, self.gameState.unassignedRoles);
}

#pragma mark - Add Player

-(void)testThatAddingPlayerAddsToLiveList
{
    // Given
    Player *newPlayer = [[Player alloc] initWithName:@"Bob" role:Farmer];
    
    // When
    [self.gameState addPlayer:newPlayer];
    
    // Then
    NSArray *expectedPlayers = @[newPlayer];
    XCTAssertEqualObjects(expectedPlayers, self.gameState.playersAlive);
}

-(void)testThatAddingPlayerDoesNotAffectTheDeadList
{
    // Given
    Player *newPlayer = [[Player alloc] initWithName:@"Bob" role:Farmer];
    
    // When
    [self.gameState addPlayer:newPlayer];
    
    // Then
    XCTAssertEqualObjects(@[], self.gameState.playersDead);
}

-(void)testThatNewlyAddedPlayerIsNotImmediatelyDestinedToDie
{
    // Given
    Player *newPlayer = [[Player alloc] initWithName:@"Bob" role:Farmer];
    
    // When
    [self.gameState addPlayer:newPlayer];
    
    // Then
    XCTAssertEqualObjects(@[], self.gameState.destinedToDie);
}

-(void)testThatAddingPlayerRemovesFromTheUnassignedRoles
{
    // Given
    Player *newPlayer = [[Player alloc] initWithName:@"Bob" role:Monk];
    NSSet *allRolesMinusMonk = [NSCountedSet setWithArray:@[@(AlphaWolf), @(PackWolf), @(WolfPup), @(Defector), @(Clairvoyant), @(Medium), @(Wizard), @(Witch), @(Healer), @(Farmer), @(Farmer), @(Hermit), @(Bard), @(Innkeeper), @(Priest), @(Sinner), @(Seducer), @(Madman), @(Jester), @(Juliet), @(GuardianAngel), @(Vampire), @(Igor), @(VampireHunter)]];
    
    // When
    [self.gameState addPlayer:newPlayer];
    
    // Then
    XCTAssertEqualObjects(allRolesMinusMonk, self.gameState.unassignedRoles);
}

-(void)testThatAddingFarmerPlayerOnlyRemovesASingleFarmer
{
    // Given
    Player *newPlayer = [[Player alloc] initWithName:@"Bob" role:Farmer];
    NSSet *allRolesMinusFarmer = [NSCountedSet setWithArray:@[@(AlphaWolf), @(PackWolf), @(WolfPup), @(Defector), @(Clairvoyant), @(Medium), @(Wizard), @(Witch), @(Healer), @(Farmer), @(Monk), @(Hermit), @(Bard), @(Innkeeper), @(Priest), @(Sinner), @(Seducer), @(Madman), @(Jester), @(Juliet), @(GuardianAngel), @(Vampire), @(Igor), @(VampireHunter)]];
    
    // When
    [self.gameState addPlayer:newPlayer];
    
    // Then
    XCTAssertEqualObjects(allRolesMinusFarmer, self.gameState.unassignedRoles);
}

-(void)testThatAddingMinionPlayerIsInvalid
{
    // Given
    Player *newPlayer = [[Player alloc] initWithName:@"Bob" role:Minion];
    
    // Then
    XCTAssertThrowsSpecificNamed([self.gameState addPlayer:newPlayer], NSException, @"NoSuchRoleAvailable");
    XCTAssertEqualObjects(@[], self.gameState.playersAlive);
}

@end
