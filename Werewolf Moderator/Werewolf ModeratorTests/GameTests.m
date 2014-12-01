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
#import "Role.h"
#import "MorningNews.h"

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

#pragma mark - Vampire Attacks

-(void)testThatVampireTurnsTargetIntoMinion
{
    // Given:
    Player *farmer = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    
    // When:
    BOOL attackSucceeded = [self.testGame vampireAttackPlayer:farmer];
    
    // Then:
    XCTAssertEqual(Minion, farmer.role.roleType);
    XCTAssertTrue(attackSucceeded);
}

-(void)testThatVampireCannotAttackHermit
{
    // Given:
    Player *player = [[Player alloc] initWithName:@"Farmer Joe" role:Hermit];
    
    // When:
    BOOL attackSucceeded = [self.testGame vampireAttackPlayer:player];
    
    // Then:
    XCTAssertEqual(Hermit, player.role.roleType);
    XCTAssertFalse(attackSucceeded);
}

-(void)testThatVampireCannotAttackProtectedPlayer
{
    // Given:
    Player *player = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    player.temporaryProtection = YES;
    
    // When:
    BOOL attackSucceeded = [self.testGame vampireAttackPlayer:player];
    
    // Then:
    XCTAssertEqual(Farmer, player.role.roleType);
    XCTAssertFalse(attackSucceeded);
}

-(void)testThatVampireCannotAttackRomeo
{
    // Given:
    Player *player = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    [self.testGame julietPicksRomeo:player];
    
    // When:
    BOOL attackSucceeded = [self.testGame vampireAttackPlayer:player];
    
    // Then:
    XCTAssertEqual(Farmer, player.role.roleType);
    XCTAssertFalse(attackSucceeded);
}

-(void)testThatVampireCannotAttackMystics
{
    // Given:
    Player *player = [[Player alloc] initWithName:@"Farmer Joe" role:Wizard];
    
    // When:
    BOOL attackSucceeded = [self.testGame vampireAttackPlayer:player];
    
    // Then:
    XCTAssertEqual(Wizard, player.role.roleType);
    XCTAssertFalse(attackSucceeded);
}

-(void)testThatVampireDiesWhenAttackingVampireHunter
{
    // Given:
    Player *hunter = [[Player alloc] initWithName:@"Van Hellsing" role:VampireHunter];
    Player *vampire = [[Player alloc] initWithName:@"Dracula" role:Vampire];
    
    // Expect:
    NSArray *destinedToDie = @[vampire];
    [[[self.mockGameState stub] andReturn:vampire] playerWithRole:Vampire inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:destinedToDie];
    
    // When:
    BOOL attackSucceeded = [self.testGame vampireAttackPlayer:hunter];
    
    // Then:
    XCTAssertFalse(attackSucceeded);
}

-(void)testThatVampireDiesWhenAttackingWolves
{
    // Given:
    Player *wolf = [[Player alloc] initWithName:@"Rex" role:Defector];
    Player *vampire = [[Player alloc] initWithName:@"Dracula" role:Vampire];
    
    // Expect:
    NSArray *destinedToDie = @[vampire];
    [[[self.mockGameState stub] andReturn:vampire] playerWithRole:Vampire inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:destinedToDie];
    
    // When:
    BOOL attackSucceeded = [self.testGame vampireAttackPlayer:wolf];
    
    // Then:
    XCTAssertFalse(attackSucceeded);
}

-(void)testThatIgorDiesInVampiresPlaceDuringVampireAttackPhase
{
    // Given:
    Player *wolf = [[Player alloc] initWithName:@"Rex" role:Defector];
    Player *igor = [[Player alloc] initWithName:@"Igor" role:Igor];
    
    // Expect:
    NSArray *destinedToDie = @[igor];
    [[[self.mockGameState stub] andReturn:igor] playerWithRole:Igor inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:destinedToDie];
    
    // When:
    BOOL attackSucceeded = [self.testGame vampireAttackPlayer:wolf];
    
    //Then:
    XCTAssertFalse(attackSucceeded);
}

#pragma mark - Wolf attacks

-(void)testThatWolfAttackTargetIsDestinedToDie
{
    // Given
    Player *dyingPlayer = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    Player *wolfTarget = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    
    // Expect
    [[[self.mockGameState stub] andReturn:@[dyingPlayer]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[dyingPlayer, wolfTarget]];
    
    // When
    BOOL attackSucceeded = [self.testGame wolfAttackPlayer:wolfTarget];
    
    // Then
    XCTAssertTrue(attackSucceeded);
}

-(void)testThatWolfAttackFailsOnProtectedTarget
{
    // Given
    Player *wolfTarget = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    wolfTarget.temporaryProtection = YES;
    
    // When
    BOOL attackSucceeded = [self.testGame wolfAttackPlayer:wolfTarget];
    
    // Then
    XCTAssertFalse(attackSucceeded);
}

-(void)testThatWolfAttackFailsOnImmuneTarget
{
    // Given
    Player *wolfTarget = [[Player alloc] initWithName:@"Farmer Joe" role:Hermit];
    
    // When
    BOOL attackSucceeded = [self.testGame wolfAttackPlayer:wolfTarget];
    
    // Then
    XCTAssertFalse(attackSucceeded);
}

-(void)testThatWolfAttackOnJulietKillsRomeoToo
{
    // Given
    Player *romeo = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    Player *juliet = [[Player alloc] initWithName:@"Farmer Joe" role:Juliet];
    
    // Expect
    [[[self.mockGameState stub] andReturn:romeo] romeoPlayer];
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[romeo, juliet]];
    
    // When
    BOOL attackSucceeded = [self.testGame wolfAttackPlayer:juliet];
    
    // Then
    XCTAssertTrue(attackSucceeded);
}

-(void)testThatWolfAttackOnGuardedKillsAngelInstead
{
    // Given
    Player *guarded = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    Player *angel = [[Player alloc] initWithName:@"Farmer Joe" role:GuardianAngel];
    
    // Expect
    [[[self.mockGameState stub] andReturn:guarded] guardedPlayer];
    [[[self.mockGameState stub] andReturn:angel] playerWithRole:GuardianAngel inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[angel]];
    
    // When
    BOOL attackSucceeded = [self.testGame wolfAttackPlayer:guarded];
    
    // Then
    XCTAssertTrue(attackSucceeded);
}


-(void)testThatWolfAttackOnVampireKillsIgorInstead
{
    // Given
    Player *igor = [[Player alloc] initWithName:@"Farmer Joe" role:Igor];
    Player *vampire = [[Player alloc] initWithName:@"Farmer Joe" role:Vampire];
    
    // Expect
    [[[self.mockGameState stub] andReturn:igor] playerWithRole:Igor inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[igor]];
    
    // When
    BOOL attackSucceeded = [self.testGame wolfAttackPlayer:vampire];
    
    // Then
    XCTAssertTrue(attackSucceeded);
}

-(void)testThatWolfAttackOnVampireWithoutIgorKillsVampire
{
    // Given
    Player *vampire = [[Player alloc] initWithName:@"Farmer Joe" role:Vampire];
    
    // Expect
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[vampire]];
    
    // When
    BOOL attackSucceeded = [self.testGame wolfAttackPlayer:vampire];
    
    // Then
    XCTAssertTrue(attackSucceeded);
}

-(void)testThatWolfAttackCancelledIfMadmanMaulledLastNight
{
    // Given
    Player *wolfTarget = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    
    // Expect
    BOOL madmanDied = YES;
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(madmanDied)] madmanMauledLastNight];
    [[self.mockGameState reject] setDestinedToDie:OCMOCK_ANY];
    
    // When
    BOOL attackSucceeded = [self.testGame wolfAttackPlayer:wolfTarget];
    
    // Then
    XCTAssertFalse(attackSucceeded);
}

#pragma mark - First night actions

-(void)testThatRomeoIsProtectedFromShadows
{
    //Given:
    Player *player = [[Player alloc] initWithName:@"Romeo" role:Farmer];
    
    //Expect:
    [[self.mockGameState expect] setRomeoPlayer:player];
    
    //When:
    [self.testGame julietPicksRomeo:player];
    
    //Then:
    XCTAssertTrue(player.permanentProtection);
}

-(void)testThatGuardedIsChosenByAngel
{
    //Given:
    Player *player = [[Player alloc] initWithName:@"Guarded" role:Farmer];
    
    //Expect:
    [[self.mockGameState expect] setGuardedPlayer:player];
    
    //When:
    [self.testGame angelPicksGuarded:player];
}

#pragma mark - It is morning

-(void)testThatNobodyIsDestinedToDieAfterMorningArrives
{
    //Given:
    Player *deadPlayer = [[Player alloc] initWithName:@"Corpse" role:Farmer];
    Player *dyingPlayer = [[Player alloc] initWithName:@"Dying" role:Farmer];
    Player *livingPlayer = [[Player alloc] initWithName:@"Living" role:Farmer];
    NSArray *destinedToDie = @[dyingPlayer];
    NSArray *deadPlayers = @[deadPlayer];
    NSArray *alivePlayers = @[dyingPlayer, livingPlayer];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:alivePlayers] playersAlive];
    [[[self.mockGameState stub] andReturn:deadPlayers] playersDead];
    [[[self.mockGameState stub] andReturn:destinedToDie] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[]];
    
    //When:
    [self.testGame transitionToMorning];
}

-(void)testThatMorningNewsListsDestinedToDieAsDead
{
    //Given:
    Player *deadPlayer = [[Player alloc] initWithName:@"Corpse" role:Farmer];
    Player *dyingPlayer = [[Player alloc] initWithName:@"Dying" role:Farmer];
    Player *livingPlayer = [[Player alloc] initWithName:@"Living" role:Farmer];
    NSArray *destinedToDie = @[dyingPlayer];
    NSArray *deadPlayers = @[deadPlayer];
    NSArray *alivePlayers = @[dyingPlayer, livingPlayer];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:alivePlayers] playersAlive];
    [[[self.mockGameState stub] andReturn:deadPlayers] playersDead];
    [[[self.mockGameState stub] andReturn:destinedToDie] destinedToDie];
    
    //When:
    MorningNews *news = [self.testGame transitionToMorning];
    
    //Then:
    XCTAssertEqualObjects(@[dyingPlayer], news.diedLastNight);
}

-(void)testThatDestinedToDiePlayersAreDeadByMorning
{
    //Given:
    Player *deadPlayer = [[Player alloc] initWithName:@"Corpse" role:Farmer];
    Player *dyingPlayer = [[Player alloc] initWithName:@"Dying" role:Farmer];
    Player *livingPlayer = [[Player alloc] initWithName:@"Living" role:Farmer];
    NSArray *destinedToDie = @[dyingPlayer];
    NSArray *deadPlayers = @[deadPlayer];
    NSArray *alivePlayers = @[dyingPlayer, livingPlayer];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:alivePlayers] playersAlive];
    [[[self.mockGameState stub] andReturn:deadPlayers] playersDead];
    [[[self.mockGameState stub] andReturn:destinedToDie] destinedToDie];
    
    //When:
    [self.testGame transitionToMorning];
    
    //Then:
    XCTAssertFalse(dyingPlayer.alive);
}

-(void)testThatMorningNewsHasNewsFromTheInn
{
    //Given:
    NewsFromTheInn news = FoundCorrupt;
    
    //Expect:
    BOOL innkeeperIsAlive = YES;
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(news)] newsFromTheInn];
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(innkeeperIsAlive)] roleIsAlive:Innkeeper];

    //When:
    MorningNews *morningNews = [self.testGame transitionToMorning];
    
    //Then:
    XCTAssertEqual(FoundCorrupt, morningNews.news);
}

-(void)testThatTransitionToMorningResetsNewsFromTheInn
{
    //Given:
    NewsFromTheInn news = FoundCorrupt;
    
    //Expect:
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(news)] newsFromTheInn];
    [[self.mockGameState expect] setNewsFromTheInn:NoNews];
    
    //When:
    [self.testGame transitionToMorning];
}

-(void)testThatNoNewsFromTheInnIfCorruptFoundButInnkeeperIsDead
{
    //Given:
    NewsFromTheInn news = FoundCorrupt;
    
    //Expect:
    BOOL innkeeperAlive = NO;
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(news)] newsFromTheInn];
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(innkeeperAlive)] roleIsAlive:Innkeeper];
    
    //When:
    MorningNews *morningNews = [self.testGame transitionToMorning];
    
    //Then:
    XCTAssertEqual(NoNews, morningNews.news);
}

-(void)testThatNoNewsFromTheInnIfNonCorruptFoundButBardIsDead
{
    //Given:
    NewsFromTheInn news = FoundNonCorrupt;
    
    //Expect:
    BOOL bardIsAlive = NO;
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(news)] newsFromTheInn];
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(bardIsAlive)] roleIsAlive:Bard];
    
    //When:
    MorningNews *morningNews = [self.testGame transitionToMorning];
    
    //Then:
    XCTAssertEqual(NoNews, morningNews.news);
}

-(void)testThatMadmanMaulledFlagIsReset
{
    //Expect
    [[self.mockGameState expect] setMadmanMauledLastNight:NO];
    
    //When
    [self.testGame transitionToMorning];
}

-(void)testThatMadmanMaulledFlagIsSetWhenMadmanDiesFromWolves
{
    //Given
    Player *madman = [[Player alloc] initWithName:@"Madman" role:Madman];
    
    //Expect
    [[[self.mockGameState stub] andReturn:madman] playerWithRole:Madman inPlayerSet:OCMOCK_ANY];
    [[self.mockGameState expect] setMadmanMauledLastNight:YES];
    
    //When
    [self.testGame transitionToMorning];
}

-(void)testThatDoubleWolfAttackFlagIsReset
{
    //Expect:
    [[self.mockGameState expect] setWolvesAttackTwice:NO];
    
    //When
    [self.testGame transitionToMorning];
}

@end
