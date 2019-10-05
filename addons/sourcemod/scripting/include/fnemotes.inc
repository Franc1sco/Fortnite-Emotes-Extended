#if defined _fnemotes_included_
#endinput
#endif
#define _fnemotes_included_

/* Natives */

/**
 * Checks client's emote status
 *
 * @param client    Client's id
 * @return          True / False
 */
native bool fnemotes_IsClientEmoting(int client);

public void __pl_fnemotes_SetNTVOptional()
{
	MarkNativeAsOptional("fnemotes_IsClientEmoting");
}