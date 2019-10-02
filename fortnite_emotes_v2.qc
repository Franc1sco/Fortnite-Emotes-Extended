// Created by Crowbar 0.62

$modelname "player/custom_player/kodua/fortnite_emotes_v2.mdl"

$bodygroup "studio"
{
	studio "fortnite_emotes_v2_animset_t_shared_player_skeleton.smd"
}


$surfaceprop "flesh"

$illumposition -1.84 -13.826 37.867

$cdmaterials "models\player\custom_player\animsets\"

$attachment "legacy_weapon_bone" "ValveBiped.weapon_bone" 0 0 0 rotate 0 0 0
$attachment "weapon_hand_L" "weapon_hand_L" 0 0 0 rotate 0 0 0
$attachment "weapon_hand_R" "weapon_hand_R" 0 0 0 rotate 0 0 0
$attachment "primary" "spine_2" 0 -0.5 0 rotate 0 0 0
$attachment "pistol" "leg_upper_R" 5.9 -4.6 1 rotate 2 7 -12
$attachment "knife" "leg_upper_L" 6 0 3.9 rotate 0 150 90
$attachment "eholster" "leg_upper_L" 0 0 5 rotate 0 0 90
$attachment "grenade0" "spine_0" 1.3 -3 -8 rotate 90 0 0
$attachment "grenade1" "spine_0" 1.3 -0.7 -8.8 rotate 90 0 0
$attachment "grenade2" "spine_0" 1.3 1.6 -9.1 rotate 90 0 0
$attachment "grenade3" "spine_0" 1.3 4.1 -8 rotate 90 0 0
$attachment "grenade4" "spine_0" 1.3 5.8 -6 rotate 90 0 0
$attachment "defusekit" "spine_0" -1.6 -6 0 rotate 0 90 90
$attachment "c4" "spine_3" 2 -5.9 1.7 rotate 4 4 85
$attachment "facemask" "head_0" 0.8 4.5 0 rotate 0 90 90
$attachment "clip_limit" "head_0" 7 6 0 rotate 0 0 0

$cbox 0 0 0 0 0 0

$bbox -13 -13 0 13 13 72

$definebone "pelvis" "" 0 42.824833 -2.853551 0 90.000003 90.000003 0 0 0 0 0 0
$definebone "lean_root" "" 0 0 0 0 0 0 0 0 0 0 0 0
$definebone "cam_driver" "" 0 0 64 0 0 0 0 0 0 0 0 0
$definebone "spine_0" "pelvis" 0.934204 0.090506 0 0.000002 6.615894 0.000003 0 0 0 0 0 0
$definebone "spine_1" "spine_0" 4.066372 0 0 0 -6.720192 0 0 0 0 0 0 0
$definebone "spine_2" "spine_1" 4.744076 0 0 0 -10.503317 0 0 0 0 0 0 0
$definebone "spine_3" "spine_2" 6.347771 0.000001 0 0.000001 14.001006 0 0 0 0 0 0 0
$definebone "neck_0" "spine_3" 6.515205 -0.000017 0 0.000001 13.985426 0 0 0 0 0 0 0
$definebone "head_0" "neck_0" 5.762173 0 0 -0.000001 -17.378826 0 0 0 0 0 0 0
$definebone "clavicle_L" "spine_3" 4.311546 3.005296 1.270492 -61.861987 -116.042907 115.414338 0 0 0 0 0 0
$definebone "arm_upper_L" "clavicle_L" 6.66543 -0.000002 0.000008 -38.000547 16.037397 11.70483 0 0 0 0 0 0
$definebone "arm_lower_L" "arm_upper_L" 11.596655 0 0.000004 -0.00002 25.480205 0.000014 0 0 0 0 0 0
$definebone "hand_L" "arm_lower_L" 11.486956 -0.000001 0 -3.03395 2.80719 86.410008 0 0 0 0 0 0
$definebone "finger_middle_meta_L" "hand_L" 0.807852 0.01545 -0.224506 -5.640275 -4.480851 5.933855 0 0 0 0 0 0
$definebone "finger_middle_0_L" "finger_middle_meta_L" 3.265083 0 0.000001 -2.980437 24.773923 2.40249 0 0 0 0 0 0
$definebone "finger_middle_1_L" "finger_middle_0_L" 2.075727 0 0 1.55697 20.250528 0.249367 0 0 0 0 0 0
$definebone "finger_middle_2_L" "finger_middle_1_L" 1.413418 -0.000002 0 0.354589 12.34228 0.032922 0 0 0 0 0 0
$definebone "finger_pinky_meta_L" "hand_L" 0.562847 0.124916 0.989242 -19.702487 5.079185 -0.790864 0 0 0 0 0 0
$definebone "finger_pinky_0_L" "finger_pinky_meta_L" 2.70488 0.000004 0 -6.970714 11.127638 -4.211328 0 0 0 0 0 0
$definebone "finger_pinky_1_L" "finger_pinky_0_L" 1.511143 0 0 0.823082 20.106189 0.130548 0 0 0 0 0 0
$definebone "finger_pinky_2_L" "finger_pinky_1_L" 0.872662 0 0 -1.327091 2.655041 0.082127 0 0 0 0 0 0
$definebone "finger_index_meta_L" "hand_L" 0.802795 0.214912 -0.873656 3.050818 -3.750097 12.112559 0 0 0 0 0 0
$definebone "finger_index_0_L" "finger_index_meta_L" 3.290373 -0.000008 -0.000001 -1.372444 28.248804 5.880793 0 0 0 0 0 0
$definebone "finger_index_1_L" "finger_index_0_L" 1.995686 0.000002 0.000001 0.630862 18.943846 0.112816 0 0 0 0 0 0
$definebone "finger_index_2_L" "finger_index_1_L" 1.269024 0.000002 0 -2.098526 0.796067 0.195979 0 0 0 0 0 0
$definebone "finger_thumb_0_L" "hand_L" 1.423082 0.741592 -1.176399 26.929406 33.103926 89.945273 0 0 0 0 0 0
$definebone "finger_thumb_1_L" "finger_thumb_0_L" 1.69886 0.000002 0 -5.586259 24.995783 -1.038861 0 0 0 0 0 0
$definebone "finger_thumb_2_L" "finger_thumb_1_L" 1.566334 0.000004 0.000004 0.358663 17.232016 0.068012 0 0 0 0 0 0
$definebone "finger_ring_meta_L" "hand_L" 0.711744 0.057617 0.410461 -12.336227 -1.130954 3.830346 0 0 0 0 0 0
$definebone "finger_ring_0_L" "finger_ring_meta_L" 2.987722 0.000008 0 -6.211744 23.368198 -1.014229 0 0 0 0 0 0
$definebone "finger_ring_1_L" "finger_ring_0_L" 1.910923 0.000004 0 0.032411 18.794548 0.005363 0 0 0 0 0 0
$definebone "finger_ring_2_L" "finger_ring_1_L" 1.280704 0 0 0.519846 7.678754 0.009718 0 0 0 0 0 0
$definebone "weapon_hand_L" "hand_L" 2.790773 1.123619 0.295329 0.000003 180.000007 0.000016 0 0 0 0 0 0
$definebone "arm_lower_L_TWIST" "arm_lower_L" 3.828991 -0.000002 -0.000008 -0.000007 0 0.000002 0 0 0 0 0 0
$definebone "arm_lower_L_TWIST1" "arm_lower_L" 7.657978 -0.000002 -0.000008 -0.000007 0 0.000002 0 0 0 0 0 0
$definebone "arm_upper_L_TWIST" "arm_upper_L" 3.865555 -0.000001 -0.000004 -0.000015 0.000003 0.000009 0 0 0 0 0 0
$definebone "arm_upper_L_TWIST1" "arm_upper_L" 7.731102 0.000006 0 -0.000015 0.000003 0.000009 0 0 0 0 0 0
$definebone "clavicle_R" "spine_3" 4.311554 3.005295 -1.27049 -61.862001 63.957127 115.414297 0 0 0 0 0 0
$definebone "arm_upper_R" "clavicle_R" -6.665441 -0.000003 -0.000011 38.000694 -163.962627 168.295139 0 0 0 0 0 0
$definebone "arm_lower_R" "arm_upper_R" 11.596649 -0.000002 -0.000004 0.000147 -25.480154 -90.000058 0 0 0 0 0 0
$definebone "hand_R" "arm_lower_R" 11.486994 0.000004 -0.000002 -2.803299 176.962403 176.558711 0 0 0 0 0 0
$definebone "finger_middle_meta_R" "hand_R" -0.807779 -0.015434 0.224528 -5.640262 -4.480861 5.933873 0 0 0 0 0 0
$definebone "finger_middle_0_R" "finger_middle_meta_R" -3.265091 -0.000008 -0.000001 -2.980429 24.773924 2.4025 0 0 0 0 0 0
$definebone "finger_middle_1_R" "finger_middle_0_R" -2.075768 0.000034 -0.000015 1.556974 20.250528 0.249384 0 0 0 0 0 0
$definebone "finger_middle_2_R" "finger_middle_1_R" -1.41341 0.000011 -0.000004 0.35459 12.342267 0.032907 0 0 0 0 0 0
$definebone "finger_pinky_meta_R" "hand_R" -0.562851 -0.124878 -0.989246 -19.70247 5.079185 -0.790855 0 0 0 0 0 0
$definebone "finger_pinky_0_R" "finger_pinky_meta_R" -2.704901 -0.000004 0 -6.970699 11.127644 -4.211313 0 0 0 0 0 0
$definebone "finger_pinky_1_R" "finger_pinky_0_R" -1.511095 -0.000008 -0.000013 0.823091 20.10619 0.130557 0 0 0 0 0 0
$definebone "finger_pinky_2_R" "finger_pinky_1_R" -0.872669 -0.000025 0.000008 -1.327082 2.655043 0.082153 0 0 0 0 0 0
$definebone "finger_index_meta_R" "hand_R" -0.802757 -0.21492 0.873665 3.050823 -3.750101 12.112568 0 0 0 0 0 0
$definebone "finger_index_0_R" "finger_index_meta_R" -3.290358 0.000015 0.000002 -1.372442 28.248807 5.880792 0 0 0 0 0 0
$definebone "finger_index_1_R" "finger_index_0_R" -1.99572 0.000074 -0.000041 0.630868 18.943851 0.112796 0 0 0 0 0 0
$definebone "finger_index_2_R" "finger_index_1_R" -1.269001 -0.00008 0.000053 -2.098522 0.79607 0.195967 0 0 0 0 0 0
$definebone "finger_thumb_0_R" "hand_R" -1.423063 -0.741619 1.176403 26.929392 33.103926 89.945273 0 0 0 0 0 0
$definebone "finger_thumb_1_R" "finger_thumb_0_R" -1.698807 0.000021 -0.000076 -5.586252 24.995791 -1.038864 0 0 0 0 0 0
$definebone "finger_thumb_2_R" "finger_thumb_1_R" -1.566319 0.000015 0.000042 0.358679 17.232006 0.068015 0 0 0 0 0 0
$definebone "finger_ring_meta_R" "hand_R" -0.711685 -0.057613 -0.410449 -12.336216 -1.130952 3.830374 0 0 0 0 0 0
$definebone "finger_ring_0_R" "finger_ring_meta_R" -2.987783 0.000034 -0.00001 -6.211729 23.368227 -1.014231 0 0 0 0 0 0
$definebone "finger_ring_1_R" "finger_ring_0_R" -1.910938 -0.000071 0.00001 0.032419 18.79456 0.005369 0 0 0 0 0 0
$definebone "finger_ring_2_R" "finger_ring_1_R" -1.280685 0.000078 -0.000008 0.519851 7.678768 0.009736 0 0 0 0 0 0
$definebone "weapon_hand_R" "hand_R" -2.790768 -1.123661 -0.295325 -0.000007 180.000007 -0.000008 0 0 0 0 0 0
$definebone "arm_lower_R_TWIST" "arm_lower_R" 3.828999 0 0.000001 -0.000055 180.000007 90.000003 0 0 0 0 0 0
$definebone "arm_lower_R_TWIST1" "arm_lower_R" 7.658009 0 -0.000001 -0.000055 180.000007 90.000003 0 0 0 0 0 0
$definebone "arm_upper_R_TWIST" "arm_upper_R" 3.865543 -0.000003 0 -0.000154 180.000007 180.000007 0 0 0 0 0 0
$definebone "arm_upper_R_TWIST1" "arm_upper_R" 7.731091 -0.000005 0.000008 -0.000154 180.000007 180.000007 0 0 0 0 0 0
$definebone "leg_upper_L" "pelvis" -3.771385 0.913481 3.69423 -2.271181 179.170781 -15.008665 0 0 0 0 0 0
$definebone "leg_lower_L" "leg_upper_L" 17.902937 -0.000001 0 0.000002 7.365627 -0.000002 0 0 0 0 0 0
$definebone "ankle_L" "leg_lower_L" 16.937244 0 0.000001 2.26058 -67.350099 179.704027 0 0 0 0 0 0
$definebone "ball_L" "ankle_L" 6.329629 -0.000004 0 0.000014 28.673589 0 0 0 0 0 0 0
$definebone "leg_upper_L_TWIST" "leg_upper_L" 5.967651 0.000002 0 0 0 -0.000003 0 0 0 0 0 0
$definebone "leg_upper_L_TWIST1" "leg_upper_L" 11.935293 0.000001 0 0 0 -0.000003 0 0 0 0 0 0
$definebone "leg_upper_R" "pelvis" -3.771435 0.913481 -3.69423 2.271184 179.170781 105.008668 0 0 0 0 0 0
$definebone "leg_lower_R" "leg_upper_R" 17.902925 0 0 7.365659 0.000007 0.000001 0 0 0 0 0 0
$definebone "ankle_R" "leg_lower_R" 16.937191 0 0 67.243513 -174.147272 -84.896015 0 0 0 0 0 0
$definebone "ball_R" "ankle_R" -6.329633 -0.000003 0.000002 0.000018 28.673582 -0.000014 0 0 0 0 0 0
$definebone "leg_upper_R_TWIST" "leg_upper_R" 5.967648 0.000001 0 -0.000005 180.000007 90.000003 0 0 0 0 0 0
$definebone "leg_upper_R_TWIST1" "leg_upper_R" 11.935291 -0.000001 0 -0.000005 180.000007 90.000003 0 0 0 0 0 0
$definebone "lfoot_lock" "ball_L" 0 0 0.000001 0.000005 0.000003 0.000001 0 0 0 0 0 0
$definebone "rfoot_lock" "ball_R" 0 0 0 0.000005 -0.000002 0 0 0 0 0 0 0
$definebone "ValveBiped.weapon_bone" "hand_R" -6.999998 -2.000004 2.5 0.000004 -90.000003 109.999999 0 0 0 0 0 0
$definebone "lh_ik_driver" "hand_L" -0.000004 0.000008 0 0.000003 0.000007 -0.000002 0 0 0 0 0 0

$bonemerge "pelvis"
$bonemerge "lean_root"
$bonemerge "cam_driver"
$bonemerge "spine_0"
$bonemerge "spine_1"
$bonemerge "spine_2"
$bonemerge "spine_3"
$bonemerge "neck_0"
$bonemerge "head_0"
$bonemerge "clavicle_L"
$bonemerge "arm_upper_L"
$bonemerge "arm_lower_L"
$bonemerge "hand_L"
$bonemerge "finger_middle_meta_L"
$bonemerge "finger_middle_0_L"
$bonemerge "finger_middle_1_L"
$bonemerge "finger_middle_2_L"
$bonemerge "finger_pinky_meta_L"
$bonemerge "finger_pinky_0_L"
$bonemerge "finger_pinky_1_L"
$bonemerge "finger_pinky_2_L"
$bonemerge "finger_index_meta_L"
$bonemerge "finger_index_0_L"
$bonemerge "finger_index_1_L"
$bonemerge "finger_index_2_L"
$bonemerge "finger_thumb_0_L"
$bonemerge "finger_thumb_1_L"
$bonemerge "finger_thumb_2_L"
$bonemerge "finger_ring_meta_L"
$bonemerge "finger_ring_0_L"
$bonemerge "finger_ring_1_L"
$bonemerge "finger_ring_2_L"
$bonemerge "weapon_hand_L"
$bonemerge "arm_lower_L_TWIST"
$bonemerge "arm_lower_L_TWIST1"
$bonemerge "arm_upper_L_TWIST"
$bonemerge "arm_upper_L_TWIST1"
$bonemerge "clavicle_R"
$bonemerge "arm_upper_R"
$bonemerge "arm_lower_R"
$bonemerge "hand_R"
$bonemerge "finger_middle_meta_R"
$bonemerge "finger_middle_0_R"
$bonemerge "finger_middle_1_R"
$bonemerge "finger_middle_2_R"
$bonemerge "finger_pinky_meta_R"
$bonemerge "finger_pinky_0_R"
$bonemerge "finger_pinky_1_R"
$bonemerge "finger_pinky_2_R"
$bonemerge "finger_index_meta_R"
$bonemerge "finger_index_0_R"
$bonemerge "finger_index_1_R"
$bonemerge "finger_index_2_R"
$bonemerge "finger_thumb_0_R"
$bonemerge "finger_thumb_1_R"
$bonemerge "finger_thumb_2_R"
$bonemerge "finger_ring_meta_R"
$bonemerge "finger_ring_0_R"
$bonemerge "finger_ring_1_R"
$bonemerge "finger_ring_2_R"
$bonemerge "weapon_hand_R"
$bonemerge "arm_lower_R_TWIST"
$bonemerge "arm_lower_R_TWIST1"
$bonemerge "arm_upper_R_TWIST"
$bonemerge "arm_upper_R_TWIST1"
$bonemerge "leg_upper_L"
$bonemerge "leg_lower_L"
$bonemerge "ankle_L"
$bonemerge "ball_L"
$bonemerge "leg_upper_L_TWIST"
$bonemerge "leg_upper_L_TWIST1"
$bonemerge "leg_upper_R"
$bonemerge "leg_lower_R"
$bonemerge "ankle_R"
$bonemerge "ball_R"
$bonemerge "leg_upper_R_TWIST"
$bonemerge "leg_upper_R_TWIST1"
$bonemerge "lfoot_lock"
$bonemerge "rfoot_lock"
$bonemerge "lh_ik_driver"


$sectionframes 30 29

$sequence "DanceMoves" {
	"fortnite_emotes_v2_anims\DanceMoves.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "ElectroShuffle" {
	"fortnite_emotes_v2_anims\ElectroShuffle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_AerobicChamp" {
	"fortnite_emotes_v2_anims\Emote_AerobicChamp.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Bendy" {
	"fortnite_emotes_v2_anims\Emote_Bendy.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_BandOfTheFort" {
	"fortnite_emotes_v2_anims\Emote_BandOfTheFort.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_BlowKiss" {
	"fortnite_emotes_v2_anims\Emote_BlowKiss.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Boogie_Down" {
	"fortnite_emotes_v2_anims\Emote_Boogie_Down.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Boogie_Down_Intro" {
	"fortnite_emotes_v2_anims\Emote_Boogie_Down_Intro.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Bring_It_On" {
	"fortnite_emotes_v2_anims\Emote_Bring_It_On.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Capoeira" {
	"fortnite_emotes_v2_anims\Emote_Capoeira.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Calculated" {
	"fortnite_emotes_v2_anims\Emote_Calculated.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Celebration_Loop" {
	"fortnite_emotes_v2_anims\Emote_Celebration_Loop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Charleston" {
	"fortnite_emotes_v2_anims\Emote_Charleston.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Confused" {
	"fortnite_emotes_v2_anims\Emote_Confused.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Chicken" {
	"fortnite_emotes_v2_anims\Emote_Chicken.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Chug" {
	"fortnite_emotes_v2_anims\Emote_Chug.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Cry" {
	"fortnite_emotes_v2_anims\Emote_Cry.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Dance_NoBones" {
	"fortnite_emotes_v2_anims\Emote_Dance_NoBones.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Shoot" {
	"fortnite_emotes_v2_anims\Emote_Dance_Shoot.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_SwipeIt" {
	"fortnite_emotes_v2_anims\Emote_Dance_SwipeIt.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Disco_T3" {
	"fortnite_emotes_v2_anims\Emote_Dance_Disco_T3.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Worm" {
	"fortnite_emotes_v2_anims\Emote_Dance_Worm.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Dance_Loser" {
	"fortnite_emotes_v2_anims\Emote_Dance_Loser.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Loser_CT" {
	"fortnite_emotes_v2_anims\Emote_Dance_Loser_CT.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Breakdance" {
	"fortnite_emotes_v2_anims\Emote_Dance_Breakdance.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Dance_Pump" {
	"fortnite_emotes_v2_anims\Emote_Dance_Pump.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_RideThePony" {
	"fortnite_emotes_v2_anims\Emote_Dance_RideThePony.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Dab" {
	"fortnite_emotes_v2_anims\Emote_Dab.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_DG_Disco" {
	"fortnite_emotes_v2_anims\Emote_DG_Disco.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_DustingOffHands" {
	"fortnite_emotes_v2_anims\Emote_DustingOffHands.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_DustOffShoulders" {
	"fortnite_emotes_v2_anims\Emote_DustOffShoulders.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_EasternBloc_Start" {
	"fortnite_emotes_v2_anims\Emote_EasternBloc_Start.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_EasternBloc" {
	"fortnite_emotes_v2_anims\Emote_EasternBloc.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_FancyFeet" {
	"fortnite_emotes_v2_anims\Emote_FancyFeet.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_FancyFeet_CT" {
	"fortnite_emotes_v2_anims\Emote_FancyFeet_CT.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Facepalm" {
	"fortnite_emotes_v2_anims\Emote_Facepalm.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Fishing" {
	"fortnite_emotes_v2_anims\Emote_Fishing.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Flex" {
	"fortnite_emotes_v2_anims\Emote_Flex.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_FlossDance" {
	"fortnite_emotes_v2_anims\Emote_FlossDance.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Fonzie_Pistol" {
	"fortnite_emotes_v2_anims\Emote_Fonzie_Pistol.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_FlippnSexy" {
	"fortnite_emotes_v2_anims\Emote_FlippnSexy.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Fresh" {
	"fortnite_emotes_v2_anims\Emote_Fresh.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_GrooveJam" {
	"fortnite_emotes_v2_anims\Emote_GrooveJam.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_golfclap" {
	"fortnite_emotes_v2_anims\Emote_golfclap.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_guitar" {
	"fortnite_emotes_v2_anims\Emote_guitar.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_HandSignals" {
	"fortnite_emotes_v2_anims\Emote_HandSignals.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_HeelClick" {
	"fortnite_emotes_v2_anims\Emote_HeelClick.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Hillbilly_Shuffle" {
	"fortnite_emotes_v2_anims\Emote_Hillbilly_Shuffle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Hillbilly_Shuffle_Intro" {
	"fortnite_emotes_v2_anims\Emote_Hillbilly_Shuffle_Intro.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Hip_Hop" {
	"fortnite_emotes_v2_anims\Emote_Hip_Hop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Hiphop_01" {
	"fortnite_emotes_v2_anims\Emote_Hiphop_01.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Hotstuff" {
	"fortnite_emotes_v2_anims\Emote_Hotstuff.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Hula" {
	"fortnite_emotes_v2_anims\Emote_Hula.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Hula_Start" {
	"fortnite_emotes_v2_anims\Emote_Hula_Start.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_IBreakYou" {
	"fortnite_emotes_v2_anims\Emote_IBreakYou.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_InfiniDab_Loop" {
	"fortnite_emotes_v2_anims\Emote_InfiniDab_Loop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_InfiniDab_Intro" {
	"fortnite_emotes_v2_anims\Emote_InfiniDab_Intro.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_IHeartYou" {
	"fortnite_emotes_v2_anims\Emote_IHeartYou.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Intensity_Loop" {
	"fortnite_emotes_v2_anims\Emote_Intensity_Loop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Intensity_Start" {
	"fortnite_emotes_v2_anims\Emote_Intensity_Start.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_IrishJig" {
	"fortnite_emotes_v2_anims\Emote_IrishJig.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_IrishJig_Start" {
	"fortnite_emotes_v2_anims\Emote_IrishJig_Start.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_KoreanEagle" {
	"fortnite_emotes_v2_anims\Emote_KoreanEagle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Kpop_02" {
	"fortnite_emotes_v2_anims\Emote_Kpop_02.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Kung-Fu_Salute" {
	"fortnite_emotes_v2_anims\Emote_Kung-Fu_Salute.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Laugh" {
	"fortnite_emotes_v2_anims\Emote_Laugh.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Laugh_CT" {
	"fortnite_emotes_v2_anims\Emote_Laugh_CT.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_LivingLarge" {
	"fortnite_emotes_v2_anims\Emote_LivingLarge.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Luchador" {
	"fortnite_emotes_v2_anims\Emote_Luchador.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Maracas" {
	"fortnite_emotes_v2_anims\Emote_Maracas.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Mask_Off_Loop" {
	"fortnite_emotes_v2_anims\Emote_Mask_Off_Loop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Mask_Off_Intro" {
	"fortnite_emotes_v2_anims\Emote_Mask_Off_Intro.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Make_It_Rain" {
	"fortnite_emotes_v2_anims\Emote_Make_It_Rain.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_NotToday" {
	"fortnite_emotes_v2_anims\Emote_NotToday.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_PopLock" {
	"fortnite_emotes_v2_anims\Emote_PopLock.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_PopRock" {
	"fortnite_emotes_v2_anims\Emote_PopRock.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_RockPaperScissor_Paper" {
	"fortnite_emotes_v2_anims\Emote_RockPaperScissor_Paper.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_RockPaperScissor_Rock" {
	"fortnite_emotes_v2_anims\Emote_RockPaperScissor_Rock.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_RockPaperScissor_Scissor" {
	"fortnite_emotes_v2_anims\Emote_RockPaperScissor_Scissor.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_RobotDance" {
	"fortnite_emotes_v2_anims\Emote_RobotDance.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Salt" {
	"fortnite_emotes_v2_anims\Emote_Salt.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Salute" {
	"fortnite_emotes_v2_anims\Emote_Salute.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_SmoothDrive" {
	"fortnite_emotes_v2_anims\Emote_SmoothDrive.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Snap" {
	"fortnite_emotes_v2_anims\Emote_Snap.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_StageBow" {
	"fortnite_emotes_v2_anims\Emote_StageBow.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_T-Rex" {
	"fortnite_emotes_v2_anims\Emote_T-Rex.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_TechnoZombie" {
	"fortnite_emotes_v2_anims\Emote_TechnoZombie.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_ThumbsDown" {
	"fortnite_emotes_v2_anims\Emote_ThumbsDown.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_ThumbsUp" {
	"fortnite_emotes_v2_anims\Emote_ThumbsUp.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Twist" {
	"fortnite_emotes_v2_anims\Emote_Twist.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_WarehouseDance_Loop" {
	"fortnite_emotes_v2_anims\Emote_WarehouseDance_Loop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_WarehouseDance_Start" {
	"fortnite_emotes_v2_anims\Emote_WarehouseDance_Start.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Wiggle" {
	"fortnite_emotes_v2_anims\Emote_Wiggle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Wave2" {
	"fortnite_emotes_v2_anims\Emote_Wave2.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Yeet" {
	"fortnite_emotes_v2_anims\Emote_Yeet.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Youre_Awesome" {
	"fortnite_emotes_v2_anims\Emote_Youre_Awesome.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Zippy_Dance" {
	"fortnite_emotes_v2_anims\Emote_Zippy_Dance.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$KeyValues
{
	qc_path 
	{
		"value" "f:\works\models\sources\animset fortnite emotes\animset_fortnite_emotes_v2.qc"
	}
}
