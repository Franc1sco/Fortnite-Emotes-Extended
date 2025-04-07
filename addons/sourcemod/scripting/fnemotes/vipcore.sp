/*****************************************************************
			G L O B A L   V A R S
*****************************************************************/

static const char g_szFeature[] = "ForniteEmotes";

/*****************************************************************
			F O R W A R D   P U B L I C S
*****************************************************************/

void vOnPluginStart_vipcore()
{
	if (!g_bVipCore)
		return;

#if DEBUG
	if (g_bLateload)
		VIP_OnVIPLoaded();
#endif
}

void vOnPluginEnd_vipcore()
{
	if (g_bVipCore && CanTestFeatures() && GetFeatureStatus(FeatureType_Native, "VIP_UnregisterFeature") == FeatureStatus_Available)
	{
		if (!VIP_IsValidFeature(g_szFeature))
			return;
		
		VIP_UnregisterFeature(g_szFeature);
	}
}

/*****************************************************************
			F O R W A R D   P L U G I N S
*****************************************************************/

void VIP_OnVIPLoaded_vipcore()
{
	if (VIP_IsValidFeature(g_szFeature))
		return;

	VIP_RegisterFeature(g_szFeature, VIP_NULL, SELECTABLE, bOnItemSelect, bOnItemDisplay);
}

bool bOnItemSelect(int iClient, char[] szFeatureName)
{
	Menu hItemSelectMenu = new Menu(MenuHandler_Vip);

	char szTitle[65];
	Format(szTitle, sizeof(szTitle), "%T:", "TITLE_MAIM_MENU", iClient);
	hItemSelectMenu.SetTitle(szTitle);

	vAddTranslatedMenuItem(hItemSelectMenu, "", "RANDOM_EMOTE", iClient);
	vAddTranslatedMenuItem(hItemSelectMenu, "", "RANDOM_DANCE", iClient);
	vAddTranslatedMenuItem(hItemSelectMenu, "", "EMOTES_LIST", iClient);
	vAddTranslatedMenuItem(hItemSelectMenu, "", "DANCES_LIST", iClient);

	hItemSelectMenu.ExitButton = true;
	hItemSelectMenu.Display(iClient, MENU_TIME_FOREVER);

	return false;
}

int MenuHandler_Vip(Menu hMenu, MenuAction eAction, int iParam1, int iParam2)
{
	switch (eAction)
	{
		case MenuAction_Select:
		{
			int iClient = iParam1, iItem = iParam2;

			switch (iItem)
			{
				case 0:
				{
					vCreateRandomEmote(iClient);
					aMainMenu(iClient);
				}
				case 1:
				{
					vCreateRandomEmote(iClient, true);
					aMainMenu(iClient);
				}
				case 2:
					aMenuEmotes(iClient);
				case 3:
					aMenuDances(iClient);
			}
		}
		case MenuAction_End:
			delete hMenu;
		case MenuAction_Cancel:
		{
			int iClient = iParam1, iReason = iParam2;

			if (iReason == MenuCancel_ExitBack)
				VIP_SendClientVIPMenu(iClient);
		}
	}
	return 0;
}

bool bOnItemDisplay(int iClient, char[] szFeatureName, char[] szDisplay, int iMaxLen)
{
	FormatEx(szDisplay, iMaxLen, "%t", "TITLE_MAIM_MENU");
	return true;
}