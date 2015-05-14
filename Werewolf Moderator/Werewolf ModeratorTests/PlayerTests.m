//
//  PlayerTests.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 13/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Player.h"
#import "Role.h"

@interface PlayerTests : XCTestCase

@end

@implementation PlayerTests

- (void)testThatPlayerRetainsName
{
    // Given
    Player *player = [[Player alloc] initWithName:@"Bob" role:Farmer];
    
    //Then:
    XCTAssertEqualObjects(@"Bob", player.name);
}

- (void)testThatPlayerRetainsRole
{
    // Given
    Player *player = [[Player alloc] initWithName:@"Bob" role:Farmer];
    
    //Then:
    XCTAssertEqualObjects(@"Farmer", player.role.name);
}

#pragma mark - Protection

-(void)testThatAlphaWolfPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:AlphaWolf];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatPackWolfPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:PackWolf];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatWolfPupfPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:WolfPup];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatDefectorPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Defector];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatClairvoyantPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Clairvoyant];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatMediumPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Medium];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatWizardPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Wizard];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatWitchPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Witch];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatHealerPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Healer];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatFarmerPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Farmer];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatHermitPlayerIsAliveAndProtected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Hermit];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertTrue(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatBardPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Bard];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatInnkeeperPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Innkeeper];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatMonkPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Monk];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatPriestPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Priest];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatSinnerPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Sinner];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatSeducerPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Seducer];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatMadmanPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Madman];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatJesterPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Jester];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatJulietPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Juliet];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatGuardianAngelPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:GuardianAngel];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatVampirePlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Vampire];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatMinionPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Minion];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatIgorPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:Igor];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}

-(void)testThatVampireHunterPlayerIsAliveAndUnprotected
{
    //Given
    Player *player = [[Player alloc] initWithName:@"Player" role:VampireHunter];
    
    //Then
    XCTAssertTrue(player.alive);
    XCTAssertFalse(player.cursed);
    XCTAssertFalse(player.permanentProtection);
    XCTAssertFalse(player.temporaryProtection);
}


@end
