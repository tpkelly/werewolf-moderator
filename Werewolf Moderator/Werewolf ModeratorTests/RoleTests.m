//
//  RoleTests.m
//  Werewolf Moderator
//
//  Created by Thomas Kelly on 12/11/2014.
//  Copyright (c) 2014 TKGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Role.h"

@interface RoleTests : XCTestCase

@end

@implementation RoleTests

#pragma mark - Wolves

-(void)testThatAlphaWolfIsACorruptWolf
{
    //Given
    Role *alphaWolf = [[Role alloc] initWithRole:AlphaWolf];
    
    //Then
    XCTAssertTrue(alphaWolf.isCorrupt);
    XCTAssertFalse(alphaWolf.isMystic);
    XCTAssertTrue(alphaWolf.isShadow);
    XCTAssertEqual(WolvesFaction, alphaWolf.faction);
}

-(void)testThatPackWolfIsACorruptWolf
{
    //Given
    Role *packWolf = [[Role alloc] initWithRole:PackWolf];
    
    //Then
    XCTAssertTrue(packWolf.isCorrupt);
    XCTAssertFalse(packWolf.isMystic);
    XCTAssertTrue(packWolf.isShadow);
    XCTAssertEqual(WolvesFaction, packWolf.faction);
}

-(void)testThatWolfPupIsACorruptWolf
{
    //Given
    Role *wolfPup = [[Role alloc] initWithRole:WolfPup];
    
    //Then
    XCTAssertTrue(wolfPup.isCorrupt);
    XCTAssertFalse(wolfPup.isMystic);
    XCTAssertTrue(wolfPup.isShadow);
    XCTAssertEqual(WolvesFaction, wolfPup.faction);
}

-(void)testThatDefectorIsANonCorruptWolf
{
    //Given
    Role *defector = [[Role alloc] initWithRole:Defector];
    
    //Then
    XCTAssertFalse(defector.isCorrupt);
    XCTAssertFalse(defector.isMystic);
    XCTAssertFalse(defector.isShadow);
    XCTAssertEqual(WolvesFaction, defector.faction);
}

#pragma mark - Vampires

-(void)testThatVampiresAreCorrupt
{
    //Given
    Role *vampire = [[Role alloc] initWithRole:Vampire];
    
    //Then
    XCTAssertTrue(vampire.isCorrupt);
    XCTAssertFalse(vampire.isMystic);
    XCTAssertTrue(vampire.isShadow);
    XCTAssertEqual(VampireFaction, vampire.faction);
}

-(void)testThatMinionsAreCorruptVampires
{
    //Given
    Role *minion = [[Role alloc] initWithRole:Minion];
    
    //Then
    XCTAssertTrue(minion.isCorrupt);
    XCTAssertFalse(minion.isMystic);
    XCTAssertTrue(minion.isShadow);
    XCTAssertEqual(VampireFaction, minion.faction);
}

-(void)testThatIgorIsANonCorruptVampireHelper
{
    //Given
    Role *igor = [[Role alloc] initWithRole:Igor];
    
    //Then
    XCTAssertFalse(igor.isCorrupt);
    XCTAssertFalse(igor.isMystic);
    XCTAssertFalse(igor.isShadow);
    XCTAssertEqual(VampireFaction, igor.faction);
}

#pragma mark - Lovers

-(void)testThatJulietIsALover
{
    //Given
    Role *juliet = [[Role alloc] initWithRole:Juliet];
    
    //Then
    XCTAssertFalse(juliet.isCorrupt);
    XCTAssertFalse(juliet.isMystic);
    XCTAssertFalse(juliet.isShadow);
    XCTAssertEqual(LoverFaction, juliet.faction);
}

-(void)testThatGuardianAngelIsALover
{
    //Given
    Role *guardianAngel = [[Role alloc] initWithRole:GuardianAngel];
    
    //Then
    XCTAssertFalse(guardianAngel.isCorrupt);
    XCTAssertFalse(guardianAngel.isMystic);
    XCTAssertFalse(guardianAngel.isShadow);
    XCTAssertEqual(LoverFaction, guardianAngel.faction);
}

#pragma mark - Crazies

-(void)testThatMadmanIsOnTheirOwnTeam
{
    //Given
    Role *madman = [[Role alloc] initWithRole:Madman];
    
    //Then
    XCTAssertFalse(madman.isCorrupt);
    XCTAssertFalse(madman.isMystic);
    XCTAssertFalse(madman.isShadow);
    XCTAssertEqual(MadmanFaction, madman.faction);
}

-(void)testThatJesterIsOnTheirOwnTeam
{
    //Given
    Role *jester = [[Role alloc] initWithRole:Jester];
    
    //Then
    XCTAssertFalse(jester.isCorrupt);
    XCTAssertFalse(jester.isMystic);
    XCTAssertFalse(jester.isShadow);
    XCTAssertEqual(JesterFaction, jester.faction);
}


#pragma mark - Villagers

-(void)testThatClairvoyantIsAMysticalVillager
{
    //Given
    Role *clairvoyant = [[Role alloc] initWithRole:Clairvoyant];
    
    //Then
    XCTAssertFalse(clairvoyant.isCorrupt);
    XCTAssertTrue(clairvoyant.isMystic);
    XCTAssertFalse(clairvoyant.isShadow);
    XCTAssertEqual(VillageFaction, clairvoyant.faction);
}

-(void)testThatWizardIsAMysticalVillager
{
    //Given
    Role *wizard = [[Role alloc] initWithRole:Wizard];
    
    //Then
    XCTAssertFalse(wizard.isCorrupt);
    XCTAssertTrue(wizard.isMystic);
    XCTAssertFalse(wizard.isShadow);
    XCTAssertEqual(VillageFaction, wizard.faction);
}

-(void)testThatMediumIsAMysticalVillager
{
    //Given
    Role *medium = [[Role alloc] initWithRole:Medium];
    
    //Then
    XCTAssertFalse(medium.isCorrupt);
    XCTAssertTrue(medium.isMystic);
    XCTAssertFalse(medium.isShadow);
    XCTAssertEqual(VillageFaction, medium.faction);
}

-(void)testThatWitchIsAMysticalVillager
{
    //Given
    Role *witch = [[Role alloc] initWithRole:Witch];
    
    //Then
    XCTAssertFalse(witch.isCorrupt);
    XCTAssertTrue(witch.isMystic);
    XCTAssertFalse(witch.isShadow);
    XCTAssertEqual(VillageFaction, witch.faction);
}

-(void)testThatHealerIsAMysticalVillager
{
    //Given
    Role *healer = [[Role alloc] initWithRole:Healer];
    
    //Then
    XCTAssertFalse(healer.isCorrupt);
    XCTAssertTrue(healer.isMystic);
    XCTAssertFalse(healer.isShadow);
    XCTAssertEqual(VillageFaction, healer.faction);
}

-(void)testThatVampireHunterHasNoPowers
{
    //Given
    Role *hunter = [[Role alloc] initWithRole:VampireHunter];
    
    //Then
    XCTAssertFalse(hunter.isCorrupt);
    XCTAssertFalse(hunter.isMystic);
    XCTAssertFalse(hunter.isShadow);
    XCTAssertEqual(VillageFaction, hunter.faction);
}

-(void)testThatHermitHasNoPowers
{
    //Given
    Role *hermit = [[Role alloc] initWithRole:Hermit];
    
    //Then
    XCTAssertFalse(hermit.isCorrupt);
    XCTAssertFalse(hermit.isMystic);
    XCTAssertFalse(hermit.isShadow);
    XCTAssertEqual(VillageFaction, hermit.faction);
}

-(void)testThatBardHasNoPowers
{
    //Given
    Role *bard = [[Role alloc] initWithRole:Bard];
    
    //Then
    XCTAssertFalse(bard.isCorrupt);
    XCTAssertFalse(bard.isMystic);
    XCTAssertFalse(bard.isShadow);
    XCTAssertEqual(VillageFaction, bard.faction);
}

-(void)testThatInnkeeperHasNoPowers
{
    //Given
    Role *innkeeper = [[Role alloc] initWithRole:Innkeeper];
    
    //Then
    XCTAssertFalse(innkeeper.isCorrupt);
    XCTAssertFalse(innkeeper.isMystic);
    XCTAssertFalse(innkeeper.isShadow);
    XCTAssertEqual(VillageFaction, innkeeper.faction);
}

-(void)testThatMonkHasNoPowers
{
    //Given
    Role *monk = [[Role alloc] initWithRole:Monk];
    
    //Then
    XCTAssertFalse(monk.isCorrupt);
    XCTAssertFalse(monk.isMystic);
    XCTAssertFalse(monk.isShadow);
    XCTAssertEqual(VillageFaction, monk.faction);
}

-(void)testThatPriestHasNoPowers
{
    //Given
    Role *priest = [[Role alloc] initWithRole:Priest];
    
    //Then
    XCTAssertFalse(priest.isCorrupt);
    XCTAssertFalse(priest.isMystic);
    XCTAssertFalse(priest.isShadow);
    XCTAssertEqual(VillageFaction, priest.faction);
}

-(void)testThatSinnerIsCorruptVillager
{
    //Given
    Role *sinner = [[Role alloc] initWithRole:Sinner];
    
    //Then
    XCTAssertTrue(sinner.isCorrupt);
    XCTAssertFalse(sinner.isMystic);
    XCTAssertFalse(sinner.isShadow);
    XCTAssertEqual(VillageFaction, sinner.faction);
}

-(void)testThatSeducerIsCorruptVillager
{
    //Given
    Role *seducer = [[Role alloc] initWithRole:Seducer];
    
    //Then
    XCTAssertTrue(seducer.isCorrupt);
    XCTAssertFalse(seducer.isMystic);
    XCTAssertFalse(seducer.isShadow);
    XCTAssertEqual(VillageFaction, seducer.faction);
}

-(void)testThatFarmerHasNoPowers
{
    //Given
    Role *farmer = [[Role alloc] initWithRole:Farmer];
    
    //Then
    XCTAssertFalse(farmer.isCorrupt);
    XCTAssertFalse(farmer.isMystic);
    XCTAssertFalse(farmer.isShadow);
    XCTAssertEqual(VillageFaction, farmer.faction);
}

@end
