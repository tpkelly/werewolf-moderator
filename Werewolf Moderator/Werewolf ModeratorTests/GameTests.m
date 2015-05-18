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
#import "AttackUtility.h"

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

#pragma mark - Cursed mystics

-(void)testThatClairvoyantIsCursedByCheckingTheHag
{
    // Given
    Player *clairvoyant = [[Player alloc] initWithName:@"Clairvoyant" role:Clairvoyant];
    Player *hag = [[Player alloc] initWithName:@"Hag" role:Hag];
    
    // Expect
    [[[self.mockGameState stub] andReturn:clairvoyant] playerWithRole:Clairvoyant inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:hag] playerWithRole:Hag inPlayerSet:OCMOCK_ANY];
    
    
    // When
    BOOL corruption = [self.testGame clairvoyantChecksPlayer:hag];
    
    // Then
    XCTAssertTrue(clairvoyant.isCursed);
    XCTAssertTrue(corruption);
}

-(void)testThatWizardIsCursedByCheckingTheHag
{
    // Given
    Player *wizard = [[Player alloc] initWithName:@"Wizard" role:Wizard];
    Player *hag = [[Player alloc] initWithName:@"Hag" role:Hag];
    
    // Expect
    [[[self.mockGameState stub] andReturn:wizard] playerWithRole:Wizard inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:hag] playerWithRole:Hag inPlayerSet:OCMOCK_ANY];
    
    
    // When
    BOOL mysticism = [self.testGame wizardChecksPlayer:hag];
    
    // Then
    XCTAssertTrue(wizard.isCursed);
    XCTAssertTrue(mysticism);
}

-(void)testThatWitchIsCursedByProtectingTheHag
{
    // Given
    Player *witch = [[Player alloc] initWithName:@"Witch" role:Witch];
    Player *hag = [[Player alloc] initWithName:@"Hag" role:Hag];
    
    // Expect
    [[[self.mockGameState stub] andReturn:witch] playerWithRole:Witch inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:hag] playerWithRole:Hag inPlayerSet:OCMOCK_ANY];
    
    
    // When
    [self.testGame witchProtectPlayer:hag];
    
    // Then
    XCTAssertTrue(witch.isCursed);
    XCTAssertTrue(hag.temporaryProtection);
}

-(void)testThatHealerIsCursedBySavingTheHag
{
    // Given
    Player *healer = [[Player alloc] initWithName:@"Healer" role:Healer];
    Player *hag = [[Player alloc] initWithName:@"Hag" role:Hag];
    
    // Expect
    BOOL healerCanHeal = YES;
    NSArray *alivePlayers = @[healer, hag];
    [[[self.mockGameState stub] andReturn:alivePlayers] playersAlive];
    [[[self.mockGameState stub] andReturnValue:OCMOCK_VALUE(healerCanHeal)] healerHasPowers];
    [[[self.mockGameState stub] andReturn:healer] playerWithRole:Healer inPlayerSet:[self.mockGameState playersAlive]];
    [[[self.mockGameState stub] andReturn:hag] playerWithRole:Hag inPlayerSet:OCMOCK_ANY];
    
    
    // When
    [self.testGame healerSavesPlayer:hag];
    
    // Then
    XCTAssertTrue(healer.isCursed);
}

-(void)testThatMediumIsNotCursedByCheckingTheHag
{
    // Given
    Player *medium = [[Player alloc] initWithName:@"Medium" role:Medium];
    Player *hag = [[Player alloc] initWithName:@"Hag" role:Hag];
    
    // Expect
    [[[self.mockGameState stub] andReturn:medium] playerWithRole:Medium inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:hag] playerWithRole:Hag inPlayerSet:OCMOCK_ANY];
    
    
    // When
    BOOL corruption = [self.testGame mediumChecksPlayer:hag];
    
    // Then
    XCTAssertFalse(medium.isCursed);
    XCTAssertTrue(corruption);
}

-(void)testThatCursedClairvoyantDoesNotSeeCorruption
{
    // Given
    Player *clairvoyant = [[Player alloc] initWithName:@"Clairvoyant" role:Clairvoyant];
    Player *corruptPlayer = [[Player alloc] initWithName:@"Corrupt" role:AlphaWolf];
    Player *noncorruptPlayer = [[Player alloc] initWithName:@"Noncorrupt" role:Hermit];
    clairvoyant.isCursed = YES;
 
    // Expect
    [[[self.mockGameState stub] andReturn:clairvoyant] playerWithRole:Clairvoyant inPlayerSet:OCMOCK_ANY];
    
    // When
    BOOL checkCorrupt = [self.testGame clairvoyantChecksPlayer:corruptPlayer];
    BOOL checkNoncorrupt = [self.testGame clairvoyantChecksPlayer:noncorruptPlayer];
    
    // Then
    XCTAssertFalse(checkCorrupt);
    XCTAssertFalse(checkNoncorrupt);
}

-(void)testThatCursedWizardDoesNotSeeMystics
{
    // Given
    Player *wizard = [[Player alloc] initWithName:@"Wizard" role:Wizard];
    Player *mystic = [[Player alloc] initWithName:@"Mystic" role:Medium];
    Player *nonmystic = [[Player alloc] initWithName:@"Nonmystic" role:Hermit];
    wizard.isCursed = YES;
    
    // Expect
    [[[self.mockGameState stub] andReturn:wizard] playerWithRole:Wizard inPlayerSet:OCMOCK_ANY];
    
    // When
    BOOL checkMystic = [self.testGame wizardChecksPlayer:mystic];
    BOOL checkNonmystic = [self.testGame wizardChecksPlayer:nonmystic];
    
    // Then
    XCTAssertFalse(checkMystic);
    XCTAssertFalse(checkNonmystic);
}

-(void)testThatCursedWitchCannotOfferProtection
{
    //Given
    Player *witch = [[Player alloc] initWithName:@"Witch" role:Witch];
    Player *farmer = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    witch.isCursed = YES;
    
    //Expect
    [[[self.mockGameState stub] andReturn:witch] playerWithRole:Witch inPlayerSet:OCMOCK_ANY];
    
    //When
    [self.testGame witchProtectPlayer:farmer];
    
    //Then
    XCTAssertFalse(farmer.temporaryProtection);
}

-(void)testThatUncursedClairvoyantSeesCursedAsCorrupt
{
    // Given
    Player *cursed = [[Player alloc] initWithName:@"Cursed" role:Farmer];
    cursed.isCursed = YES;
    
    // When
    BOOL isCorrupt = [self.testGame clairvoyantChecksPlayer:cursed];

    // Then
    XCTAssertTrue(isCorrupt);
}

-(void)testThatWitchCanDetectCurses
{
    // Given
    Player *cursed = [[Player alloc] initWithName:@"Cursed" role:Farmer];
    Player *uncursed = [[Player alloc] initWithName:@"Uncursed" role:Farmer];
    cursed.isCursed = YES;
    
    // When
    BOOL checkCursed = [self.testGame witchProtectPlayer:cursed];
    BOOL checkUncursed = [self.testGame witchProtectPlayer:uncursed];
    
    // Then
    XCTAssertTrue(checkCursed);
    XCTAssertFalse(checkUncursed);
}

-(void)testThatCursedWitchCannotDetectCurses
{
    // Given
    Player *witch = [[Player alloc] initWithName:@"Witch" role:Witch];
    Player *cursed = [[Player alloc] initWithName:@"Cursed" role:Farmer];
    Player *uncursed = [[Player alloc] initWithName:@"Uncursed" role:Farmer];
    cursed.isCursed = YES;
    witch.isCursed = YES;
    
    // Expect
    [[[self.mockGameState stub] andReturn:witch] playerWithRole:Witch inPlayerSet:OCMOCK_ANY];
    
    // When
    BOOL checkCursed = [self.testGame witchProtectPlayer:cursed];
    BOOL checkUncursed = [self.testGame witchProtectPlayer:uncursed];
    
    // Then
    XCTAssertFalse(checkCursed);
    XCTAssertFalse(checkUncursed);
}

-(void)testThatCursedPlayerLosesCurseOnDeath
{
    // Given
    Player *cursed = [[Player alloc] initWithName:@"Cursed" role:Farmer];
    cursed.isCursed = YES;
    
    // When
    [AttackUtility killPlayer:cursed reason:BurnedAtStake state:self.mockGameState];
    
    // Then
    XCTAssertFalse(cursed.isCursed);
}

-(void)testThatCursedPlayerDoesNotLoseCurseAtMorningIfAlive
{
    // Given
    Player *cursed = [[Player alloc] initWithName:@"Cursed" role:Farmer];
    cursed.isCursed = YES;
    
    // Expect
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    
    // When
    [self.testGame transitionToMorning];
    
    // Then
    XCTAssertTrue(cursed.isCursed);
}

-(void)testThatCursedPlayerLosesCurseOnDeathByMorning
{
    // Given
    Player *cursed = [[Player alloc] initWithName:@"Cursed" role:Farmer];
    cursed.isCursed = YES;
    
    // Expect
    [[[self.mockGameState stub] andReturn:@[cursed]] destinedToDie];
    
    // When
    [self.testGame transitionToMorning];
    
    // Then
    XCTAssertFalse(cursed.isCursed);
}

-(void)testThatCursesAreLiftedWhenTheHagDies
{
    // Given
    Player *cursed = [[Player alloc] initWithName:@"Cursed" role:Farmer];
    Player *hag = [[Player alloc] initWithName:@"Hag" role:Hag];
    cursed.isCursed = YES;
    
    // Expect
    [[[self.mockGameState stub] andReturn:hag] playerWithRole:Hag inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:@[hag, cursed]] playersAlive];
    
    // When
    [AttackUtility killPlayer:hag reason:BurnedAtStake state:self.mockGameState];
    
    // Then
    XCTAssertFalse(cursed.isCursed);
}

-(void)testThatCursedPlayerDoesNotLoseCurseAtMorningIfHagAlive
{
    // Given
    Player *cursed = [[Player alloc] initWithName:@"Cursed" role:Farmer];
    Player *hag = [[Player alloc] initWithName:@"Hag" role:Hag];
    cursed.isCursed = YES;
    
    // Expect
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[[self.mockGameState stub] andReturn:@[cursed, hag]] playersAlive];
    
    // When
    [self.testGame transitionToMorning];
    
    // Then
    XCTAssertTrue(cursed.isCursed);
}

-(void)testThatCursedPlayerLosesCurseOnHagDeathByMorning
{
    // Given
    Player *cursed = [[Player alloc] initWithName:@"Cursed" role:Farmer];
    Player *hag = [[Player alloc] initWithName:@"Hag" role:Hag];
    cursed.isCursed = YES;
    
    // Expect
    [[[self.mockGameState stub] andReturn:@[hag]] destinedToDie];
    [[[self.mockGameState stub] andReturn:@[cursed, hag]] playersAlive];
    
    // When
    [self.testGame transitionToMorning];
    
    // Then
    XCTAssertFalse(cursed.isCursed);
}

#pragma mark - Vampire Attacks

-(void)testThatVampireTurnsTargetIntoMinion
{
    // Given:
    Player *farmer = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    
    // When:
    AttackResult result = [self.testGame vampireAttackPlayer:farmer];
    
    // Then:
    XCTAssertEqual(Minion, farmer.role.roleType);
    XCTAssertEqual(Success, result);
}

-(void)testThatNewlyCreatedMinionHasOldNameIncluded
{
    // Given:
    Player *farmer = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    
    // When:
    [self.testGame vampireAttackPlayer:farmer];
    
    // Then:
    XCTAssertEqualObjects(@"Minion, ex-Farmer", farmer.role.name);
}

-(void)testThatVampireCannotAttackHermit
{
    // Given:
    Player *player = [[Player alloc] initWithName:@"Farmer Joe" role:Hermit];
    
    // When:
    AttackResult result = [self.testGame vampireAttackPlayer:player];
    
    // Then:
    XCTAssertEqual(Hermit, player.role.roleType);
    XCTAssertEqual(TargetImmune, result);
}

-(void)testThatVampireCannotAttackProtectedPlayer
{
    // Given:
    Player *player = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    player.temporaryProtection = YES;
    
    // When:
    AttackResult result = [self.testGame vampireAttackPlayer:player];
    
    // Then:
    XCTAssertEqual(Farmer, player.role.roleType);
    XCTAssertEqual(TargetImmune, result);
}

-(void)testThatVampireCannotAttackRomeo
{
    // Given:
    Player *player = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    [self.testGame julietPicksRomeo:player];
    
    // When:
    AttackResult result = [self.testGame vampireAttackPlayer:player];
    
    // Then:
    XCTAssertEqual(Farmer, player.role.roleType);
    XCTAssertEqual(TargetImmune, result);
}

-(void)testThatVampireCannotAttackMystics
{
    // Given:
    Player *player = [[Player alloc] initWithName:@"Farmer Joe" role:Wizard];
    
    // When:
    AttackResult result = [self.testGame vampireAttackPlayer:player];
    
    // Then:
    XCTAssertEqual(Wizard, player.role.roleType);
    XCTAssertEqual(TargetImmune, result);
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
    AttackResult result = [self.testGame vampireAttackPlayer:hunter];
    
    // Then:
    XCTAssertEqual(TargetInformed, result);
}

-(void)testThatVampireDiesWhenAttackingWolves
{
    // Given:
    Player *wolf = [[Player alloc] initWithName:@"Rex" role:AlphaWolf];
    Player *vampire = [[Player alloc] initWithName:@"Dracula" role:Vampire];
    
    // Expect:
    NSArray *destinedToDie = @[vampire];
    [[[self.mockGameState stub] andReturn:vampire] playerWithRole:Vampire inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:destinedToDie];
    
    // When:
    AttackResult result = [self.testGame vampireAttackPlayer:wolf];
    
    // Then:
    XCTAssertEqual(TargetImmune, result);
}

-(void)testThatVampireLivesWhenAttackingDefector
{
    // Given:
    Player *defector = [[Player alloc] initWithName:@"Rex" role:Defector];
    Player *vampire = [[Player alloc] initWithName:@"Dracula" role:Vampire];
    
    // Expect:
    [[[self.mockGameState stub] andReturn:vampire] playerWithRole:Vampire inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState reject] setDestinedToDie:OCMOCK_ANY];
    
    // When:
    AttackResult result = [self.testGame vampireAttackPlayer:defector];
    
    // Then:
    XCTAssertEqual(Success, result);
}

-(void)testThatDefectorBecomesMinionInVampireAttack
{
    // Given:
    Player *defector = [[Player alloc] initWithName:@"Defector" role:Defector];
    
    // When
    [self.testGame vampireAttackPlayer:defector];
    
    // Then
    XCTAssertEqual(Minion, defector.role.roleType);
}

-(void)testThatIgorDiesInVampiresPlaceDuringVampireAttackPhase
{
    // Given:
    Player *wolf = [[Player alloc] initWithName:@"Rex" role:AlphaWolf];
    Player *igor = [[Player alloc] initWithName:@"Igor" role:Igor];
    
    // Expect:
    NSArray *destinedToDie = @[igor];
    [[[self.mockGameState stub] andReturn:igor] playerWithRole:Igor inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:destinedToDie];
    
    // When:
    AttackResult result = [self.testGame vampireAttackPlayer:wolf];
    
    //Then:
    XCTAssertEqual(TargetImmune, result);
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
    AttackResult result = [self.testGame wolfAttackPlayer:wolfTarget];
    
    // Then
    XCTAssertEqual(Success, result);
}

-(void)testThatWolfAttackFailsOnProtectedTarget
{
    // Given
    Player *wolfTarget = [[Player alloc] initWithName:@"Farmer Joe" role:Farmer];
    wolfTarget.temporaryProtection = YES;
    
    // When
    AttackResult result = [self.testGame wolfAttackPlayer:wolfTarget];
    
    // Then
    XCTAssertEqual(TargetImmune, result);
}

-(void)testThatWolfAttackFailsOnImmuneTarget
{
    // Given
    Player *wolfTarget = [[Player alloc] initWithName:@"Farmer Joe" role:Hermit];
    
    // When
    AttackResult result = [self.testGame wolfAttackPlayer:wolfTarget];
    
    // Then
    XCTAssertEqual(TargetImmune, result);
}

-(void)testThatWolfAttackOnJulietKillsRomeoToo
{
    // Given
    Player *romeo = [[Player alloc] initWithName:@"Romeo" role:Farmer];
    Player *juliet = [[Player alloc] initWithName:@"Juliet" role:Juliet];
    
    // Expect
    [[[self.mockGameState stub] andReturn:romeo] romeoPlayer];
    [[[self.mockGameState expect] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[romeo]];
    [[[self.mockGameState expect] andReturn:@[romeo]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[romeo, juliet]];
    
    // When
    AttackResult result = [self.testGame wolfAttackPlayer:juliet];
    
    // Then
    XCTAssertEqual(Success, result);
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
    AttackResult result = [self.testGame wolfAttackPlayer:guarded];
    
    // Then
    XCTAssertEqual(Success, result);
}

-(void)testThatWolfAttackOnGuardedRomeoOnlyKillsAngelAndJuliet
{
    //Given:
    Player *guardedRomeo = [[Player alloc] initWithName:@"Romeo" role:Farmer];
    Player *angel = [[Player alloc] initWithName:@"Angel" role:GuardianAngel];
    Player *juliet = [[Player alloc] initWithName:@"Juliet" role:Juliet];
    
    //Expect
    [[[self.mockGameState stub] andReturn:guardedRomeo] guardedPlayer];
    [[[self.mockGameState stub] andReturn:guardedRomeo] romeoPlayer];
    [[[self.mockGameState stub] andReturn:angel] playerWithRole:GuardianAngel inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:juliet] playerWithRole:Juliet inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState expect] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[angel]];
    [[[self.mockGameState expect] andReturn:@[angel]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[angel, juliet]];
    
    // When
    AttackResult result = [self.testGame wolfAttackPlayer:juliet];
    
    // Then
    XCTAssertEqual(Success, result);
}

-(void)testThatWolfAttackOnVampireDoesNotKillIgor
{
    // Given
    Player *igor = [[Player alloc] initWithName:@"Farmer Joe" role:Igor];
    Player *vampire = [[Player alloc] initWithName:@"Farmer Joe" role:Vampire];
    
    // Expect
    [[[self.mockGameState stub] andReturn:igor] playerWithRole:Igor inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[vampire]];
    
    // When
    AttackResult result = [self.testGame wolfAttackPlayer:vampire];
    
    // Then
    XCTAssertEqual(Success, result);
}

-(void)testThatWolfAttackOnVampireWithoutIgorKillsVampire
{
    // Given
    Player *vampire = [[Player alloc] initWithName:@"Farmer Joe" role:Vampire];
    
    // Expect
    [[[self.mockGameState stub] andReturn:@[]] destinedToDie];
    [[self.mockGameState expect] setDestinedToDie:@[vampire]];
    
    // When
    AttackResult result = [self.testGame wolfAttackPlayer:vampire];
    
    // Then
    XCTAssertEqual(Success, result);
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
    AttackResult result = [self.testGame wolfAttackPlayer:wolfTarget];
    
    // Then
    XCTAssertEqual(TargetImmune, result);
}

-(void)testThatWolfAttackOnDefectorInformsDefector
{
    // Given
    Player *defector = [[Player alloc] initWithName:@"Defector" role:Defector];
    
    // When
    AttackResult result = [self.testGame wolfAttackPlayer:defector];
    
    // Then
    XCTAssertEqual(TargetInformed, result);
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

-(void)testThatRomeoIsNamedAsSuch
{
    //Given:
    Player *player = [[Player alloc] initWithName:@"Player" role:Farmer];
    
    //When:
    [self.testGame julietPicksRomeo:player];
    
    //Then:
    XCTAssertEqualObjects(@"Farmer, Romeo", player.role.name);
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

-(void)testThatGuardedIsNamedAsSuch
{
    //Given:
    Player *player = [[Player alloc] initWithName:@"Player" role:Farmer];
    
    //When:
    [self.testGame angelPicksGuarded:player];
    
    //Then:
    XCTAssertEqualObjects(@"Farmer, Guarded", player.role.name);
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

-(void)testThatMadmanWinsIfMaulled
{
    //Given:
    Player *madman = [[Player alloc] initWithName:@"Madman" role:Madman];
    
    //Expect
    [[[self.mockGameState stub] andReturn:madman] playerWithRole:Madman inPlayerSet:OCMOCK_ANY];
    [[[self.mockGameState stub] andReturn:@[@(JesterFaction)]] winningFactions];
    [[self.mockGameState expect] setWinningFactions:@[@(JesterFaction), @(MadmanFaction)]];
    
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

#pragma mark - Game Over

-(void)testThatGameIsNotOverWhenMultipleFactionsInPlay
{
    //Given:
    Player *wolf = [[Player alloc] initWithName:@"Wolf" role:AlphaWolf];
    Player *vampire = [[Player alloc] initWithName:@"Vampire" role:Vampire];
    Player *villager = [[Player alloc] initWithName:@"Villager" role:Farmer];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[wolf, vampire, villager]] playersAlive];
    
    //Then:
    XCTAssertFalse([self.testGame gameIsOver]);
}

-(void)testThatWolvesDoNotWinWithLoversInPlay
{
    //Given:
    Player *wolf = [[Player alloc] initWithName:@"Wolf" role:AlphaWolf];
    Player *angel = [[Player alloc] initWithName:@"Angel" role:GuardianAngel];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[wolf, angel]] playersAlive];
    
    //Then:
    XCTAssertFalse([self.testGame gameIsOver]);
}

-(void)testThatWolvesWinIfOnlyWolvesInPlay
{
    //Given:
    Player *alpha = [[Player alloc] initWithName:@"Wolf" role:AlphaWolf];
    Player *pack = [[Player alloc] initWithName:@"Wolf" role:PackWolf];
    Player *pup = [[Player alloc] initWithName:@"Wolf" role:WolfPup];
    Player *defector = [[Player alloc] initWithName:@"Wolf" role:Defector];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[alpha, pack, pup, defector]] playersAlive];
    
    //Then:
    XCTAssertTrue([self.testGame gameIsOver]);
}

-(void)testThatVampiresWinIfOnlyVampiresInPlay
{
    //Given:
    Player *vampire = [[Player alloc] initWithName:@"Vamp" role:Vampire];
    Player *igor = [[Player alloc] initWithName:@"Igor" role:Igor];
    Player *minion = [[Player alloc] initWithName:@"Minion" role:Minion];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[vampire, igor, minion]] playersAlive];
    
    //Then:
    XCTAssertTrue([self.testGame gameIsOver]);
}

-(void)testThatMinionsCanWinOnTheirOwn
{
    //Given:
    Player *minion1 = [[Player alloc] initWithName:@"Minion" role:Minion];
    Player *minion2 = [[Player alloc] initWithName:@"Minion" role:Minion];
    Player *minion3 = [[Player alloc] initWithName:@"Minion" role:Minion];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[minion1, minion2, minion3]] playersAlive];
    
    //Then:
    XCTAssertTrue([self.testGame gameIsOver]);
}

-(void)testThatVillageWinsWithNonShadowElementsOfOtherFactions
{
    //Given:
    Player *villager = [[Player alloc] initWithName:@"Villager" role:Farmer];
    Player *defector = [[Player alloc] initWithName:@"Defector" role:Defector];
    Player *igor = [[Player alloc] initWithName:@"Igor" role:Igor];
    Player *madman = [[Player alloc] initWithName:@"Madman" role:Madman];
    Player *jester = [[Player alloc] initWithName:@"Jester" role:Jester];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[villager, defector, igor, madman, jester]] playersAlive];
    
    //Then:
    XCTAssertTrue([self.testGame gameIsOver]);
}

-(void)testThatNobodyHasWonIfGameIsNotOver
{
    //Given:
    Player *wolf = [[Player alloc] initWithName:@"Wolf" role:AlphaWolf];
    Player *angel = [[Player alloc] initWithName:@"Angel" role:GuardianAngel];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[wolf, angel]] playersAlive];
    [[[self.mockGameState stub] andReturn:@[@(JesterFaction)]] winningFactions];
    
    //Then:
    XCTAssertEqualObjects([NSSet set], [self.testGame factionsWhichWon]);
}

-(void)testThatWerewolvesWonIfOnlyWerewolvesSurvived
{
    //Given:
    Player *alpha = [[Player alloc] initWithName:@"Wolf" role:AlphaWolf];
    Player *pack = [[Player alloc] initWithName:@"Wolf" role:PackWolf];
    Player *pup = [[Player alloc] initWithName:@"Wolf" role:WolfPup];
    Player *defector = [[Player alloc] initWithName:@"Wolf" role:Defector];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[alpha, pack, pup, defector]] playersAlive];
    
    //Then:
    NSSet *expectedFactions = [NSSet setWithObject:@(WolvesFaction)];
    XCTAssertEqualObjects(expectedFactions, [self.testGame factionsWhichWon]);
}

-(void)testThatVampiresWonIfOnlyVampiresSurvived
{
    //Given:
    Player *vampire = [[Player alloc] initWithName:@"Vamp" role:Vampire];
    Player *igor = [[Player alloc] initWithName:@"Igor" role:Igor];
    Player *minion = [[Player alloc] initWithName:@"Minion" role:Minion];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[vampire, igor, minion]] playersAlive];
    
    //Then:
    NSSet *expectedFactions = [NSSet setWithObject:@(VampireFaction)];
    XCTAssertEqualObjects(expectedFactions, [self.testGame factionsWhichWon]);
}

-(void)testThatVillagersWinIfOnlyVillagersRemain
{
    //Given:
    Player *villager = [[Player alloc] initWithName:@"Villager" role:Farmer];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[villager]] playersAlive];
    
    //Then:
    NSSet *expectedFactions = [NSSet setWithObject:@(VillageFaction)];
    XCTAssertEqualObjects(expectedFactions, [self.testGame factionsWhichWon]);
}

-(void)testThatMadmanAndJesterDoNotWinIfAlive
{
    //Given:
    Player *madman = [[Player alloc] initWithName:@"Madman" role:Madman];
    Player *jester = [[Player alloc] initWithName:@"Jester" role:Jester];
    Player *farmer = [[Player alloc] initWithName:@"Farmer" role:Farmer];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[madman, jester, farmer]] playersAlive];
    
    //Then:
    NSSet *expectedFactions = [NSSet setWithArray:@[@(VillageFaction)]];
    XCTAssertEqualObjects(expectedFactions, [self.testGame factionsWhichWon]);
}

-(void)testThatGameIsOverWhenLoversAreLeft
{
    //Given:
    Player *romeo = [[Player alloc] initWithName:@"Romeo" role:AlphaWolf];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:romeo] romeoPlayer];
    [[[self.mockGameState stub] andReturnValue:@YES] roleIsAlive:Juliet];
    
    //Then:
    XCTAssertTrue([self.testGame gameIsOver]);
}

-(void)testThatLoversWinWhenBothAreAlive
{
    //Given:
    Player *villager = [[Player alloc] initWithName:@"Villager" role:Juliet];
    Player *romeo = [[Player alloc] initWithName:@"Romeo" role:AlphaWolf];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:romeo] romeoPlayer];
    [[[self.mockGameState stub] andReturnValue:@YES] roleIsAlive:Juliet];
    [[[self.mockGameState stub] andReturn:@[villager, romeo]] playersAlive];

    
    //Then:
    NSSet *expectedFactions = [NSSet setWithArray:@[@(WolvesFaction), @(LoverFaction)]];
    XCTAssertEqualObjects(expectedFactions, [self.testGame factionsWhichWon]);
}

-(void)testThatMadmanAndJesterWinIfPreviouslyWon
{
    //Given:
    Player *villager = [[Player alloc] initWithName:@"Villager" role:Juliet];
    
    //Expect:
    [[[self.mockGameState stub] andReturn:@[villager]] playersAlive];
    [[[self.mockGameState stub] andReturn:@[@(MadmanFaction), @(JesterFaction)]] winningFactions];
    
    //Then:
    NSSet *expectedFactions = [NSSet setWithArray:@[@(MadmanFaction), @(JesterFaction), @(VillageFaction)]];
    XCTAssertEqualObjects(expectedFactions, [self.testGame factionsWhichWon]);
}

-(void)testThatHagWinsWithWolves
{
    // Given
    Player *hag = [[Player alloc] initWithName:@"Hag" role:Hag];
    Player *wolf = [[Player alloc] initWithName:@"Wolf" role:AlphaWolf];
    
    // Expect
    [[[self.mockGameState stub] andReturn:@[hag, wolf]] playersAlive];
    
    // Then
    XCTAssertTrue([self.testGame gameIsOver]);
}

-(void)testThatHagWinsWithVampire
{
    // Given
    Player *hag = [[Player alloc] initWithName:@"Hag" role:Hag];
    Player *vampire = [[Player alloc] initWithName:@"Vampire" role:Vampire];
    
    // Expect
    [[[self.mockGameState stub] andReturn:@[hag, vampire]] playersAlive];
    
    // Then
    XCTAssertTrue([self.testGame gameIsOver]);
}

-(void)testThatGameEndsWhenHagIsOnlyRemainingShadow
{
    // Given
    Player *hag = [[Player alloc] initWithName:@"Hag" role:Hag];
    Player *farmer = [[Player alloc] initWithName:@"Farmer" role:Farmer];
    
    // Expect
    [[[self.mockGameState stub] andReturn:@[hag, farmer]] playersAlive];
    
    // Then
    XCTAssertTrue([self.testGame gameIsOver]);
}

-(void)testThatVillageDoesNotWinWithACursedPlayerRemaining
{
    // Given
    Player *cursed = [[Player alloc] initWithName:@"Cursed" role:Farmer];
    Player *farmer = [[Player alloc] initWithName:@"Farmer" role:Farmer];
    cursed.isCursed = YES;
    
    // Expect
    [[[self.mockGameState stub] andReturn:@[cursed, farmer]] playersAlive];
    
    // Then
    XCTAssertFalse([self.testGame gameIsOver]);
}

@end
