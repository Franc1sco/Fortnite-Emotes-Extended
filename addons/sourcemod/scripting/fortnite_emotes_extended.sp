#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#pragma newdecls required

#define     FlashbangOffset         15

Handle g_cvThirdperson;

Handle g_cvSaveWeaponsRoundEnd;
Handle g_cvCooldown;
Handle g_cvEmotesSounds;

bool g_bHalfTime;
bool g_bWarmUp;

bool g_bPlayerHurtHooked;

int g_iEmoteEnt[MAXPLAYERS+1];
int g_iEmoteSoundEnt[MAXPLAYERS+1];

char g_sEmoteSound[MAXPLAYERS+1][PLATFORM_MAX_PATH];

bool g_bClientDancing[MAXPLAYERS+1];

float g_fLastAngles[MAXPLAYERS+1][3];
float g_fLastPosition[MAXPLAYERS+1][3];

char g_sPrimaryWeapon[MAXPLAYERS + 1][32];
char g_sSecondaryWeapon[MAXPLAYERS + 1][32];
char g_sKnife[MAXPLAYERS + 1][32];
char g_sGrenades[MAXPLAYERS + 1][4][32];
bool g_bTaser[MAXPLAYERS + 1];

int g_iPrimaryWeaponClip[MAXPLAYERS+1];
int g_iPrimaryWeaponAmmo[MAXPLAYERS+1];

int g_iSecondaryWeaponClip[MAXPLAYERS+1];
int g_iSecondaryWeaponAmmo[MAXPLAYERS+1];

int g_iTaserClip[MAXPLAYERS+1];
int g_iTaserAmmo[MAXPLAYERS+1];

int g_iFlashbangAmmo[MAXPLAYERS+1];

Handle CooldownTimers[MAXPLAYERS+1];
bool g_bEmoteCooldown[MAXPLAYERS+1];

public Plugin myinfo =
{
	name = "SM Fortnite Emotes Extended",
	author = "Kodua, Franc1sco franug, TheBO$$",
	description = "This plugin is for demonstration of some animations from Fortnite in CS:GO",
	version = "1.0.3",
	url = "https://github.com/Franc1sco/Fortnite-Emotes-Extended"
};

public void OnPluginStart()
{	
	RegConsoleCmd("emotes", Command_Menu);
	RegConsoleCmd("emote", Command_Menu);
	RegConsoleCmd("dance", Command_Menu);
	RegConsoleCmd("danc", Command_Menu);
	RegConsoleCmd("dances", Command_Menu);

	HookEvent("player_death", 	Event_PlayerDeath, 	EventHookMode_Pre);

	HookEvent("bomb_planted", 	Event_BombPlanted);

	HookEvent("round_start", 	Event_RoundStart, 	EventHookMode_PostNoCopy);

	HookEvent("announce_phase_end", 	Event_HalfTime, 	EventHookMode_PostNoCopy);

	HookEvent("round_announce_warmup", 	Event_WarmUp, 	EventHookMode_PostNoCopy);//warmup START
	HookEvent("round_announce_match_start", 	Event_MatchStart, 	EventHookMode_PostNoCopy);//warmup END

	g_cvSaveWeaponsRoundEnd = CreateConVar("sm_emotes_save_weapons_round_end", "1", "Save players' weapons after round end (only for dancing players). Set it to 0 if you're running jail, retake, etc.", _, true, 0.0, true, 1.0);
	g_cvEmotesSounds = CreateConVar("sm_emotes_sounds", "1", "Enable/Disable sounds for emotes.", _, true, 0.0, true, 1.0);
	g_cvCooldown = CreateConVar("sm_emotes_cooldown", "4.0", "Cooldown for emotes in seconds. -1 or 0 = no cooldown.");

	g_cvThirdperson = FindConVar("sv_allow_thirdperson");
	if (g_cvThirdperson == INVALID_HANDLE)
		SetFailState("sv_allow_thirdperson not found!");

	SetConVarInt(g_cvThirdperson, 1);

	HookConVarChange(g_cvThirdperson, OnConVarChanged);

	AutoExecConfig(true, "fortnite_emotes_extended");
}

public void OnConVarChanged(Handle cvar, const char[] oldVal, const char[] newVal)
{
	if (cvar == g_cvThirdperson)
	{
		if (StringToInt(newVal) != 1)
			SetConVarInt(g_cvThirdperson, 1);
	}
}

public void OnMapStart()
{
	AddFileToDownloadsTable("models/player/custom_player/kodua/fortnite_emotes_v2.mdl");
	AddFileToDownloadsTable("models/player/custom_player/kodua/fortnite_emotes_v2.vvd");
	AddFileToDownloadsTable("models/player/custom_player/kodua/fortnite_emotes_v2.dx90.vtx");

	// edit
	// add the sound file routes here
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/ninja_dance_01.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/dance_soldier_03.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Hip_Hop_Good_Vibes_Mix_01_Loop.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_zippy_A.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_electroshuffle_music.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_aerobics_01.wav"); 
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_music_emotes_bendy.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_bandofthefort_music.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_boogiedown.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_flapper_music.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_chicken_foley_01.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_cry.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_music_boneless.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emotes_music_shoot_v7.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Athena_Emotes_Music_SwipeIt.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_disco.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_worm_music.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_music_emotes_takethel.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_breakdance_music.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Emote_Dance_Pump.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_ridethepony_music_01.mp3"); 
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_facepalm_foley_01.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Athena_Emotes_OnTheHook_02.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_floss_music.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Emote_FlippnSexy.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_fresh_music.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_groove_jam_a.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/br_emote_shred_guitar_mix_03_loop.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Emote_HeelClick.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/s5_hiphop_breakin_132bmp_loop.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Emote_Hotstuff.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_hula_01.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_infinidab.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_Intensity.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_irish_jig_foley_music_loop.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Athena_Music_Emotes_KoreanEagle.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_kpop_01.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_laugh_01.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_LivingLarge_A.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Emote_Luchador.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Emote_Hillbilly_Shuffle.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_samba_new_B.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_makeitrain_music.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Athena_Emote_PopLock.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Emote_PopRock_01.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_robot_music.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_salute_foley_01.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Emote_Snap1.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/emote_stagebow.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Emote_Dino_Complete.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_founders_music.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emotes_music_twist.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Emote_Warehouse.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Wiggle_Music_Loop.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/Emote_Yeet.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/youre_awesome_emote_music.mp3");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emotes_lankylegs_loop_02.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/eastern_bloc_musc_setup_d.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_bandofthefort_music.wav");
	AddFileToDownloadsTable("sound/kodua/fortnite_emotes/athena_emote_hot_music.wav");
    

	// this dont touch
	PrecacheModel("models/player/custom_player/kodua/fortnite_emotes_v2.mdl", true);

	// edit
	// add mp3 files without sound/
	// add wav files with */
	PrecacheSound("kodua/fortnite_emotes/ninja_dance_01.mp3");
	PrecacheSound("kodua/fortnite_emotes/dance_soldier_03.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/Hip_Hop_Good_Vibes_Mix_01_Loop.wav");
	PrecacheSound("*/kodua/fortnite_emotes/emote_zippy_A.wav");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_electroshuffle_music.wav");
	PrecacheSound("*/kodua/fortnite_emotes/emote_aerobics_01.wav");
	PrecacheSound("*/kodua/fortnite_emotes/athena_music_emotes_bendy.wav");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_bandofthefort_music.wav");
	PrecacheSound("*/kodua/fortnite_emotes/emote_boogiedown.wav");
	PrecacheSound("kodua/fortnite_emotes/emote_capoeira.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_flapper_music.wav");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_chicken_foley_01.wav");
	PrecacheSound("kodua/fortnite_emotes/emote_cry.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_music_boneless.wav");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emotes_music_shoot_v7.wav");
	PrecacheSound("*/kodua/fortnite_emotes/Athena_Emotes_Music_SwipeIt.wav");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_disco.wav");
	PrecacheSound("kodua/fortnite_emotes/athena_emote_worm_music.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/athena_music_emotes_takethel.wav");
	PrecacheSound("kodua/fortnite_emotes/athena_emote_breakdance_music.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/Emote_Dance_Pump.wav");
	PrecacheSound("kodua/fortnite_emotes/athena_emote_ridethepony_music_01.mp3");
	PrecacheSound("kodua/fortnite_emotes/athena_emote_facepalm_foley_01.mp3");
	PrecacheSound("kodua/fortnite_emotes/Athena_Emotes_OnTheHook_02.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_floss_music.wav");
	PrecacheSound("kodua/fortnite_emotes/Emote_FlippnSexy.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_fresh_music.wav");
	PrecacheSound("*/kodua/fortnite_emotes/emote_groove_jam_a.wav");
	PrecacheSound("*/kodua/fortnite_emotes/br_emote_shred_guitar_mix_03_loop.wav");
	PrecacheSound("kodua/fortnite_emotes/Emote_HeelClick.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/s5_hiphop_breakin_132bmp_loop.wav");
	PrecacheSound("kodua/fortnite_emotes/Emote_Hotstuff.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/emote_hula_01.wav");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_infinidab.wav");
	PrecacheSound("*/kodua/fortnite_emotes/emote_Intensity.wav");
	PrecacheSound("*/kodua/fortnite_emotes/emote_irish_jig_foley_music_loop.wav");
	PrecacheSound("*/kodua/fortnite_emotes/Athena_Music_Emotes_KoreanEagle.wav");
	PrecacheSound("*/kodua/fortnite_emotes/emote_kpop_01.wav");
	PrecacheSound("kodua/fortnite_emotes/emote_laugh_01.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/emote_LivingLarge_A.wav");
	PrecacheSound("kodua/fortnite_emotes/Emote_Luchador.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/Emote_Hillbilly_Shuffle.wav");
	PrecacheSound("*/kodua/fortnite_emotes/emote_samba_new_B.wav");
	PrecacheSound("kodua/fortnite_emotes/athena_emote_makeitrain_music.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/Athena_Emote_PopLock.wav");
	PrecacheSound("*/kodua/fortnite_emotes/Emote_PopRock_01.wav");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_robot_music.wav");
	PrecacheSound("kodua/fortnite_emotes/athena_emote_salute_foley_01.mp3");
	PrecacheSound("kodua/fortnite_emotes/Emote_Snap1.mp3");
	PrecacheSound("kodua/fortnite_emotes/emote_stagebow.mp3");
	PrecacheSound("kodua/fortnite_emotes/Emote_Dino_Complete.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_founders_music.wav");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emotes_music_twist.wav");
	PrecacheSound("*/kodua/fortnite_emotes/Emote_Warehouse.wav");
	PrecacheSound("*/kodua/fortnite_emotes/Wiggle_Music_Loop.wav");
	PrecacheSound("kodua/fortnite_emotes/Emote_Yeet.mp3");
	PrecacheSound("kodua/fortnite_emotes/youre_awesome_emote_music.mp3");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emotes_lankylegs_loop_02.wav");
	PrecacheSound("*/kodua/fortnite_emotes/eastern_bloc_musc_setup_d.wav");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_bandofthefort_music.wav");
	PrecacheSound("*/kodua/fortnite_emotes/athena_emote_hot_music.wav");
}

public void OnClientPutInServer(int client)
{
	if (IsValidClient(client))
	{	
		ResetCam(client);
		TerminateEmote(client);
		g_bEmoteCooldown[client] = false;

		if (CooldownTimers[client] != null)
		{
			KillTimer(CooldownTimers[client]);
			CooldownTimers[client] = null;
		}
	}
}

public void OnClientDisconnect(int client)
{
	if (IsValidClient(client))
	{
		ResetCam(client);
		TerminateEmote(client);

		if (CooldownTimers[client] != null)
		{
			KillTimer(CooldownTimers[client]);
			CooldownTimers[client] = null;
			g_bEmoteCooldown[client] = false;
		}
	}
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast) 
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if (IsValidClient(client))
	{
		ResetCam(client);
		StopEmote(client);
	}
}

public void Event_BombPlanted(Event event, const char[] name, bool dontBroadcast) 
{
	HookEvent("player_hurt", 	Event_PlayerHurt, 	EventHookMode_Pre);
	g_bPlayerHurtHooked = true;
}

public void Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast) 
{
	int attacker = GetClientOfUserId(event.GetInt("attacker"));

	char sAttacker[16];
	GetEntityClassname(attacker, sAttacker, sizeof(sAttacker));
	if (StrEqual(sAttacker, "worldspawn"))//If player was killed by bomb
	{
		int client = GetClientOfUserId(event.GetInt("userid"));
		StopEmote(client);
	}
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast) 
{
	RearmAllDancers();
	if (g_bPlayerHurtHooked)
	{
		UnhookEvent("player_hurt", 	Event_PlayerHurt, 	EventHookMode_Pre);
		g_bPlayerHurtHooked = false;
	}
}

public void Event_HalfTime(Event event, const char[] name, bool dontBroadcast) 
{
	g_bHalfTime = true;
}

public void Event_MatchStart(Event event, const char[] name, bool dontBroadcast) 
{
	g_bWarmUp = false;
}

public void Event_WarmUp(Event event, const char[] name, bool dontBroadcast)
{
	g_bWarmUp = true;
}

public Action Command_Menu(int client, int args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

	if (!IsPlayerAlive(client))
	{
		ReplyToCommand(client, "\x0E[Emotes]\x07 You must be alive to use this!");
		return Plugin_Handled;
	}

	Menu_Dance(client);

	return Plugin_Handled;
}

public Action CreateEmote(int client, const char[] anim1, const char[] anim2, const char[] soundName, bool isLooped)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

	if (!IsPlayerAlive(client))
	{
		ReplyToCommand(client, "\x0E[Emotes]\x07 You must be alive to use this!");
		return Plugin_Handled;
	}

	if (!(GetEntityFlags(client) & FL_ONGROUND))
	{
		ReplyToCommand(client, "\x0E[Emotes]\x07 You must stay on the ground to use this!");
		return Plugin_Handled;
	}

	if (g_bEmoteCooldown[client])
	{
		ReplyToCommand(client, "\x0E[Emotes]\x07 It is on cooldown!");
		return Plugin_Handled;
	}

	if (StrEqual(anim1, ""))
	{
		ReplyToCommand(client, "\x0E[Emotes]\x07 Argument 1 is invalid!!!");
		return Plugin_Handled;
	}

	if (g_iEmoteEnt[client])
		StopEmote(client);

	if (GetEntityMoveType(client) == MOVETYPE_NONE)
	{
		ReplyToCommand(client, "\x0E[Emotes]\x07 You can't use it right now!");
		return Plugin_Handled;
	}

	int EmoteEnt = CreateEntityByName("prop_dynamic");
	if (IsValidEntity(EmoteEnt))
	{
		SetEntityMoveType(client, MOVETYPE_NONE);
		DisarmPlayer(client);

		float vec[3], ang[3];
		GetClientAbsOrigin(client, vec);
		GetClientAbsAngles(client, ang);

		Array_Copy(vec, g_fLastPosition[client], 3);
		Array_Copy(ang, g_fLastAngles[client], 3);

		char emoteEntName[16];
		FormatEx(emoteEntName, sizeof(emoteEntName), "emoteEnt%i", GetRandomInt(1000000, 9999999));
		
		DispatchKeyValue(EmoteEnt, "targetname", emoteEntName);
		DispatchKeyValue(EmoteEnt, "model", "models/player/custom_player/kodua/fortnite_emotes_v2.mdl");
		DispatchKeyValue(EmoteEnt, "solid", "0");
		DispatchKeyValue(EmoteEnt, "rendermode", "10");

		ActivateEntity(EmoteEnt);
		DispatchSpawn(EmoteEnt);

		TeleportEntity(EmoteEnt, g_fLastPosition[client], g_fLastAngles[client], NULL_VECTOR);
		
		SetVariantString(emoteEntName);
		AcceptEntityInput(client, "SetParent", client, client, 0);

		g_iEmoteEnt[client] = EntIndexToEntRef(EmoteEnt);

		int enteffects = GetEntProp(client, Prop_Send, "m_fEffects");
		enteffects |= 1; /* This is EF_BONEMERGE */
		enteffects |= 16; /* This is EF_NOSHADOW */
		enteffects |= 64; /* This is EF_NORECEIVESHADOW */
		enteffects |= 128; /* This is EF_BONEMERGE_FASTCULL */
		enteffects |= 512; /* This is EF_PARENT_ANIMATES */
		SetEntProp(client, Prop_Send, "m_fEffects", enteffects);

		//Sound

		if (GetConVarBool(g_cvEmotesSounds) && !StrEqual(soundName, ""))
		{
			int EmoteSoundEnt = CreateEntityByName("info_target");
			if (IsValidEntity(EmoteSoundEnt))
			{
				char soundEntName[16];
				FormatEx(soundEntName, sizeof(soundEntName), "soundEnt%i", GetRandomInt(1000000, 9999999));

				DispatchKeyValue(EmoteSoundEnt, "targetname", soundEntName);

				DispatchSpawn(EmoteSoundEnt);

				vec[2] += 72.0;
				TeleportEntity(EmoteSoundEnt, vec, NULL_VECTOR, NULL_VECTOR);

				SetVariantString(emoteEntName);
				AcceptEntityInput(EmoteSoundEnt, "SetParent");

				g_iEmoteSoundEnt[client] = EntIndexToEntRef(EmoteSoundEnt);

				//Formatting sound path

				char soundNameBuffer[64];

				if (StrEqual(soundName, "ninja_dance_01") || StrEqual(soundName, "dance_soldier_03"))
				{
					int randomSound = GetRandomInt(0, 1);
					if(randomSound)
					{
						soundNameBuffer = "ninja_dance_01";
					} else
					{
						soundNameBuffer = "dance_soldier_03";
					}
				} else
				{
					FormatEx(soundNameBuffer, sizeof(soundNameBuffer), "%s", soundName);
				}

				if (isLooped)
				{
					FormatEx(g_sEmoteSound[client], PLATFORM_MAX_PATH, "*/kodua/fortnite_emotes/%s.wav", soundNameBuffer);
				} else
				{
					FormatEx(g_sEmoteSound[client], PLATFORM_MAX_PATH, "kodua/fortnite_emotes/%s.mp3", soundNameBuffer);
				}

				EmitSoundToAll(g_sEmoteSound[client], EmoteSoundEnt, SNDCHAN_AUTO, SNDLEVEL_CONVO, _, 0.8, _, _, vec, _, _, _);
			}
		} else
		{
			g_sEmoteSound[client] = "";
		}

		if (StrEqual(anim2, "none", false))
		{
			HookSingleEntityOutput(EmoteEnt, "OnAnimationDone", EndAnimation, true);
		} else
		{
			SetVariantString(anim2);
			AcceptEntityInput(EmoteEnt, "SetDefaultAnimation", -1, -1, 0);
		}

		SetVariantString(anim1);
		AcceptEntityInput(EmoteEnt, "SetAnimation", -1, -1, 0);

		SetCam(client);

		g_bClientDancing[client] = true;

		if (GetConVarFloat(g_cvCooldown) > 0.0)
		{
			g_bEmoteCooldown[client] = true;
			CooldownTimers[client] = CreateTimer(GetConVarFloat(g_cvCooldown), ResetCooldown, client);
		}
	}
	return Plugin_Handled;
}

public Action OnPlayerRunCmd(int client, int &iButtons, int &iImpulse, float fVelocity[3], float fAngles[3], int &iWeapon)
{
	if (g_bClientDancing[client] && !(GetEntityFlags(client) & FL_ONGROUND))
		StopEmote(client);

	static int iAllowedButtons = IN_BACK | IN_FORWARD | IN_MOVELEFT | IN_MOVERIGHT | IN_JUMP | IN_WALK | IN_SPEED | IN_SCORE;

	if (iButtons == 0)
		return Plugin_Continue;

	if (g_iEmoteEnt[client] == 0)
		return Plugin_Continue;

	if ((iButtons & iAllowedButtons) && !(iButtons &~ iAllowedButtons)) 
		return Plugin_Continue;

	StopEmote(client);

	return Plugin_Continue;
}

public void EndAnimation(const char[] output, int caller, int activator, float delay) 
{
	if (caller > 0)
	{
		activator = GetEmoteActivator(EntIndexToEntRef(caller));
		StopEmote(activator);
	}
}

int GetEmoteActivator(int iEntRefDancer)
{
	if (iEntRefDancer == INVALID_ENT_REFERENCE)
		return 0;
	
	for (int i = 1; i <= MaxClients; i++) 
	{
		if (g_iEmoteEnt[i] == iEntRefDancer) 
		{
			return i;
		}
	}
	return 0;
}

void StopEmote(int client)
{
	if (!g_iEmoteEnt[client])
		return;

	int iEmoteEnt = EntRefToEntIndex(g_iEmoteEnt[client]);
	if (iEmoteEnt && iEmoteEnt != INVALID_ENT_REFERENCE && IsValidEntity(iEmoteEnt))
	{
		AcceptEntityInput(client, "ClearParent", client, client, 0);
		AcceptEntityInput(iEmoteEnt, "Kill");

		TeleportEntity(client, g_fLastPosition[client], g_fLastAngles[client], NULL_VECTOR);
		ResetCam(client);
		RearmPlayerWithAmmo(client);
		SetEntityMoveType(client, MOVETYPE_WALK);

		g_iEmoteEnt[client] = 0;
		g_bClientDancing[client] = false;
	} else
	{
		g_iEmoteEnt[client] = 0;
		g_bClientDancing[client] = false;
	}

	if (g_iEmoteSoundEnt[client])
	{
		int iEmoteSoundEnt = EntRefToEntIndex(g_iEmoteSoundEnt[client]);

		if (!StrEqual(g_sEmoteSound[client], "") && iEmoteSoundEnt && iEmoteSoundEnt != INVALID_ENT_REFERENCE && IsValidEntity(iEmoteSoundEnt))
		{
			StopSound(iEmoteSoundEnt, SNDCHAN_AUTO, g_sEmoteSound[client]);
			AcceptEntityInput(iEmoteSoundEnt, "Kill");
			g_iEmoteSoundEnt[client] = 0;
		} else
		{
			g_iEmoteSoundEnt[client] = 0;
		}
	}
}

void TerminateEmote(int client)
{
	if (!g_iEmoteEnt[client])
		return;

	int iEmoteEnt = EntRefToEntIndex(g_iEmoteEnt[client]);
	if (iEmoteEnt && iEmoteEnt != INVALID_ENT_REFERENCE && IsValidEntity(iEmoteEnt))
	{
		AcceptEntityInput(client, "ClearParent", client, client, 0);
		AcceptEntityInput(iEmoteEnt, "Kill");

		g_iEmoteEnt[client] = 0;
		g_bClientDancing[client] = false;
	} else
	{
		g_iEmoteEnt[client] = 0;
		g_bClientDancing[client] = false;
	}

	if (g_iEmoteSoundEnt[client])
	{
		int iEmoteSoundEnt = EntRefToEntIndex(g_iEmoteSoundEnt[client]);

		if (!StrEqual(g_sEmoteSound[client], "") && iEmoteSoundEnt && iEmoteSoundEnt != INVALID_ENT_REFERENCE && IsValidEntity(iEmoteSoundEnt))
		{
			StopSound(iEmoteSoundEnt, SNDCHAN_AUTO, g_sEmoteSound[client]);
			AcceptEntityInput(iEmoteSoundEnt, "Kill");
			g_iEmoteSoundEnt[client] = 0;
		} else
		{
			g_iEmoteSoundEnt[client] = 0;
		}
	}
}

void DisarmPlayer(int client)
{
	//Primary weapon
	int iPrimary = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
	if (IsValidEntity(iPrimary) && iPrimary != INVALID_ENT_REFERENCE && iPrimary != -1)
	{
		switch(GetEntProp(iPrimary, Prop_Send, "m_iItemDefinitionIndex"))
		{
			case 23: Format(g_sPrimaryWeapon[client], sizeof(g_sPrimaryWeapon[]), "weapon_mp5sd");
			case 60: Format(g_sPrimaryWeapon[client], sizeof(g_sPrimaryWeapon[]), "weapon_m4a1_silencer");
			default: GetEntityClassname(iPrimary, g_sPrimaryWeapon[client], sizeof(g_sPrimaryWeapon[]));
		}

		g_iPrimaryWeaponClip[client] = Weapon_GetPrimaryClip(iPrimary);
		g_iPrimaryWeaponAmmo[client] = GetEntProp(iPrimary, Prop_Send, "m_iPrimaryReserveAmmoCount");

		RemovePlayerItem(client, iPrimary);
		AcceptEntityInput(iPrimary, "Kill");
	} else
	{
		Format(g_sPrimaryWeapon[client], sizeof(g_sPrimaryWeapon[]), "empty");
	}

	//Secondary weapon
	int iSecondary = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
	if (IsValidEntity(iSecondary) && iSecondary != INVALID_ENT_REFERENCE && iSecondary != -1)
	{
		switch(GetEntProp(iSecondary, Prop_Send, "m_iItemDefinitionIndex")) 
		{
			case 61: Format(g_sSecondaryWeapon[client], sizeof(g_sSecondaryWeapon[]), "weapon_usp_silencer");
			case 63: Format(g_sSecondaryWeapon[client], sizeof(g_sSecondaryWeapon[]), "weapon_cz75a");
			case 64: Format(g_sSecondaryWeapon[client], sizeof(g_sSecondaryWeapon[]), "weapon_revolver");
			default: GetEntityClassname(iSecondary, g_sSecondaryWeapon[client], sizeof(g_sSecondaryWeapon[]));
		}

		g_iSecondaryWeaponClip[client] = Weapon_GetPrimaryClip(iSecondary);
		g_iSecondaryWeaponAmmo[client] = GetEntProp(iSecondary, Prop_Send, "m_iPrimaryReserveAmmoCount");

		RemovePlayerItem(client, iSecondary);
		AcceptEntityInput(iSecondary, "Kill");
	} else
	{
		Format(g_sSecondaryWeapon[client], sizeof(g_sSecondaryWeapon[]), "empty");
	}

	//Knife & Taser & Nades
	g_iFlashbangAmmo[client] = GetEntProp(client, Prop_Send, "m_iAmmo", _, FlashbangOffset);

	g_bTaser[client] = false;
	Format(g_sKnife[client], sizeof(g_sKnife[]), "empty");

	for (int i = 0; i <= 3; i++) Format(g_sGrenades[client][i], sizeof(g_sGrenades[][]), "empty");
 
	int iWeapon, iGrenade, iWeaponArraySize = GetEntPropArraySize(client, Prop_Send, "m_hMyWeapons");
	for (int iIndex = 0; iIndex < iWeaponArraySize; iIndex++)
	{
		iWeapon = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", iIndex);
		if (IsValidEntity(iWeapon))
		{
			char sWeapon[32];
			GetEntityClassname(iWeapon, sWeapon, sizeof(sWeapon));
			if (StrEqual(sWeapon, "weapon_taser"))
			{
				g_bTaser[client] = true;

				g_iTaserClip[client] = Weapon_GetPrimaryClip(iWeapon);
				g_iTaserAmmo[client] = GetEntProp(iWeapon, Prop_Send, "m_iPrimaryReserveAmmoCount");

				RemovePlayerItem(client, iWeapon);
				AcceptEntityInput(iWeapon, "Kill");
			}
			else if (GetPlayerWeaponSlot(client, 2) == iWeapon)
			{
				GetEntityClassname(iWeapon, g_sKnife[client], sizeof(g_sKnife[]));
				RemovePlayerItem(client, iWeapon);
				AcceptEntityInput(iWeapon, "Kill");
			}
			else if (GetPlayerWeaponSlot(client, 3) == iWeapon)
			{
				if (SafeRemoveWeapon(client, iWeapon, 3))
				{
					GetEntityClassname(iWeapon, g_sGrenades[client][iGrenade], 32);
					iGrenade++;
				}
			}
		}
	}
}

void RearmAllDancers()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			if (g_bClientDancing[i] == true)
			{
				ResetCam(i);
				if (GetConVarBool(g_cvSaveWeaponsRoundEnd) && !g_bWarmUp && !g_bHalfTime)
					RearmPlayer(i);
				g_bClientDancing[i] = false;
			}
		}	
	}
	g_bHalfTime = false;
}

void RearmPlayerWithAmmo(int client)
{
	//Knife
	if (!StrEqual(g_sKnife[client], "empty"))
		GivePlayerItem(client, g_sKnife[client]);

	//Taser
	if (g_bTaser[client])
	{
		GivePlayerItem(client, "weapon_taser");

		int iTaser, iWeaponArraySize = GetEntPropArraySize(client, Prop_Send, "m_hMyWeapons");
		for (int iIndex = 0; iIndex < iWeaponArraySize; iIndex++)
		{
			iTaser = GetEntPropEnt(client, Prop_Send, "m_hMyWeapons", iIndex);
			if (IsValidEntity(iTaser))
			{
				char sWeapon[32];
				GetEntityClassname(iTaser, sWeapon, sizeof(sWeapon));
				if (StrEqual(sWeapon, "weapon_taser"))
				{
					SetEntProp(iTaser, Prop_Data, "m_iClip1", g_iTaserClip[client]);
					SetEntProp(iTaser, Prop_Send, "m_iPrimaryReserveAmmoCount", g_iTaserAmmo[client]);
				}
			}
		}
	}

	//Primary weapon
	if (!StrEqual(g_sPrimaryWeapon[client], "empty"))
	{
		GivePlayerItem(client, g_sPrimaryWeapon[client]);

		int iPrimary = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
		if (IsValidEntity(iPrimary) && iPrimary != INVALID_ENT_REFERENCE && iPrimary != -1)
		{
			char sWeapon[32];
			switch(GetEntProp(iPrimary, Prop_Send, "m_iItemDefinitionIndex"))
			{
				case 23: Format(sWeapon, sizeof(sWeapon), "weapon_mp5sd");
				case 60: Format(sWeapon, sizeof(sWeapon), "weapon_m4a1_silencer");
				default: GetEntityClassname(iPrimary, sWeapon, sizeof(sWeapon));
			}
			if (StrEqual(sWeapon, g_sPrimaryWeapon[client]))
			{
				SetEntProp(iPrimary, Prop_Data, "m_iClip1", g_iPrimaryWeaponClip[client]);
				SetEntProp(iPrimary, Prop_Send, "m_iPrimaryReserveAmmoCount", g_iPrimaryWeaponAmmo[client]);
			}
		}
	}

	//Secondary weapon
	if (!StrEqual(g_sSecondaryWeapon[client], "empty"))
	{
		GivePlayerItem(client, g_sSecondaryWeapon[client]);

		int iSecondary = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
		if (IsValidEntity(iSecondary) && iSecondary != INVALID_ENT_REFERENCE && iSecondary != -1)
		{
			char sWeapon[32];
			switch(GetEntProp(iSecondary, Prop_Send, "m_iItemDefinitionIndex")) 
			{
				case 61: Format(sWeapon, sizeof(sWeapon), "weapon_usp_silencer");
				case 63: Format(sWeapon, sizeof(sWeapon), "weapon_cz75a");
				case 64: Format(sWeapon, sizeof(sWeapon), "weapon_revolver");
				default: GetEntityClassname(iSecondary, sWeapon, sizeof(sWeapon));
			}
			if (StrEqual(sWeapon, g_sSecondaryWeapon[client]))
			{
				SetEntProp(iSecondary, Prop_Data, "m_iClip1", g_iSecondaryWeaponClip[client]);
				SetEntProp(iSecondary, Prop_Send, "m_iPrimaryReserveAmmoCount", g_iSecondaryWeaponAmmo[client]);
			}
		}
	}

	//Grenades
	for (int i = 0; i <= 3; i++)
	{
		if (StrEqual(g_sGrenades[client][i], "empty")) break;
		GivePlayerItem(client, g_sGrenades[client][i]);
	}
	SetEntProp(client, Prop_Send, "m_iAmmo", g_iFlashbangAmmo[client], _, FlashbangOffset);
}

void RearmPlayer(int client)
{
	//Primary weapon
	if (!StrEqual(g_sPrimaryWeapon[client], "empty"))
		GivePlayerItem(client, g_sPrimaryWeapon[client]);

	//Secondary weapon
	int iSecondary = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
	if (IsValidEntity(iSecondary) && iSecondary != INVALID_ENT_REFERENCE && iSecondary != -1 && !StrEqual(g_sSecondaryWeapon[client], "empty"))
	{
		RemovePlayerItem(client, iSecondary);
		AcceptEntityInput(iSecondary, "Kill");
		GivePlayerItem(client, g_sSecondaryWeapon[client]);
	} else
	{
		if (!StrEqual(g_sSecondaryWeapon[client], "empty"))
			GivePlayerItem(client, g_sSecondaryWeapon[client]);
	}

	//Knife
	int iKnife = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE);
	if (iKnife == -1 && !StrEqual(g_sKnife[client], "empty"))
		GivePlayerItem(client, g_sKnife[client]);

	//Taser
	if (g_bTaser[client])
		GivePlayerItem(client, "weapon_taser");

	//Grenades
	for (int i = 0; i <= 3; i++)
	{
		if(StrEqual(g_sGrenades[client][i], "empty")) break;
		GivePlayerItem(client, g_sGrenades[client][i]);
	}
	SetEntProp(client, Prop_Send, "m_iAmmo", g_iFlashbangAmmo[client], _, FlashbangOffset);
}

void SetCam(int client)
{
	ClientCommand(client, "cam_collision 0");
	ClientCommand(client, "cam_idealdist 100");
	ClientCommand(client, "cam_idealpitch 0");
	ClientCommand(client, "cam_idealyaw 0");
	ClientCommand(client, "thirdperson");
}

void ResetCam(int client)
{
	ClientCommand(client, "firstperson");
	ClientCommand(client, "cam_collision 1");
	ClientCommand(client, "cam_idealdist 150");
}

public Action ResetCooldown(Handle timer, any client)
{
	g_bEmoteCooldown[client] = false;
	CooldownTimers[client] = null;
}

public Action Menu_Dance(int client)
{
	Menu menu = new Menu(MenuHandler1);
	menu.SetTitle("Dances and Emotes:");
	
	menu.AddItem("", "Random Emote");
	menu.AddItem("", "Random Dance");
	menu.AddItem("", "Emotes List");
	menu.AddItem("", "Dances List");	
	
	// edit
	// add more lines to the menu, id is the same that the case

	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
 
	return Plugin_Handled;
}

public int MenuHandler1(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{		
		case MenuAction_Select:
		{
			int client = param1;
			
			switch (param2)
			{
				case 0: 
				{
					RandomEmote(client);
					Menu_Dance(client);
				}		
				case 1: 
				{
					RandomDance(client);
					Menu_Dance(client);
				}		
				case 2: EmotesMenu(client);
				case 3: DancesMenu(client);
			}
		}	
	}
}


public Action EmotesMenu(int client)
{
	Menu menu = new Menu(MenuHandlerEmotes);
	menu.SetTitle("Emotes:\n");
	
	menu.AddItem("0", "Finger Guns");
	menu.AddItem("1", "Come To Me");
	menu.AddItem("2", "Thumbs Down");
	menu.AddItem("3", "Thumbs Up");
	menu.AddItem("4", "Celebration");
	menu.AddItem("5", "Blow kiss");	
	menu.AddItem("6", "Calculated");
	menu.AddItem("7", "Confused");
	menu.AddItem("8", "Chug");
	menu.AddItem("9", "Cry");
	menu.AddItem("10", "Band of the fort"); 
	menu.AddItem("11", "Shake It Up 2");
	menu.AddItem("12", "Facepalm");
	menu.AddItem("13", "On the Hook");
	menu.AddItem("14", "Flex");
	menu.AddItem("15", "Golf Clap");
	menu.AddItem("16", "Hand Signals");
	menu.AddItem("17", "Click!");
	menu.AddItem("18", "Hot Stuff");
	menu.AddItem("19", "Breaking Point");
	menu.AddItem("20", "True Love");	
	menu.AddItem("21", "Kung-Fu Salute");
	menu.AddItem("22", "Laugh");
	menu.AddItem("23", "Luchador");
	menu.AddItem("24", "Make it Rain");
	menu.AddItem("25", "No hoy");
	menu.AddItem("26", "Paper");
	menu.AddItem("27", "Rock");
	menu.AddItem("28", "Scissors");
	menu.AddItem("29", "Salt");
	menu.AddItem("30", "Saltue");
	menu.AddItem("31", "420");
	menu.AddItem("32", "Snap");
	menu.AddItem("33", "Stage Bow");
	menu.AddItem("34", "Thumbs Down");
	menu.AddItem("35", "Thumbs Up");
	menu.AddItem("36", "Salute 2");
	menu.AddItem("37", "Yeet");
	

	menu.ExitButton = true;
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
 
	return Plugin_Handled;
}

public int MenuHandlerEmotes(Menu menu, MenuAction action, int client, int param2)
{
	switch (action)
	{		
		case MenuAction_Select:
		{
			char info[16];
			if(menu.GetItem(param2, info, sizeof(info)))
			{
				int iParam2 = StringToInt(info);

				switch (iParam2)
				{
					case 0:
					CreateEmote(client, "Emote_Fonzie_Pistol", "none", "", false);
					case 1:
					CreateEmote(client, "Emote_Bring_It_On", "none", "", false);
					case 2:
					CreateEmote(client, "Emote_ThumbsDown", "none", "", false);
					case 3:
					CreateEmote(client, "Emote_ThumbsUp", "none", "", false);
					case 4:
					CreateEmote(client, "Emote_Celebration_Loop", "", "", false);
					case 5:
					CreateEmote(client, "Emote_BlowKiss", "none", "", false);
					case 6:
					CreateEmote(client, "Emote_Calculated", "none", "", false);
					case 7:
					CreateEmote(client, "Emote_Confused", "none", "", false);
					case 8:
					CreateEmote(client, "Emote_Chug", "none", "", false);
					case 9:
					CreateEmote(client, "Emote_Cry", "none", "emote_cry", false);
					case 10:
					CreateEmote(client, "Emote_DustingOffHands", "none", "athena_emote_bandofthefort_music", true);
					case 11:
					CreateEmote(client, "Emote_DustOffShoulders", "none", "athena_emote_hot_music", true);
					case 12:
					CreateEmote(client, "Emote_Facepalm", "none", "athena_emote_facepalm_foley_01", false);
					case 13:
					CreateEmote(client, "Emote_Fishing", "none", "Athena_Emotes_OnTheHook_02", false);
					case 14:
					CreateEmote(client, "Emote_Flex", "none", "", false);
					case 15:
					CreateEmote(client, "Emote_golfclap", "none", "", false);
					case 16:
					CreateEmote(client, "Emote_HandSignals", "none", "", false);
					case 17:
					CreateEmote(client, "Emote_HeelClick", "none", "Emote_HeelClick", false);
					case 18:
					CreateEmote(client, "Emote_Hotstuff", "none", "Emote_Hotstuff", false);	
					case 19:
					CreateEmote(client, "Emote_IBreakYou", "none", "", false);	
					case 20:
					CreateEmote(client, "Emote_IHeartYou", "none", "", false);
					case 21:
					CreateEmote(client, "Emote_Kung-Fu_Salute", "none", "", false);
					case 22:
					CreateEmote(client, "Emote_Laugh", "Emote_Laugh_CT", "emote_laugh_01.mp3", false);		
					case 23:
					CreateEmote(client, "Emote_Luchador", "none", "Emote_Luchador", false);
					case 24:
					CreateEmote(client, "Emote_Make_It_Rain", "none", "athena_emote_makeitrain_music", false);
					case 25:
					CreateEmote(client, "Emote_NotToday", "none", "", false);	
					case 26:
					CreateEmote(client, "Emote_RockPaperScissor_Paper", "none", "", false);
					case 27:
					CreateEmote(client, "Emote_RockPaperScissor_Rock", "none", "", false);
					case 28:
					CreateEmote(client, "Emote_RockPaperScissor_Scissor", "none", "", false);
					case 29:
					CreateEmote(client, "Emote_Salt", "none", "", false);
					case 30:
					CreateEmote(client, "Emote_Salute", "none", "athena_emote_salute_foley_01", false);
					case 31:
					CreateEmote(client, "Emote_SmoothDrive", "none", "", false);
					case 32:
					CreateEmote(client, "Emote_Snap", "none", "Emote_Snap1", false);
					case 33:
					CreateEmote(client, "Emote_StageBow", "none", "emote_stagebow", false);	
					case 34:
					CreateEmote(client, "Emote_ThumbsDown", "none", "", false);
					case 35:
					CreateEmote(client, "Emote_ThumbsUp", "none", "", false);		
					case 36:
					CreateEmote(client, "Emote_Wave2", "none", "", false);
					case 37:
					CreateEmote(client, "Emote_Yeet", "none", "Emote_Yeet", false);				
					
				}
			}
			menu.DisplayAt(client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
		}
		case MenuAction_Cancel:
		{
			if(param2 == MenuCancel_ExitBack)
			{
				Menu_Dance(client);
			}
		}
	}
}

public Action DancesMenu(int client)
{
	Menu menu = new Menu(MenuHandlerDances);
	menu.SetTitle("Dances:\n");
	
	menu.AddItem("0", "Default dance");
	menu.AddItem("1", "Rambunctious");
	menu.AddItem("2", "Electro Shuffle");
	menu.AddItem("3", "Aerobic");
	menu.AddItem("4", "Bendy");
	menu.AddItem("5", "Band Of The Fort");
	menu.AddItem("6", "Boogie");
	menu.AddItem("7", "Capoeira");
	menu.AddItem("8", "Flapper");
	menu.AddItem("9", "Chicken");
	menu.AddItem("10", "Boneless");
	menu.AddItem("11", "Shoot");
	menu.AddItem("12", "Shake It Up");
	menu.AddItem("13", "Disco Fever");
	menu.AddItem("14", "Disco Fever 2");	
	menu.AddItem("15", "The Worm");
	menu.AddItem("16", "Take The L");
	menu.AddItem("17", "BreakDance");
	menu.AddItem("18", "Pump");
	menu.AddItem("19", "Ride The Pony");
	menu.AddItem("20", "Dab");
	menu.AddItem("21", "Eanster Bloc");
	menu.AddItem("22", "Dream Feet");
	menu.AddItem("23", "Floss");
	menu.AddItem("24", "Flippn Sexy");
	menu.AddItem("25", "Fresh");
	menu.AddItem("26", "Grefg");
	menu.AddItem("27", "Rock!");
	menu.AddItem("28", "Shuffle");
	menu.AddItem("29", "Hip Hop");
	menu.AddItem("30", "Hula Hop");
	menu.AddItem("31", "Infinite Dab");	
	menu.AddItem("32", "Intensity");
	menu.AddItem("33", "Irish Jig");
	menu.AddItem("34", "Korean Eagle");
	menu.AddItem("35", "Kpop");	
	menu.AddItem("36", "Living Large");
	menu.AddItem("37", "Maracas");
	menu.AddItem("38", "Pop Lock");
	menu.AddItem("39", "Pop Rock");
	menu.AddItem("40", "Robot");
	menu.AddItem("41", "T-Rex");
	menu.AddItem("42", "Electro Swing");
	menu.AddItem("43", "Twist");
	menu.AddItem("44", "Ware House");
	menu.AddItem("45", "Wiggle");
	menu.AddItem("46", "You're Awesome");	
	

	menu.ExitButton = true;
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
 
	return Plugin_Handled;
}

public int MenuHandlerDances(Menu menu, MenuAction action, int client, int param2)
{
	switch (action)
	{		
		case MenuAction_Select:
		{
			char info[16];
			if(menu.GetItem(param2, info, sizeof(info)))
			{
				int iParam2 = StringToInt(info);

				switch (iParam2)
				{
					case 0:
					CreateEmote(client, "DanceMoves", "none", "ninja_dance_01", false);
					case 1:
					CreateEmote(client, "Emote_Zippy_Dance", "none", "emote_zippy_A", true);
					case 2:
					CreateEmote(client, "ElectroShuffle", "none", "athena_emote_electroshuffle_music", true);
					case 3:
					CreateEmote(client, "Emote_AerobicChamp", "none", "emote_aerobics_01", true);
					case 4:
					CreateEmote(client, "Emote_Bendy", "none", "athena_music_emotes_bendy", true);
					case 5:
					CreateEmote(client, "Emote_BandOfTheFort", "none", "athena_emote_bandofthefort_music", true);	
					case 6:
					CreateEmote(client, "Emote_Boogie_Down_Intro", "Emote_Boogie_Down", "emote_boogiedown", true);	
					case 7:
					CreateEmote(client, "Emote_Capoeira", "none", "emote_capoeira", false);
					case 8:
					CreateEmote(client, "Emote_Charleston", "none", "athena_emote_flapper_music", true);
					case 9:
					CreateEmote(client, "Emote_Chicken", "none", "athena_emote_chicken_foley_01", true);
					case 10:
					CreateEmote(client, "Emote_Dance_NoBones", "none", "athena_emote_music_boneless", true);
					case 11:
					CreateEmote(client, "Emote_Dance_Shoot", "none", "athena_emotes_music_shoot_v7", true);
					case 12:
					CreateEmote(client, "Emote_Dance_SwipeIt", "none", "Emote_Dance_SwipeIt", true);
					case 13:
					CreateEmote(client, "Emote_Dance_Disco_T3", "none", "athena_emote_disco", true);
					case 14:
					CreateEmote(client, "Emote_DG_Disco", "none", "athena_emote_disco", true); 					
					case 15:
					CreateEmote(client, "Emote_Dance_Worm", "none", "athena_emote_worm_music", false);
					case 16:
					CreateEmote(client, "Emote_Dance_Loser", "Emote_Dance_Loser_CT", "athena_music_emotes_takethel", true);
					case 17:
					CreateEmote(client, "Emote_Dance_Breakdance", "none", "athena_emote_breakdance_music", false);
					case 18:
					CreateEmote(client, "Emote_Dance_Pump", "none", "Emote_Dance_Pump.wav", true);
					case 19:
					CreateEmote(client, "Emote_Dance_RideThePony", "none", "athena_emote_ridethepony_music_01", false);
					case 20:
					CreateEmote(client, "Emote_Dab", "none", "", false);
					case 21:
					CreateEmote(client, "Emote_EasternBloc_Start", "Emote_EasternBloc", "eastern_bloc_musc_setup_d", true);
					case 22:
					CreateEmote(client, "Emote_FancyFeet", "Emote_FancyFeet_CT", "athena_emotes_lankylegs_loop_02", true); 
					case 23:
					CreateEmote(client, "Emote_FlossDance", "none", "athena_emote_floss_music", true);
					case 24:
					CreateEmote(client, "Emote_FlippnSexy", "none", "Emote_FlippnSexy", false);
					case 25:
					CreateEmote(client, "Emote_Fresh", "none", "athena_emote_fresh_music", true);
					case 26:
					CreateEmote(client, "Emote_GrooveJam", "none", "emote_groove_jam_a", true);	
					case 27:
					CreateEmote(client, "Emote_guitar", "none", "br_emote_shred_guitar_mix_03_loop", true);	
					case 28:
					CreateEmote(client, "Emote_Hillbilly_Shuffle_Intro", "Emote_Hillbilly_Shuffle", "Emote_Hillbilly_Shuffle", true); 
					case 29:
					CreateEmote(client, "Emote_Hiphop_01", "Emote_Hip_Hop", "s5_hiphop_breakin_132bmp_loop", true);	
					case 30:
					CreateEmote(client, "Emote_Hula_Start", "Emote_Hula", "emote_hula_01", true);
					case 31:
					CreateEmote(client, "Emote_InfiniDab_Intro", "Emote_InfiniDab_Loop", "athena_emote_infinidab", true);	
					case 32:
					CreateEmote(client, "Emote_Intensity_Start", "Emote_Intensity_Loop", "emote_Intensity", true);
					case 33:
					CreateEmote(client, "Emote_IrishJig_Start", "Emote_IrishJig", "emote_irish_jig_foley_music_loop", true);
					case 34:
					CreateEmote(client, "Emote_KoreanEagle", "none", "Athena_Music_Emotes_KoreanEagle", true);
					case 35:
					CreateEmote(client, "Emote_Kpop_02", "none", "emote_kpop_01", true);	
					case 36:
					CreateEmote(client, "Emote_LivingLarge", "none", "emote_LivingLarge_A", true);	
					case 37:
					CreateEmote(client, "Emote_Maracas", "none", "emote_samba_new_B", true);
					case 38:
					CreateEmote(client, "Emote_PopLock", "none", "Athena_Emote_PopLock", true);
					case 39:
					CreateEmote(client, "Emote_PopRock", "none", "Emote_PopRock_01", true);		
					case 40:
					CreateEmote(client, "Emote_RobotDance", "none", "athena_emote_robot_music", true);	
					case 41:
					CreateEmote(client, "Emote_T-Rex", "none", "Emote_Dino_Complete", false);
					case 42:
					CreateEmote(client, "Emote_TechnoZombie", "none", "athena_emote_founders_music", true);		
					case 43:
					CreateEmote(client, "Emote_Twist", "none", "athena_emotes_music_twist", true);
					case 44:
					CreateEmote(client, "Emote_WarehouseDance_Start", "Emote_WarehouseDance_Loop", "Emote_Warehouse", true);
					case 45:
					CreateEmote(client, "Emote_Wiggle", "none", "Wiggle_Music_Loop", true);
					case 46:
					CreateEmote(client, "Emote_Youre_Awesome", "none", "youre_awesome_emote_music", false);					
				}
			}
			menu.DisplayAt(client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
		}
		case MenuAction_Cancel:
		{
			if(param2 == MenuCancel_ExitBack)
			{
				Menu_Dance(client);
			}
		}		
	}
}

public Action RandomEmote(int i)
{

					int number = GetRandomInt(0, 37);
					
					switch (number)
					{
						case 0:
						CreateEmote(i, "Emote_Fonzie_Pistol", "none", "", false);
						case 1:
						CreateEmote(i, "Emote_Bring_It_On", "none", "", false);
						case 2:
						CreateEmote(i, "Emote_ThumbsDown", "none", "", false);
						case 3:
						CreateEmote(i, "Emote_ThumbsUp", "none", "", false);
						case 4:
						CreateEmote(i, "Emote_Celebration_Loop", "", "", false);
						case 5:
						CreateEmote(i, "Emote_BlowKiss", "none", "", false);
						case 6:
						CreateEmote(i, "Emote_Calculated", "none", "", false);
						case 7:
						CreateEmote(i, "Emote_Confused", "none", "", false);
						case 8:
						CreateEmote(i, "Emote_Chug", "none", "", false);
						case 9:
						CreateEmote(i, "Emote_Cry", "none", "emote_cry", false);
						case 10:
						CreateEmote(i, "Emote_DustingOffHands", "none", "athena_emote_bandofthefort_music", true);
						case 11:
						CreateEmote(i, "Emote_DustOffShoulders", "none", "athena_emote_hot_music", true);
						case 12:
						CreateEmote(i, "Emote_Facepalm", "none", "athena_emote_facepalm_foley_01", false);
						case 13:
						CreateEmote(i, "Emote_Fishing", "none", "Athena_Emotes_OnTheHook_02", false);
						case 14:
						CreateEmote(i, "Emote_Flex", "none", "", false);
						case 15:
						CreateEmote(i, "Emote_golfclap", "none", "", false);
						case 16:
						CreateEmote(i, "Emote_HandSignals", "none", "", false);
						case 17:
						CreateEmote(i, "Emote_HeelClick", "none", "Emote_HeelClick", false);
						case 18:
						CreateEmote(i, "Emote_Hotstuff", "none", "Emote_Hotstuff", false);	
						case 19:
						CreateEmote(i, "Emote_IBreakYou", "none", "", false);	
						case 20:
						CreateEmote(i, "Emote_IHeartYou", "none", "", false);
						case 21:
						CreateEmote(i, "Emote_Kung-Fu_Salute", "none", "", false);
						case 22:
						CreateEmote(i, "Emote_Laugh", "Emote_Laugh_CT", "emote_laugh_01.mp3", false);		
						case 23:
						CreateEmote(i, "Emote_Luchador", "none", "Emote_Luchador", false);
						case 24:
						CreateEmote(i, "Emote_Make_It_Rain", "none", "athena_emote_makeitrain_music", false);
						case 25:
						CreateEmote(i, "Emote_NotToday", "none", "", false);	
						case 26:
						CreateEmote(i, "Emote_RockPaperScissor_Paper", "none", "", false);
						case 27:
						CreateEmote(i, "Emote_RockPaperScissor_Rock", "none", "", false);
						case 28:
						CreateEmote(i, "Emote_RockPaperScissor_Scissor", "none", "", false);
						case 29:
						CreateEmote(i, "Emote_Salt", "none", "", false);
						case 30:
						CreateEmote(i, "Emote_Salute", "none", "athena_emote_salute_foley_01", false);
						case 31:
						CreateEmote(i, "Emote_SmoothDrive", "none", "", false);
						case 32:
						CreateEmote(i, "Emote_Snap", "none", "Emote_Snap1", false);
						case 33:
						CreateEmote(i, "Emote_StageBow", "none", "emote_stagebow", false);	
						case 34:
						CreateEmote(i, "Emote_ThumbsDown", "none", "", false);
						case 35:
						CreateEmote(i, "Emote_ThumbsUp", "none", "", false);		
						case 36:
						CreateEmote(i, "Emote_Wave2", "none", "", false);
						case 37:
						CreateEmote(i, "Emote_Yeet", "none", "Emote_Yeet", false);	
					}	

}

public Action RandomDance(int i)
{
					int number = GetRandomInt(0, 46);
					
					switch (number)
					{
						case 0:
						CreateEmote(i, "DanceMoves", "none", "ninja_dance_01", false);
						case 1:
						CreateEmote(i, "Emote_Zippy_Dance", "none", "emote_zippy_A", true);
						case 2:
						CreateEmote(i, "ElectroShuffle", "none", "athena_emote_electroshuffle_music", true);
						case 3:
						CreateEmote(i, "Emote_AerobicChamp", "none", "emote_aerobics_01", true);
						case 4:
						CreateEmote(i, "Emote_Bendy", "none", "athena_music_emotes_bendy", true);
						case 5:
						CreateEmote(i, "Emote_BandOfTheFort", "none", "athena_emote_bandofthefort_music", true);	
						case 6:
						CreateEmote(i, "Emote_Boogie_Down_Intro", "Emote_Boogie_Down", "emote_boogiedown", true);	
						case 7:
						CreateEmote(i, "Emote_Capoeira", "none", "emote_capoeira", false);
						case 8:
						CreateEmote(i, "Emote_Charleston", "none", "athena_emote_flapper_music", true);
						case 9:
						CreateEmote(i, "Emote_Chicken", "none", "athena_emote_chicken_foley_01", true);
						case 10:
						CreateEmote(i, "Emote_Dance_NoBones", "none", "athena_emote_music_boneless", true);
						case 11:
						CreateEmote(i, "Emote_Dance_Shoot", "none", "athena_emotes_music_shoot_v7", true);
						case 12:
						CreateEmote(i, "Emote_Dance_SwipeIt", "none", "Emote_Dance_SwipeIt", true);
						case 13:
						CreateEmote(i, "Emote_Dance_Disco_T3", "none", "athena_emote_disco", true);
						case 14:
						CreateEmote(i, "Emote_DG_Disco", "none", "athena_emote_disco", true); 					
						case 15:
						CreateEmote(i, "Emote_Dance_Worm", "none", "athena_emote_worm_music", false);
						case 16:
						CreateEmote(i, "Emote_Dance_Loser", "Emote_Dance_Loser_CT", "athena_music_emotes_takethel", true);
						case 17:
						CreateEmote(i, "Emote_Dance_Breakdance", "none", "athena_emote_breakdance_music", false);
						case 18:
						CreateEmote(i, "Emote_Dance_Pump", "none", "Emote_Dance_Pump.wav", true);
						case 19:
						CreateEmote(i, "Emote_Dance_RideThePony", "none", "athena_emote_ridethepony_music_01", false);
						case 20:
						CreateEmote(i, "Emote_Dab", "none", "", false);
						case 21:
						CreateEmote(i, "Emote_EasternBloc_Start", "Emote_EasternBloc", "eastern_bloc_musc_setup_d", true);
						case 22:
						CreateEmote(i, "Emote_FancyFeet", "Emote_FancyFeet_CT", "athena_emotes_lankylegs_loop_02", true); 
						case 23:
						CreateEmote(i, "Emote_FlossDance", "none", "athena_emote_floss_music", true);
						case 24:
						CreateEmote(i, "Emote_FlippnSexy", "none", "Emote_FlippnSexy", false);
						case 25:
						CreateEmote(i, "Emote_Fresh", "none", "athena_emote_fresh_music", true);
						case 26:
						CreateEmote(i, "Emote_GrooveJam", "none", "emote_groove_jam_a", true);	
						case 27:
						CreateEmote(i, "Emote_guitar", "none", "br_emote_shred_guitar_mix_03_loop", true);	
						case 28:
						CreateEmote(i, "Emote_Hillbilly_Shuffle_Intro", "Emote_Hillbilly_Shuffle", "Emote_Hillbilly_Shuffle", true); 
						case 29:
						CreateEmote(i, "Emote_Hiphop_01", "Emote_Hip_Hop", "s5_hiphop_breakin_132bmp_loop", true);	
						case 30:
						CreateEmote(i, "Emote_Hula_Start", "Emote_Hula", "emote_hula_01", true);
						case 31:
						CreateEmote(i, "Emote_InfiniDab_Intro", "Emote_InfiniDab_Loop", "athena_emote_infinidab", true);	
						case 32:
						CreateEmote(i, "Emote_Intensity_Start", "Emote_Intensity_Loop", "emote_Intensity", true);
						case 33:
						CreateEmote(i, "Emote_IrishJig_Start", "Emote_IrishJig", "emote_irish_jig_foley_music_loop", true);
						case 34:
						CreateEmote(i, "Emote_KoreanEagle", "none", "Athena_Music_Emotes_KoreanEagle", true);
						case 35:
						CreateEmote(i, "Emote_Kpop_02", "none", "emote_kpop_01", true);	
						case 36:
						CreateEmote(i, "Emote_LivingLarge", "none", "emote_LivingLarge_A", true);	
						case 37:
						CreateEmote(i, "Emote_Maracas", "none", "emote_samba_new_B", true);
						case 38:
						CreateEmote(i, "Emote_PopLock", "none", "Athena_Emote_PopLock", true);
						case 39:
						CreateEmote(i, "Emote_PopRock", "none", "Emote_PopRock_01", true);		
						case 40:
						CreateEmote(i, "Emote_RobotDance", "none", "athena_emote_robot_music", true);	
						case 41:
						CreateEmote(i, "Emote_T-Rex", "none", "Emote_Dino_Complete", false);
						case 42:
						CreateEmote(i, "Emote_TechnoZombie", "none", "athena_emote_founders_music", true);		
						case 43:
						CreateEmote(i, "Emote_Twist", "none", "athena_emotes_music_twist", true);
						case 44:
						CreateEmote(i, "Emote_WarehouseDance_Start", "Emote_WarehouseDance_Loop", "Emote_Warehouse", true);
						case 45:
						CreateEmote(i, "Emote_Wiggle", "none", "Wiggle_Music_Loop", true);
						case 46:
						CreateEmote(i, "Emote_Youre_Awesome", "none", "youre_awesome_emote_music", false);	
					}	
}

stock bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
}

stock bool SafeRemoveWeapon(int client, int weapon, int slot)
{
    if (HasEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex"))
    {
        int iDefIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
       
        if (iDefIndex < 0 || iDefIndex > 700)
        {
            return false;
        }
    }
   
    if (HasEntProp(weapon, Prop_Send, "m_bInitialized"))
    {
        if (GetEntProp(weapon, Prop_Send, "m_bInitialized") == 0)
        {
            return false;
        }
    }
   
    if (HasEntProp(weapon, Prop_Send, "m_bStartedArming"))
    {
        if (GetEntSendPropOffs(weapon, "m_bStartedArming") > -1)
        {
            return false;
        }
    }
   
    if (GetPlayerWeaponSlot(client, slot) != weapon)
    {
        return false;
    }
   
    if (!RemovePlayerItem(client, weapon))
    {
        return false;
    }
   
    int iWorldModel = GetEntPropEnt(weapon, Prop_Send, "m_hWeaponWorldModel");
   
    if (IsValidEdict(iWorldModel) && IsValidEntity(iWorldModel))
    {
        if (!AcceptEntityInput(iWorldModel, "Kill"))
        {
            return false;
        }
    }
   
    if (weapon == GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"))
    {
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1);
    }
   
    AcceptEntityInput(weapon, "Kill");
   
    return true;
}

/**
 * Copies a 1 dimensional static array.
 *
 * @param array			Static Array to copy from.
 * @param newArray		New Array to copy to.
 * @param size			Size of the array (or number of cells to copy)
 * @noreturn
 */
stock void Array_Copy(const any[] array, any[] newArray, int size)
{
	for (int i=0; i < size; i++) {
		newArray[i] = array[i];
	}
}

/*
 * Gets the primary clip count of a weapon.
 *
 * @param weapon		Weapon Entity.
 * @return				Primary Clip count.
 */
stock int Weapon_GetPrimaryClip(int weapon)
{
	return GetEntProp(weapon, Prop_Data, "m_iClip1");
}
