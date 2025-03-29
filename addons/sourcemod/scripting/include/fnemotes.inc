#if defined _fnemotes_included_
	#endinput
#endif
#define _fnemotes_included_

/* Natives */

/**
 * Checks client's emote status
 *
 * @param iClient    Client's id
 * @return          True / False
 */
native bool fnemotes_IsClientEmoting(int iClient);

/**
 * When a client do a emote
 *
 * @param iClient    Client's id
 */
forward void fnemotes_OnEmote(int iClient);

public SharedPlugin __pl_fnemotes =
{
	name = "fnemotes",
	file = "fortnite_emotes_extended.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_fnemotes_SetNTVOptional()
{
	MarkNativeAsOptional("fnemotes_IsClientEmoting");
	MarkNativeAsOptional("fnemotes_OnEmote");
}
#endif