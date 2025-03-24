#if defined _menu_included
	#endinput
#endif
#define _menu_included

/*****************************************************************
			P L U G I N   F U N C T I O N S
*****************************************************************/

Action Menu_Main(int client)
{
	Menu menu = new Menu(MenuHandler_Dance);

	char title[65];
	Format(title, sizeof(title), "%T:", "TITLE_MAIM_MENU", client);
	menu.SetTitle(title);

	AddTranslatedMenuItem(menu, "", "RANDOM_EMOTE", client);
	AddTranslatedMenuItem(menu, "", "RANDOM_DANCE", client);
	AddTranslatedMenuItem(menu, "", "EMOTES_LIST", client);
	AddTranslatedMenuItem(menu, "", "DANCES_LIST", client);

	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

int MenuHandler_Dance(Menu menu, MenuAction action, int param1, int param2)
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
					StopEmote(client);
					CreateRandomEmote(client);
					Menu_Main(client);
				}
				case 1:
				{
					StopEmote(client);
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
	}
	return 0;
}

Action Menu_Emotes(int client)
{
	Menu menu = new Menu(MenuHandlerEmotes);

	char title[65];
	Format(title, sizeof(title), "%T:", "TITLE_EMOTES_MENU", client);
	menu.SetTitle(title);

	for (int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		for (int j = 1; j <= g_iEmotesSize[i]; j++)
		{
			char
				sIndex[8];

			Format(sIndex, sizeof(sIndex), "%d:%d", i, j);
			AddTranslatedMenuItem(menu, sIndex, g_Emotes[i][j].name, client);
		}
	}

	menu.ExitButton		= true;
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

int MenuHandlerEmotes(Menu menu, MenuAction action, int client, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			char sItem[16];
			if (menu.GetItem(param2, sItem, sizeof(sItem)))
			{
				int
					iFile,
					iItem;

				char
					sBuffer[2][4],
					sAnim1[64],
					sAnim2[64],
					sSound[PLATFORM_MAX_PATH];

				bool
					bIsLoop;

				ExplodeString(sItem, ":", sBuffer, sizeof(sBuffer), sizeof(sBuffer[]));
				iFile = StringToInt(sBuffer[0]);
				iItem = StringToInt(sBuffer[1]);
				
				if (!GetEmoteInfo(iFile, g_Emotes[iFile][iItem].name, sAnim1, sizeof(sAnim1), sAnim2, sizeof(sAnim2), sSound, sizeof(sSound), bIsLoop))
				{
					CPrintToChat(client, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_Emotes[iFile][iItem].name);
					return 0;
				}

				CreateEmote(client, sAnim1, sAnim1, sAnim2, bIsLoop, iFile);
			}
			menu.DisplayAt(client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
		}
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
				Menu_Main(client);
		}
	}
	return 0;
}

Action Menu_Dances(int client)
{
	Menu menu = new Menu(MenuHandlerDances);

	char title[65];
	Format(title, sizeof(title), "%T:", "TITLE_DANCES_MENU", client);
	menu.SetTitle(title);

	for (int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		for (int j = 1; j <= g_iDancesSize[i]; j++)
		{
			char
				sIndex[8];

			Format(sIndex, sizeof(sIndex), "%d:%d", i, j);
			AddTranslatedMenuItem(menu, sIndex, g_Dances[i][j].name, client);
		}
	}

	menu.ExitButton		= true;
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

int MenuHandlerDances(Menu menu, MenuAction action, int client, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			char sItem[16];
			if (menu.GetItem(param2, sItem, sizeof(sItem)))
			{
				int
					iFile,
					iItem;

				char
					sBuffer[2][4],
					sAnim1[64],
					sAnim2[64],
					sSound[PLATFORM_MAX_PATH];

				bool
					bIsLoop;

				ExplodeString(sItem, ":", sBuffer, sizeof(sBuffer), sizeof(sBuffer[]));
				iFile = StringToInt(sBuffer[0]);
				iItem = StringToInt(sBuffer[1]);

				if (!GetEmoteInfo(iFile, g_Dances[iFile][iItem].name, sAnim1, sizeof(sAnim1), sAnim2, sizeof(sAnim2), sSound, sizeof(sSound), bIsLoop, true))
				{
					CPrintToChat(client, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_Dances[iFile][iItem].name);
					return 0;
				}
				CreateEmote(client, sAnim1, sAnim2, sSound, bIsLoop, iFile);

			}
			menu.DisplayAt(client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
		}
		case MenuAction_Cancel:
		{
			if (param2 == MenuCancel_ExitBack)
				Menu_Main(client);
		}
	}
	return 0;
}

void AddTranslatedMenuItem(Menu menu, const char[] opt, const char[] phrase, int client)
{
	char buffer[128];
	Format(buffer, sizeof(buffer), "%T", phrase, client);
	menu.AddItem(opt, buffer);
}

void CreateRandomEmote(int client, bool IsDance = false)
{
	int
		iFileRandom,
		iIndexRandom;

	char
		sAnim1[64],
		sAnim2[64],
		sSound[PLATFORM_MAX_PATH];

	bool
		bIsLoop;
	int iSize;

	do {
		iFileRandom = GetRandomInt(1, g_iFilesFnemotesCounter);
		iSize = IsDance ? g_iDancesSize[iFileRandom] : g_iEmotesSize[iFileRandom];
	} while (iSize == 0);

	iIndexRandom = GetRandomInt(1, iSize);

	if (IsDance)
	{
		if (!GetEmoteInfo(iFileRandom, g_Dances[iFileRandom][iIndexRandom].name, sAnim1, sizeof(sAnim1), sAnim2, sizeof(sAnim2), sSound, sizeof(sSound), bIsLoop, true))
			CPrintToChat(client, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_Dances[iFileRandom][iIndexRandom].name);
	}
	else
	{
		if (!GetEmoteInfo(iFileRandom, g_Emotes[iFileRandom][iIndexRandom].name, sAnim1, sizeof(sAnim1), sAnim2, sizeof(sAnim2), sSound, sizeof(sSound), bIsLoop))
			CPrintToChat(client, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_Emotes[iFileRandom][iIndexRandom].name);
	}

	LogDebug("%s: iFileRandom: %d | iIndexRandom: %d | sAnim1: %s | sAnim2: %s | sSound: %s | bIsLoop: %s | client: %N", IsDance ? "CreateRandomDance" : "CreateRandomEmote", iFileRandom, iIndexRandom, sAnim1, sAnim2, sSound, bIsLoop ? "true" : "false", client);
	CreateEmote(client, sAnim1, sAnim2, sSound, bIsLoop, iFileRandom);
}