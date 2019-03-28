.text
.thumb
.align 2

.include "..\\defines"

.global BattleScript_PrintCustomString
.global BattleScript_QuickClaw
.global BattleScript_MagicBounce
.global BattleScript_MoveUsedFlinched
.global BattleScript_MoveUsedGravityPrevents
.global BattleScript_MoveUsedHealBlockPrevents
.global BattleScript_MoveUsedThroatChopPrevents
.global BattleScript_MoveUsedFailedPrimalWeather
.global BattleScript_MoveUsedPsychicTerrainPrevents
.global BattleScript_MoveUsedPowderPrevents
.global BattleScript_StanceChangeToBlade
.global BattleScript_StanceChangeToShield
.global BattleScript_ZMoveActivateStatus
.global BattleScript_ZMoveActivateDamaging
.global BattleScript_DarkTypePreventsPrankster
.global BattleScript_MoveUsedSkyBattlePrevents

.global AbilityRaisedStatString

@;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_PrintCustomString:
	printstring 0x184
	waitmessage DELAY_1SECOND
	return

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MagicBounce:
	attackstring
	ppreduce
	pause DELAY_HALFSECOND
	setword BATTLE_STRING_LOADER MagicBounceString
	printstring 0x184
	waitmessage DELAY_1SECOND
	orword 0x2023DD0 0x800C00
	various BANK_ATTACKER 0x1
	return

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MoveUsedFlinched:
	printstring 0x4A
	waitmessage DELAY_1SECOND
	jumpifability BANK_ATTACKER ABILITY_STEADFAST SteadfastBoost
	goto BS_MOVE_END

SteadfastBoost:
	setbyte 0x2023FDF 0x0
	playstatchangeanimation BANK_ATTACKER STAT_ANIM_SPD STAT_ANIM_UP
	setbyte STAT_CHANGE_BYTE STAT_SPD | INCREASE_1
	statbuffchange STAT_ATTACKER | STAT_BS_PTR BS_MOVE_END
	jumpifbyte EQUALS MULTISTRING_CHOOSER 0x2 BS_MOVE_END
	copyarray 0x2023FDB USER_BANK 0x1 @;gBattlescripting->bank
	setword BATTLE_STRING_LOADER AbilityRaisedStatString
	printstring 0x184
	waitmessage DELAY_1SECOND
	goto BS_MOVE_END
	
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MoveUsedGravityPrevents:
	pause DELAY_HALFSECOND
	setword BATTLE_STRING_LOADER GravityAttackCancelString
	printstring 0x184
	waitmessage DELAY_1SECOND
	goto 0x81D694E

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MoveUsedHealBlockPrevents:
	pause DELAY_HALFSECOND
	setword BATTLE_STRING_LOADER HealBlockAttackCancelString
	printstring 0x184
	waitmessage DELAY_1SECOND
	goto BS_MOVE_END

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MoveUsedThroatChopPrevents:
	pause DELAY_HALFSECOND
	setword BATTLE_STRING_LOADER ThroatChopAttackCancelString
	printstring 0x184
	waitmessage DELAY_1SECOND
	goto BS_MOVE_END

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MoveUsedFailedPrimalWeather:
	orbyte OUTCOME 0x20
	attackstring
	ppreduce
	pause DELAY_HALFSECOND
	jumpifhalfword ANDS WEATHER_FLAGS weather_harsh_sun HarshSunEvaportionBS
	setword BATTLE_STRING_LOADER MoveFizzledInHeavyRainString
	printstring 0x184
	waitmessage DELAY_1SECOND
	goto BS_MOVE_END

HarshSunEvaportionBS:
	setword BATTLE_STRING_LOADER MoveEvaporatedInHarshSunString
	printstring 0x184
	waitmessage DELAY_1SECOND
	goto BS_MOVE_END

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MoveUsedPsychicTerrainPrevents:
	orbyte OUTCOME 0x20
	attackstring
	ppreduce
	pause DELAY_HALFSECOND
	setword BATTLE_STRING_LOADER PsychicTerrainAttackCancelString
	printstring 0x184
	waitmessage DELAY_1SECOND
	goto BS_MOVE_END

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MoveUsedPowderPrevents:
	attackstring
	ppreduce
	pause DELAY_HALFSECOND
	playanimation BANK_ATTACKER ANIM_POWDER_EXPLOSION 0x0
	jumpifability BANK_ATTACKER ABILITY_MAGICGUARD SkipPowderDamage
	graphicalhpupdate BANK_ATTACKER
	datahpupdate BANK_ATTACKER

SkipPowderDamage:
	setword BATTLE_STRING_LOADER PowderExplosionString
	printstring 0x184
	waitmessage DELAY_1SECOND
	faintpokemon BANK_ATTACKER 0x0 0x0
	orbyte OUTCOME 0x1
	goto BS_MOVE_END

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_StanceChangeToBlade:
	call BattleScript_AbilityPopUp
	playanimation BANK_ATTACKER ANIM_TRANSFORM 0x0
	setword BATTLE_STRING_LOADER String_SwitchedToBladeForm
	printstring 0x184
	waitmessage DELAY_1SECOND
	call BattleScript_AbilityPopUpRevert
	return

BattleScript_StanceChangeToShield:
	call BattleScript_AbilityPopUp
	playanimation BANK_ATTACKER ANIM_TRANSFORM 0x0
	setword BATTLE_STRING_LOADER String_SwitchedToShieldForm
	printstring 0x184
	waitmessage DELAY_1SECOND
	call BattleScript_AbilityPopUpRevert
	return

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_ZMoveActivateStatus:
	call BSTryRemoveIllusion
	setword BATTLE_STRING_LOADER ZPowerSurroundsString
	printstring 0x184
	playanimation BANK_ATTACKER ANIM_ZMOVE_ACTIVATE 0x0
	callasm SetZEffect+1
	setword BATTLE_STRING_LOADER ZMoveUnleashedString
	printstring 0x184
	waitmessage DELAY_1SECOND
	return

BattleScript_ZMoveActivateDamaging:
	call BSTryRemoveIllusion
	setword BATTLE_STRING_LOADER ZPowerSurroundsString
	printstring 0x184
	playanimation BANK_ATTACKER ANIM_ZMOVE_ACTIVATE 0x0
	setword BATTLE_STRING_LOADER ZMoveUnleashedString
	printstring 0x184
	waitmessage DELAY_1SECOND
	return
	
BSTryRemoveIllusion:
	jumpifspecialstatusflag BANK_SCRIPTING STATUS3_ILLUSION 0x1 RemoveIllusionReturn
	@;remove illusion counter
	clearspecialstatusbit BANK_SCRIPTING STATUS3_ILLUSION
	call BattleScript_AbilityPopUp
	reloadhealthbar BANK_SCRIPTING
	playanimation BANK_SCRIPTING ANIM_TRANSFORM 0x0
	setword BATTLE_STRING_LOADER IllusionWoreOffString
	printstring 0x184
	waitmessage DELAY_1SECOND
	call BattleScript_AbilityPopUpRevert
RemoveIllusionReturn:
	return

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_DarkTypePreventsPrankster:
	call BattleScript_AbilityPopUp
	orbyte OUTCOME OUTCOME_MISSED
	printstring 27 @;STRINGID_IT_DOESNT_AFFECT
	waitmessage DELAY_1SECOND
	call BattleScript_AbilityPopUpRevert
	goto BS_MOVE_END

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

BattleScript_MoveUsedSkyBattlePrevents:
	pause DELAY_HALFSECOND
	setword BATTLE_STRING_LOADER SkyBattleAttackCancelString
	printstring 0x184
	waitmessage DELAY_1SECOND
	goto BS_MOVE_END

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.align 2
MagicBounceString: .byte 0xFD, 0x0F, 0xB4, 0xE7, 0x00, 0xFD, 0x14, 0xFE, 0xEB, 0xD5, 0xE7, 0x00, 0xD6, 0xE3, 0xE9, 0xE2, 0xD7, 0xD9, 0xD8, 0x00, 0xD6, 0xD5, 0xD7, 0xDF, 0x00, 0xD6, 0xED, 0x00, 0xC7, 0xD5, 0xDB, 0xDD, 0xD7, 0x00, 0xBC, 0xE3, 0xE9, 0xE2, 0xD7, 0xD9, 0xAB, 0xFF
AbilityRaisedStatString: .byte 0xFD, 0x13, 0xB4, 0xE7, 0x00, 0xFD, 0x1A, 0xFE, 0xE6, 0xD5, 0xDD, 0xE7, 0xD9, 0xD8, 0x00, 0xDD, 0xE8, 0xE7, 0x0, 0xFD, 0x0, 0xAB, 0xFF
GravityAttackCancelString: .byte 0xFD, 0x0F, 0x00, 0xD7, 0xD5, 0xE2, 0xB4, 0xE8, 0x00, 0xE9, 0xE7, 0xD9, 0xFE, 0xFD, 0x14, 0x00, 0xD6, 0xD9, 0xD7, 0xD5, 0xE9, 0xE7, 0xD9, 0x00, 0xE3, 0xDA, 0x00, 0xDB, 0xE6, 0xD5, 0xEA, 0xDD, 0xE8, 0xED, 0xAB, 0xFF
HealBlockAttackCancelString: .byte 0xFD, 0x0F, 0x00, 0xD7, 0xD5, 0xE2, 0xB4, 0xE8, 0x00, 0xE9, 0xE7, 0xD9, 0xFE, 0xFD, 0x14, 0x00, 0xD5, 0xDA, 0xE8, 0xD9, 0xE6, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xC2, 0xD9, 0xD5, 0xE0, 0x00, 0xBC, 0xE0, 0xE3, 0xD7, 0xDF, 0xAB, 0xFF
ThroatChopAttackCancelString: .byte 0xFD, 0x0F, 0x00, 0xD7, 0xD5, 0xE2, 0xB4, 0xE8, 0x00, 0xE9, 0xE7, 0xD9, 0xFE, 0xE7, 0xE3, 0xE9, 0xE2, 0xD8, 0x00, 0xE1, 0xE3, 0xEA, 0xD9, 0xE7, 0x00, 0xD5, 0xDA, 0xE8, 0xD9, 0xE6, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xCE, 0xDC, 0xE6, 0xE3, 0xD5, 0xE8, 0x00, 0xBD, 0xDC, 0xE3, 0xE4, 0xAB, 0xFF
MoveEvaporatedInHarshSunString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xD1, 0xD5, 0xE8, 0xD9, 0xE6, 0xAE, 0xE8, 0xED, 0xE4, 0xD9, 0x00, 0xD5, 0xE8, 0xE8, 0xD5, 0xD7, 0xDF, 0x00, 0xD9, 0xEA, 0xD5, 0xE4, 0xE3, 0xE6, 0xD5, 0xE8, 0xD9, 0xD8, 0xFE, 0xDD, 0xE2, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xDC, 0xD5, 0xE6, 0xE7, 0xDC, 0x00, 0xE7, 0xE9, 0xE2, 0xE0, 0xDD, 0xDB, 0xDC, 0xE8, 0xAB, 0xFF
MoveFizzledInHeavyRainString: .byte 0xCE, 0xDC, 0xD9, 0x00, 0xC0, 0xDD, 0xE6, 0xD9, 0xAE, 0xE8, 0xED, 0xE4, 0xD9, 0x00, 0xD5, 0xE8, 0xE8, 0xD5, 0xD7, 0xDF, 0x00, 0xDA, 0xDD, 0xEE, 0xEE, 0xE0, 0xD9, 0xD8, 0xFE, 0xE3, 0xE9, 0xE8, 0x00, 0xDD, 0xE2, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xDC, 0xD9, 0xD5, 0xEA, 0xED, 0x00, 0xE6, 0xD5, 0xDD, 0xE2, 0xAB, 0xFF
PsychicTerrainAttackCancelString: .byte 0xFD, 0x10, 0x00, 0xE7, 0xE9, 0xE6, 0xE6, 0xE3, 0xE9, 0xE2, 0xD8, 0xE7, 0x00, 0xDD, 0xE8, 0xE7, 0xD9, 0xE0, 0xDA, 0xFE, 0xEB, 0xDD, 0xE8, 0xDC, 0x00, 0xE4, 0xE7, 0xED, 0xD7, 0xDC, 0xDD, 0xD7, 0x00, 0xE8, 0xD9, 0xE6, 0xE6, 0xD5, 0xDD, 0xE2, 0xAB, 0xFF
PowderExplosionString: .byte 0xD1, 0xDC, 0xD9, 0xE2, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xDA, 0xE0, 0xD5, 0xE1, 0xD9, 0x00, 0xE8, 0xE3, 0xE9, 0xD7, 0xDC, 0xD9, 0xD8, 0x00, 0xE8, 0xDC, 0xD9, 0x00, 0xE4, 0xE3, 0xEB, 0xD8, 0xD9, 0xE6, 0x00, 0xE3, 0xE2, 0xFE, 0xFD, 0x0F, 0xB8, 0x00, 0xDD, 0xE8, 0x00, 0xD9, 0xEC, 0xE4, 0xE0, 0xE3, 0xD8, 0xD9, 0xD8, 0xAB, 0xFF
String_SwitchedToBladeForm: .byte 0xFD, 0x0F, 0x00, 0xE8, 0xE6, 0xD5, 0xE2, 0xE7, 0xDA, 0xE3, 0xE6, 0xE1, 0xD9, 0xD8, 0xFE, 0xDD, 0xE2, 0xE8, 0xE3, 0x00, 0xDD, 0xE8, 0xE7, 0x00, 0xD6, 0xE0, 0xD5, 0xD8, 0xD9, 0x00, 0xDA, 0xE3, 0xE6, 0xE1, 0xAB, 0xFF
String_SwitchedToShieldForm: .byte 0xFD, 0x0F, 0x00, 0xE8, 0xE6, 0xD5, 0xE2, 0xE7, 0xDA, 0xE3, 0xE6, 0xE1, 0xD9, 0xD8, 0xFE, 0xDD, 0xE2, 0xE8, 0xE3, 0x00, 0xDD, 0xE8, 0xE7, 0x00, 0xE7, 0xDC, 0xDD, 0xD9, 0xE0, 0xD8, 0x00, 0xDA, 0xE3, 0xE6, 0xE1, 0xAB, 0xFF
ZPowerSurroundsString: .byte 0xFD, 0x0F, 0x0, 0xE7, 0xE9, 0xE6, 0xE6, 0xE3, 0xE9, 0xE2, 0xD8, 0xD9, 0xD8, 0xFE, 0xDD, 0xE8, 0xE7, 0xD9, 0xE0, 0xDA, 0x00, 0xEB, 0xDD, 0xE8, 0xDC, 0x00, 0xDD, 0xE8, 0xE7, 0x00, 0xD4, 0xAE, 0xCA, 0xE3, 0xEB, 0xD9, 0xE6, 0xAB, 0xFF
ZMoveUnleashedString: .byte 0xFD, 0x0F, 0x0, 0xE9, 0xE2, 0xE0, 0xD9, 0xD5, 0xE7, 0xDC, 0xD9, 0xE7, 0xFE, 0xDD, 0xE8, 0xE7, 0x00, 0xDA, 0xE9, 0xE0, 0xE0, 0xAE, 0xDA, 0xE3, 0xE6, 0xD7, 0xD9, 0x00, 0xD4, 0xAE, 0xE1, 0xE3, 0xEA, 0xD9, 0xAB, 0xFF
IllusionWoreOffString: .byte 0xFD, 0x13, 0xB4, 0xE7, 0x00, 0xDD, 0xE0, 0xE0, 0xE9, 0xE7, 0xDD, 0xE3, 0xE2, 0xFE, 0xEB, 0xE3, 0xE6, 0xD9, 0x00, 0xE3, 0xDA, 0xDA, 0xAB, 0xFF
SkyBattleAttackCancelString: .byte 0xBC, 0xE9, 0xE8, 0x00, 0xDD, 0xE8, 0x00, 0xEB, 0xE3, 0xE2, 0xB4, 0xE8, 0x00, 0xEB, 0xE3, 0xE6, 0xDF, 0x00, 0xEB, 0xD9, 0xE0, 0xE0, 0x00, 0xDD, 0xE2, 0xFE, 0xCD, 0xDF, 0xED, 0x00, 0xBC, 0xD5, 0xE8, 0xE8, 0xE0, 0xD9, 0xE7, 0xB0, 0xFF
