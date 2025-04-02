/*****************************************************************
			P L U G I N   F U N C T I O N S
*****************************************************************/

/**
 * Creates an emote for a client with specified animations, sound, and properties.
 *
 * @param iClient       The client index for whom the emote is being created.
 * @param szAnim1       The primary animation name for the emote.
 * @param szAnim2       The secondary animation name for the emote (optional, can be "none").
 * @param szSoundName   The name of the sound to play during the emote (optional, can be "none").
 * @param bIsLooped     Whether the emote animation should loop.
 * @param iFile         The file index for the emote's model and sound data.
 *
 * @return              Plugin_Handled if the emote creation is handled or invalid conditions are met.
 */
Action aCreateEmote(int iClient, const char[] szAnim1, const char[] szAnim2, const char[] szSoundName, bool bIsLooped, int iFile)
{
    if (!bIsValidClient(iClient))
        return Plugin_Handled;

    if (g_gfEmoteForward_Pre != null)
    {
        Action eRes = Plugin_Continue;
        Call_StartForward(g_gfEmoteForward_Pre);
        Call_PushCell(iClient);
        Call_Finish(eRes);

        if (eRes != Plugin_Continue)
            return Plugin_Handled;
    }

    L4DTeam eTeam = L4D_GetClientTeam(iClient);
    if (eTeam != L4DTeam_Survivor)
    {
        CPrintToChat(iClient, "%t %t", "TAG", "NOTSURVIVOR");
        return Plugin_Handled;
    }

    if (g_bPause && IsInPause())
    {
        CPrintToChat(iClient, "%t %t", "TAG", "PAUSE_MODE");
        return Plugin_Handled;
    }

    if (!IsPlayerAlive(iClient))
    {
        CPrintToChat(iClient, "%t %t", "TAG", "MUST_BE_ALIVE");
        return Plugin_Handled;
    }

    if (!(GetEntityFlags(iClient) & FL_ONGROUND))
    {
        CPrintToChat(iClient, "%t %t", "TAG", "STAY_ON_GROUND");
        return Plugin_Handled;
    }

    if (g_hCooldownTimers[iClient])
    {
        CPrintToChat(iClient, "%t %t", "TAG", "COOLDOWN_EMOTES");
        return Plugin_Handled;
    }

    if (StrEqual(szAnim1, "none"))
    {
        CPrintToChat(iClient, "%t %t", "TAG", "AMIN_1_INVALID");
        return Plugin_Handled;
    }

    if (g_iEmoteEnt[iClient])
        vStopEmote(iClient);

    if (GetEntityMoveType(iClient) == MOVETYPE_NONE)
    {
        CPrintToChat(iClient, "%t %t", "TAG", "CANNOT_USE_NOW");
        return Plugin_Handled;
    }



    vLogDebug("CreateEmote: szAnim1 = %s, szAnim2 = %s, szSoundName = %s, bIsLooped = %d, iFile = %d", szAnim1, szAnim2, szSoundName, bIsLooped, iFile);
    int iEmoteEnt = CreateEntityByName("prop_dynamic");
    if (!IsValidEntity(iEmoteEnt))
        return Plugin_Handled;

    SetEntityMoveType(iClient, MOVETYPE_NONE);
    vWeaponBlock(iClient);

    float afVec[3], afAng[3];
    GetClientAbsOrigin(iClient, afVec);
    GetClientAbsAngles(iClient, afAng);

    g_fLastPosition[iClient] = afVec;
    g_fLastAngles[iClient] = afAng;
    int iSkin = -1;
    char szEmoteEntName[16];
    FormatEx(szEmoteEntName, sizeof(szEmoteEntName), "emoteEnt%i", GetRandomInt(1000000, 9999999));
    char szModel[PLATFORM_MAX_PATH];
    GetClientModel(iClient, szModel, sizeof(szModel));
    iSkin = 0;
    DispatchKeyValue(iEmoteEnt, "targetname", szEmoteEntName);

    DispatchKeyValue(iEmoteEnt, "model", g_szModels[iFile][1].szPath);

    DispatchKeyValue(iEmoteEnt, "solid", "0");
    DispatchKeyValue(iEmoteEnt, "rendermode", "0");

    ActivateEntity(iEmoteEnt);
    DispatchSpawn(iEmoteEnt);

    TeleportEntity(iEmoteEnt, afVec, afAng, NULL_VECTOR);

    SetVariantString(szEmoteEntName);
    AcceptEntityInput(iClient, "SetParent", iClient, iClient, iSkin);

    g_iEmoteEnt[iClient] = EntIndexToEntRef(iEmoteEnt);

    SetEntProp(iClient, Prop_Send, "m_fEffects", EF_BONEMERGE | EF_NOSHADOW | EF_NORECEIVESHADOW | EF_BONEMERGE_FASTCULL | EF_PARENT_ANIMATES);

    // Sound
    if (g_cvEmotesSounds.BoolValue && !StrEqual(szSoundName, "none"))
    {
        int iEmoteSoundEnt = CreateEntityByName("info_target");
        if (IsValidEntity(iEmoteSoundEnt))
        {
            char szSoundEntName[16];
            FormatEx(szSoundEntName, sizeof(szSoundEntName), "soundEnt%d", GetRandomInt(0, 10000));

            DispatchKeyValue(iEmoteSoundEnt, "targetname", szSoundEntName);

            DispatchSpawn(iEmoteSoundEnt);

            afVec[2] += 72.0;
            TeleportEntity(iEmoteSoundEnt, afVec, NULL_VECTOR, NULL_VECTOR);

            SetVariantString(szEmoteEntName);
            AcceptEntityInput(iEmoteSoundEnt, "SetParent");

            g_iEmoteSoundEnt[iClient] = EntIndexToEntRef(iEmoteSoundEnt);

            char szSound[PLATFORM_MAX_PATH];
            for (int iSoundIndex = 1; iSoundIndex <= g_iSoundsSize[iFile]; iSoundIndex++)
            {
                Format(szSound, sizeof(szSound), "%s.mp3", szSoundName);
                if (StrContains(g_szSounds[iFile][iSoundIndex].szPath, szSound) != -1)
                {
                    szSound[0] = '\0';
                    Format(szSound, sizeof(szSound), g_szSounds[iFile][iSoundIndex].szPath);

                    ReplaceStringEx(szSound, sizeof(szSound), "sound/", "");
                    FormatEx(g_szEmoteSound[iClient], PLATFORM_MAX_PATH, szSound);
                }
            }
            vLogSound("CreateEmote: szSoundName: %s | g_aszEmoteSound = %s | iClient: %N", szSoundName, g_szEmoteSound[iClient], iClient);
            EmitSoundToAll(g_szEmoteSound[iClient], iEmoteSoundEnt, SNDCHAN_AUTO, SNDLEVEL_NORMAL, _, g_cvSoundVolume.FloatValue, _, _, afVec, _, _, _);
        }
        else
        {
            LogError("CreateEmote: Entity info_target creation failed for sound %d", iEmoteSoundEnt);
            g_szEmoteSound[iClient] = "none";
            vLogSound("CreateEmote: szSoundName: %s | g_aszEmoteSound = %s | iClient: %N", szSoundName, g_szEmoteSound[iClient], iClient);
        }
    }
    else
    {
        vLogSound("CreateEmote: g_cvEmotesSounds: %s | StrEqual(szSoundName, none): %s", g_cvEmotesSounds.BoolValue ? "true" : "false", StrEqual(szSoundName, "none") ? "true" : "false");
        vLogSound("CreateEmote: szSoundName: %s | g_aszEmoteSound = %s | iClient: %N", szSoundName, g_szEmoteSound[iClient], iClient);
        g_szEmoteSound[iClient] = "none";
    }

    if (StrEqual(szAnim2, "none", false))
    {
        HookSingleEntityOutput(iEmoteEnt, "OnAnimationDone", vEndAnimation, true);
    }
    else
    {
        SetVariantString(szAnim2);
        AcceptEntityInput(iEmoteEnt, "SetDefaultAnimation", -1, -1, 0);
    }

    char szFinalAnim[64];
    strcopy(szFinalAnim, sizeof(szFinalAnim), szAnim1);

    int charIndex = IdentifySurvivorFast(iClient);

    if (charIndex == SurvivorCharacter_Zoey || charIndex == SurvivorCharacter_Rochelle)
    {
    StrCat(szFinalAnim, sizeof(szFinalAnim), "_F");
    }

    SetVariantString(szFinalAnim);

    //SetVariantString(szAnim1);
    AcceptEntityInput(iEmoteEnt, "SetAnimation", -1, -1, 0);

    if (g_cvSpeed.FloatValue != 1.0)
        SetEntPropFloat(iEmoteEnt, Prop_Send, "m_flPlaybackRate", g_cvSpeed.FloatValue);

    vSetCam(iClient);

    g_bClientDancing[iClient] = true;

    if (g_cvHidePlayers.BoolValue)
    {
        for (int i = 1; i <= MaxClients; i++)
        {
            if (!IsClientInGame(i) || !IsPlayerAlive(i) || GetClientTeam(i) == GetClientTeam(iClient) || g_bHooked[i])
                continue;

            SDKHook(i, SDKHook_SetTransmit, aSetTransmit);
            g_bHooked[i] = true;
        }
    }

    if (g_cvCooldown.FloatValue > 0.0)
        g_hCooldownTimers[iClient] = CreateTimer(g_cvCooldown.FloatValue, aResetCooldown, iClient);

    Call_StartForward(g_gfEmoteForward);
    Call_PushCell(iClient);
    Call_Finish();

    if (bIsLooped) {}

    return Plugin_Handled;
}

/**
 * Ends an animation for a given caller entity by stopping the associated emote.
 *
 * @param szOutput   Unused parameter, reserved for future use or additional functionality.
 * @param iCaller    The entity index of the caller. If greater than 0, the emote will be stopped.
 * @param iActivator The entity index of the activator. This will be updated to the emote activator if iCaller is valid.
 * @param flDelay    Unused parameter, reserved for future use or additional functionality.
 */
void vEndAnimation(const char[] szOutput, int iCaller, int iActivator, float flDelay)
{
	if (iCaller > 0)
	{
		iActivator = iGetEmoteActivator(EntIndexToEntRef(iCaller));
		vStopEmote(iActivator);
	}
}

/**
 * Retrieves the client index of the player who activated a specific emote.
 *
 * @param iEntRefDancer The entity reference of the dancer (emote entity).
 *                      If this is INVALID_ENT_REFERENCE, the function will return 0.
 *
 * @return The client index of the player who activated the emote, or 0 if no match is found
 *         or if the input entity reference is invalid.
 */
int iGetEmoteActivator(int iEntRefDancer)
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

/**
 * Stops the emote for a given client.
 *
 * @param iClient The client index for whom the emote should be stopped.
 */
void vStopEmote(int iClient)
{
    if (!g_iEmoteEnt[iClient])
        return;

    int iEmoteEnt = EntRefToEntIndex(g_iEmoteEnt[iClient]);
    if (!iEmoteEnt || iEmoteEnt == INVALID_ENT_REFERENCE || !IsValidEntity(iEmoteEnt))
    {
        g_iEmoteEnt[iClient]		 = 0;
        g_bClientDancing[iClient] = false;
        return;
    }

    char szEmoteEntName[50];
    GetEntPropString(iEmoteEnt, Prop_Data, "m_iName", szEmoteEntName, sizeof(szEmoteEntName));
    SetVariantString(szEmoteEntName);
    AcceptEntityInput(iClient, "ClearParent", iEmoteEnt, iEmoteEnt, 0);
    DispatchKeyValue(iEmoteEnt, "OnUser1", "!self,Kill,,1.0,-1");
    AcceptEntityInput(iEmoteEnt, "FireUser1");

    if (g_cvTeleportBack.BoolValue)
        TeleportEntity(iClient, g_fLastPosition[iClient], g_fLastAngles[iClient], NULL_VECTOR);

    vRemoveSkin(iClient);
    vRevSetCam(iClient);
    vWeaponUnblock(iClient);
    SetEntityMoveType(iClient, MOVETYPE_WALK);

    g_iEmoteEnt[iClient]		 = 0;
    g_bClientDancing[iClient] = false;

    if (!g_iEmoteSoundEnt[iClient])
        return;

    int iEmoteSoundEnt = EntRefToEntIndex(g_iEmoteSoundEnt[iClient]);

    if (StrEqual(g_szEmoteSound[iClient], "none") || !iEmoteSoundEnt || iEmoteSoundEnt == INVALID_ENT_REFERENCE || !IsValidEntity(iEmoteSoundEnt))
    {
        g_iEmoteSoundEnt[iClient] = 0;
        return;
    }

    vLogSound("StopEmote: g_aszEmoteSound = %s | iClient: %N", g_szEmoteSound[iClient], iClient);
    StopSound(iEmoteSoundEnt, SNDCHAN_AUTO, g_szEmoteSound[iClient]);
    AcceptEntityInput(iEmoteSoundEnt, "Kill");
    g_iEmoteSoundEnt[iClient] = 0;
}

/**
 * Terminates the emote for a specific client.
 *
 * This function handles the cleanup of emote-related entities and states for the given client.
 * It ensures that any active emote entity or sound entity associated with the client is properly
 * removed and the client's emote state is reset.
 *
 * @param iClient The client index for whom the emote is being terminated.
 */
void vTerminateEmote(int iClient)
{
    if (!g_iEmoteEnt[iClient])
        return;

    int iEmoteEnt = EntRefToEntIndex(g_iEmoteEnt[iClient]);
    if (!iEmoteEnt || iEmoteEnt == INVALID_ENT_REFERENCE || !IsValidEntity(iEmoteEnt))
    {
        g_iEmoteEnt[iClient]		 = 0;
        g_bClientDancing[iClient] = false;
        return;
    }

    char szEmoteEntName[50];
    GetEntPropString(iEmoteEnt, Prop_Data, "m_iName", szEmoteEntName, sizeof(szEmoteEntName));
    SetVariantString(szEmoteEntName);
    AcceptEntityInput(iClient, "ClearParent", iEmoteEnt, iEmoteEnt, 0);
    DispatchKeyValue(iEmoteEnt, "OnUser1", "!self,Kill,,1.0,-1");
    AcceptEntityInput(iEmoteEnt, "FireUser1");

    g_iEmoteEnt[iClient]		 = 0;
    g_bClientDancing[iClient] = false;

    if (!g_iEmoteSoundEnt[iClient])
        return;

    int iEmoteSoundEnt = EntRefToEntIndex(g_iEmoteSoundEnt[iClient]);

    if (StrEqual(g_szEmoteSound[iClient], "none") || !iEmoteSoundEnt || iEmoteSoundEnt == INVALID_ENT_REFERENCE || !IsValidEntity(iEmoteSoundEnt))
    {
        g_iEmoteSoundEnt[iClient] = 0;
        return;
    }

    vLogSound("TerminateEmote: g_aszEmoteSound = %s | iClient: %N", g_szEmoteSound[iClient], iClient);
    StopSound(iEmoteSoundEnt, SNDCHAN_AUTO, g_szEmoteSound[iClient]);
    AcceptEntityInput(iEmoteSoundEnt, "Kill");
    g_iEmoteSoundEnt[iClient] = 0;
}

/**
 * Blocks the usage and switching of weapons for a specific client.
 *
 * @param iClient The client index for whom the weapon functionality is being blocked.
 */
void vWeaponBlock(int iClient)
{
	SDKHook(iClient, SDKHook_WeaponCanUse, aWeaponCanUseSwitch);
	SDKHook(iClient, SDKHook_WeaponSwitch, aWeaponCanUseSwitch);

	if (g_cvHideWeapons.BoolValue)
		SDKHook(iClient, SDKHook_PostThinkPost, vOnPostThinkPost);

	int iEnt = GetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon");
	if (iEnt != -1)
	{
		g_iWeaponHandEnt[iClient] = EntIndexToEntRef(iEnt);

		SetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon", -1);
	}
}

/**
 * Unblocks the weapon usage for a specific client and cleans up related hooks and properties.
 *
 * @param iClient The client index for which weapon usage is being unblocked.
 */
void vWeaponUnblock(int iClient)
{
	SDKUnhook(iClient, SDKHook_WeaponCanUse, aWeaponCanUseSwitch);
	SDKUnhook(iClient, SDKHook_WeaponSwitch, aWeaponCanUseSwitch);

	// Even if are not activated, there will be no errors
	SDKUnhook(iClient, SDKHook_PostThinkPost, vOnPostThinkPost);

	if (iGetEmotePeople() == 0)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i) && g_bHooked[i])
			{
				SDKUnhook(i, SDKHook_SetTransmit, aSetTransmit);
				g_bHooked[i] = false;
			}
		}
	}

	if (IsPlayerAlive(iClient) && g_iWeaponHandEnt[iClient] != INVALID_ENT_REFERENCE)
	{
		int iEnt = EntRefToEntIndex(g_iWeaponHandEnt[iClient]);
		if (iEnt != INVALID_ENT_REFERENCE)
			SetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon", iEnt);
	}

	g_iWeaponHandEnt[iClient] = INVALID_ENT_REFERENCE;
}

/**
 * Callback function that determines whether a weapon can be switched.
 *
 * @param iClient The client index of the player attempting to switch weapons.
 * @param iWeapon The weapon index of the weapon being switched to.
 * @return Always returns Plugin_Stop to prevent weapon switching.
 */
Action aWeaponCanUseSwitch(int iClient, int iWeapon)
{
	return Plugin_Stop;
}

/**
 * Called after the game processes all client input and updates the game state.
 *
 * @param iClient    The client index of the player being processed.
 */
void vOnPostThinkPost(int iClient)
{
	SetEntProp(iClient, Prop_Send, "m_iAddonBits", 0);
}

/**
 * Determines whether an entity should be transmitted to a specific client.
 *
 * @param iEntity       The entity index to check for transmission.
 * @param iClient       The client index to check against.
 *
 * @return              Plugin_Handled if the client is dancing, alive, and on a different team
 *                      than the entity; otherwise, Plugin_Continue.
 */
public Action aSetTransmit(int iEntity, int iClient)
{
	if (g_bClientDancing[iClient] && IsPlayerAlive(iClient) && GetClientTeam(iClient) != GetClientTeam(iEntity))
		return Plugin_Handled;

	return Plugin_Continue;
}

/**
 * Sets the camera properties for a client.
 *
 * @param iClient The client index for whom the camera properties are being set.
 */
void vSetCam(int iClient)
{
	SetEntPropFloat(iClient, Prop_Send, "m_TimeForceExternalView", 99999.3);
	SetEntProp(iClient, Prop_Send, "m_iHideHUD", GetEntProp(iClient, Prop_Send, "m_iHideHUD") | HIDEHUD_CROSSHAIR);
}

/**
 * Resets the camera settings for a specified client.
 *
 * @param iClient The client index whose camera settings will be reset.
 */
void vRevSetCam(int iClient)
{
	SetEntPropFloat(iClient, Prop_Send, "m_TimeForceExternalView", 0.0);
	SetEntProp(iClient, Prop_Send, "m_iHideHUD", GetEntProp(iClient, Prop_Send, "m_iHideHUD") & ~HIDEHUD_CROSSHAIR);
}

/**
 * Resets the cooldown timer for a specific client.
 *
 * @param hTimer       Handle to the timer that triggered this function.
 * @param iClient      The client index for whom the cooldown is being reset.
 * @return             Plugin_Stop to indicate the timer should stop.
 */
Action aResetCooldown(Handle hTimer, any iClient)
{
	g_hCooldownTimers[iClient] = null;
	return Plugin_Stop;
}