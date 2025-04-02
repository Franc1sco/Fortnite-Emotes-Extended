// Created by Crowbar 0.74

$modelname "fortnite_emotes/original/fnemotesv101.mdl"

$bodygroup "studio"
{
	studio "animset_t_shared_survivor_skeleton.smd"
}


$surfaceprop "flesh"

$contents "solid"

$illumposition -1.84 -13.826 37.867

$cdmaterials "models\survivors\"

$attachment "eyes" "ValveBiped.Bip01_Head1" 2.92 -2.8 0 rotate 0 -89.37 -90
$attachment "mouth" "ValveBiped.Bip01_Head1" 0.84 -6.09 -0.16 rotate 0 -80 -90
$attachment "survivor_light" "ValveBiped.Bip01_Spine2" 6.3 25.2 0 rotate 0 0 0
$attachment "forward" "ValveBiped.forward" 0 0 0 rotate 0 0 0
$attachment "pistol" "ValveBiped.Bip01_R_Thigh" -3.48 2.17 -5.47 rotate -3.66 -0.47 96.14
$attachment "weapon_bone" "ValveBiped.weapon_bone" 0 0 0 rotate 0 0 0
$attachment "medkit" "ValveBiped.Bip01_Spine4" -1.34 -5.84 -1.37 rotate 5.03 77.16 0
$attachment "primary" "ValveBiped.Bip01_Spine4" 3.21 -5.16 -2.75 rotate -13.7 170.19 174.29
$attachment "attach_R_shoulderBladeAim" "ValveBiped.Bip01_Spine4" -11.07 -1.46 -5.33 rotate -90 -102.85 0
$attachment "attach_L_shoulderBladeAim" "ValveBiped.Bip01_Spine4" -11.07 -1.46 3.69 rotate -90 -102.85 0
$attachment "melee" "ValveBiped.Bip01_Spine4" 2.87 -5.56 5.47 rotate 24.08 175.37 97.14
$attachment "molotov" "ValveBiped.Bip01_Spine" -3.78 -2.89 8.29 rotate -63.44 -74.67 -101.41
$attachment "grenade" "ValveBiped.Bip01_Spine" -0.8 1.38 9.33 rotate -90 -175.23 0
$attachment "pills" "ValveBiped.Bip01_Spine" -3.1 0.74 -8.47 rotate -41.18 -88.48 -87.05
$attachment "lfoot" "ValveBiped.Bip01_L_Foot" 0 5.25 0 rotate 0 0 0
$attachment "rfoot" "ValveBiped.Bip01_R_Foot" 0 5.25 0 rotate 0 0 0
$attachment "muzzle_flash" "ValveBiped.Bip01_L_Hand" 0 0 0 rotate 0 0 0
$attachment "survivor_neck" "ValveBiped.Bip01_Neck1" 0 0 0 rotate 0 0 0
$attachment "forward" "ValveBiped.forward" 0 0 0 rotate 0 0 0
$attachment "bleedout" "ValveBiped.Bip01_Pelvis" 9.97 10.5 5.25 rotate 0 0 0
$attachment "survivor_light" "ValveBiped.Bip01_Spine2" 6.3 25.2 0 rotate 0 0 0
$attachment "legL_B" "ValveBiped.attachment_bandage_legL" 0 0 0 rotate -90 -90 0
$attachment "armL_B" "ValveBiped.attachment_bandage_armL" 0 0 0 rotate -90 -90 0
$attachment "armL_T" "ValveBiped.attachment_armL_T" 0 0 0 rotate -90 -90 0
$attachment "armR_T" "ValveBiped.attachment_armR_T" 0 0 0 rotate -90 -90 0
$attachment "armL" "ValveBiped.Bip01_L_Forearm" 0 0 0 rotate 0 0 0
$attachment "legL" "ValveBiped.Bip01_L_Calf" 0 0 0 rotate 0 0 0
$attachment "thighL" "ValveBiped.Bip01_L_Thigh" 0 0 0 rotate 0 0 0
$attachment "spine" "ValveBiped.Bip01_Spine" 0 0 0 rotate -90 -90 0

$cbox 0 0 0 0 0 0

$bbox -13 -13 0 13 13 72

$definebone "ValveBiped.Bip01_Pelvis" "" 0 0.542612 40.233574 0 0 89.999975 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine" "ValveBiped.Bip01_Pelvis" 0 4.246162 -0.018825 4.766603 89.999982 89.999982 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine1" "ValveBiped.Bip01_Spine" 4.195629 0 0 0 -9.852981 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine2" "ValveBiped.Bip01_Spine1" 3.883152 0.000002 0 0 -0.906993 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Spine4" "ValveBiped.Bip01_Spine2" 5.985943 0.000001 0 0 28.371673 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Clavicle" "ValveBiped.Bip01_Spine4" 4.268658 1.531896 -1.575 63.875301 -147.035777 -54.583286 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_UpperArm" "ValveBiped.Bip01_R_Clavicle" 5.782728 0 -0.000001 22.698471 -42.953697 82.694992 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Forearm" "ValveBiped.Bip01_R_UpperArm" 11.452759 0 -0.000004 0.00002 -7.202481 -0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Clavicle" "ValveBiped.Bip01_Spine4" 4.268658 1.531893 1.575 -63.875287 -147.035791 50.277507 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_UpperArm" "ValveBiped.Bip01_L_Clavicle" 5.782726 0.000008 0 -19.730429 -44.165468 -79.348288 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Forearm" "ValveBiped.Bip01_L_UpperArm" 11.452759 0.000002 0 -0.000019 -7.202476 0.000002 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Hand" "ValveBiped.Bip01_L_Forearm" 10.94553 -0.000006 -0.000031 6.507298 7.122673 78.669798 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Hand" "ValveBiped.Bip01_R_Forearm" 10.945526 -0.000006 0.000011 -6.507525 7.122611 -78.876985 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Thigh" "ValveBiped.Bip01_Pelvis" -3.806942 0 0 3.326304 -92.951464 -84.289083 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Knee" "ValveBiped.Bip01_R_Thigh" 19.253838 0 0 0 1.446719 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Quadricep" "ValveBiped.Bip01_R_Thigh" 6.694794 0 0 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Neck1" "ValveBiped.Bip01_Spine4" 5.620499 0.000002 0 0 14.358376 179.999841 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_Head1" "ValveBiped.Bip01_Neck1" 4.684902 0 0 -0.000057 26.575554 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Calf" "ValveBiped.Bip01_R_Thigh" 19.263094 0 0 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Foot" "ValveBiped.Bip01_R_Calf" 17.589094 0 0 3.939485 -74.439534 5.084025 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Toe0" "ValveBiped.Bip01_R_Foot" 6.240661 0 0 1.366219 -19.288963 -6.40802 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Thigh" "ValveBiped.Bip01_Pelvis" 3.806942 0 0 3.326308 -87.048507 -95.710935 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Quadricep" "ValveBiped.Bip01_L_Thigh" 6.694798 0 0 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Knee" "ValveBiped.Bip01_L_Thigh" 19.253841 0 0 0 1.446891 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger4" "ValveBiped.Bip01_L_Hand" 3.147141 0.005682 -1.551346 8.213354 -12.990153 11.742423 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger41" "ValveBiped.Bip01_L_Finger4" 1.585907 0 0 0.95524 -34.374614 0.653397 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger42" "ValveBiped.Bip01_L_Finger41" 0.849091 -0.000001 0 -10.048536 -17.354283 -3.121078 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger3" "ValveBiped.Bip01_L_Hand" 3.471081 0.213264 -0.574065 5.954124 -16.778209 11.33786 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger31" "ValveBiped.Bip01_L_Finger3" 1.897533 0 0 -5.063457 -30.512996 -2.977606 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger32" "ValveBiped.Bip01_L_Finger31" 1.014454 0.000002 0 0.559038 -13.904494 0.138367 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger2" "ValveBiped.Bip01_L_Hand" 3.75008 0.114767 0.430058 3.893596 -14.79107 10.730301 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger21" "ValveBiped.Bip01_L_Finger2" 2.25819 -0.000002 0 -3.092655 -37.967191 -2.410839 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger22" "ValveBiped.Bip01_L_Finger21" 1.210384 0 0 0.688638 -8.970363 0.108686 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger1" "ValveBiped.Bip01_L_Hand" 3.868296 -0.166639 1.490141 1.961121 -11.693713 10.352718 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger11" "ValveBiped.Bip01_L_Finger1" 1.78607 -0.000004 0 3.66905 -38.756259 2.940814 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger12" "ValveBiped.Bip01_L_Finger11" 1.044437 0 0 2.209322 -1.896561 0.073158 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger0" "ValveBiped.Bip01_L_Hand" 1.121475 -1.351564 1.030998 -19.74184 -7.111196 97.051428 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger01" "ValveBiped.Bip01_L_Finger0" 1.92812 0.000002 -0.000002 -10.778418 -10.615979 0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Finger02" "ValveBiped.Bip01_L_Finger01" 1.285137 0.000002 -0.000002 -2.328841 11.249066 0.000004 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Calf" "ValveBiped.Bip01_L_Thigh" 19.263103 0 0 0 0 0 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Foot" "ValveBiped.Bip01_L_Calf" 17.589098 0 0 -3.939487 -74.439534 -4.413494 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Toe0" "ValveBiped.Bip01_L_Foot" 6.240662 0 0 -1.58761 -19.272641 1.162818 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Ulna" "ValveBiped.Bip01_L_Forearm" 5.88435 0 0.000008 -0.000019 0.000001 -7.237035 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Wrist" "ValveBiped.Bip01_L_Forearm" 11.768703 0.000001 0.000004 -0.000019 0.000001 -13.6609 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_L_Elbow" "ValveBiped.Bip01_L_UpperArm" 11.679188 0.000001 0.000011 -0.00002 -9.262344 0.000003 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger4" "ValveBiped.Bip01_R_Hand" 3.147156 0.000069 1.551354 -8.213407 -12.98992 -11.535193 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger41" "ValveBiped.Bip01_R_Finger4" 1.585903 0 0 -0.955232 -34.374638 -0.653397 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger42" "ValveBiped.Bip01_R_Finger41" 0.849083 0 0 10.048534 -17.354307 3.121076 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger3" "ValveBiped.Bip01_R_Hand" 3.471106 0.211189 0.574833 -5.954234 -16.777979 -11.130627 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger31" "ValveBiped.Bip01_R_Finger3" 1.89753 0.000002 0 5.063459 -30.512989 2.977607 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger32" "ValveBiped.Bip01_R_Finger31" 1.014442 0.000003 0 -0.559035 -13.904495 -0.138369 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger2" "ValveBiped.Bip01_R_Hand" 3.750099 0.116323 -0.429641 -3.893705 -14.790899 -10.52312 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger21" "ValveBiped.Bip01_R_Finger2" 2.258186 0.000002 0 3.092654 -37.967195 2.410836 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger22" "ValveBiped.Bip01_R_Finger21" 1.210392 0.000001 0 -0.688637 -8.970371 -0.108691 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger1" "ValveBiped.Bip01_R_Hand" 3.868324 -0.161243 -1.490732 -1.961176 -11.693485 -10.145487 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger11" "ValveBiped.Bip01_R_Finger1" 1.786066 0 0 -3.669048 -38.756262 -2.940819 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger12" "ValveBiped.Bip01_R_Finger11" 1.044449 0 0 -2.20932 -1.896563 -0.073162 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger0" "ValveBiped.Bip01_R_Hand" 1.121504 -1.347836 -1.03588 19.767273 -7.037112 -96.832917 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger01" "ValveBiped.Bip01_R_Finger0" 1.928122 0.000002 0 10.778421 -10.615991 0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Finger02" "ValveBiped.Bip01_R_Finger01" 1.285137 0.000002 0.000002 2.328843 11.249042 -0.000001 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Wrist" "ValveBiped.Bip01_R_Forearm" 11.768707 -0.000001 -0.000011 0.00002 0 13.903739 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Ulna" "ValveBiped.Bip01_R_Forearm" 5.884361 0 -0.000004 0.00002 0 7.369183 0 0 0 0 0 0
$definebone "ValveBiped.Bip01_R_Elbow" "ValveBiped.Bip01_R_UpperArm" 11.679192 0 0 0.000022 -9.26229 -0.000004 0 0 0 0 0 0
$definebone "ValveBiped.attachment_bandage_legL" "ValveBiped.Bip01_L_Calf" 7.023272 -6.880002 4.339548 -83.423261 -63.332738 150.153431 0 0 0 0 0 0
$definebone "ValveBiped.attachment_bandage_armL" "ValveBiped.Bip01_L_Forearm" 3.813801 -3.870655 0.998562 -61.285737 11.452965 89.999975 0 0 0 0 0 0
$definebone "ValveBiped.attachment_armL_T" "ValveBiped.Bip01_L_Forearm" 0 -0.000007 -0.000027 6.5073 7.122672 78.669798 0 0 0 0 0 0
$definebone "ValveBiped.attachment_armR_T" "ValveBiped.Bip01_R_Forearm" 0 -0.000008 -0.000034 6.507325 7.122669 78.669798 0 0 0 0 0 0
$definebone "ValveBiped.L_weapon_bone" "ValveBiped.Bip01_L_Hand" 3.349001 -1.370996 0.724998 -5.043001 89.255 113.322004 0 0 0 0 0 0
$definebone "ValveBiped.weapon_bone" "ValveBiped.Bip01_R_Hand" 2.856895 -1.536198 -0.9738 -15.616422 -90.427695 -86.009389 0 0 0 0 0 0
$definebone "ValveBiped.weapon_bone_Clip" "ValveBiped.weapon_bone" -0.000004 0 10 0.000007 0.000001 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.weapon_bone_extra" "ValveBiped.weapon_bone" 0.018896 0.665159 9.395878 0.000007 0.000001 -0.000002 0 0 0 0 0 0
$definebone "ValveBiped.forward" "ValveBiped.Bip01_Head1" 2 -3 0 0 -76 -90.000003 0 0 0 0 0 0

$bonemerge "ValveBiped.Bip01_Pelvis"
$bonemerge "ValveBiped.Bip01_Spine"
$bonemerge "ValveBiped.Bip01_Spine1"
$bonemerge "ValveBiped.Bip01_Spine2"
$bonemerge "ValveBiped.Bip01_Spine4"
$bonemerge "ValveBiped.Bip01_R_Clavicle"
$bonemerge "ValveBiped.Bip01_R_UpperArm"
$bonemerge "ValveBiped.Bip01_R_Forearm"
$bonemerge "ValveBiped.Bip01_L_Clavicle"
$bonemerge "ValveBiped.Bip01_L_UpperArm"
$bonemerge "ValveBiped.Bip01_L_Forearm"
$bonemerge "ValveBiped.Bip01_L_Hand"
$bonemerge "ValveBiped.Bip01_R_Hand"
$bonemerge "ValveBiped.Bip01_L_Finger4"
$bonemerge "ValveBiped.Bip01_L_Finger41"
$bonemerge "ValveBiped.Bip01_L_Finger42"
$bonemerge "ValveBiped.Bip01_L_Finger3"
$bonemerge "ValveBiped.Bip01_L_Finger31"
$bonemerge "ValveBiped.Bip01_L_Finger32"
$bonemerge "ValveBiped.Bip01_L_Finger2"
$bonemerge "ValveBiped.Bip01_L_Finger21"
$bonemerge "ValveBiped.Bip01_L_Finger22"
$bonemerge "ValveBiped.Bip01_L_Finger1"
$bonemerge "ValveBiped.Bip01_L_Finger11"
$bonemerge "ValveBiped.Bip01_L_Finger12"
$bonemerge "ValveBiped.Bip01_L_Finger0"
$bonemerge "ValveBiped.Bip01_L_Finger01"
$bonemerge "ValveBiped.Bip01_L_Finger02"
$bonemerge "ValveBiped.Bip01_L_Ulna"
$bonemerge "ValveBiped.Bip01_L_Wrist"
$bonemerge "ValveBiped.Bip01_R_Finger4"
$bonemerge "ValveBiped.Bip01_R_Finger41"
$bonemerge "ValveBiped.Bip01_R_Finger42"
$bonemerge "ValveBiped.Bip01_R_Finger3"
$bonemerge "ValveBiped.Bip01_R_Finger31"
$bonemerge "ValveBiped.Bip01_R_Finger32"
$bonemerge "ValveBiped.Bip01_R_Finger2"
$bonemerge "ValveBiped.Bip01_R_Finger21"
$bonemerge "ValveBiped.Bip01_R_Finger22"
$bonemerge "ValveBiped.Bip01_R_Finger1"
$bonemerge "ValveBiped.Bip01_R_Finger11"
$bonemerge "ValveBiped.Bip01_R_Finger12"
$bonemerge "ValveBiped.Bip01_R_Finger0"
$bonemerge "ValveBiped.Bip01_R_Finger01"
$bonemerge "ValveBiped.Bip01_R_Finger02"
$bonemerge "ValveBiped.Bip01_R_Wrist"
$bonemerge "ValveBiped.Bip01_R_Ulna"
$bonemerge "ValveBiped.L_weapon_bone"
$bonemerge "ValveBiped.weapon_bone"
$bonemerge "ValveBiped.weapon_bone_Clip"
$bonemerge "ValveBiped.weapon_bone_extra"


$sectionframes 30 28

$sequence "DanceMoves" {
	"fnemotes_l4d2_anims\DanceMoves.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Mask_Off_Intro" {
	"fnemotes_l4d2_anims\Emote_Mask_Off_Intro.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Mask_Off_Loop" {
	"fnemotes_l4d2_anims\Emote_Mask_Off_Loop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Zippy_Dance" {
	"fnemotes_l4d2_anims\Emote_Zippy_Dance.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "ElectroShuffle" {
	"fnemotes_l4d2_anims\ElectroShuffle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_AerobicChamp" {
	"fnemotes_l4d2_anims\Emote_AerobicChamp.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Bendy" {
	"fnemotes_l4d2_anims\Emote_Bendy.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_BandOfTheFort" {
	"fnemotes_l4d2_anims\Emote_BandOfTheFort.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Boogie_Down_Intro" {
	"fnemotes_l4d2_anims\Emote_Boogie_Down_Intro.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Boogie_Down" {
	"fnemotes_l4d2_anims\Emote_Boogie_Down.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Capoeira" {
	"fnemotes_l4d2_anims\Emote_Capoeira.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Charleston" {
	"fnemotes_l4d2_anims\Emote_Charleston.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Chicken" {
	"fnemotes_l4d2_anims\Emote_Chicken.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_NoBones" {
	"fnemotes_l4d2_anims\Emote_Dance_NoBones.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Shoot" {
	"fnemotes_l4d2_anims\Emote_Dance_Shoot.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_SwipeIt" {
	"fnemotes_l4d2_anims\Emote_Dance_SwipeIt.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Disco_T3" {
	"fnemotes_l4d2_anims\Emote_Dance_Disco_T3.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_DG_Disco" {
	"fnemotes_l4d2_anims\Emote_DG_Disco.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Worm" {
	"fnemotes_l4d2_anims\Emote_Dance_Worm.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Loser" {
	"fnemotes_l4d2_anims\Emote_Dance_Loser.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Loser_CT" {
	"fnemotes_l4d2_anims\Emote_Dance_Loser_CT.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Breakdance" {
	"fnemotes_l4d2_anims\Emote_Dance_Breakdance.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Dance_Pump" {
	"fnemotes_l4d2_anims\Emote_Dance_Pump.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_RideThePony" {
	"fnemotes_l4d2_anims\Emote_Dance_RideThePony.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Dab" {
	"fnemotes_l4d2_anims\Emote_Dab.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_EasternBloc_Start" {
	"fnemotes_l4d2_anims\Emote_EasternBloc_Start.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_EasternBloc" {
	"fnemotes_l4d2_anims\Emote_EasternBloc.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_FancyFeet" {
	"fnemotes_l4d2_anims\Emote_FancyFeet.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_FancyFeet_CT" {
	"fnemotes_l4d2_anims\Emote_FancyFeet_CT.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_FlossDance" {
	"fnemotes_l4d2_anims\Emote_FlossDance.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_FlippnSexy" {
	"fnemotes_l4d2_anims\Emote_FlippnSexy.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Fresh" {
	"fnemotes_l4d2_anims\Emote_Fresh.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_GrooveJam" {
	"fnemotes_l4d2_anims\Emote_GrooveJam.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_guitar" {
	"fnemotes_l4d2_anims\Emote_guitar.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Hillbilly_Shuffle_Intro" {
	"fnemotes_l4d2_anims\Emote_Hillbilly_Shuffle_Intro.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Hillbilly_Shuffle" {
	"fnemotes_l4d2_anims\Emote_Hillbilly_Shuffle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Hiphop_01" {
	"fnemotes_l4d2_anims\Emote_Hiphop_01.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Hip_Hop" {
	"fnemotes_l4d2_anims\Emote_Hip_Hop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Hula_Start" {
	"fnemotes_l4d2_anims\Emote_Hula_Start.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Hula" {
	"fnemotes_l4d2_anims\Emote_Hula.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_InfiniDab_Intro" {
	"fnemotes_l4d2_anims\Emote_InfiniDab_Intro.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_InfiniDab_Loop" {
	"fnemotes_l4d2_anims\Emote_InfiniDab_Loop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Intensity_Start" {
	"fnemotes_l4d2_anims\Emote_Intensity_Start.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Intensity_Loop" {
	"fnemotes_l4d2_anims\Emote_Intensity_Loop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_IrishJig_Start" {
	"fnemotes_l4d2_anims\Emote_IrishJig_Start.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_IrishJig" {
	"fnemotes_l4d2_anims\Emote_IrishJig.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_KoreanEagle" {
	"fnemotes_l4d2_anims\Emote_KoreanEagle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Kpop_02" {
	"fnemotes_l4d2_anims\Emote_Kpop_02.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_LivingLarge" {
	"fnemotes_l4d2_anims\Emote_LivingLarge.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Maracas" {
	"fnemotes_l4d2_anims\Emote_Maracas.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_PopLock" {
	"fnemotes_l4d2_anims\Emote_PopLock.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_PopRock" {
	"fnemotes_l4d2_anims\Emote_PopRock.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_RobotDance" {
	"fnemotes_l4d2_anims\Emote_RobotDance.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_T-Rex" {
	"fnemotes_l4d2_anims\Emote_T-Rex.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_TechnoZombie" {
	"fnemotes_l4d2_anims\Emote_TechnoZombie.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Twist" {
	"fnemotes_l4d2_anims\Emote_Twist.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_WarehouseDance_Start" {
	"fnemotes_l4d2_anims\Emote_WarehouseDance_Start.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_WarehouseDance_Loop" {
	"fnemotes_l4d2_anims\Emote_WarehouseDance_Loop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Wiggle" {
	"fnemotes_l4d2_anims\Emote_Wiggle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Youre_Awesome" {
	"fnemotes_l4d2_anims\Emote_Youre_Awesome.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Fonzie_Pistol" {
	"fnemotes_l4d2_anims\Emote_Fonzie_Pistol.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Bring_It_On" {
	"fnemotes_l4d2_anims\Emote_Bring_It_On.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_ThumbsDown" {
	"fnemotes_l4d2_anims\Emote_ThumbsDown.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_ThumbsUp" {
	"fnemotes_l4d2_anims\Emote_ThumbsUp.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Celebration_Loop" {
	"fnemotes_l4d2_anims\Emote_Celebration_Loop.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_BlowKiss" {
	"fnemotes_l4d2_anims\Emote_BlowKiss.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Calculated" {
	"fnemotes_l4d2_anims\Emote_Calculated.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Confused" {
	"fnemotes_l4d2_anims\Emote_Confused.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Chug" {
	"fnemotes_l4d2_anims\Emote_Chug.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Cry" {
	"fnemotes_l4d2_anims\Emote_Cry.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_DustingOffHands" {
	"fnemotes_l4d2_anims\Emote_DustingOffHands.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_DustOffShoulders" {
	"fnemotes_l4d2_anims\Emote_DustOffShoulders.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Facepalm" {
	"fnemotes_l4d2_anims\Emote_Facepalm.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Fishing" {
	"fnemotes_l4d2_anims\Emote_Fishing.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Flex" {
	"fnemotes_l4d2_anims\Emote_Flex.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_golfclap" {
	"fnemotes_l4d2_anims\Emote_golfclap.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_HandSignals" {
	"fnemotes_l4d2_anims\Emote_HandSignals.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_HeelClick" {
	"fnemotes_l4d2_anims\Emote_HeelClick.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Hotstuff" {
	"fnemotes_l4d2_anims\Emote_Hotstuff.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_IBreakYou" {
	"fnemotes_l4d2_anims\Emote_IBreakYou.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_IHeartYou" {
	"fnemotes_l4d2_anims\Emote_IHeartYou.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Kung-Fu_Salute" {
	"fnemotes_l4d2_anims\Emote_Kung-Fu_Salute.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Laugh" {
	"fnemotes_l4d2_anims\Emote_Laugh.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Laugh_CT" {
	"fnemotes_l4d2_anims\Emote_Laugh_CT.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Luchador" {
	"fnemotes_l4d2_anims\Emote_Luchador.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Make_It_Rain" {
	"fnemotes_l4d2_anims\Emote_Make_It_Rain.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_NotToday" {
	"fnemotes_l4d2_anims\Emote_NotToday.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_RockPaperScissor_Paper" {
	"fnemotes_l4d2_anims\Emote_RockPaperScissor_Paper.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_RockPaperScissor_Rock" {
	"fnemotes_l4d2_anims\Emote_RockPaperScissor_Rock.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_RockPaperScissor_Scissor" {
	"fnemotes_l4d2_anims\Emote_RockPaperScissor_Scissor.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Salt" {
	"fnemotes_l4d2_anims\Emote_Salt.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Salute" {
	"fnemotes_l4d2_anims\Emote_Salute.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_SmoothDrive" {
	"fnemotes_l4d2_anims\Emote_SmoothDrive.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Snap" {
	"fnemotes_l4d2_anims\Emote_Snap.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_StageBow" {
	"fnemotes_l4d2_anims\Emote_StageBow.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Wave2" {
	"fnemotes_l4d2_anims\Emote_Wave2.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Yeet" {
	"fnemotes_l4d2_anims\Emote_Yeet.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "DanceMoves_F" {
	"fnemotes_l4d2_anims\DanceMoves_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Mask_Off_Intro_F" {
	"fnemotes_l4d2_anims\Emote_Mask_Off_Intro_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Mask_Off_Loop_F" {
	"fnemotes_l4d2_anims\Emote_Mask_Off_Loop_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Zippy_Dance_F" {
	"fnemotes_l4d2_anims\Emote_Zippy_Dance_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "ElectroShuffle_F" {
	"fnemotes_l4d2_anims\ElectroShuffle_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_AerobicChamp_F" {
	"fnemotes_l4d2_anims\Emote_AerobicChamp_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Bendy_F" {
	"fnemotes_l4d2_anims\Emote_Bendy_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_BandOfTheFort_F" {
	"fnemotes_l4d2_anims\Emote_BandOfTheFort_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Boogie_Down_Intro_F" {
	"fnemotes_l4d2_anims\Emote_Boogie_Down_Intro_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Boogie_Down_F" {
	"fnemotes_l4d2_anims\Emote_Boogie_Down_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Capoeira_F" {
	"fnemotes_l4d2_anims\Emote_Capoeira_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Charleston_F" {
	"fnemotes_l4d2_anims\Emote_Charleston_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Chicken_F" {
	"fnemotes_l4d2_anims\Emote_Chicken_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_NoBones_F" {
	"fnemotes_l4d2_anims\Emote_Dance_NoBones_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Shoot_F" {
	"fnemotes_l4d2_anims\Emote_Dance_Shoot_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_SwipeIt_F" {
	"fnemotes_l4d2_anims\Emote_Dance_SwipeIt_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Disco_T3_F" {
	"fnemotes_l4d2_anims\Emote_Dance_Disco_T3_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_DG_Disco_F" {
	"fnemotes_l4d2_anims\Emote_DG_Disco_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Worm_F" {
	"fnemotes_l4d2_anims\Emote_Dance_Worm_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Loser_F" {
	"fnemotes_l4d2_anims\Emote_Dance_Loser_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Loser_CT_F" {
	"fnemotes_l4d2_anims\Emote_Dance_Loser_CT_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_Breakdance_F" {
	"fnemotes_l4d2_anims\Emote_Dance_Breakdance_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Dance_Pump_F" {
	"fnemotes_l4d2_anims\Emote_Dance_Pump_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Dance_RideThePony_F" {
	"fnemotes_l4d2_anims\Emote_Dance_RideThePony_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Dab_F" {
	"fnemotes_l4d2_anims\Emote_Dab_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_EasternBloc_Start_F" {
	"fnemotes_l4d2_anims\Emote_EasternBloc_Start_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_EasternBloc_F" {
	"fnemotes_l4d2_anims\Emote_EasternBloc_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_FancyFeet_F" {
	"fnemotes_l4d2_anims\Emote_FancyFeet_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_FancyFeet_CT_F" {
	"fnemotes_l4d2_anims\Emote_FancyFeet_CT_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_FlossDance_F" {
	"fnemotes_l4d2_anims\Emote_FlossDance_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_FlippnSexy_F" {
	"fnemotes_l4d2_anims\Emote_FlippnSexy_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Fresh_F" {
	"fnemotes_l4d2_anims\Emote_Fresh_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_GrooveJam_F" {
	"fnemotes_l4d2_anims\Emote_GrooveJam_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_guitar_F" {
	"fnemotes_l4d2_anims\Emote_guitar_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Hillbilly_Shuffle_Intro_F" {
	"fnemotes_l4d2_anims\Emote_Hillbilly_Shuffle_Intro_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Hillbilly_Shuffle_F" {
	"fnemotes_l4d2_anims\Emote_Hillbilly_Shuffle_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Hiphop_01_F" {
	"fnemotes_l4d2_anims\Emote_Hiphop_01_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Hip_Hop_F" {
	"fnemotes_l4d2_anims\Emote_Hip_Hop_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Hula_Start_F" {
	"fnemotes_l4d2_anims\Emote_Hula_Start_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Hula_F" {
	"fnemotes_l4d2_anims\Emote_Hula_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_InfiniDab_Intro_F" {
	"fnemotes_l4d2_anims\Emote_InfiniDab_Intro_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_InfiniDab_Loop_F" {
	"fnemotes_l4d2_anims\Emote_InfiniDab_Loop_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Intensity_Start_F" {
	"fnemotes_l4d2_anims\Emote_Intensity_Start_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Intensity_Loop_F" {
	"fnemotes_l4d2_anims\Emote_Intensity_Loop_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_IrishJig_Start_F" {
	"fnemotes_l4d2_anims\Emote_IrishJig_Start_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_IrishJig_F" {
	"fnemotes_l4d2_anims\Emote_IrishJig_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_KoreanEagle_F" {
	"fnemotes_l4d2_anims\Emote_KoreanEagle_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Kpop_02_F" {
	"fnemotes_l4d2_anims\Emote_Kpop_02_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_LivingLarge_F" {
	"fnemotes_l4d2_anims\Emote_LivingLarge_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Maracas_F" {
	"fnemotes_l4d2_anims\Emote_Maracas_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_PopLock_F" {
	"fnemotes_l4d2_anims\Emote_PopLock_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_PopRock_F" {
	"fnemotes_l4d2_anims\Emote_PopRock_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_RobotDance_F" {
	"fnemotes_l4d2_anims\Emote_RobotDance_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_T-Rex_F" {
	"fnemotes_l4d2_anims\Emote_T-Rex_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_TechnoZombie_F" {
	"fnemotes_l4d2_anims\Emote_TechnoZombie_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Twist_F" {
	"fnemotes_l4d2_anims\Emote_Twist_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_WarehouseDance_Start_F" {
	"fnemotes_l4d2_anims\Emote_WarehouseDance_Start_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_WarehouseDance_Loop_F" {
	"fnemotes_l4d2_anims\Emote_WarehouseDance_Loop_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Wiggle_F" {
	"fnemotes_l4d2_anims\Emote_Wiggle_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Youre_Awesome_F" {
	"fnemotes_l4d2_anims\Emote_Youre_Awesome_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Fonzie_Pistol_F" {
	"fnemotes_l4d2_anims\Emote_Fonzie_Pistol_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Bring_It_On_F" {
	"fnemotes_l4d2_anims\Emote_Bring_It_On_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_ThumbsDown_F" {
	"fnemotes_l4d2_anims\Emote_ThumbsDown_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_ThumbsUp_F" {
	"fnemotes_l4d2_anims\Emote_ThumbsUp_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Celebration_Loop_F" {
	"fnemotes_l4d2_anims\Emote_Celebration_Loop_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_BlowKiss_F" {
	"fnemotes_l4d2_anims\Emote_BlowKiss_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Calculated_F" {
	"fnemotes_l4d2_anims\Emote_Calculated_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Confused_F" {
	"fnemotes_l4d2_anims\Emote_Confused_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Chug_F" {
	"fnemotes_l4d2_anims\Emote_Chug_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Cry_F" {
	"fnemotes_l4d2_anims\Emote_Cry_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_DustingOffHands_F" {
	"fnemotes_l4d2_anims\Emote_DustingOffHands_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_DustOffShoulders_F" {
	"fnemotes_l4d2_anims\Emote_DustOffShoulders_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Facepalm_F" {
	"fnemotes_l4d2_anims\Emote_Facepalm_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Fishing_F" {
	"fnemotes_l4d2_anims\Emote_Fishing_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Flex_F" {
	"fnemotes_l4d2_anims\Emote_Flex_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_golfclap_F" {
	"fnemotes_l4d2_anims\Emote_golfclap_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_HandSignals_F" {
	"fnemotes_l4d2_anims\Emote_HandSignals_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_HeelClick_F" {
	"fnemotes_l4d2_anims\Emote_HeelClick_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Hotstuff_F" {
	"fnemotes_l4d2_anims\Emote_Hotstuff_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_IBreakYou_F" {
	"fnemotes_l4d2_anims\Emote_IBreakYou_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_IHeartYou_F" {
	"fnemotes_l4d2_anims\Emote_IHeartYou_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Kung-Fu_Salute_F" {
	"fnemotes_l4d2_anims\Emote_Kung-Fu_Salute_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Laugh_F" {
	"fnemotes_l4d2_anims\Emote_Laugh_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Laugh_CT_F" {
	"fnemotes_l4d2_anims\Emote_Laugh_CT_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Luchador_F" {
	"fnemotes_l4d2_anims\Emote_Luchador_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Make_It_Rain_F" {
	"fnemotes_l4d2_anims\Emote_Make_It_Rain_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_NotToday_F" {
	"fnemotes_l4d2_anims\Emote_NotToday_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_RockPaperScissor_Paper_F" {
	"fnemotes_l4d2_anims\Emote_RockPaperScissor_Paper_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_RockPaperScissor_Rock_F" {
	"fnemotes_l4d2_anims\Emote_RockPaperScissor_Rock_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_RockPaperScissor_Scissor_F" {
	"fnemotes_l4d2_anims\Emote_RockPaperScissor_Scissor_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Salt_F" {
	"fnemotes_l4d2_anims\Emote_Salt_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Salute_F" {
	"fnemotes_l4d2_anims\Emote_Salute_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_SmoothDrive_F" {
	"fnemotes_l4d2_anims\Emote_SmoothDrive_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
	loop
}

$sequence "Emote_Snap_F" {
	"fnemotes_l4d2_anims\Emote_Snap_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_StageBow_F" {
	"fnemotes_l4d2_anims\Emote_StageBow_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Wave2_F" {
	"fnemotes_l4d2_anims\Emote_Wave2_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$sequence "Emote_Yeet_F" {
	"fnemotes_l4d2_anims\Emote_Yeet_F.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$keyvalues
{
// CSGO compiler adds the qc_path keyvalue section automatically.
//	qc_path 
//	{
//		"value" "f:\works\models\sources\animset fortnite emotes\animset_fortnite_emotes_v2.qc"
//	}
}
