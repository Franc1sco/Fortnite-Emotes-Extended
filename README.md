# Fortnite-Emotes-Extended

## Resumen

Este proyecto empaqueta y mantiene una variante orientada a Left 4 Dead 2 del plugin de emotes de Fortnite para SourceMod.

El objetivo del repositorio es ofrecer un artefacto instalable, consistente con el stack AoC, listo para servidor y FastDL, sin depender de includes privadas ni de compresiones manuales posteriores.

El catalogo actual base incluye:

- 36 emotes
- 48 dances
- 60 archivos de sonido
- 3 archivos de modelo para el rig original

## Comandos principales

El plugin registra estos comandos para los jugadores y administradores:

- sm_emote
- sm_emotecode
- sm_dance
- sm_dancecode
- sm_setemote
- sm_setdance
- sm_emotes_resources
- sm_emotes_reloadresources

## Configuracion relevante

La autoexec principal queda en:

- cfg/sourcemod/fortnite_emotes_extended.cfg

ConVars relevantes:

- sm_emotes_cooldown
- sm_emotes_sounds
- sm_emotes_soundvolume
- sm_emotes_hide_weapons
- sm_emotes_hide_enemies
- sm_emotes_teleportonend
- sm_emotes_speed
- sm_emotes_download_resources
- sm_emotes_admin_flag_menu
- sm_dances_admin_flag_menu

## API publica

La libreria publica registrada por el plugin es fnemotes.

Interfaces expuestas:

- native bool fnemotes_IsClientEmoting(int iClient)
- forward void fnemotes_OnEmote(int iClient)

La include publica distribuida para otros plugins es:

- addons/sourcemod/scripting/include/fnemotes.inc

## Artefactos CI

El repositorio publica paquetes listos para instalar desde GitHub Releases:

- fortnite-emotes-extended-latest.zip
	- canal estable desde main
- fortnite-emotes-extended-develop.zip
	- canal de integracion desde develop
- fortnite-emotes-extended-<version>.zip
	- release versionada desde tags sourcemod/vX.Y.Z

Canales:

- channel/latest
- channel/develop

## Contenido del paquete

El artefacto generado por CI incluye:

- addons/sourcemod/plugins/vip/fortnite_emotes_extended.smx
- addons/sourcemod/scripting/fortnite_emotes_extended.sp
- addons/sourcemod/scripting/fnemotes/
- addons/sourcemod/scripting/include/fnemotes.inc
- addons/sourcemod/data/fnemotes/
- addons/sourcemod/translations/
- cfg/sourcemod/fortnite_emotes_extended.cfg
- models/fortnite_emotes/original/
- sound/fortnite_emotes/original/

El plugin compilado se distribuye en:

- addons/sourcemod/plugins/vip/fortnite_emotes_extended.smx

Ese layout coincide con la forma en que AoC lo carga dentro del stack competitivo.

## Includes publicas

Solo se distribuye la include publica:

- addons/sourcemod/scripting/include/fnemotes.inc

Las includes colors.inc, pause.inc, readyup.inc y vip_core.inc se usan solo para compilacion local del plugin y no forman parte del artefacto.

Eso evita publicar dependencias de compilacion que pertenecen al entorno del servidor y no a la API publica del plugin.

## Models y Sound

Los assets de models y sound se empaquetan en el zip con sus archivos originales y con un sidecar .bz2 individual por cada archivo.

Esto permite usar el mismo artefacto como base de despliegue del servidor y como origen para FastDL sin regenerar compresiones aparte.

Layout de assets mantenido por CI:

- models/fortnite_emotes/original/
- sound/fortnite_emotes/original/

En particular:

- sound/fortnite_emotes/original contiene sonidos mp3
- models/fortnite_emotes/original contiene los archivos mdl, vvd y dx90.vtx del modelo base

## Instalacion rapida

1. Descarga el zip del canal deseado desde GitHub Releases.
2. Extrae el contenido en la raiz de left4dead2 del servidor.
3. Verifica que el plugin quede en addons/sourcemod/plugins/vip/.
4. Reinicia el servidor o carga el plugin.

## Uso desde otros plugins

Si otro plugin necesita detectar si un cliente esta ejecutando un emote, solo debe consumir la include publica fnemotes.inc y enlazar contra la libreria fnemotes.

No se deben redistribuir las includes locales del proyecto como parte de una API externa.

## Fork

Este proyecto es un fork de:

- https://github.com/Franc1sco/Fortnite-Emotes-Extended/tree/l4d

La variante mantenida aqui incorpora mejoras enfocadas a Left 4 Dead 2, al empaquetado reproducible por CI, al consumo por artifacts de GitHub Releases y a la integracion con el stack competitivo de AoC.
