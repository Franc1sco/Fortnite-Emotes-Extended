/*****************************************************************
			G L O B A L   V A R S
*****************************************************************/

#define FNEMOTES_DIR	"data/fnemotes"
#define FNEMOTES_LIMIT_FILES	5	// Max number of files in the fnemotes directory. Sourcepawn doesn't support dynamic global arrays

#define KEY_MODELS 		"models"
#define KEY_SOUNDS		"sounds"
#define KEY_EMOTES		"emotes"
#define KEY_DANCES		"dances"
#define KEY_SIZE		"size"
#define MAX_RESOURCES	120

enum struct eResources
{
	char szPath[PLATFORM_MAX_PATH];
}

KeyValues
	g_kvResources[FNEMOTES_LIMIT_FILES];

eResources
	g_szModels[FNEMOTES_LIMIT_FILES][MAX_RESOURCES], // [] = file index, [] = resource index
	g_szSounds[FNEMOTES_LIMIT_FILES][MAX_RESOURCES]; // [] = file index, [] = resource index

int
	g_iModelSize[FNEMOTES_LIMIT_FILES], // [] = file index
	g_iSoundsSize[FNEMOTES_LIMIT_FILES], // [] = file index
	g_iEmotesSize[FNEMOTES_LIMIT_FILES], // [] = file index
	g_iDancesSize[FNEMOTES_LIMIT_FILES], // [] = file index
	g_iFilesFnemotesCounter; // Counter for the number of files in the fnemotes directory

enum struct eFilesFnEmotes
{
	char szName[64];
}

eFilesFnEmotes
	g_szFilesConfig[FNEMOTES_LIMIT_FILES], // Array to store the names of the .cfg files in the fnemotes directory
	g_szEmotes[FNEMOTES_LIMIT_FILES][MAX_RESOURCES], // [] = file index, [] = emote index
	g_szDances[FNEMOTES_LIMIT_FILES][MAX_RESOURCES]; // [] = file index, [] = dance index

/*****************************************************************
			F O R W A R D   P U B L I C S
*****************************************************************/

OnPluginStart_resources()
{
	if (!bLoadResources())
		SetFailState("Couldn't load resources from [%s] folder", FNEMOTES_DIR);

	RegConsoleCmd("sm_emotes_resources", aCommand_Resources);
	RegAdminCmd("sm_emotes_reloadresources", aCommand_ReloadResources, ADMFLAG_GENERIC);
}

public Action aCommand_Resources(int iClient, int iArgs)
{
	for (int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		ReplyToCommand(iClient, "\nFile [%s]", g_szFilesConfig[i].szName);
		ReplyToCommand(iClient, "--------------------");
		for (int j = 1; j <= g_iModelSize[i]; j++)
		{
			ReplyToCommand(iClient, "Model [%d] - [%s]", j, g_szModels[i][j].szPath);
		}

		ReplyToCommand(iClient, "--------------------");
		for (int j = 1; j <= g_iSoundsSize[i]; j++)
		{
			ReplyToCommand(iClient, "Sound [%d] - [%s]", j, g_szSounds[i][j].szPath);
		}
		ReplyToCommand(iClient, "--------------------");

		for (int j = 1; j <= g_iEmotesSize[i]; j++)
		{
			ReplyToCommand(iClient, "Emote [%d] - [%s]", j, g_szEmotes[i][j].szName);
		}
		ReplyToCommand(iClient, "--------------------");

		for (int j = 1; j <= g_iDancesSize[i]; j++)
		{
			ReplyToCommand(iClient, "Dance [%d] - [%s]", j, g_szDances[i][j].szName);
		}
		ReplyToCommand(iClient, "--------------------");
	}

	return Plugin_Handled;
}

public Action aCommand_ReloadResources(int iClient, int iArgs)
{
	for (int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		delete g_kvResources[i];
	}

	if (!bLoadResources())
	{
		ReplyToCommand(iClient, "Couldn't reload resources from [%s] folder", FNEMOTES_DIR);
		return Plugin_Handled;
	}

	ReplyToCommand(iClient, "Resources reloaded successfully");
	return Plugin_Handled;
}

void vOnMapStart_Resources()
{
	if (!g_cvDownloadResources.BoolValue)
		return;

	for (int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		for (int j = 1; j <= g_iModelSize[i]; j++)
		{
			if (StrContains(g_szModels[i][j].szPath, ".mdl") == -1)
				continue;

			if (IsModelPrecached(g_szModels[i][j].szPath))
				continue;

			AddFileToDownloadsTable(g_szModels[i][j].szPath);
			PrecacheModel(g_szModels[i][j].szPath, true);
			vLogResources("Precached model [%s]", g_szModels[i][j].szPath);
		}
		
		char szSound[MAX_RESOURCES];
		for (int j = 1; j <= g_iSoundsSize[i]; j++)
		{
			AddFileToDownloadsTable(g_szSounds[i][j].szPath);
			Format(szSound, sizeof(szSound), g_szSounds[i][j].szPath);
			ReplaceStringEx(szSound, sizeof(szSound), "sound/", "");
			PrecacheSound(szSound);
			vLogResources("Precached sound [%s]", szSound);
		}
	}
}

/*****************************************************************
			P L U G I N   F U N C T I O N S
*****************************************************************/

bool bLoadResources()
{
	if (!bReadDirectory())
	{
		LogError("Couldn't find any .cfg files in [%s] folder", FNEMOTES_DIR);
		return false;
	}

	for (int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		char szFnemotesPath[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, szFnemotesPath, sizeof(szFnemotesPath), "%s/%s", FNEMOTES_DIR, g_szFilesConfig[i].szName);

		g_kvResources[i] = new KeyValues("Resources");

		if (!g_kvResources[i].ImportFromFile(szFnemotesPath))
		{
			delete g_kvResources[i];
			LogError("Couldn't import file [%s]", szFnemotesPath);
			return false;
		}

		if (!bReadResources(i))
		{
			LogError("Couldn't read resources from file [%s]", g_szFilesConfig[i].szName);
			continue;
		}

		char szBuffer[62];
		strcopy(szBuffer, sizeof(szBuffer), g_szFilesConfig[i].szName);
		ReplaceString(szBuffer, sizeof(szBuffer), ".cfg", "");
		Format(szBuffer, sizeof(szBuffer), "%s.phrases", szBuffer);
		vLoadTranslation(szBuffer);
	}

	return true;
}

/**
 * Reads and parses resource data from a KeyValues file.
 *
 * This function processes multiple resource types (models, sounds, emotes, dances)
 * from a KeyValues file and stores the parsed data into global arrays.
 *
 * @param iFile The index of the file to read from the global KeyValues array.
 * 
 * @return True if all required keys and data are successfully read, false otherwise.
 *         If any required key or data is missing, an error is logged and the function
 *         returns false.
 */
bool bReadResources(int iFile)
{
	g_kvResources[iFile].Rewind();
	if (!g_kvResources[iFile].JumpToKey(KEY_MODELS))
	{
		LogError("Couldn't find key [%s] in file [%s]", KEY_MODELS, g_szFilesConfig[iFile].szName);
		return false;
	}

	g_iModelSize[iFile] = g_kvResources[iFile].GetNum(KEY_SIZE, -1);
	if (g_iModelSize[iFile] == -1)
	{
		LogError("Couldn't find key [%s => %s] in file [%s]", KEY_MODELS, KEY_SIZE, g_szFilesConfig[iFile].szName);
		return false;
	}

	char szIndex[4];
	for (int j = 1; j <= g_iModelSize[iFile]; j++)
	{
		IntToString(j, szIndex, sizeof(szIndex));
		g_kvResources[iFile].GetString(szIndex, g_szModels[iFile][j].szPath, sizeof(g_szModels[][].szPath));
	}

	g_kvResources[iFile].GoBack();
	if (!g_kvResources[iFile].JumpToKey(KEY_SOUNDS))
	{
		LogError("Couldn't find key [%s] in file [%s]", KEY_SOUNDS, g_szFilesConfig[iFile].szName);
		return false;
	}
	g_iSoundsSize[iFile] = g_kvResources[iFile].GetNum(KEY_SIZE, -1);
	if (g_iSoundsSize[iFile] == -1)
	{
		LogError("Couldn't find key [%s => %s] in file [%s]", KEY_SOUNDS, KEY_SIZE, g_szFilesConfig[iFile].szName);
		return false;
	}

	for (int j = 1; j <= g_iSoundsSize[iFile]; j++)
	{
		IntToString(j, szIndex, sizeof(szIndex));
		g_kvResources[iFile].GetString(szIndex, g_szSounds[iFile][j].szPath, sizeof(g_szModels[][].szPath));
	}

	g_kvResources[iFile].GoBack();
	if (!g_kvResources[iFile].JumpToKey(KEY_EMOTES))
	{
		LogError("Couldn't find key [%s] in file [%s]", KEY_EMOTES, g_szFilesConfig[iFile].szName);
		return false;
	}
	g_iEmotesSize[iFile] = g_kvResources[iFile].GetNum(KEY_SIZE, -1);
	if (g_iEmotesSize[iFile] == -1)
	{
		LogError("Couldn't find key [%s => %s] in file [%s]", KEY_EMOTES, KEY_SIZE, g_szFilesConfig[iFile].szName);
		return false;
	}

	for (int j = 1; j <= g_iEmotesSize[iFile]; j++)
	{
		IntToString(j, szIndex, sizeof(szIndex));
		g_kvResources[iFile].GetString(szIndex, g_szEmotes[iFile][j].szName, sizeof(g_szEmotes[][].szName));
	}

	g_kvResources[iFile].GoBack();
	if (!g_kvResources[iFile].JumpToKey(KEY_DANCES))
	{
		LogError("Couldn't find key [%s] in file [%s]", KEY_DANCES, g_szFilesConfig[iFile].szName);
		return false;
	}
	g_iDancesSize[iFile] = g_kvResources[iFile].GetNum(KEY_SIZE, -1);
	if (g_iDancesSize[iFile] == -1)
	{
		LogError("Couldn't find key [%s => %s] in file [%s]", KEY_DANCES, KEY_SIZE, g_szFilesConfig[iFile].szName);
		return false;
	}

	for (int j = 1; j <= g_iDancesSize[iFile]; j++)
	{
		IntToString(j, szIndex, sizeof(szIndex));
		g_kvResources[iFile].GetString(szIndex, g_szDances[iFile][j].szName, sizeof(g_szDances[][].szName));
	}

	return true;
}

/**
 * Reads the directory specified by FNEMOTES_DIR and populates the global array `g_aszFilesConfig`
 * with the names of configuration files (.cfg) found in the directory.
 *
 * @return True if the directory exists and contains at least one valid configuration file; 
 *         False otherwise.
 */
bool bReadDirectory()
{
	char szPath[PLATFORM_MAX_PATH];

	BuildPath(Path_SM, szPath, sizeof(szPath), FNEMOTES_DIR);

	if (!DirExists(szPath))
		return false;

	DirectoryListing hDl = OpenDirectory(szPath);

	g_iFilesFnemotesCounter = 1;
	while (hDl.GetNext(g_szFilesConfig[g_iFilesFnemotesCounter].szName, sizeof(g_szFilesConfig[].szName)))
	{
		if (StrContains(g_szFilesConfig[g_iFilesFnemotesCounter].szName, ".cfg") == -1)
			continue;

		g_iFilesFnemotesCounter++;
	}
	g_iFilesFnemotesCounter--; // the last array is always empty, we don't need it

	if (g_iFilesFnemotesCounter == 0)
		return false;

	return true;
}

/**
 * Retrieves information about a specific emote from a KeyValues resource file.
 *
 * @param iFile         The index of the resource file in the global array `g_ahKvResources`.
 * @param szName        The name of the emote to retrieve information for.
 * @param szAnim1       A buffer to store the first animation name associated with the emote.
 * @param iAnim1Length  The size of the buffer for the first animation name.
 * @param szAnim2       A buffer to store the second animation name associated with the emote.
 * @param iAnim2Length  The size of the buffer for the second animation name.
 * @param szSound       A buffer to store the sound file name associated with the emote.
 * @param iSoundLength  The size of the buffer for the sound file name.
 * @param bIsLooping    A reference to a boolean that will be set to true if the emote is looping, false otherwise.
 * @param bIsDance      (Optional) A boolean indicating whether to look for the emote in the "dances" key instead of "emotes". Defaults to false.
 *
 * @return              True if the emote information was successfully retrieved, false otherwise.
 */
bool bGetEmoteInfo(const int iFile, const char[] szName, char[] szAnim1, int iAnim1Length, char[] szAnim2, int iAnim2Length, char[] szSound, int iSoundLength, bool &bIsLooping, bool bIsDance = false)
{
	g_kvResources[iFile].Rewind();

	char szBuffer[64], szKey[16];

	strcopy(szKey, sizeof(szKey), bIsDance ? KEY_DANCES : KEY_EMOTES);

	if (!g_kvResources[iFile].JumpToKey(szKey))
	{
		LogError("Couldn't find key [%s] in file [%s]", szKey, g_szFilesConfig[iFile].szName);
		return false;
	}

	if (!g_kvResources[iFile].JumpToKey(szName))
	{
		LogError("Couldn't find key [%s] in file [%s]", szName, g_szFilesConfig[iFile].szName);
		return false;
	}

	g_kvResources[iFile].GetString("anim1", szBuffer, sizeof(szBuffer));
	strcopy(szAnim1, iAnim1Length, szBuffer);
	g_kvResources[iFile].GetString("anim2", szBuffer, sizeof(szBuffer));
	strcopy(szAnim2, iAnim2Length, szBuffer);
	g_kvResources[iFile].GetString("sound", szBuffer, sizeof(szBuffer));
	strcopy(szSound, iSoundLength, szBuffer);
	bIsLooping = view_as<bool>(g_kvResources[iFile].GetNum("isloop", 0));

#if DEBUG
	vLogDebug("GetEmoteInfo: Name: %s | Anim1: %s | Anim2: %s | Sound: %s | Loop: %s", szName, szAnim1, szAnim2, szSound, bIsLooping ? "true" : "false");
#endif

	return true;
}