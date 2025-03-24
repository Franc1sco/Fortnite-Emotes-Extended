/*  SM Fortnite Emotes Extended
 *
 *  Copyright (C) 2020 Francisco 'Franc1sco' García
 *
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program. If not, see http://www.gnu.org/licenses/.
 */
#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <colors>

#undef REQUIRE_PLUGIN
#include <adminmenu>
#include <readyup>
#include <pause>
#include <vip_core>
#define REQUIRE_PLUGIN

/*****************************************************************
			G L O B A L   V A R S
*****************************************************************/

#define DEBUG		0

#define EF_BONEMERGE		  0x001
#define EF_NOSHADOW			  0x010
#define EF_BONEMERGE_FASTCULL 0x080
#define EF_NORECEIVESHADOW	  0x040
#define EF_PARENT_ANIMATES	  0x200
#define HIDEHUD_ALL			  (1 << 2)
#define HIDEHUD_CROSSHAIR	  (1 << 8)

ConVar
	g_cvarHidePlayers,

	g_cvarFlagEmotesMenu,
	g_cvarFlagDancesMenu,
	g_cvarCooldown,
	g_cvarSoundVolume,
	g_cvarEmotesSounds,
	g_cvarHideWeapons,
	g_cvarTeleportBack,
	g_cvarSpeed,
	g_cvarDownloadResources;

int
	g_iEmoteEnt[MAXPLAYERS + 1],
	g_iEmoteSoundEnt[MAXPLAYERS + 1],

	g_iWeaponHandEnt[MAXPLAYERS + 1],

	playerModels[MAXPLAYERS + 1],
	playerModelsIndex[MAXPLAYERS + 1];

char
	g_sEmoteSound[MAXPLAYERS + 1][PLATFORM_MAX_PATH];

bool
	g_bClientDancing[MAXPLAYERS + 1],
	g_bEmoteCooldown[MAXPLAYERS + 1],
	g_bHooked[MAXPLAYERS + 1],

	g_bLateload,
	g_bVipCore	 = false,
	g_bPause	 = false;

Handle
	CooldownTimers[MAXPLAYERS + 1];

float
	g_fLastAngles[MAXPLAYERS + 1][3],
	g_fLastPosition[MAXPLAYERS + 1][3];

/*****************************************************************
			L I B R A R Y   I N C L U D E S
*****************************************************************/

#include "fnemotes/left4dhooks.sp"
#include "fnemotes/native.sp"
#include "fnemotes/resources.sp"
#include "fnemotes/menu.sp"
#include "fnemotes/vipcore.sp"
#include "fnemotes/emotes.sp"

/*****************************************************************
			P L U G I N   I N F O
*****************************************************************/
public Plugin myinfo =
{
	name		= "SM Fortnite Emotes Extended - L4D Version",
	author		= "Kodua, Franc1sco franug, TheBO$$, Foxhound, lechuga",
	description = "This plugin is for demonstration of some animations from Fortnite in L4D",
	version		= "1.6.1",
	url			= "https://github.com/lechuga16/Fortnite-Emotes-Extended"
};

/*****************************************************************
			F O R W A R D   P U B L I C S
*****************************************************************/
public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	if (!L4D_IsEngineLeft4Dead())
	{
		strcopy(error, err_max, "Plugin only supports in Left 4 Dead engine branch");
		return APLRes_SilentFailure;
	}

	AskPluginLoad2_native();
	g_bLateload = late;
	return APLRes_Success;
}

public void OnAllPluginsLoaded()
{
	g_bVipCore	 = LibraryExists("vip_core");
	g_bPause	 = LibraryExists("pause");
}

public void OnLibraryRemoved(const char[] sName)
{
	if (StrEqual(sName, "vip_core"))
		g_bVipCore = false;

	if (StrEqual(sName, "pause"))
		g_bPause = false;
}

public void OnLibraryAdded(const char[] sName)
{
	if (StrEqual(sName, "vip_core"))
		g_bVipCore = true;

	if (StrEqual(sName, "pause"))
		g_bPause = true;
}

public void OnPluginStart()
{
	LoadTranslation("common.phrases");
	LoadTranslation("fnemotes.phrases");

	if (g_iEngine == Engine_Left4Dead)
	{
		HookEvent("player_afk", Event_PAfkQ);
		HookEvent("player_team", Event_PAfkQ);

		HookEvent("player_bot_replace", Event_PAfk);
		HookEvent("bot_player_replace", Event_PAfk);
	}
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
	HookEvent("round_start", Event_Start);
	HookEvent("player_team", Event_PlayerTeam);

	g_cvarEmotesSounds		= CreateConVar("sm_emotes_sounds", "1", "Enable/Disable sounds for emotes.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvarCooldown			= CreateConVar("sm_emotes_cooldown", "2.0", "Cooldown for emotes in seconds. 0 = no cooldown.", FCVAR_NOTIFY, true, 0.0);
	g_cvarSoundVolume		= CreateConVar("sm_emotes_soundvolume", "1.0", "Sound volume for the emotes.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvarFlagEmotesMenu	= CreateConVar("sm_emotes_admin_flag_menu", "", "admin flag for emotes (empty for all players)", FCVAR_NOTIFY);
	g_cvarFlagDancesMenu	= CreateConVar("sm_dances_admin_flag_menu", "", "admin flag for dances (empty for all players)", FCVAR_NOTIFY);
	g_cvarHideWeapons		= CreateConVar("sm_emotes_hide_weapons", "1", "Hide weapons when dancing", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvarHidePlayers		= CreateConVar("sm_emotes_hide_enemies", "0", "Hide enemy players when dancing", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvarTeleportBack		= CreateConVar("sm_emotes_teleportonend", "1", "Teleport back to the exact position when he started to dance. (Some maps need this for teleport triggers)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvarSpeed				= CreateConVar("sm_emotes_speed", "0.8", "Sets the playback speed of the animation. default (1.0)", FCVAR_NOTIFY, true, 0.0);
	g_cvarDownloadResources = CreateConVar("sm_emotes_download_resources", "1", "Download method for the resources", FCVAR_NOTIFY, true, 0.0, true, 1.0);

	RegConsoleCmd("sm_emote", Command_Emote);
	RegConsoleCmd("sm_emotecode", Command_EmoteCode);
	RegConsoleCmd("sm_dance", Command_Dance);
	RegConsoleCmd("sm_dancecode", Command_DanceCode);
	RegAdminCmd("sm_setemote", Command_SetEmote, ADMFLAG_GENERIC);
	RegAdminCmd("sm_setdance", Command_SetDance, ADMFLAG_GENERIC);

	AutoExecConfig(false, "fortnite_emotes_extended");

	if (g_bLateload)
	{
		g_bVipCore	 = LibraryExists("vip_core");
		g_bPause	 = LibraryExists("pause");
	}

	OnPluginStart_resources();
	OnPluginStart_vipcore();
}

public Action Command_Emote(int client, int args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

#if !DEBUG
	if(g_bLateload)
	{
		CReplyToCommand(client, "%t %t", "TAG", "LATLOAD");
		return Plugin_Handled;
	}
#endif

	if (!IsValidAccess(client))
		CReplyToCommand(client, "%t %t", "TAG", "NO_EMOTES_ACCESS_FLAG");

	if(args == 0 && SM_REPLY_TO_CHAT == GetCmdReplySource())
	{
		Menu_Main(client);
		return Plugin_Handled;
	}

	if (args != 1)
	{
		CReplyToCommand(client, "%t: sm_emote <#emote>", "USAGE");
		return Plugin_Handled;
	}

	if (g_bEmoteCooldown[client])
	{
		CReplyToCommand(client, "%t %t", "TAG", "COOLDOWN_EMOTES");
		return Plugin_Handled;
	}

	if (!IsSurvivor(client))
	{
		CReplyToCommand(client, "%t %t", "TAG", "NOTSURVIVOR");
		return Plugin_Handled;
	}

	if (g_bPause)
	{
		if (IsInPause())
		{
			CReplyToCommand(client, "%t %t", "TAG", "PAUSE_MODE");
			return Plugin_Handled;
		}
	}

	if (g_bClientDancing[client])
	{
		CReplyToCommand(client, "%t %t", "TAG", "CANNOT_USE_NOW");
		return Plugin_Handled;
	}

	int iEmoteCode = GetCmdArgInt(1);

	iEmoteCode = (iEmoteCode < 0) ? -iEmoteCode : iEmoteCode;

	int
		iFile,
		iItem;

	char
		sAnim1[32],
		sAnim2[32],
		sSound[64];

	bool
		bIsLoop;

	int iEmoteCounter = 0;

	for (int iFilesIndex = 1; iFilesIndex <= g_iFilesFnemotesCounter; iFilesIndex++)
	{
		iEmoteCounter += g_iEmotesSize[iFilesIndex];
		if (iEmoteCode <= iEmoteCounter)
		{
			iFile = iFilesIndex;
			iItem = iEmoteCode - (iEmoteCounter - g_iEmotesSize[iFilesIndex]);
			break;
		}
	}

	if (iFile == 0 || iItem == 0)
	{
		CReplyToCommand(client, "%t %t", "TAG", "INVALID_EMOTE_ID", iEmoteCounter);
		return Plugin_Handled;
	}

	if (!GetEmoteInfo(iFile, g_Emotes[iFile][iItem].name, sAnim1, sizeof(sAnim1), sAnim2, sizeof(sAnim2), sSound, sizeof(sSound), bIsLoop))
	{
		CPrintToChat(client, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_Emotes[iFile][iItem].name);
		return Plugin_Handled;
	}

	CreateEmote(client, sAnim1, sAnim2, sSound, bIsLoop, iFile);
	return Plugin_Handled;
}

public Action Command_EmoteCode(int client, int args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

#if !DEBUG
	if(g_bLateload)
	{
		CReplyToCommand(client, "%t %t", "TAG", "LATLOAD");
		return Plugin_Handled;
	}
#endif

	if (!IsValidAccess(client))
		CReplyToCommand(client, "%t %t", "TAG", "NO_EMOTES_ACCESS_FLAG");

	CPrintToChat(client, "%t %t", "TAG", "EMOTES_LIST_CONSOLE");
	int iCode = 1;

	for (int iFilesIndex = 1; iFilesIndex <= g_iFilesFnemotesCounter; iFilesIndex++)
	{	
		if(g_iEmotesSize[iFilesIndex] == 0)
			continue;

		if(iFilesIndex != 1)
			PrintToConsole(client, " ");

		PrintToConsole(client, "\nFile [%s]", g_FilesConfig[iFilesIndex].name);
		PrintToConsole(client, "--------------------");
		for (int iEmoteIndex = 1; iEmoteIndex <= g_iEmotesSize[iFilesIndex]; iEmoteIndex++)
		{
			PrintToConsole(client, "> Code: #%d | %s", iCode, g_Emotes[iFilesIndex][iEmoteIndex].name);
			iCode++;
		}
		PrintToConsole(client, "--------------------");
	}

	return Plugin_Handled;
}

public Action Command_DanceCode(int client, int args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

#if !DEBUG
	if(g_bLateload)
	{
		CReplyToCommand(client, "%t %t", "TAG", "LATLOAD");
		return Plugin_Handled;
	}
#endif

	if (!IsValidAccess(client))
		CReplyToCommand(client, "%t %t", "TAG", "NO_EMOTES_ACCESS_FLAG");

	CPrintToChat(client, "%t %t", "TAG", "DANCE_LIST_CONSOLE");
	int iCode = 1;

	for (int iFilesIndex = 1; iFilesIndex <= g_iFilesFnemotesCounter; iFilesIndex++)
	{	
		if(g_iDancesSize[iFilesIndex] == 0)
			continue;

		if(iFilesIndex != 1)
			PrintToConsole(client, " ");

		PrintToConsole(client, "\nFile [%s]", g_FilesConfig[iFilesIndex].name);
		PrintToConsole(client, "--------------------");
		for (int iDanceIndex = 1; iDanceIndex <= g_iDancesSize[iFilesIndex]; iDanceIndex++)
		{
			PrintToConsole(client, "> Code: #%d | %s", iCode, g_Dances[iFilesIndex][iDanceIndex].name);
			iCode++;
		}
		PrintToConsole(client, "--------------------");
	}

	return Plugin_Handled;
}

public Action Command_Dance(int client, int args)
{
	if (!IsValidClient(client))
		return Plugin_Handled;

#if !DEBUG
	if(g_bLateload)
	{
		CReplyToCommand(client, "%t %t", "TAG", "LATLOAD");
		return Plugin_Handled;
	}
#endif

	if (!IsValidAccess(client))
		CReplyToCommand(client, "%t %t", "TAG", "NO_DANCES_ACCESS_FLAG");

	if(args == 0 && SM_REPLY_TO_CHAT == GetCmdReplySource())
	{
		Menu_Main(client);
		return Plugin_Handled;
	}

	if (args != 1)
	{
		CReplyToCommand(client, "%t: sm_emote <#emote>", "USAGE");
		return Plugin_Handled;
	}

	if (g_bEmoteCooldown[client])
	{
		CReplyToCommand(client, "%t %t", "TAG", "COOLDOWN_EMOTES");
		return Plugin_Handled;
	}

	if (!IsSurvivor(client))
	{
		CReplyToCommand(client, "%t %t", "TAG", "NOTSURVIVOR");
		return Plugin_Handled;
	}

	if (g_bPause)
	{
		if (IsInPause())
		{
			CReplyToCommand(client, "%t %t", "TAG", "PAUSE_MODE");
			return Plugin_Handled;
		}
	}

	if (g_bClientDancing[client])
	{
		CReplyToCommand(client, "%t %t", "TAG", "CANNOT_USE_NOW");
		return Plugin_Handled;
	}

	int iDanceCode = GetCmdArgInt(1);
	iDanceCode = (iDanceCode < 0) ? -iDanceCode : iDanceCode;

	int
		iFile,
		iItem;

	char
		sAnim1[32],
		sAnim2[32],
		sSound[64];

	bool
		bIsLoop;

	int iDanceCounter = 0;

	for (int iFilesIndex = 1; iFilesIndex <= g_iFilesFnemotesCounter; iFilesIndex++)
	{
		iDanceCounter += g_iDancesSize[iFilesIndex];
		if (iDanceCode <= iDanceCounter)
		{
			iFile = iFilesIndex;
			iItem = iDanceCode - (iDanceCounter - g_iDancesSize[iFilesIndex]);
			break;
		}
	}

	if (iFile == 0 || iItem == 0)
	{
		CReplyToCommand(client, "%t %t", "TAG", "INVALID_DANCE_ID", iDanceCounter);
		return Plugin_Handled;
	}

	if (!GetEmoteInfo(iFile, g_Dances[iFile][iItem].name, sAnim1, sizeof(sAnim1), sAnim2, sizeof(sAnim2), sSound, sizeof(sSound), bIsLoop, true))
	{
		CPrintToChat(client, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_Dances[iFile][iItem].name);
		return Plugin_Handled;
	}

	CreateEmote(client, sAnim1, sAnim2, sSound, bIsLoop, iFile);
	return Plugin_Handled;
}

Action Command_SetEmote(int client, int args)
{
	if (args != 1 && args != 3)
	{
		CReplyToCommand(client, "%t: sm_setemote <#userid|name> <configid|blank:random> <emoteid|blank:random>", "USAGE");
		return Plugin_Handled;
	}

#if !DEBUG
	if(g_bLateload)
	{
		CReplyToCommand(client, "%t %t", "TAG", "LATLOAD");
		return Plugin_Handled;
	}
#endif

	char target[65];
	GetCmdArg(1, target, sizeof(target));

	char
		target_name[MAX_TARGET_LENGTH];

	int
		target_list[MAXPLAYERS],
		target_count;

	bool
		tn_is_ml;

	if ((target_count = ProcessTargetString(target, client, target_list, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name, sizeof(target_name), tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	if (args == 3)
	{
		for (int i = 0; i < target_count; i++)
		{
			CreateRandomEmote(target_list[i]);
		}
	}

	int iFile = GetCmdArgInt(2);
	if (!CheckConfig(iFile))
	{
		CReplyToCommand(client, "%t %t", "TAG", "INVALID_CONFIG_ID", g_iFilesFnemotesCounter);
		return Plugin_Handled;
	}

	int iItem = GetCmdArgInt(3);
	if (!CheckEmote(iFile, iItem))
	{
		CReplyToCommand(client, "%t %t", "TAG", "INVALID_EMOTE_ID", g_iEmotesSize[iFile]);
		return Plugin_Handled;
	}

	for (int i = 0; i < target_count; i++)
	{
		char
			sAnim1[32],
			sAnim2[32],
			sSound[64];

		bool
			bIsLoop;

		if (!GetEmoteInfo(iFile, g_Emotes[iFile][iItem].name, sAnim1, sizeof(sAnim1), sAnim2, sizeof(sAnim2), sSound, sizeof(sSound), bIsLoop))
		{
			CPrintToChat(client, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_Emotes[iFile][iItem].name);
			return Plugin_Handled;
		}

		CreateEmote(target_list[i], sAnim1, sAnim2, sSound, bIsLoop, iFile);
	}

	return Plugin_Handled;
}

Action Command_SetDance(int client, int args)
{
	if (args != 1 && args != 3)
	{
		CReplyToCommand(client, "%t: sm_setdance <#userid|name> <configid|blank:random> <emoteid|blank:random>", "USAGE");
		return Plugin_Handled;
	}

	char target[65];
	GetCmdArg(1, target, sizeof(target));

	char
		target_name[MAX_TARGET_LENGTH];

	int
		target_list[MAXPLAYERS],
		target_count;

	bool
		tn_is_ml;

	if ((target_count = ProcessTargetString(target, client, target_list, MAXPLAYERS, COMMAND_FILTER_ALIVE, target_name, sizeof(target_name), tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	if (args == 3)
	{
		for (int i = 0; i < target_count; i++)
		{
			CreateRandomEmote(target_list[i], true);
		}
	}

	int iFile = GetCmdArgInt(2);
	if (!CheckConfig(iFile))
	{
		CReplyToCommand(client, "%t %t", "TAG", "INVALID_CONFIG_ID", g_iFilesFnemotesCounter);
		return Plugin_Handled;
	}

	int iItem = GetCmdArgInt(3);
	if (!CheckEmote(iFile, iItem))
	{
		CReplyToCommand(client, "%t %t", "TAG", "INVALID_EMOTE_ID", g_iEmotesSize[iFile]);
		return Plugin_Handled;
	}

	for (int i = 0; i < target_count; i++)
	{
		char
			sAnim1[32],
			sAnim2[32],
			sSound[64];

		bool
			bIsLoop;

		if (!GetEmoteInfo(iFile, g_Dances[iFile][iItem].name, sAnim1, sizeof(sAnim1), sAnim2, sizeof(sAnim2), sSound, sizeof(sSound), bIsLoop, true))
		{
			CPrintToChat(client, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_Dances[iFile][iItem].name);
			return Plugin_Handled;
		}

		CreateEmote(target_list[i], sAnim1, sAnim2, sSound, bIsLoop, iFile);
	}

	return Plugin_Handled;
}

public void OnConfigsExecuted()
{
	OnConfigsExecuted_resources();
}

public void OnMapStart()
{
	if(g_bLateload)
		g_bLateload = false;
	OnMapStart_Resources();
}

public void OnPluginEnd()
{
	StopDancer();
	OnPluginEnd_vipcore();
	OnPluginEnd_resources();
}

public void OnClientPutInServer(int client)
{
	if (IsValidClient(client))
	{
		ResetCam(client);
		TerminateEmote(client);
		g_iWeaponHandEnt[client] = INVALID_ENT_REFERENCE;

		if (CooldownTimers[client] != null)
			KillTimer(CooldownTimers[client]);
	}
}

public void OnClientDisconnect(int client)
{
	if (IsValidClient(client))
	{
		ResetCam(client);
		TerminateEmote(client);
	}
	if (CooldownTimers[client] != null)
	{
		KillTimer(CooldownTimers[client]);
		CooldownTimers[client]	 = null;
		g_bEmoteCooldown[client] = false;
	}

	g_bHooked[client] = false;
}

/*****************************************************************
			F O R W A R D   P L U G I N S
*****************************************************************/
public Action OnPlayerRunCmd(int client, int& iButtons, int& iImpulse, float fVelocity[3], float fAngles[3], int& iWeapon)
{
	if (g_bClientDancing[client] && !(GetEntityFlags(client) & FL_ONGROUND))
		StopEmote(client);

	static int iAllowedButtons = IN_BACK | IN_FORWARD | IN_MOVELEFT | IN_MOVERIGHT | IN_WALK | IN_SPEED | IN_SCORE;

	if (iButtons == 0)
		return Plugin_Continue;

	if (g_iEmoteEnt[client] == 0)
		return Plugin_Continue;

	if ((iButtons & iAllowedButtons) && !(iButtons & ~iAllowedButtons))
		return Plugin_Continue;

	StopEmote(client);

	return Plugin_Continue;
}

public void OnPause()
{
	StopDancer();
}

public void OnRoundLiveCountdownPre()
{
	StopDancer();
}

public void VIP_OnVIPLoaded()
{
	VIP_OnVIPLoaded_vipcore();
}

/****************************************************************
			C A L L B A C K   F U N C T I O N S
****************************************************************/
public void Event_PAfk(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "player"));
	int target = GetClientOfUserId(GetEventInt(event, "bot"));
	if (IsClientInGame(client))
	{
		ResetCam(client);
		TerminateEmote(client);
		RemoveSkin(client);
		WeaponUnblock(client);
		g_bClientDancing[client] = false;
	}

	SetEntityMoveType(target, MOVETYPE_WALK);
}

public void Event_PAfkQ(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (0 < client <= MaxClients && g_bClientDancing[client])
	{
		ResetCam(client);
		TerminateEmote(client);
		RemoveSkin(client);
		WeaponUnblock(client);
		g_bClientDancing[client] = false;
	}
}

public Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (IsValidClient(client))
	{
		ResetCam(client);
		StopEmote(client);
	}
	return Plugin_Continue;
}

public Action Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	int client	 = GetClientOfUserId(event.GetInt("userid"));

	if (!IsSurvivor(client))
		return Plugin_Continue;

	if (attacker != client)
		StopEmote(client);

	return Plugin_Continue;
}

public Action Event_Start(Event event, const char[] name, bool dontBroadcast)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i, false) && g_bClientDancing[i])
		{
			ResetCam(i);
			// StopEmote(client);
			WeaponUnblock(i);

			g_bClientDancing[i] = false;
		}
	}

	return Plugin_Continue;
}

public void Event_PlayerTeam(Event hEvent, const char[] sEventName, bool bDontBroadcast)
{
	int iClient = GetClientOfUserId(hEvent.GetInt("userid"));
	if (!IsClientInGame(iClient) || IsFakeClient(iClient))
		return;

	L4DTeam
		OldTeam = view_as<L4DTeam>(hEvent.GetInt("oldteam"));

	if (OldTeam != L4DTeam_Survivor)
		return;

	StopEmote(iClient);
}

/*****************************************************************
			P L U G I N   F U N C T I O N S
*****************************************************************/

stock bool IsValidClient(int client, bool nobots = true)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
		return false;

	return IsClientInGame(client);
}

bool CheckAdminFlags(int client, int iFlag)
{
	int iUserFlags = GetUserFlagBits(client);
	return (iUserFlags & ADMFLAG_ROOT || (iUserFlags & iFlag) == iFlag);
}

int GetEmotePeople()
{
	int count;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && g_bClientDancing[i])
			count++;
	}

	return count;
}

public void OnClientPostAdminCheck(int client)
{
	playerModelsIndex[client] = -1;
	playerModels[client]	  = INVALID_ENT_REFERENCE;
}

bool IsSurvivor(int client)
{
	return (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2);
}

public int CreatePlayerModelProp(int client, char[] sModel)
{
	if (g_iEngine == Engine_Left4Dead)
	{
		RemoveSkin(client);
		int skin = CreateEntityByName("commentary_dummy");
		DispatchKeyValue(skin, "model", sModel);
		DispatchSpawn(skin);
		SetEntProp(skin, Prop_Send, "m_fEffects", EF_BONEMERGE | EF_BONEMERGE_FASTCULL | EF_PARENT_ANIMATES);
		SetVariantString("!activator");
		AcceptEntityInput(skin, "SetParent", client, skin);
		SetVariantString("primary");
		AcceptEntityInput(skin, "SetParentAttachment", skin, skin, 0);
		playerModels[client]	  = EntIndexToEntRef(skin);
		playerModelsIndex[client] = skin;
		return skin;
	}

	return 0;
}

public void RemoveSkin(int client)
{
	if (IsValidEntity(playerModels[client]))
		AcceptEntityInput(playerModels[client], "Kill");

	playerModels[client]	  = INVALID_ENT_REFERENCE;
	playerModelsIndex[client] = -1;
}

/**
 * Check if the translation file exists
 *
 * @param translation	Translation name.
 * @noreturn
 */
stock void LoadTranslation(const char[] translation)
{
	char
		sPath[PLATFORM_MAX_PATH],
		sName[64];

	Format(sName, sizeof(sName), "translations/%s.txt", translation);
	BuildPath(Path_SM, sPath, sizeof(sPath), sName);
	if (!FileExists(sPath))
		SetFailState("Missing translation file %s.txt", translation);

	LoadTranslations(translation);
}

/**
 * Stops the dancing emote for all valid clients.
 */
void StopDancer()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsValidClient(i) && g_bClientDancing[i])
			StopEmote(i);
	}
}

/**
 * Checks if a client has valid access.
 *
 * @param client The client index to check.
 * @return True if the client has valid access, false otherwise.
 */
bool IsValidAccess(int client, bool isDance = false)
{
	if (g_bVipCore)
	{
		if (VIP_IsClientVIP(client))
			return true;
	}
	else
	{
		char sFlagAdmin[32];
		if (isDance)
			g_cvarFlagDancesMenu.GetString(sFlagAdmin, sizeof(sFlagAdmin));
		else
			g_cvarFlagEmotesMenu.GetString(sFlagAdmin, sizeof(sFlagAdmin));

		if (CheckAdminFlags(client, ReadFlagString(sFlagAdmin)))
			return true;
	}

	return false;
}

bool CheckConfig(int iConfig)
{
	if (iConfig < 1 || iConfig > g_iFilesFnemotesCounter)
		return false;

	return true;
}

bool CheckEmote(int iConfig, int iEmote, bool bIsDance = false)
{
	int iEmoteSize;

	if (bIsDance)
		iEmoteSize = g_iDancesSize[iConfig];
	else
		iEmoteSize = g_iEmotesSize[iConfig];

	if (iEmote < 1 || iEmote > iEmoteSize)
		return false;

	return true;
}