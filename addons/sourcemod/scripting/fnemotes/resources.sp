#if defined _resources_included
	#endinput
#endif
#define _resources_included

/*****************************************************************
			G L O B A L   V A R S
*****************************************************************/

#define FNEMOTES_DIR	"data/fnemotes"
#define FNEMOTES_LIMIT_FILES	5	// Max number of files in the fnemotes directory. Sourcepawn doesn't support dynamic gloval arrays

#define KEY_MODELS 		"models"
#define KEY_SOUNDS		"sounds"
#define KEY_EMOTES		"emotes"
#define KEY_DANCES		"dances"
#define KEY_SIZE		"size"
#define MAX_RESOURCES	120

enum struct Resources
{
	char path[PLATFORM_MAX_PATH];
}

KeyValues
	g_kvResources[FNEMOTES_LIMIT_FILES];

Resources
	g_Models[FNEMOTES_LIMIT_FILES][MAX_RESOURCES], // [] = file index, [] = resource index
	g_Sounds[FNEMOTES_LIMIT_FILES][MAX_RESOURCES]; // [] = file index, [] = resource index

int
	g_iModelSize[FNEMOTES_LIMIT_FILES], // [] = file index
	g_iSoundsSize[FNEMOTES_LIMIT_FILES], // [] = file index
	g_iEmotesSize[FNEMOTES_LIMIT_FILES], // [] = file index
	g_iDancesSize[FNEMOTES_LIMIT_FILES], // [] = file index
	g_iFilesFnemotesCounter; // Counter for the number of files in the fnemotes directory

enum struct FilesFnEmotes
{
	char name[64];
}

FilesFnEmotes
	g_FilesConfig[FNEMOTES_LIMIT_FILES], // Array to store the names of the .cfg files in the fnemotes directory
	g_Emotes[FNEMOTES_LIMIT_FILES][MAX_RESOURCES], // [] = file index, [] = emote index
	g_Dances[FNEMOTES_LIMIT_FILES][MAX_RESOURCES]; // [] = file index, [] = dance index

/*****************************************************************
			F O R W A R D   P U B L I C S
*****************************************************************/

OnPluginStart_resources()
{
	if (!LoadResources())
		SetFailState("Couldn't load resources from [%s] folder", FNEMOTES_DIR);

	RegConsoleCmd("sm_emotes_resources", Command_Resources);
	RegAdminCmd("sm_emotes_reloadresources", Command_ReloadResources, ADMFLAG_GENERIC);
}

public Action Command_Resources(int client, int args)
{
	for (int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		ReplyToCommand(client, "\nFile [%s]", g_FilesConfig[i].name);
		ReplyToCommand(client, "--------------------");
		for (int j = 1; j <= g_iModelSize[i]; j++)
		{
			ReplyToCommand(client, "Model [%d] - [%s]", j, g_Models[i][j].path);
		}

		ReplyToCommand(client, "--------------------");
		for (int j = 1; j <= g_iSoundsSize[i]; j++)
		{
			ReplyToCommand(client, "Sound [%d] - [%s]", j, g_Sounds[i][j].path);
		}
		ReplyToCommand(client, "--------------------");

		for (int j = 1; j <= g_iEmotesSize[i]; j++)
		{
			ReplyToCommand(client, "Emote [%d] - [%s]", j, g_Emotes[i][j].name);
		}
		ReplyToCommand(client, "--------------------");

		for (int j = 1; j <= g_iDancesSize[i]; j++)
		{
			ReplyToCommand(client, "Dance [%d] - [%s]", j, g_Dances[i][j].name);
		}
		ReplyToCommand(client, "--------------------");
	}

	return Plugin_Handled;
}

public Action Command_ReloadResources(int client, int args)
{
	for(int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		delete g_kvResources[i];
	}

	if (!LoadResources())
	{
		ReplyToCommand(client, "Couldn't reload resources from [%s] folder", FNEMOTES_DIR);
		return Plugin_Handled;
	}

	ReplyToCommand(client, "Resources reloaded successfully");
	return Plugin_Handled;

}

void OnPluginEnd_resources()
{
	ClearGlobalVariables();
}

void OnConfigsExecuted_resources()
{
#if !DEBUG
	if (g_bLateload)
		return;
#endif
}

void OnMapStart_Resources()
{
#if !DEBUG
	if (g_bLateload)
		return;
#endif

	if (!g_cvarDownloadResources.BoolValue)
		return;

	for(int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		for (int j = 1; j <= g_iModelSize[i]; j++)
		{
			AddFileToDownloadsTable(g_Models[i][j].path);
		}

		for (int j = 1; j <= g_iSoundsSize[i]; j++)
		{
			AddFileToDownloadsTable(g_Sounds[i][j].path);
		}
	}

	for(int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		for (int j = 1; j <= g_iModelSize[i]; j++)
		{
			if (StrContains(g_Models[i][j].path, ".mdl") == -1)
				continue;

			PrecacheModel(g_Models[i][j].path, true);
		}

		char szSound[MAX_RESOURCES];
		for (int j = 1; j <= g_iSoundsSize[i]; j++)
		{
			Format(szSound, sizeof(szSound), g_Sounds[i][j].path);
			ReplaceStringEx(szSound, sizeof(szSound), "sound/", "");
			PrecacheSound(szSound);
		}
	}
}

/*****************************************************************
			P L U G I N   F U N C T I O N S
*****************************************************************/

bool LoadResources()
{
	if(!ReadDirectory())
	{
		LogError("Couldn't find any .cfg files in [%s] folder", FNEMOTES_DIR);
		return false;
	}

	for(int i = 1; i <= g_iFilesFnemotesCounter; i++)
	{
		char sFnemotesPatch[PLATFORM_MAX_PATH];
		BuildPath(Path_SM, sFnemotesPatch, sizeof(sFnemotesPatch), "%s/%s", FNEMOTES_DIR, g_FilesConfig[i].name);

		g_kvResources[i] = new KeyValues("Resources");
	
		if (!g_kvResources[i].ImportFromFile(sFnemotesPatch))
		{
			delete g_kvResources[i];
			LogError("Couldn't import file [%s]", sFnemotesPatch);
			return false;
		}

		if(!ReadResources(i))
		{
			LogError("Couldn't read resources from file [%s]", g_FilesConfig[i].name);
			continue;
		}
		
		char sBuffer[62];
		strcopy(sBuffer, sizeof(sBuffer), g_FilesConfig[i].name);
		ReplaceString(sBuffer, sizeof(sBuffer), ".cfg", "");	// Remove .cfg extension
		Format(sBuffer, sizeof(sBuffer), "%s.phrases", sBuffer);
		LoadTranslation(sBuffer);
	}

	return true;
}


bool ReadResources(int iFile)
{
	g_kvResources[iFile].Rewind();
	if(!g_kvResources[iFile].JumpToKey(KEY_MODELS))
	{
		LogError("Couldn't find key [%s] in file [%s]", KEY_MODELS, g_FilesConfig[iFile].name);
		return false;
	}
	
	g_iModelSize[iFile] = g_kvResources[iFile].GetNum(KEY_SIZE, -1);
	if (g_iModelSize[iFile] == -1)
	{
		LogError("Couldn't find key [%s => %s] in file [%s]", KEY_MODELS, KEY_SIZE, g_FilesConfig[iFile].name);
		return false;
	}

	char sIndex[4];
	for (int j = 1; j <= g_iModelSize[iFile]; j++)
	{
		IntToString(j, sIndex, sizeof(sIndex));
		g_kvResources[iFile].GetString(sIndex, g_Models[iFile][j].path, sizeof(g_Models[][].path));
	}

	g_kvResources[iFile].GoBack();
	if(!g_kvResources[iFile].JumpToKey(KEY_SOUNDS))
	{
		LogError("Couldn't find key [%s] in file [%s]", KEY_SOUNDS, g_FilesConfig[iFile].name);
		return false;
	}
	g_iSoundsSize[iFile] = g_kvResources[iFile].GetNum(KEY_SIZE, -1);
	if (g_iSoundsSize[iFile] == -1)
	{
		LogError("Couldn't find key [%s => %s] in file [%s]", KEY_SOUNDS, KEY_SIZE, g_FilesConfig[iFile].name);
		return false;
	}

	for (int j = 1; j <= g_iSoundsSize[iFile]; j++)
	{
		IntToString(j, sIndex, sizeof(sIndex));
		g_kvResources[iFile].GetString(sIndex, g_Sounds[iFile][j].path, sizeof(g_Models[][].path));
	}

	g_kvResources[iFile].GoBack();
	if(!g_kvResources[iFile].JumpToKey(KEY_EMOTES))
	{
		LogError("Couldn't find key [%s] in file [%s]", KEY_EMOTES, g_FilesConfig[iFile].name);
		return false;
	}
	g_iEmotesSize[iFile] = g_kvResources[iFile].GetNum(KEY_SIZE, -1);
	if (g_iEmotesSize[iFile] == -1)
	{
		LogError("Couldn't find key [%s => %s] in file [%s]", KEY_EMOTES, KEY_SIZE, g_FilesConfig[iFile].name);
		return false;
	}

	for (int j = 1; j <= g_iEmotesSize[iFile]; j++)
	{
		IntToString(j, sIndex, sizeof(sIndex));
		g_kvResources[iFile].GetString(sIndex, g_Emotes[iFile][j].name, sizeof(g_Emotes[][].name));
	}

	g_kvResources[iFile].GoBack();
	if(!g_kvResources[iFile].JumpToKey(KEY_DANCES))
	{
		LogError("Couldn't find key [%s] in file [%s]", KEY_DANCES, g_FilesConfig[iFile].name);
		return false;
	}
	g_iDancesSize[iFile] = g_kvResources[iFile].GetNum(KEY_SIZE, -1);
	if (g_iDancesSize[iFile] == -1)
	{
		LogError("Couldn't find key [%s => %s] in file [%s]", KEY_DANCES, KEY_SIZE, g_FilesConfig[iFile].name);
		return false;
	}

	for (int j = 1; j <= g_iDancesSize[iFile]; j++)
	{
		IntToString(j, sIndex, sizeof(sIndex));
		g_kvResources[iFile].GetString(sIndex, g_Dances[iFile][j].name, sizeof(g_Dances[][].name));
	}

	return true;
}

/**
 * Reads the directory specified by `FNEMOTES_DIR` and populates the `g_FilesConfig` array with the names of the .cfg files found.
 * 
 * @return True if at least one .cfg file is found in the directory, false otherwise.
 */
bool ReadDirectory()
{
	char sPath[PLATFORM_MAX_PATH];

	BuildPath(Path_SM, sPath, sizeof(sPath), FNEMOTES_DIR);

	if (!DirExists(sPath))
		return false;

	DirectoryListing dL = OpenDirectory(sPath);

	g_iFilesFnemotesCounter = 1;
	while (dL.GetNext(g_FilesConfig[g_iFilesFnemotesCounter].name, sizeof(g_FilesConfig[].name)))
	{
		if (StrContains(g_FilesConfig[g_iFilesFnemotesCounter].name, ".cfg") == -1)
			continue;

		g_iFilesFnemotesCounter++;
	}
	g_iFilesFnemotesCounter--; // the last array is always empty, we don't need it

	if (g_iFilesFnemotesCounter == 0)
		return false;

	return true;
}

bool GetEmoteInfo(const int iFile, const char[] sName, char[] sAnim1, int iAnim1Leng, char[] sAnim2, int iAnim2Leng, char[] sSound, int iSoundLeng, bool &bIsLooping, bool bIsDance = false)
{
	g_kvResources[iFile].Rewind();

	char 
		sBuffer[64],
		sKey[16];

	strcopy(sKey, sizeof(sKey), bIsDance ? KEY_DANCES : KEY_EMOTES);

	if (!g_kvResources[iFile].JumpToKey(sKey))
	{
		LogError("Couldn't find key [%s] in file [%s]", sKey, g_FilesConfig[iFile].name);
		return false;
	}

	if (!g_kvResources[iFile].JumpToKey(sName))
	{
		LogError("Couldn't find key [%s] in file [%s]", sName, g_FilesConfig[iFile].name);
		return false;
	}
		
	g_kvResources[iFile].GetString("anim1", sBuffer, sizeof(sBuffer));
	strcopy(sAnim1, iAnim1Leng, sBuffer);
	g_kvResources[iFile].GetString("anim2", sBuffer, sizeof(sBuffer));
	strcopy(sAnim2, iAnim2Leng, sBuffer);
	g_kvResources[iFile].GetString("sound", sBuffer, sizeof(sBuffer));
	strcopy(sSound, iSoundLeng, sBuffer);
	bIsLooping = view_as<bool>(g_kvResources[iFile].GetNum("isloop", 0));

#if DEBUG
	LogDebug("GetEmoteInfo: Name: %s | Anim1: %s | Anim2: %s | Sound: %s | Loop: %s", sName, sAnim1, sAnim2, sSound, bIsLooping ? "true" : "false");
#endif

	return true;
}

void ClearGlobalVariables()
{
    for (int i = 0; i < FNEMOTES_LIMIT_FILES; i++)
    {
        g_iModelSize[i] = 0;
        g_iSoundsSize[i] = 0;
        g_iEmotesSize[i] = 0;
        g_iDancesSize[i] = 0;

        for (int j = 0; j < MAX_RESOURCES; j++)
        {
            g_Models[i][j].path[0] = '\0';
            g_Sounds[i][j].path[0] = '\0';
            g_Emotes[i][j].name[0] = '\0';
            g_Dances[i][j].name[0] = '\0';
        }

        g_FilesConfig[i].name[0] = '\0';
    }

    g_iFilesFnemotesCounter = 0;
}