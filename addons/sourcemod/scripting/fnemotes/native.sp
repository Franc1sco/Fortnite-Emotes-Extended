/*****************************************************************
			G L O B A L   V A R S
*****************************************************************/

GlobalForward
	g_gfEmoteForward,
	g_gfEmoteForward_Pre;

/*****************************************************************
			F O R W A R D   P U B L I C S
*****************************************************************/
public AskPluginLoad2_native()
{
	g_gfEmoteForward		= CreateGlobalForward("fnemotes_OnEmote", ET_Ignore, Param_Cell);
	g_gfEmoteForward_Pre	= CreateGlobalForward("fnemotes_OnEmote_Pre", ET_Event, Param_Cell);

	CreateNative("fnemotes_IsClientEmoting", iNative_IsClientEmoting);
	RegPluginLibrary("fnemotes");
}

/*****************************************************************
			N A T I V E S
*****************************************************************/

int iNative_IsClientEmoting(Handle hPlugin, int iNumParams)
{
	return g_bClientDancing[GetNativeCell(1)];
}