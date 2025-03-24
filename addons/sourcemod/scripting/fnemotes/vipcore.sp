#if defined _vipcore_included
	#endinput
#endif
#define _vipcore_included

/*****************************************************************
			G L O B A L   V A R S
*****************************************************************/

static const char g_sFeature[] = "ForniteEmotes";

/*****************************************************************
			F O R W A R D   P U B L I C S
*****************************************************************/

void OnPluginStart_vipcore()
{
	if (!g_bVipCore)
		return;

#if !DEBUG
	if (g_bLateload)
		return;
#endif

	VIP_OnVIPLoaded();
}

void OnPluginEnd_vipcore()
{
	if (g_bVipCore && CanTestFeatures() && GetFeatureStatus(FeatureType_Native, "VIP_UnregisterFeature") == FeatureStatus_Available)
	{
		if (!VIP_IsValidFeature(g_sFeature))
			return;
		
		VIP_UnregisterFeature(g_sFeature);
	}
}

/*****************************************************************
			F O R W A R D   P L U G I N S
*****************************************************************/

void VIP_OnVIPLoaded_vipcore()
{
	if (VIP_IsValidFeature(g_sFeature))
		return;

	VIP_RegisterFeature(g_sFeature, VIP_NULL, SELECTABLE, OnItemSelect, OnItemDisplay);
}

public bool OnItemSelect(int client, char[] sFeatureName)
{
	if(g_bLateload)
	{
		CReplyToCommand(client, "%t %t", "TAG", "LATLOAD");
		return false;
	}

	Menu menu = new Menu(MenuHandler_Vip);

	char title[65];
	Format(title, sizeof(title), "%T:", "TITLE_MAIM_MENU", client);
	menu.SetTitle(title);

	AddTranslatedMenuItem(menu, "", "RANDOM_EMOTE", client);
	AddTranslatedMenuItem(menu, "", "RANDOM_DANCE", client);
	AddTranslatedMenuItem(menu, "", "EMOTES_LIST", client);
	AddTranslatedMenuItem(menu, "", "DANCES_LIST", client);

	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);

	return false;
}

int MenuHandler_Vip(Menu menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			int
				client = param1,
				item   = param2;

			switch (item)
			{
				case 0:
				{
					CreateRandomEmote(client);
					Menu_Main(client);
				}
				case 1:
				{
					CreateRandomEmote(client, true);
					Menu_Main(client);
				}
				case 2:
					Menu_Emotes(client);
				case 3:
					Menu_Dances(client);
			}
		}
		case MenuAction_End:
			delete menu;
		case MenuAction_Cancel:
		{
			int
				client = param1,
				reason = param2;

			if (reason == MenuCancel_ExitBack)
				VIP_SendClientVIPMenu(client);
		}
	}
	return 0;
}

public bool OnItemDisplay(int client, char[] sFeatureName, char[] sDisplay, int iMaxLen)
{
	FormatEx(sDisplay, iMaxLen, "%t", "TITLE_MAIM_MENU");
	return true;
}