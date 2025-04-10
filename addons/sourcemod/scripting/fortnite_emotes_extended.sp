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

#define DEBUG			0
#define DEBUG_SOUND 	0
#define DEBUG_RESOURCES 0

#define EF_BONEMERGE		  0x001
#define EF_NOSHADOW			  0x010
#define EF_BONEMERGE_FASTCULL 0x080
#define EF_NORECEIVESHADOW	  0x040
#define EF_PARENT_ANIMATES	  0x200
#define HIDEHUD_ALL			  (1 << 2)
#define HIDEHUD_CROSSHAIR	  (1 << 8)
#define DIR_EMOTES		  	"logs/Fornite_Emotes.log"

ConVar
	g_cvHidePlayers,
	g_cvFlagEmotesMenu,
	g_cvFlagDancesMenu,
	g_cvCooldown,
	g_cvSoundVolume,
	g_cvEmotesSounds,
	g_cvHideWeapons,
	g_cvTeleportBack,
	g_cvSpeed,
	g_cvDownloadResources;

int
	g_iEmoteEnt[MAXPLAYERS + 1],
	g_iEmoteSoundEnt[MAXPLAYERS + 1],
	g_iWeaponHandEnt[MAXPLAYERS + 1],
	g_iPlayerModels[MAXPLAYERS + 1],
	g_iPlayerModelsIndex[MAXPLAYERS + 1];

char
	g_szEmoteSound[MAXPLAYERS + 1][PLATFORM_MAX_PATH];

#if DEBUG
char
	g_szLogPath[PLATFORM_MAX_PATH];
#endif

bool
	g_bClientDancing[MAXPLAYERS + 1],
	g_bEmoteCooldown[MAXPLAYERS + 1],
	g_bHooked[MAXPLAYERS + 1],
	g_bLateload,
	g_bVipCore = false,
	g_bPause = false;

Handle
	g_hCooldownTimers[MAXPLAYERS + 1];

float
	g_fLastAngles[MAXPLAYERS + 1][3],
	g_fLastPosition[MAXPLAYERS + 1][3];

enum L4DTeam
{
	L4DTeam_Unassigned				= 0,
	L4DTeam_Spectator				= 1,
	L4DTeam_Survivor				= 2,
	L4DTeam_Infected				= 3
}

stock const int g_iGenderToSurvivorIndex[L4D2Gender_MaxSize] =
{
	SurvivorCharacter_Invalid, // L4D2Gender_Neutral = 0,
	SurvivorCharacter_Invalid, // L4D2Gender_Male = 1,
	SurvivorCharacter_Invalid, // L4D2Gender_Female = 2,
	SurvivorCharacter_Bill, // L4D2Gender_Nanvet = 3, // Bill
	SurvivorCharacter_Zoey, // L4D2Gender_TeenGirl = 4, // Zoey
	SurvivorCharacter_Francis, // L4D2Gender_Biker = 5, // Francis
	SurvivorCharacter_Louis, // L4D2Gender_Manager = 6, // Louis
	SurvivorCharacter_Nick, // L4D2Gender_Gambler = 7, // Nick
	SurvivorCharacter_Rochelle, // L4D2Gender_Producer = 8, // Rochelle
	SurvivorCharacter_Coach, // L4D2Gender_Coach = 9, // Coach
	SurvivorCharacter_Ellis, // L4D2Gender_Mechanic = 10, // Ellis
	SurvivorCharacter_Invalid, // L4D2Gender_Ceda = 11,
	SurvivorCharacter_Invalid, // L4D2Gender_Crawler = 12, // Mudman
	SurvivorCharacter_Invalid, // L4D2Gender_Undistractable = 13, // Workman (class not reacting to the pipe bomb)
	SurvivorCharacter_Invalid, // L4D2Gender_Fallen = 14,
	SurvivorCharacter_Invalid, // L4D2Gender_Riot_Control = 15, // RiotCop
	SurvivorCharacter_Invalid, // L4D2Gender_Clown = 16,
	SurvivorCharacter_Invalid, // L4D2Gender_Jimmy = 17, // JimmyGibbs
	SurvivorCharacter_Invalid, // L4D2Gender_Hospital_Patient = 18,
	SurvivorCharacter_Invalid, // L4D2Gender_Witch_Bride = 19,
	SurvivorCharacter_Invalid, // L4D2Gender_Police = 20, // l4d1 RiotCop (was removed from the game)
	SurvivorCharacter_Invalid, // L4D2Gender_Male_L4D1 = 21,
	SurvivorCharacter_Invalid, // L4D2Gender_Female_L4D1 = 22
};

enum /*SurvivorCharacterType*/
{
	SurvivorCharacter_Nick = 0,
	SurvivorCharacter_Rochelle,
	SurvivorCharacter_Coach,
	SurvivorCharacter_Ellis,
	SurvivorCharacter_Bill,
	SurvivorCharacter_Zoey,
	SurvivorCharacter_Francis,
	SurvivorCharacter_Louis,
	SurvivorCharacter_Invalid, // 8

	SurvivorCharacter_Size // 9 size
};

enum /*L4D2_Gender*/
{
	L4D2Gender_Neutral			= 0,
	L4D2Gender_Male				= 1,
	L4D2Gender_Female			= 2,
	L4D2Gender_Nanvet			= 3, //Bill
	L4D2Gender_TeenGirl			= 4, //Zoey
	L4D2Gender_Biker			= 5, //Francis
	L4D2Gender_Manager			= 6, //Louis
	L4D2Gender_Gambler			= 7, //Nick
	L4D2Gender_Producer			= 8, //Rochelle
	L4D2Gender_Coach			= 9, //Coach
	L4D2Gender_Mechanic			= 10, //Ellis
	L4D2Gender_Ceda				= 11,
	L4D2Gender_Crawler			= 12, //Mudman
	L4D2Gender_Undistractable	= 13, //Workman (class not reacting to the pipe bomb)
	L4D2Gender_Fallen			= 14,
	L4D2Gender_Riot_Control		= 15, //RiotCop
	L4D2Gender_Clown			= 16,
	L4D2Gender_Jimmy			= 17, //JimmyGibbs
	L4D2Gender_Hospital_Patient	= 18,
	L4D2Gender_Witch_Bride		= 19,
	L4D2Gender_Police			= 20, //l4d1 RiotCop (was removed from the game)
	L4D2Gender_Male_L4D1		= 21,
	L4D2Gender_Female_L4D1		= 22,

	L4D2Gender_MaxSize //23 size
};

/*****************************************************************
			L I B R A R Y   I N C L U D E S
*****************************************************************/

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
	version		= "1.7.0",
	url			= "https://github.com/lechuga16/Fortnite-Emotes-Extended"
};

/*****************************************************************
			F O R W A R D   P U B L I C S
*****************************************************************/
public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	if (Engine_Left4Dead2 != GetEngineVersion())
	{
		strcopy(error, err_max, "Plugin only supports in Left 4 Dead 2");
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
#if DEBUG
	BuildPath(Path_SM, g_szLogPath, sizeof(g_szLogPath), DIR_EMOTES);
#endif
	vLoadTranslation("common.phrases");
	vLoadTranslation("fnemotes.phrases");

	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
	HookEvent("round_start", Event_Start);
	HookEvent("player_team", Event_PlayerTeam);

	g_cvEmotesSounds		= CreateConVar("sm_emotes_sounds", "1", "Enable/Disable sounds for emotes.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvCooldown			= CreateConVar("sm_emotes_cooldown", "2.0", "Cooldown for emotes in seconds. 0 = no cooldown.", FCVAR_NOTIFY, true, 0.0);
	g_cvSoundVolume		= CreateConVar("sm_emotes_soundvolume", "1.0", "Sound volume for the emotes.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvFlagEmotesMenu	= CreateConVar("sm_emotes_admin_flag_menu", "", "admin flag for emotes (empty for all players)", FCVAR_NOTIFY);
	g_cvFlagDancesMenu	= CreateConVar("sm_dances_admin_flag_menu", "", "admin flag for dances (empty for all players)", FCVAR_NOTIFY);
	g_cvHideWeapons		= CreateConVar("sm_emotes_hide_weapons", "1", "Hide weapons when dancing", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvHidePlayers		= CreateConVar("sm_emotes_hide_enemies", "0", "Hide enemy players when dancing", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvTeleportBack		= CreateConVar("sm_emotes_teleportonend", "1", "Teleport back to the exact position when he started to dance. (Some maps need this for teleport triggers)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_cvSpeed				= CreateConVar("sm_emotes_speed", "0.8", "Sets the playback speed of the animation. default (1.0)", FCVAR_NOTIFY, true, 0.0);
	g_cvDownloadResources = CreateConVar("sm_emotes_download_resources", "1", "Download method for the resources", FCVAR_NOTIFY, true, 0.0, true, 1.0);

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
	vOnPluginStart_vipcore();
}

public Action Command_Emote(int iClient, int iArgs)
{
	if (!bIsValidClient(iClient))
		return Plugin_Handled;

	if (!bIsValidAccess(iClient))
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "NO_EMOTES_ACCESS_FLAG");
		return Plugin_Handled;
	}

	if (iArgs == 0 && SM_REPLY_TO_CHAT == GetCmdReplySource())
	{
		aMainMenu(iClient);
		return Plugin_Handled;
	}

	if (iArgs != 1)
	{
		CReplyToCommand(iClient, "%t: sm_emote <#emote>", "USAGE");
		return Plugin_Handled;
	}

	if (g_bEmoteCooldown[iClient])
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "COOLDOWN_EMOTES");
		return Plugin_Handled;
	}

	if (!bIsSurvivor(iClient))
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "NOTSURVIVOR");
		return Plugin_Handled;
	}

	if (g_bPause)
	{
		if (IsInPause())
		{
			CReplyToCommand(iClient, "%t %t", "TAG", "PAUSE_MODE");
			return Plugin_Handled;
		}
	}

	if (g_bClientDancing[iClient])
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "CANNOT_USE_NOW");
		return Plugin_Handled;
	}

	int iEmoteCode = GetCmdArgInt(1);
	iEmoteCode = (iEmoteCode < 0) ? -iEmoteCode : iEmoteCode;

	int iFile, iItem;
	char szAnim1[64], szAnim2[64], szSound[PLATFORM_MAX_PATH];
	bool bIsLoop;

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
		CReplyToCommand(iClient, "%t %t", "TAG", "INVALID_EMOTE_ID", iEmoteCounter);
		return Plugin_Handled;
	}

	if (!bGetEmoteInfo(iFile, g_szEmotes[iFile][iItem].szName, szAnim1, sizeof(szAnim1), szAnim2, sizeof(szAnim2), szSound, sizeof(szSound), bIsLoop))
	{
		CPrintToChat(iClient, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_szEmotes[iFile][iItem].szName);
		return Plugin_Handled;
	}

	aCreateEmote(iClient, szAnim1, szAnim2, szSound, bIsLoop, iFile);
	return Plugin_Handled;
}

public Action Command_EmoteCode(int iClient, int iArgs)
{
	if (!bIsValidClient(iClient))
		return Plugin_Handled;

	if (!bIsValidAccess(iClient))
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "NO_EMOTES_ACCESS_FLAG");
		return Plugin_Handled;
	}

	CPrintToChat(iClient, "%t %t", "TAG", "EMOTES_LIST_CONSOLE");
	int iCode = 1;
	char szBuffer[128];
	for (int iFilesIndex = 1; iFilesIndex <= g_iFilesFnemotesCounter; iFilesIndex++)
	{	
		if(g_iEmotesSize[iFilesIndex] == 0)
			continue;

		if(iFilesIndex != 1)
			PrintToConsole(iClient, " ");
		
		szBuffer[0] = '\0';
		strcopy(szBuffer, sizeof(szBuffer), g_szFilesConfig[iFilesIndex].szName);
		ReplaceString(szBuffer, sizeof(szBuffer), "fnemotes_", "");
		ReplaceString(szBuffer, sizeof(szBuffer), ".cfg", "");
		PrintToConsole(iClient, "%t %s", "FILE", szBuffer);
		PrintToConsole(iClient, "--------------------");
		for (int iEmoteIndex = 1; iEmoteIndex <= g_iEmotesSize[iFilesIndex]; iEmoteIndex++)
		{
			szBuffer[0] = '\0';
			strcopy(szBuffer, sizeof(szBuffer), g_szEmotes[iFilesIndex][iEmoteIndex].szName);
			ReplaceString(szBuffer, sizeof(szBuffer), "Emote_", "");
			ReplaceString(szBuffer, sizeof(szBuffer), "_", " ");
			PrintToConsole(iClient, "> %t: %d | %t: %s", "CODE", iCode, "NAME", szBuffer);
			iCode++;
		}
		PrintToConsole(iClient, "--------------------");
	}

	return Plugin_Handled;
}

public Action Command_DanceCode(int iClient, int iArgs)
{
	if (!bIsValidClient(iClient))
		return Plugin_Handled;

	if (!bIsValidAccess(iClient))
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "NO_EMOTES_ACCESS_FLAG");
		return Plugin_Handled;
	}

	CPrintToChat(iClient, "%t %t", "TAG", "DANCE_LIST_CONSOLE");
	int iCode = 1;
	char szBuffer[128];

	for (int iFilesIndex = 1; iFilesIndex <= g_iFilesFnemotesCounter; iFilesIndex++)
	{	
		if(g_iDancesSize[iFilesIndex] == 0)
			continue;

		if(iFilesIndex != 1)
			PrintToConsole(iClient, " ");

		szBuffer[0] = '\0';
		strcopy(szBuffer, sizeof(szBuffer), g_szFilesConfig[iFilesIndex].szName);
		ReplaceString(szBuffer, sizeof(szBuffer), "fnemotes_", "");
		ReplaceString(szBuffer, sizeof(szBuffer), ".cfg", "");
		PrintToConsole(iClient, "%t %s", "FILE", szBuffer);
		PrintToConsole(iClient, "--------------------");
		for (int iDanceIndex = 1; iDanceIndex <= g_iDancesSize[iFilesIndex]; iDanceIndex++)
		{
			szBuffer[0] = '\0';
			strcopy(szBuffer, sizeof(szBuffer), g_szDances[iFilesIndex][iDanceIndex].szName);
			ReplaceString(szBuffer, sizeof(szBuffer), "Emote_", "");
			ReplaceString(szBuffer, sizeof(szBuffer), "_", " ");
			PrintToConsole(iClient, "> %t: %d | %t: %s", "CODE", iCode, "NAME", szBuffer);
			iCode++;
		}
		PrintToConsole(iClient, "--------------------");
	}

	return Plugin_Handled;
}

public Action Command_Dance(int iClient, int iArgs)
{
	if (!bIsValidClient(iClient))
		return Plugin_Handled;

	if (!bIsValidAccess(iClient))
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "NO_EMOTES_ACCESS_FLAG");
		return Plugin_Handled;
	}

	if(iArgs == 0 && SM_REPLY_TO_CHAT == GetCmdReplySource())
	{
		aMainMenu(iClient);
		return Plugin_Handled;
	}

	if (iArgs != 1)
	{
		CReplyToCommand(iClient, "%t: sm_emote <#emote>", "USAGE");
		return Plugin_Handled;
	}

	if (g_bEmoteCooldown[iClient])
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "COOLDOWN_EMOTES");
		return Plugin_Handled;
	}

	if (!bIsSurvivor(iClient))
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "NOTSURVIVOR");
		return Plugin_Handled;
	}

	if (g_bPause)
	{
		if (IsInPause())
		{
			CReplyToCommand(iClient, "%t %t", "TAG", "PAUSE_MODE");
			return Plugin_Handled;
		}
	}

	if (g_bClientDancing[iClient])
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "CANNOT_USE_NOW");
		return Plugin_Handled;
	}

	int iDanceCode = GetCmdArgInt(1);
	iDanceCode = (iDanceCode < 0) ? -iDanceCode : iDanceCode;

	int iFile, iItem;
	char szAnim1[64], szAnim2[64], szSound[PLATFORM_MAX_PATH];
	bool bIsLoop;

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
		CReplyToCommand(iClient, "%t %t", "TAG", "INVALID_DANCE_ID", iDanceCounter);
		return Plugin_Handled;
	}

	if (!bGetEmoteInfo(iFile, g_szDances[iFile][iItem].szName, szAnim1, sizeof(szAnim1), szAnim2, sizeof(szAnim2), szSound, sizeof(szSound), bIsLoop, true))
	{
		CPrintToChat(iClient, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_szDances[iFile][iItem].szName);
		return Plugin_Handled;
	}

	aCreateEmote(iClient, szAnim1, szAnim2, szSound, bIsLoop, iFile);
	return Plugin_Handled;
}

Action Command_SetEmote(int iClient, int iArgs)
{
	if (iArgs != 1 && iArgs != 3)
	{
		CReplyToCommand(iClient, "%t: sm_setemote <#userid|name> <configid|blank:random> <emoteid|blank:random>", "USAGE");
		return Plugin_Handled;
	}

	char szTarget[65];
	GetCmdArg(1, szTarget, sizeof(szTarget));

	char szTargetName[MAX_TARGET_LENGTH];
	int aiTargetList[MAXPLAYERS], iTargetCount;
	bool bTnIsMl;

	if ((iTargetCount = ProcessTargetString(szTarget, iClient, aiTargetList, MAXPLAYERS, COMMAND_FILTER_ALIVE, szTargetName, sizeof(szTargetName), bTnIsMl)) <= 0)
	{
		ReplyToTargetError(iClient, iTargetCount);
		return Plugin_Handled;
	}

	if (iArgs == 3)
	{
		for (int i = 0; i < iTargetCount; i++)
		{
			vCreateRandomEmote(aiTargetList[i]);
		}
	}

	int iFile = GetCmdArgInt(2);
	if (!bCheckConfig(iFile))
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "INVALID_CONFIG_ID", g_iFilesFnemotesCounter);
		return Plugin_Handled;
	}

	int iItem = GetCmdArgInt(3);
	if (!bCheckEmote(iFile, iItem))
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "INVALID_EMOTE_ID", g_iEmotesSize[iFile]);
		return Plugin_Handled;
	}

	for (int i = 0; i < iTargetCount; i++)
	{
		char szAnim1[64], szAnim2[64], szSound[PLATFORM_MAX_PATH];
		bool bIsLoop;

		if (!bGetEmoteInfo(iFile, g_szEmotes[iFile][iItem].szName, szAnim1, sizeof(szAnim1), szAnim2, sizeof(szAnim2), szSound, sizeof(szSound), bIsLoop))
		{
			CPrintToChat(iClient, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_szEmotes[iFile][iItem].szName);
			return Plugin_Handled;
		}

		aCreateEmote(aiTargetList[i], szAnim1, szAnim2, szSound, bIsLoop, iFile);
	}

	return Plugin_Handled;
}

Action Command_SetDance(int iClient, int iArgs)
{
	if (iArgs != 1 && iArgs != 3)
	{
		CReplyToCommand(iClient, "%t: sm_setdance <#userid|name> <configid|blank:random> <emoteid|blank:random>", "USAGE");
		return Plugin_Handled;
	}

	char szTarget[65];
	GetCmdArg(1, szTarget, sizeof(szTarget));

	char szTargetName[MAX_TARGET_LENGTH];
	int aiTargetList[MAXPLAYERS], iTargetCount;
	bool bTnIsMl;

	if ((iTargetCount = ProcessTargetString(szTarget, iClient, aiTargetList, MAXPLAYERS, COMMAND_FILTER_ALIVE, szTargetName, sizeof(szTargetName), bTnIsMl)) <= 0)
	{
		ReplyToTargetError(iClient, iTargetCount);
		return Plugin_Handled;
	}

	if (iArgs == 3)
	{
		for (int i = 0; i < iTargetCount; i++)
		{
			vCreateRandomEmote(aiTargetList[i], true);
		}
	}

	int iFile = GetCmdArgInt(2);
	if (!bCheckConfig(iFile))
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "INVALID_CONFIG_ID", g_iFilesFnemotesCounter);
		return Plugin_Handled;
	}

	int iItem = GetCmdArgInt(3);
	if (!bCheckEmote(iFile, iItem))
	{
		CReplyToCommand(iClient, "%t %t", "TAG", "INVALID_EMOTE_ID", g_iEmotesSize[iFile]);
		return Plugin_Handled;
	}

	for (int i = 0; i < iTargetCount; i++)
	{
		char szAnim1[64], szAnim2[64], szSound[PLATFORM_MAX_PATH];
		bool bIsLoop;

		if (!bGetEmoteInfo(iFile, g_szDances[iFile][iItem].szName, szAnim1, sizeof(szAnim1), szAnim2, sizeof(szAnim2), szSound, sizeof(szSound), bIsLoop, true))
		{
			CPrintToChat(iClient, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_szDances[iFile][iItem].szName);
			return Plugin_Handled;
		}

		aCreateEmote(aiTargetList[i], szAnim1, szAnim2, szSound, bIsLoop, iFile);
	}

	return Plugin_Handled;
}

public void OnMapStart()
{
	vOnMapStart_Resources();
}

public void OnPluginEnd()
{
	vStopDancer();
	vOnPluginEnd_vipcore();
}

public void OnClientPutInServer(int iClient)
{
	if (bIsValidClient(iClient))
	{
		vRevSetCam(iClient);
		vTerminateEmote(iClient);
		g_iWeaponHandEnt[iClient] = INVALID_ENT_REFERENCE;

		if (g_hCooldownTimers[iClient] != null)
			KillTimer(g_hCooldownTimers[iClient]);
	}
}

public void OnClientDisconnect(int iClient)
{
	if (bIsValidClient(iClient))
	{
		vRevSetCam(iClient);
		vTerminateEmote(iClient);
	}
	if (g_hCooldownTimers[iClient] != null)
	{
		KillTimer(g_hCooldownTimers[iClient]);
		g_hCooldownTimers[iClient]	 = null;
		g_bEmoteCooldown[iClient] = false;
	}

	g_bHooked[iClient] = false;
}

/*****************************************************************
			F O R W A R D   P L U G I N S
*****************************************************************/

public Action OnPlayerRunCmd(int iClient, int& iButtons, int& iImpulse, float fVelocity[3], float fAngles[3], int& iWeapon)
{
	if (g_bClientDancing[iClient] && !(GetEntityFlags(iClient) & FL_ONGROUND))
		vStopEmote(iClient);

	static int iAllowedButtons = IN_BACK | IN_FORWARD | IN_MOVELEFT | IN_MOVERIGHT | IN_WALK | IN_SPEED | IN_SCORE;

	if (iButtons == 0)
		return Plugin_Continue;

	if (g_iEmoteEnt[iClient] == 0)
		return Plugin_Continue;

	if ((iButtons & iAllowedButtons) && !(iButtons & ~iAllowedButtons))
		return Plugin_Continue;

	vStopEmote(iClient);

	return Plugin_Continue;
}

public void OnPause()
{
	vStopDancer();
}

public void OnRoundLiveCountdownPre()
{
	vStopDancer();
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
	int iClient = GetClientOfUserId(GetEventInt(event, "player"));
	int iTarget = GetClientOfUserId(GetEventInt(event, "bot"));
	if (IsClientInGame(iClient))
	{
		vRevSetCam(iClient);
		vTerminateEmote(iClient);
		vRemoveSkin(iClient);
		vWeaponUnblock(iClient);
		g_bClientDancing[iClient] = false;
	}

	SetEntityMoveType(iTarget, MOVETYPE_WALK);
}

public void Event_PAfkQ(Handle event, const char[] name, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));
	if (0 < iClient <= MaxClients && g_bClientDancing[iClient])
	{
		vRevSetCam(iClient);
		vTerminateEmote(iClient);
		vRemoveSkin(iClient);
		vWeaponUnblock(iClient);
		g_bClientDancing[iClient] = false;
	}
}

public Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(GetEventInt(event, "userid"));

	if (bIsValidClient(iClient))
	{
		vRevSetCam(iClient);
		vStopEmote(iClient);
	}
	return Plugin_Continue;
}

public Action Event_PlayerHurt(Event event, const char[] name, bool dontBroadcast)
{
	int iAttacker = GetClientOfUserId(event.GetInt("attacker"));
	int iClient	 = GetClientOfUserId(event.GetInt("userid"));

	if (!bIsSurvivor(iClient))
		return Plugin_Continue;

	if (iAttacker != iClient)
		vStopEmote(iClient);

	return Plugin_Continue;
}

public Action Event_Start(Event event, const char[] name, bool dontBroadcast)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (bIsValidClient(i, false) && g_bClientDancing[i])
		{
			vRevSetCam(i);
			// vStopEmote(client);
			vWeaponUnblock(i);

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

	vStopEmote(iClient);
}

public void OnClientPostAdminCheck(int iClient)
{
	g_iPlayerModelsIndex[iClient] = -1;
	g_iPlayerModels[iClient]	  = INVALID_ENT_REFERENCE;
}

/*****************************************************************
			P L U G I N   F U N C T I O N S
*****************************************************************/

/**
 * Checks if a client is valid and meets the specified conditions.
 *
 * @param iClient       The client index to validate.
 * @param bNoBots       Optional. If true (default), bots are considered invalid.
 * @return              True if the client is valid, connected, in-game, and (if bNoBots is true) not a bot.
 */
bool bIsValidClient(int iClient, bool bNoBots = true)
{
	if (iClient <= 0 || iClient > MaxClients || !IsClientConnected(iClient) || (bNoBots && IsFakeClient(iClient)))
		return false;

	return IsClientInGame(iClient);
}

bool bCheckAdminFlags(int iClient, int iFlag)
{
	int iUserFlags = GetUserFlagBits(iClient);
	return (iUserFlags & ADMFLAG_ROOT || (iUserFlags & iFlag) == iFlag);
}

/**
 * Retrieves the number of clients currently performing a dance emote.
 *
 * @return The count of clients who are in-game and actively dancing.
 */
int iGetEmotePeople()
{
	int count;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && g_bClientDancing[i])
			count++;
	}

	return count;
}

/**
 * Checks if a client has the specified admin flag or root access.
 *
 * @param iClient       The client index to check.
 * @param iFlag         The specific admin flag to check for.
 * @return              True if the client has the specified flag or root access, false otherwise.
 */
bool bIsSurvivor(int iClient)
{
	return (iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient) && GetClientTeam(iClient) == 2);
}

/**
 * Removes the skin model associated with a specific client.
 *
 * @param iClient The client index whose skin model should be removed.
 */
void vRemoveSkin(int iClient)
{
	if (IsValidEntity(g_iPlayerModels[iClient]))
		AcceptEntityInput(g_iPlayerModels[iClient], "Kill");

	g_iPlayerModels[iClient]	  = INVALID_ENT_REFERENCE;
	g_iPlayerModelsIndex[iClient] = -1;
}

/**
 * Check if the translation file exists
 *
 * @param translation	Translation name.
 * @noreturn
 */
void vLoadTranslation(const char[] szTranslation)
{
	char szPath[PLATFORM_MAX_PATH], szName[64];

	Format(szName, sizeof(szName), "translations/%s.txt", szTranslation);
	BuildPath(Path_SM, szPath, sizeof(szPath), szName);
	if (!FileExists(szPath))
		SetFailState("Missing translation file %s.txt", szTranslation);

	LoadTranslations(szTranslation);
}

/**
 * Stops the dancing emote for all valid clients.
 */
void vStopDancer()
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if (g_iEmoteEnt[i])
            vStopEmote(i);

        if (g_hCooldownTimers[i] != null)
            delete g_hCooldownTimers[i];
    }
}

/**
 * Checks if a client has valid access.
 *
 * @param iClient The client index to check.
 * @return True if the client has valid access, false otherwise.
 */
bool bIsValidAccess(int iClient, bool bIsDance = false)
{
	if (g_bVipCore)
	{
		if (VIP_IsClientVIP(iClient))
			return true;
	}
	else
	{
		char szFlagAdmin[32];
		if (bIsDance)
			g_cvFlagDancesMenu.GetString(szFlagAdmin, sizeof(szFlagAdmin));
		else
			g_cvFlagEmotesMenu.GetString(szFlagAdmin, sizeof(szFlagAdmin));

		if (bCheckAdminFlags(iClient, ReadFlagString(szFlagAdmin)))
			return true;
	}

	return false;
}

/**
 * Checks if the given configuration index is valid.
 *
 * @param iConfig        The configuration index to check.
 * @return               True if the configuration index is within the valid range (1 to g_iFilesFnemotesCounter), false otherwise.
 */
bool bCheckConfig(int iConfig)
{
	if (iConfig < 1 || iConfig > g_iFilesFnemotesCounter)
		return false;

	return true;
}

/**
 * Checks if the given emote index is valid within the specified configuration.
 *
 * @param iConfig       The configuration index to check against.
 * @param iEmote        The emote index to validate.
 * @param bIsDance      (Optional) Whether the emote is a dance. Defaults to false.
 *                      If true, the function checks against the dance size array.
 *
 * @return              True if the emote index is valid, false otherwise.
 */
bool bCheckEmote(int iConfig, int iEmote, bool bIsDance = false)
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

/**
 * Returns the clients team using L4DTeam.
 *
 * @param iClient		Player's index.
 * @return				Current L4DTeam of player.
 * @error				Invalid client index.
 */
stock L4DTeam L4D_GetClientTeam(int iClient)
{
	int iTeam = GetClientTeam(iClient);
	return view_as<L4DTeam>(iTeam);
}

stock int IdentifySurvivorFast(int iClient)
{
	int iGender = GetEntProp(iClient, Prop_Send, "m_Gender");
	return g_iGenderToSurvivorIndex[iGender];
}

#if DEBUG
void vLogDebug(const char[] szMessage, any...)
{
	static char szFormat[1024];
	
	VFormat(szFormat, sizeof(szFormat), szMessage, 2);
	File file = OpenFile(g_szLogPath, "a+");

	LogToFileEx(g_szLogPath, "[Debug] %s", szFormat);
	delete file;
}

#if DEBUG_SOUND
void vLogSound(const char[] szMessage, any...)
{
	static char szFormat[1024];
	
	VFormat(szFormat, sizeof(szFormat), szMessage, 2);
	File file = OpenFile(g_szLogPath, "a+");

	LogToFileEx(g_szLogPath, "[Sound] %s", szFormat);
	delete file;
}
#else
public void vLogSound(const char[] szMessage, any...) {}
#endif

#if DEBUG_RESOURCES
void vLogResources(const char[] szMessage, any...)
{
	static char szFormat[1024];
	
	VFormat(szFormat, sizeof(szFormat), szMessage, 2);
	File file = OpenFile(g_szLogPath, "a+");

	LogToFileEx(g_szLogPath, "[Resources] %s", szFormat);
	delete file;
}
#else
public void vLogResources(const char[] szMessage, any...) {}
#endif

#else
public void vLogDebug(const char[] szMessage, any...) {}
public void vLogSound(const char[] szMessage, any...) {}
public void vLogResources(const char[] szMessage, any...) {}
#endif