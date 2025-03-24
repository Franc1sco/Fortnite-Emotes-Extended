#if defined _emotes_included
	#endinput
#endif
#define _emotes_included

/*****************************************************************
			P L U G I N   F U N C T I O N S
*****************************************************************/

Action CreateEmote(int client, const char[] anim1, const char[] anim2, const char[] soundName, bool isLooped, int iFile)
{
    if (!IsValidClient(client))
        return Plugin_Handled;

    if (g_EmoteForward_Pre != null)
    {
        Action res = Plugin_Continue;
        Call_StartForward(g_EmoteForward_Pre);
        Call_PushCell(client);
        Call_Finish(res);

        if (res != Plugin_Continue)
            return Plugin_Handled;
    }

    L4DTeam team = L4D_GetClientTeam(client);
    if (team != L4DTeam_Survivor)
    {
        CPrintToChat(client, "%t %t", "TAG", "NOTSURVIVOR");
        return Plugin_Handled;
    }

    if (g_bPause && IsInPause())
    {
        CPrintToChat(client, "%t %t", "TAG", "PAUSE_MODE");
        return Plugin_Handled;
    }

    if (!IsPlayerAlive(client))
    {
        CPrintToChat(client, "%t %t", "TAG", "MUST_BE_ALIVE");
        return Plugin_Handled;
    }

    if (!(GetEntityFlags(client) & FL_ONGROUND))
    {
        CPrintToChat(client, "%t %t", "TAG", "STAY_ON_GROUND");
        return Plugin_Handled;
    }

    if (CooldownTimers[client])
    {
        CPrintToChat(client, "%t %t", "TAG", "COOLDOWN_EMOTES");
        return Plugin_Handled;
    }

    if (StrEqual(anim1, "none"))
    {
        CPrintToChat(client, "%t %t", "TAG", "AMIN_1_INVALID");
        return Plugin_Handled;
    }

    if (g_iEmoteEnt[client])
        StopEmote(client);

    if (GetEntityMoveType(client) == MOVETYPE_NONE)
    {
        CPrintToChat(client, "%t %t", "TAG", "CANNOT_USE_NOW");
        return Plugin_Handled;
    }

    LogDebug("CreateEmote: anim1 = %s, anim2 = %s, soundName = %s, isLooped = %d, iFile = %d", anim1, anim2, soundName, isLooped, iFile);
    int EmoteEnt = CreateEntityByName("prop_dynamic");
    if (!IsValidEntity(EmoteEnt))
        return Plugin_Handled;

    SetEntityMoveType(client, MOVETYPE_NONE);
    WeaponBlock(client);

    float vec[3], ang[3];
    GetClientAbsOrigin(client, vec);
    GetClientAbsAngles(client, ang);

    g_fLastPosition[client] = vec;
    g_fLastAngles[client] = ang;
    int skin = -1;
    char emoteEntName[16];
    FormatEx(emoteEntName, sizeof(emoteEntName), "emoteEnt%i", GetRandomInt(1000000, 9999999));
    char model[PLATFORM_MAX_PATH];
    GetClientModel(client, model, sizeof(model));
    skin = CreatePlayerModelProp(client, model);
    DispatchKeyValue(EmoteEnt, "targetname", emoteEntName);

    DispatchKeyValue(EmoteEnt, "model", g_Models[iFile][1].path);
    LogDebug("CreateEmote: model = %s", g_Models[iFile][1].path);

    DispatchKeyValue(EmoteEnt, "solid", "0");
    DispatchKeyValue(EmoteEnt, "rendermode", "0");

    ActivateEntity(EmoteEnt);
    DispatchSpawn(EmoteEnt);

    TeleportEntity(EmoteEnt, vec, ang, NULL_VECTOR);

    SetVariantString(emoteEntName);
    AcceptEntityInput(client, "SetParent", client, client, skin);

    g_iEmoteEnt[client] = EntIndexToEntRef(EmoteEnt);

    SetEntProp(client, Prop_Send, "m_fEffects", EF_BONEMERGE | EF_NOSHADOW | EF_NORECEIVESHADOW | EF_BONEMERGE_FASTCULL | EF_PARENT_ANIMATES);

    // Sound
    if (g_cvarEmotesSounds.BoolValue && !StrEqual(soundName, "none"))
    {
        int EmoteSoundEnt = CreateEntityByName("info_target");
        if (IsValidEntity(EmoteSoundEnt))
        {
            char soundEntName[16];
            FormatEx(soundEntName, sizeof(soundEntName), "soundEnt%d", GetRandomInt(0, 10000));

            DispatchKeyValue(EmoteSoundEnt, "targetname", soundEntName);

            DispatchSpawn(EmoteSoundEnt);

            vec[2] += 72.0;
            TeleportEntity(EmoteSoundEnt, vec, NULL_VECTOR, NULL_VECTOR);

            SetVariantString(emoteEntName);
            AcceptEntityInput(EmoteSoundEnt, "SetParent");

            g_iEmoteSoundEnt[client] = EntIndexToEntRef(EmoteSoundEnt);

            char szSound[PLATFORM_MAX_PATH];
            for(int iSoundIndex = 1; iSoundIndex <= g_iSoundsSize[iFile]; iSoundIndex++)
            {
                if(StrContains(g_Sounds[iFile][iSoundIndex].path, soundName, false) != -1)
                {
                	Format(szSound, sizeof(szSound), g_Sounds[iFile][iSoundIndex].path);

			        ReplaceStringEx(szSound, sizeof(szSound), "sound/", "");
                    FormatEx(g_sEmoteSound[client], PLATFORM_MAX_PATH, szSound);
                }
            }
            LogSound("CreateEmote: soundName: %s | g_sEmoteSound = %s | client: %N", soundName, g_sEmoteSound[client], client);
            EmitSoundToAll(g_sEmoteSound[client], EmoteSoundEnt, SNDCHAN_AUTO, SNDLEVEL_NORMAL, _, g_cvarSoundVolume.FloatValue, _, _, vec, _, _, _);
        }
        else
        {
            LogError("CreateEmote: Entity info_target creation failed for sound %d", EmoteSoundEnt);
            g_sEmoteSound[client] = "none";
            LogSound("CreateEmote: soundName: %s | g_sEmoteSound = %s | client: %N", soundName, g_sEmoteSound[client], client);
        }
    }
    else
    {
        LogSound("CreateEmote: g_cvarEmotesSounds: %s | StrEqual(soundName, none): %s", g_cvarEmotesSounds.BoolValue ? "true" : "false", StrEqual(soundName, "none") ? "true" : "false");
        LogSound("CreateEmote: soundName: %s | g_sEmoteSound = %s | client: %N", soundName, g_sEmoteSound[client], client);
        g_sEmoteSound[client] = "none";
    }

    if (StrEqual(anim2, "none", false))
    {
        HookSingleEntityOutput(EmoteEnt, "OnAnimationDone", EndAnimation, true);
    }
    else
    {
        SetVariantString(anim2);
        AcceptEntityInput(EmoteEnt, "SetDefaultAnimation", -1, -1, 0);
    }

    LogDebug("CreateEmote: anim1 = %s, anim2 = %s", anim1, anim2);

    SetVariantString(anim1);
    AcceptEntityInput(EmoteEnt, "SetAnimation", -1, -1, 0);

    if (g_cvarSpeed.FloatValue != 1.0)
        SetEntPropFloat(EmoteEnt, Prop_Send, "m_flPlaybackRate", g_cvarSpeed.FloatValue);

    SetCam(client);

    g_bClientDancing[client] = true;

    if (g_cvarHidePlayers.BoolValue)
    {
        for (int i = 1; i <= MaxClients; i++)
        {
            if (!IsClientInGame(i) || !IsPlayerAlive(i) || GetClientTeam(i) == GetClientTeam(client) || g_bHooked[i])
                continue;

            SDKHook(i, SDKHook_SetTransmit, SetTransmit);
            g_bHooked[i] = true;
        }
    }

    if (g_cvarCooldown.FloatValue > 0.0)
        CooldownTimers[client] = CreateTimer(g_cvarCooldown.FloatValue, ResetCooldown, client);

    Call_StartForward(g_EmoteForward);
    Call_PushCell(client);
    Call_Finish();

    if (isLooped) {}

    return Plugin_Handled;
}

void EndAnimation(const char[] output, int caller, int activator, float delay)
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
			return i;
	}
	return 0;
}

void StopEmote(int client)
{
    if (!g_iEmoteEnt[client])
        return;

    int iEmoteEnt = EntRefToEntIndex(g_iEmoteEnt[client]);
    if (!iEmoteEnt || iEmoteEnt == INVALID_ENT_REFERENCE || !IsValidEntity(iEmoteEnt))
    {
        g_iEmoteEnt[client]		 = 0;
        g_bClientDancing[client] = false;
        return;
    }

    char emoteEntName[50];
    GetEntPropString(iEmoteEnt, Prop_Data, "m_iName", emoteEntName, sizeof(emoteEntName));
    SetVariantString(emoteEntName);
    AcceptEntityInput(client, "ClearParent", iEmoteEnt, iEmoteEnt, 0);
    DispatchKeyValue(iEmoteEnt, "OnUser1", "!self,Kill,,1.0,-1");
    AcceptEntityInput(iEmoteEnt, "FireUser1");

    if (g_cvarTeleportBack.BoolValue)
        TeleportEntity(client, g_fLastPosition[client], g_fLastAngles[client], NULL_VECTOR);

    RemoveSkin(client);
    ResetCam(client);
    WeaponUnblock(client);
    SetEntityMoveType(client, MOVETYPE_WALK);

    g_iEmoteEnt[client]		 = 0;
    g_bClientDancing[client] = false;

    if (!g_iEmoteSoundEnt[client])
        return;

    int iEmoteSoundEnt = EntRefToEntIndex(g_iEmoteSoundEnt[client]);

    if (StrEqual(g_sEmoteSound[client], "none") || !iEmoteSoundEnt || iEmoteSoundEnt == INVALID_ENT_REFERENCE || !IsValidEntity(iEmoteSoundEnt))
    {
        g_iEmoteSoundEnt[client] = 0;
        return;
    }

    LogSound("StopEmote: g_sEmoteSound = %s | client: %N", g_sEmoteSound[client], client);
    StopSound(iEmoteSoundEnt, SNDCHAN_AUTO, g_sEmoteSound[client]);
    AcceptEntityInput(iEmoteSoundEnt, "Kill");
    g_iEmoteSoundEnt[client] = 0;
}

void TerminateEmote(int client)
{
    if (!g_iEmoteEnt[client])
        return;

    int iEmoteEnt = EntRefToEntIndex(g_iEmoteEnt[client]);
    if (!iEmoteEnt || iEmoteEnt == INVALID_ENT_REFERENCE || !IsValidEntity(iEmoteEnt))
    {
        g_iEmoteEnt[client]		 = 0;
        g_bClientDancing[client] = false;
        return;
    }

    char emoteEntName[50];
    GetEntPropString(iEmoteEnt, Prop_Data, "m_iName", emoteEntName, sizeof(emoteEntName));
    SetVariantString(emoteEntName);
    AcceptEntityInput(client, "ClearParent", iEmoteEnt, iEmoteEnt, 0);
    DispatchKeyValue(iEmoteEnt, "OnUser1", "!self,Kill,,1.0,-1");
    AcceptEntityInput(iEmoteEnt, "FireUser1");

    g_iEmoteEnt[client]		 = 0;
    g_bClientDancing[client] = false;

    if (!g_iEmoteSoundEnt[client])
        return;

    int iEmoteSoundEnt = EntRefToEntIndex(g_iEmoteSoundEnt[client]);

    if (StrEqual(g_sEmoteSound[client], "none") || !iEmoteSoundEnt || iEmoteSoundEnt == INVALID_ENT_REFERENCE || !IsValidEntity(iEmoteSoundEnt))
    {
        g_iEmoteSoundEnt[client] = 0;
        return;
    }

    LogSound("TerminateEmote: g_sEmoteSound = %s | client: %N", g_sEmoteSound[client], client);
    StopSound(iEmoteSoundEnt, SNDCHAN_AUTO, g_sEmoteSound[client]);
    AcceptEntityInput(iEmoteSoundEnt, "Kill");
    g_iEmoteSoundEnt[client] = 0;
}

void WeaponBlock(int client)
{
	SDKHook(client, SDKHook_WeaponCanUse, WeaponCanUseSwitch);
	SDKHook(client, SDKHook_WeaponSwitch, WeaponCanUseSwitch);

	if (g_cvarHideWeapons.BoolValue)
		SDKHook(client, SDKHook_PostThinkPost, OnPostThinkPost);

	int iEnt = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if (iEnt != -1)
	{
		g_iWeaponHandEnt[client] = EntIndexToEntRef(iEnt);

		SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1);
	}
}

void WeaponUnblock(int client)
{
	SDKUnhook(client, SDKHook_WeaponCanUse, WeaponCanUseSwitch);
	SDKUnhook(client, SDKHook_WeaponSwitch, WeaponCanUseSwitch);

	// Even if are not activated, there will be no errors
	SDKUnhook(client, SDKHook_PostThinkPost, OnPostThinkPost);

	if (GetEmotePeople() == 0)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i) && g_bHooked[i])
			{
				SDKUnhook(i, SDKHook_SetTransmit, SetTransmit);
				g_bHooked[i] = false;
			}
		}
	}

	if (IsPlayerAlive(client) && g_iWeaponHandEnt[client] != INVALID_ENT_REFERENCE)
	{
		int iEnt = EntRefToEntIndex(g_iWeaponHandEnt[client]);
		if (iEnt != INVALID_ENT_REFERENCE)
			SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", iEnt);
	}

	g_iWeaponHandEnt[client] = INVALID_ENT_REFERENCE;
}

Action WeaponCanUseSwitch(int client, int weapon)
{
	return Plugin_Stop;
}

void OnPostThinkPost(int client)
{
	SetEntProp(client, Prop_Send, "m_iAddonBits", 0);
}

public Action SetTransmit(int entity, int client)
{
	if (g_bClientDancing[client] && IsPlayerAlive(client) && GetClientTeam(client) != GetClientTeam(entity))
		return Plugin_Handled;

	return Plugin_Continue;
}

void SetCam(int client)
{
	SetEntPropFloat(client, Prop_Send, "m_TimeForceExternalView", 99999.3);
	SetEntProp(client, Prop_Send, "m_iHideHUD", GetEntProp(client, Prop_Send, "m_iHideHUD") | HIDEHUD_CROSSHAIR);
}

void ResetCam(int client)
{
	SetEntPropFloat(client, Prop_Send, "m_TimeForceExternalView", 0.0);
	SetEntProp(client, Prop_Send, "m_iHideHUD", GetEntProp(client, Prop_Send, "m_iHideHUD") & ~HIDEHUD_CROSSHAIR);
}

Action ResetCooldown(Handle timer, any client)
{
	CooldownTimers[client] = null;
	return Plugin_Stop;
}