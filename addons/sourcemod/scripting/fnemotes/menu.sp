/*****************************************************************
			P L U G I N   F U N C T I O N S
*****************************************************************/

Action aMainMenu(int iClient)
{
	Menu hMenu = new Menu(iMainMenuHandler);

	char szTitle[65];
	Format(szTitle, sizeof(szTitle), "%T:", "TITLE_MAIM_MENU", iClient);
	hMenu.SetTitle(szTitle);

	vAddTranslatedMenuItem(hMenu, "", "RANDOM_EMOTE", iClient);
	vAddTranslatedMenuItem(hMenu, "", "RANDOM_DANCE", iClient);
	vAddTranslatedMenuItem(hMenu, "", "EMOTES_LIST", iClient);
	vAddTranslatedMenuItem(hMenu, "", "DANCES_LIST", iClient);

	hMenu.ExitButton = true;
	hMenu.Display(iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

int iMainMenuHandler(Menu hMenu, MenuAction eAction, int iParam1, int iParam2)
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
					vStopEmote(iClient);
					vCreateRandomEmote(iClient);
					aMainMenu(iClient);
				}
				case 1:
				{
					vStopEmote(iClient);
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
	}
	return 0;
}

Action aMenuEmotes(int iClient)
{
	Menu hMenu = new Menu(iMenuEmotesHandler);

	char szTitle[65];
	Format(szTitle, sizeof(szTitle), "%T:", "TITLE_EMOTES_MENU", iClient);
	hMenu.SetTitle(szTitle);

	for (int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		for (int j = 1; j <= g_iEmotesSize[i]; j++)
		{
			char szIndex[8];
			Format(szIndex, sizeof(szIndex), "%d:%d", i, j);
			vAddTranslatedMenuItem(hMenu, szIndex, g_szEmotes[i][j].szName, iClient);
		}
	}

	hMenu.ExitButton = true;
	hMenu.ExitBackButton = true;
	hMenu.Display(iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

int iMenuEmotesHandler(Menu hMenu, MenuAction eAction, int iClient, int iParam2)
{
	switch (eAction)
	{
		case MenuAction_Select:
		{
			char szItem[16];
			if (hMenu.GetItem(iParam2, szItem, sizeof(szItem)))
			{
				int iFile, iItem;
				char szBuffer[2][4], szAnim1[64], szAnim2[64], szSound[PLATFORM_MAX_PATH];
				bool bIsLoop;

				ExplodeString(szItem, ":", szBuffer, sizeof(szBuffer), sizeof(szBuffer[]));
				iFile = StringToInt(szBuffer[0]);
				iItem = StringToInt(szBuffer[1]);
				
				if (!bGetEmoteInfo(iFile, g_szEmotes[iFile][iItem].szName, szAnim1, sizeof(szAnim1), szAnim2, sizeof(szAnim2), szSound, sizeof(szSound), bIsLoop))
				{
					CPrintToChat(iClient, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_szEmotes[iFile][iItem].szName);
					return 0;
				}

				aCreateEmote(iClient, szAnim1, szAnim1, szAnim2, bIsLoop, iFile);
			}
			hMenu.DisplayAt(iClient, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
		}
		case MenuAction_Cancel:
		{
			if (iParam2 == MenuCancel_ExitBack)
				aMainMenu(iClient);
		}
	}
	return 0;
}

Action aMenuDances(int iClient)
{
	Menu hMenu = new Menu(iMenuDancesHandler);

	char szTitle[65];
	Format(szTitle, sizeof(szTitle), "%T:", "TITLE_DANCES_MENU", iClient);
	hMenu.SetTitle(szTitle);

	for (int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		for (int j = 1; j <= g_iDancesSize[i]; j++)
		{
			char szIndex[8];
			Format(szIndex, sizeof(szIndex), "%d:%d", i, j);
			vAddTranslatedMenuItem(hMenu, szIndex, g_szDances[i][j].szName, iClient);
		}
	}

	hMenu.ExitButton = true;
	hMenu.ExitBackButton = true;
	hMenu.Display(iClient, MENU_TIME_FOREVER);

	return Plugin_Handled;
}

int iMenuDancesHandler(Menu hMenu, MenuAction eAction, int iClient, int iParam2)
{
	switch (eAction)
	{
		case MenuAction_Select:
		{
			char szItem[16];
			if (hMenu.GetItem(iParam2, szItem, sizeof(szItem)))
			{
				int iFile, iItem;
				char szBuffer[2][4], szAnim1[64], szAnim2[64], szSound[PLATFORM_MAX_PATH];
				bool bIsLoop;

				ExplodeString(szItem, ":", szBuffer, sizeof(szBuffer), sizeof(szBuffer[]));
				iFile = StringToInt(szBuffer[0]);
				iItem = StringToInt(szBuffer[1]);

				if (!bGetEmoteInfo(iFile, g_szDances[iFile][iItem].szName, szAnim1, sizeof(szAnim1), szAnim2, sizeof(szAnim2), szSound, sizeof(szSound), bIsLoop, true))
				{
					CPrintToChat(iClient, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_szDances[iFile][iItem].szName);
					return 0;
				}
				aCreateEmote(iClient, szAnim1, szAnim2, szSound, bIsLoop, iFile);
			}
			hMenu.DisplayAt(iClient, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
		}
		case MenuAction_Cancel:
		{
			if (iParam2 == MenuCancel_ExitBack)
				aMainMenu(iClient);
		}
	}
	return 0;
}

void vAddTranslatedMenuItem(Menu hMenu, const char[] szOpt, const char[] szPhrase, int iClient)
{
	char szBuffer[128];
	Format(szBuffer, sizeof(szBuffer), "%T", szPhrase, iClient);
	hMenu.AddItem(szOpt, szBuffer);
}

/**
 * Creates a random emote or dance for the specified client.
 *
 * @param iClient       The client index for whom the emote or dance is created.
 * @param bIsDance      (Optional) If true, a random dance is created. If false, a random emote is created. Defaults to false.
 */
void vCreateRandomEmote(int iClient, bool bIsDance = false)
{
	int iFileRandom, iIndexRandom;
	char szAnim1[64], szAnim2[64], szSound[PLATFORM_MAX_PATH];
	bool bIsLoop;
	int iSize;

	do {
		iFileRandom = GetRandomInt(1, g_iFilesFnemotesCounter);
		iSize = bIsDance ? g_iDancesSize[iFileRandom] : g_iEmotesSize[iFileRandom];
	} while (iSize == 0);

	iIndexRandom = GetRandomInt(1, iSize);

	if (bIsDance)
	{
		if (!bGetEmoteInfo(iFileRandom, g_szDances[iFileRandom][iIndexRandom].szName, szAnim1, sizeof(szAnim1), szAnim2, sizeof(szAnim2), szSound, sizeof(szSound), bIsLoop, true))
			CPrintToChat(iClient, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_szDances[iFileRandom][iIndexRandom].szName);
	}
	else
	{
		if (!bGetEmoteInfo(iFileRandom, g_szEmotes[iFileRandom][iIndexRandom].szName, szAnim1, sizeof(szAnim1), szAnim2, sizeof(szAnim2), szSound, sizeof(szSound), bIsLoop))
			CPrintToChat(iClient, "%t %t", "TAG", "ERROR_EMOTE_INFO", g_szEmotes[iFileRandom][iIndexRandom].szName);
	}

	vLogDebug("%s: iFileRandom: %d | iIndexRandom: %d | szAnim1: %s | szAnim2: %s | szSound: %s | bIsLoop: %s | iClient: %N", bIsDance ? "CreateRandomDance" : "CreateRandomEmote", iFileRandom, iIndexRandom, szAnim1, szAnim2, szSound, bIsLoop ? "true" : "false", iClient);
	aCreateEmote(iClient, szAnim1, szAnim2, szSound, bIsLoop, iFileRandom);
}