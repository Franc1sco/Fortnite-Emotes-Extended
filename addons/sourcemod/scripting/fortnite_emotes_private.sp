#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>


Handle cvThirdperson;

int g_iEmoteEnt[MAXPLAYERS+1];
int g_iEmoteSoundEnt[MAXPLAYERS+1];

char g_sEmoteSound[MAXPLAYERS+1][PLATFORM_MAX_PATH];

bool g_bClientDancing[MAXPLAYERS+1];

float g_fLastAngles[MAXPLAYERS+1][3];
float g_fLastPosition[MAXPLAYERS+1][3];

//int g_iEquippedWeapon[MAXPLAYERS+1];

Handle CooldownTimers[MAXPLAYERS+1];
bool g_bEmoteCooldown[MAXPLAYERS+1];

public Plugin myinfo =
{
	name = "Fortnite Emotes Private",
	author = "Kodua and Franc1sco franug",
	description = "This plugin is for demonstration of some animations from Fortnite in CS:GO",
	version = "1.0.1c extended",
	url = "https://steamcommunity.com/id/kodua"
};

public void OnPluginStart()
{
	RegConsoleCmd("emotes", Command_Menu);

	HookEvent("player_death", 	Event_PlayerDeath);

	HookEvent("round_start", 	Event_RoundStart, 	EventHookMode_PostNoCopy);

	cvThirdperson = FindConVar("sv_allow_thirdperson");
	if(cvThirdperson == INVALID_HANDLE)
		SetFailState("sv_allow_thirdperson not found!");

	SetConVarInt(cvThirdperson, 1);

	HookConVarChange(cvThirdperson, ConVarChanged);
}

public void ConVarChanged(Handle cvar, const char[] oldVal, const char[] newVal)
{
	if(cvar == cvThirdperson)
	{
		if(StringToInt(newVal) != 1)
			SetConVarInt(cvThirdperson, 1);
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
	if(IsValidClient(client))
	{	
		ResetCam(client);
		TerminateEmote(client);
	}
}

public void OnClientDisconnect(int client)
{
	if(IsValidClient(client))
	{
		ResetCam(client);
		TerminateEmote(client);

		if (CooldownTimers[client] != null)
		{
			KillTimer(CooldownTimers[client]);
			CooldownTimers[client] = null;
		}
	}
}

public void Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast) 
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if(IsValidClient(client))
	{
		ResetCam(client);
		TerminateEmote(client);
	}
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast) 
{
	ResetCamForDancers();
}

public Action Command_Menu(int client, int args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

	if (!IsPlayerAlive(client))
	{
		ReplyToCommand(client, "¡Debes estar vivo para usar esto!");
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
		ReplyToCommand(client, "¡Debes estar vivo para usar esto!");
		return Plugin_Handled;
	}

	if (!(GetEntityFlags(client) & FL_ONGROUND))
	{
		ReplyToCommand(client, "¡Debes permanecer en el suelo para usar esto!");
		return Plugin_Handled;
	}

	if (g_bEmoteCooldown[client])
	{
		ReplyToCommand(client, "It is on cooldown!");
		return Plugin_Handled;
	}

	if (StrEqual(anim1, ""))
	{
		ReplyToCommand(client, "¡El argumento 1 no es válido!");
		return Plugin_Handled;
	}

	if (g_iEmoteEnt[client])
		StopEmote(client);

	int EmoteEnt = CreateEntityByName("prop_dynamic");
	if (IsValidEntity(EmoteEnt))
	{
		SetEntityMoveType(client, MOVETYPE_NONE);

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

		if (!StrEqual(soundName, ""))
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

		if(StrEqual(anim2, "none", false))
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
/*
		//Saving active weapon and equiping knife
		g_iEquippedWeapon[client] = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
*/
		int iKnife = GetPlayerWeaponSlot(client, CS_SLOT_KNIFE);
		if(IsValidEntity(iKnife) && iKnife != INVALID_ENT_REFERENCE && iKnife != -1)
			SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", iKnife);

		g_bClientDancing[client] = true;
		g_bEmoteCooldown[client] = true;
		CooldownTimers[client] = CreateTimer(4.0, ResetCooldown, client);
	}
	return Plugin_Handled;
}

public Action OnPlayerRunCmd(int client, int &iButtons, int &iImpulse, float fVelocity[3], float fAngles[3], int &iWeapon)
{
	if (g_bClientDancing[client])
	{
		if (iWeapon != 0)
			return Plugin_Handled;
	}

	if(g_bClientDancing[client] && !(GetEntityFlags(client) & FL_ONGROUND))
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
		SetEntityMoveType(client, MOVETYPE_WALK);
/*
		if(IsValidEntity(g_iEquippedWeapon[client]) && g_iEquippedWeapon[client] != INVALID_ENT_REFERENCE && g_iEquippedWeapon[client] != -1)
		{
			char sWeapon[32];
			GetEntityClassname(g_iEquippedWeapon[client], sWeapon, sizeof(sWeapon));
			if(!StrEqual(sWeapon, "weapon_c4"))
				SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", g_iEquippedWeapon[client]);
		}
*/
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

void ResetCamForDancers()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i))
		{
			if (g_bClientDancing[i] == true)
			{
				ResetCam(i);
				g_bClientDancing[i] = false;
			}
		}	
	}
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

//////////////MENU//////////////

public int MenuHandler1(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{		
		case MenuAction_Select:
		{
			int client = param1;

			char info[16];
			if(menu.GetItem(param2, info, sizeof(info)))
			{
				int iParam2 = StringToInt(info);

				switch (iParam2)
				{
					case 0:
					CreateEmote(client, "DanceMoves", "none", "ninja_dance_01", false);
					case 1:
					CreateEmote(client, "Emote_MaskOff_Intro", "Emote_MaskOff_Loop", "Hip_Hop_Good_Vibes_Mix_01_Loop", true);
					case 2:
					CreateEmote(client, "Emote_Fonzie_Pistol", "none", "", false);
					case 3:
					CreateEmote(client, "Emote_Zippy_Dance", "none", "emote_zippy_A", true);
					case 4:
					CreateEmote(client, "Emote_Celebration_Loop", "none", "", false);
					case 5:
					CreateEmote(client, "ElectroShuffle", "none", "athena_emote_electroshuffle_music", true);
					case 6:
					CreateEmote(client, "Emote_AerobicChamp", "none", "emote_aerobics_01", true);
					case 7:
					CreateEmote(client, "Emote_Bendy", "none", "athena_music_emotes_bendy", true);
					case 8:
					CreateEmote(client, "Emote_BandOfTheFort", "none", "athena_emote_bandofthefort_music", true);
					case 9:
					CreateEmote(client, "Emote_BlowKiss", "none", "", false);
					case 10:
					CreateEmote(client, "Emote_Boogie_Down_Intro", "Emote_Boogie_Down", "emote_boogiedown", true);
					case 11:
					CreateEmote(client, "Emote_Bring_It_On", "none", "", false);
					case 12:
					CreateEmote(client, "Emote_Capoeira", "none", "emote_capoeira", false);
					case 13:
					CreateEmote(client, "Emote_Calculated", "none", "", false);
					case 14:
					CreateEmote(client, "Emote_Celebration_Loop", "none", "", false);
					case 15:
					CreateEmote(client, "Emote_Charleston", "none", "athena_emote_flapper_music", true);
					case 16:
					CreateEmote(client, "Emote_Confused", "none", "", false);
					case 17:
					CreateEmote(client, "Emote_Chicken", "none", "athena_emote_chicken_foley_01", true);
					case 18:
					CreateEmote(client, "Emote_Chug", "none", "", false);
					case 19:
					CreateEmote(client, "Emote_Cry", "none", "emote_cry", false);
					case 20:
					CreateEmote(client, "Emote_Dance_NoBones", "none", "athena_emote_music_boneless", true);
					case 21:
					CreateEmote(client, "Emote_Dance_Shoot", "none", "athena_emotes_music_shoot_v7", true);
					case 22:
					CreateEmote(client, "Emote_Dance_SwipeIt", "none", "Emote_Dance_SwipeIt", true);
					case 23:
					CreateEmote(client, "Emote_Dance_Disco_T3", "none", "athena_emote_disco", true);
					case 24:
					CreateEmote(client, "Emote_Dance_Worm", "none", "athena_emote_worm_music", false);
					case 25:
					CreateEmote(client, "Emote_Dance_Loser", "Emote_Dance_Loser_CT", "athena_music_emotes_takethel", true);
					case 26:
					CreateEmote(client, "Emote_Dance_Breakdance", "none", "athena_emote_breakdance_music", false);
					case 27:
					CreateEmote(client, "Emote_Dance_Pump", "none", "Emote_Dance_Pump.wav", true);
					case 28:
					CreateEmote(client, "Emote_Dance_RideThePony", "none", "athena_emote_ridethepony_music_01", false);
					case 29:
					CreateEmote(client, "Emote_Dab", "none", "", false);
					case 30:
					CreateEmote(client, "Emote_DG_Disco", "none", "athena_emote_disco", true); 
					case 31:
					CreateEmote(client, "Emote_DustingOffHands", "none", "athena_emote_bandofthefort_music", true);
					case 32:
					CreateEmote(client, "Emote_DustOffShoulders", "none", "athena_emote_hot_music", true);
					case 33:
					CreateEmote(client, "Emote_EasternBloc_Start", "Emote_EasternBloc", "eastern_bloc_musc_setup_d", true);
					case 34:
					CreateEmote(client, "Emote_FancyFeet", "Emote_FancyFeet_CT", "athena_emotes_lankylegs_loop_02", true); 
					case 35:
					CreateEmote(client, "Emote_Facepalm", "none", "athena_emote_facepalm_foley_01", false);
					case 36:
					CreateEmote(client, "Emote_Fishing", "none", "Athena_Emotes_OnTheHook_02", false);
					case 37:
					CreateEmote(client, "Emote_Flex", "none", "", false);
					case 38:
					CreateEmote(client, "Emote_FlossDance", "none", "athena_emote_floss_music", true);
					case 39:
					CreateEmote(client, "Emote_Fonzie_Pistol", "none", "", false);
					case 40:
					CreateEmote(client, "Emote_FlippnSexy", "none", "Emote_FlippnSexy", false);
					case 41:
					CreateEmote(client, "Emote_Fresh", "none", "athena_emote_fresh_music", true);
					case 42:
					CreateEmote(client, "Emote_GrooveJam", "none", "emote_groove_jam_a", true);
					case 43:
					CreateEmote(client, "Emote_golfclap", "none", "", false);
					case 44:
					CreateEmote(client, "Emote_guitar", "none", "br_emote_shred_guitar_mix_03_loop", true);
					case 45:
					CreateEmote(client, "Emote_HandSignals", "none", "", false);
					case 46:
					CreateEmote(client, "Emote_HeelClick", "none", "Emote_HeelClick", 	false);
					case 47:
					CreateEmote(client, "Emote_Hillbilly_Shuffle_Intro", "Emote_Hillbilly_Shuffle", "Emote_Hillbilly_Shuffle", true); 
					case 48:
					CreateEmote(client, "Emote_Hiphop_01", "Emote_Hip_Hop", "s5_hiphop_breakin_132bmp_loop", true);
					case 49:
					CreateEmote(client, "Emote_Hotstuff", "none", "Emote_Hotstuff", false);
					case 50:
					CreateEmote(client, "Emote_Hula_Start", "Emote_Hula", "emote_hula_01", true);
					case 51:
					CreateEmote(client, "Emote_IBreakYou", "none", "", false);
					case 52:
					CreateEmote(client, "Emote_InfiniDab_Intro", "Emote_InfiniDab_Loop", "athena_emote_infinidab", true);
					case 53:
					CreateEmote(client, "Emote_IHeartYou", "none", "", false);
					case 54:
					CreateEmote(client, "Emote_Intensity_Start", "Emote_Intensity_Loop", "emote_Intensity", true);
					case 55:
					CreateEmote(client, "Emote_IrishJig_Start", "Emote_IrishJig", "emote_irish_jig_foley_music_loop", true);
					case 56:
					CreateEmote(client, "Emote_KoreanEagle", "none", "Athena_Music_Emotes_KoreanEagle", true);
					case 57:
					CreateEmote(client, "Emote_Kpop_02", "none", "emote_kpop_01", true);
					case 58:
					CreateEmote(client, "Emote_Kung-Fu_Salute", "none", "", false);
					case 59:
					CreateEmote(client, "Emote_Laugh", "Emote_Laugh_CT", "emote_laugh_01.mp3", false);
					case 60:
					CreateEmote(client, "Emote_LivingLarge", "none", "emote_LivingLarge_A", true);
					case 61:
					CreateEmote(client, "Emote_Luchador", "none", "Emote_Luchador", false);
					case 62:
					CreateEmote(client, "Emote_Maracas", "none", "emote_samba_new_B", true);
					case 63:
					CreateEmote(client, "Emote_Make_It_Rain", "none", "athena_emote_makeitrain_music", false);
					case 64:
					CreateEmote(client, "Emote_NotToday", "none", "", false);
					case 65:
					CreateEmote(client, "Emote_PopLock", "none", "Athena_Emote_PopLock", true);
					case 66:
					CreateEmote(client, "Emote_PopRock", "none", "Emote_PopRock_01", true);
					case 67:
					CreateEmote(client, "Emote_RockPaperScissor_Paper", "none", "", false);
					case 68:
					CreateEmote(client, "Emote_RockPaperScissor_Rock", "none", "", false);
					case 69:
					CreateEmote(client, "Emote_RockPaperScissor_Scissor", "none", "", false);
					case 70:
					CreateEmote(client, "Emote_RobotDance", "none", "athena_emote_robot_music", true);
					case 71:
					CreateEmote(client, "Emote_Salt", "none", "", false);
					case 72:
					CreateEmote(client, "Emote_Salute", "none", "athena_emote_salute_foley_01", false);
					case 73:
					CreateEmote(client, "Emote_SmoothDrive", "none", "", false);
					case 74:
					CreateEmote(client, "Emote_Snap", "none", "Emote_Snap1", false);
					case 75:
					CreateEmote(client, "Emote_StageBow", "none", "emote_stagebow", false);
					case 76:
					CreateEmote(client, "Emote_T-Rex", "none", "Emote_Dino_Complete", false);
					case 77:
					CreateEmote(client, "Emote_TechnoZombie", "none", "athena_emote_founders_music", true);
					case 78:
					CreateEmote(client, "Emote_ThumbsDown", "none", "", false);
					case 79:
					CreateEmote(client, "Emote_ThumbsUp", "none", "", false);
					case 80:
					CreateEmote(client, "Emote_Twist", "none", "athena_emotes_music_twist", true);
					case 81:
					CreateEmote(client, "Emote_WarehouseDance_Start", "Emote_WarehouseDance_Loop", "Emote_Warehouse", true);
					case 82:
					CreateEmote(client, "Emote_Wiggle", "none", "Wiggle_Music_Loop", true);
					case 83:
					CreateEmote(client, "Emote_Wave2", "none", "", false);
					case 84:
					CreateEmote(client, "Emote_Yeet", "none", "Emote_Yeet", false);
					case 85:
					CreateEmote(client, "Emote_Youre_Awesome", "none", "youre_awesome_emote_music", false);
					
					
					
					
					// CreateEmote(client, "", "", "", );
					// edit
					// add more cases
					// CreateModel(client, "Animation", "EndAnimation", "soundname", isloop?);
				}
			}
			menu.DisplayAt(client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
		}
	}
}

public Action Menu_Dance(int client)
{
	Menu menu = new Menu(MenuHandler1);
	menu.SetTitle("Escoge algun emote:");

	menu.AddItem("0", "Default dance");
	menu.AddItem("1", "Justicia naranja");
	menu.AddItem("2", "Finger Guns");
	menu.AddItem("3", "Rambunctious");
	menu.AddItem("4", "Jubilation");
	menu.AddItem("5", "Electro Shuffle");
	menu.AddItem("6", "Aerobic");
	menu.AddItem("7", "Bendy");
	menu.AddItem("8", "Band Of The Fort");
	menu.AddItem("9", "Golpe beso");
	menu.AddItem("10", "Boogie");
	menu.AddItem("11", "venid a por mi");
	menu.AddItem("12", "Capoeira");
	menu.AddItem("13", "Calculado");
	menu.AddItem("14", "Celebración");
	menu.AddItem("15", "Charlestón");
	menu.AddItem("16", "Confuso");
	menu.AddItem("17", "Gallina");
	menu.AddItem("18", "Chug");
	menu.AddItem("19", "Llorar");
	menu.AddItem("20", "Sin huesos");
	menu.AddItem("21", "Shoot");
	menu.AddItem("22", "Agitalo");
	menu.AddItem("23", "Fiebre disco");
	menu.AddItem("24", "El gusano");
	menu.AddItem("25", "Take The L");
	menu.AddItem("26", "BreakDance");
	menu.AddItem("27", "Pump");
	menu.AddItem("28", "Monta el pony");
	menu.AddItem("29", "Dab");
	menu.AddItem("30", "Fiebre disco");
	menu.AddItem("31", "Band of the fort"); 
	menu.AddItem("32", "Agitalo"); // Comentario Nombre
	menu.AddItem("33", "Eanster Bloc");
	menu.AddItem("34", "Pies Elegantes"); 
	menu.AddItem("35", "Facepalm");
	menu.AddItem("36", "Pescar");
	menu.AddItem("37", "Flex");
	menu.AddItem("38", "Floss");
	menu.AddItem("39", "pistola dedo");
	menu.AddItem("40", "Flippn Sexy");
	menu.AddItem("41", "Fresh");
	menu.AddItem("42", "Grefg");
	menu.AddItem("43", "Golf Clap");
	menu.AddItem("44", "Rock!");
	menu.AddItem("45", "Señales");
	menu.AddItem("46", "en el talón");
	menu.AddItem("47", "Shuffle");
	menu.AddItem("48", "Hip Hop");
	menu.AddItem("49", "Hot Stuff");
	menu.AddItem("50", "Hula Hop");
	menu.AddItem("51", "Te voy a romper");
	menu.AddItem("52", "Dab infinito");
	menu.AddItem("53", "Te amo");
	menu.AddItem("54", "Intensidad");
	menu.AddItem("55", "Irish Jig");
	menu.AddItem("56", "Korean Eagle");
	menu.AddItem("57", "Kpop");
	menu.AddItem("58", "Kung-Fu Saludate");
	menu.AddItem("59", "Reirse");
	menu.AddItem("60", "Living Large");
	menu.AddItem("61", "Luchador");
	menu.AddItem("62", "Maracas");
	menu.AddItem("63", "Haz que llueva");
	menu.AddItem("64", "No hoy");
	menu.AddItem("65", "Pop Lock");
	menu.AddItem("66", "Pop Rock");
	menu.AddItem("67", "Papel");
	menu.AddItem("68", "Piedra");
	menu.AddItem("69", "Tijera");
	menu.AddItem("70", "Robot");
	menu.AddItem("71", "Sal");
	menu.AddItem("72", "Saludar");
	menu.AddItem("73", "420");
	menu.AddItem("74", "Snap");
	menu.AddItem("75", "Stage Bow");
	menu.AddItem("76", "T-Rex");
	menu.AddItem("77", "Electro Zombie");
	menu.AddItem("78", "Pulgares Abajo");
	menu.AddItem("79", "Pulgares Arriba");
	menu.AddItem("80", "Twist");
	menu.AddItem("81", "Ware House");
	menu.AddItem("82", "Wiggle");
	menu.AddItem("83", "Saludar 2");
	menu.AddItem("84", "Yeet");
	menu.AddItem("85", "Eres increible");
	
	// edit
	// add more lines to the menu, id is the same that the case

	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
 
	return Plugin_Handled;
}

stock bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
	{
		return false;
	}
	return IsClientInGame(client);
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