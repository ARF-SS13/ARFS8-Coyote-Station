/// Undefined phase, before the round starts
#define ROUND_PHASE_0 0
/// Startup peacetime, sparse only minor issues, light foreshadowing of the main threat
/// From 0 to 30 minutes
#define ROUND_PHASE_1 1
/// Early game, minor issues start to appear, but the main threat is not yet active
/// From 30 minutes to 1 hour
#define ROUND_PHASE_2 2
/// The main threats get ready, foreshadowing is in full swing
/// From 1 to 1.5 hours
#define ROUND_PHASE_3 3
/// The main threat begins!
/// From 1.5 to 2 hours
#define ROUND_PHASE_4 4
/// Midlate game, main threat is active
/// From 2 to 2.5 hours
#define ROUND_PHASE_5 5
/// Late game, continuation of the main threat
/// From 2.5 to end
#define ROUND_PHASE_6 6


#define RW_LOGPATH "data/ratwiggle/log.txt"
#define RW_LOGLVL_DEBUG 1
#define RW_LOGLVL_INFO 2
#define RW_LOGLVL_WARN 3
#define RW_LOGLVL_ERROR 4
#define RW_LOGLVL_DISABLE 5


#define RADIO_INTERFERENCE_RESISTANCE_NONE 0
#define RADIO_INTERFERENCE_RESISTANCE_LOW 1
#define RADIO_INTERFERENCE_RESISTANCE_MEDIUM 2
#define RADIO_INTERFERENCE_RESISTANCE_HIGH 3
#define RADIO_INTERFERENCE_RESISTANCE_MAX RADIO_INTERFERENCE_RESISTANCE_HIGH

#define NARRATIVE_AREA_FLAG_ERP_ZONES (1 << 0)
#define NARRATIVE_AREA_FLAG_RUINS (1 << 1)
#define NARRATIVE_AREA_FLAG_SPACE (1 << 2)
#define NARRATIVE_AREA_FLAG_MAINTS (1 << 3)
#define NARRATIVE_AREA_FLAG_ATMOS (1 << 4)

#define COMSIG_NARRATIVE_LIFE_EFFECTS "narrative_life_effects"

