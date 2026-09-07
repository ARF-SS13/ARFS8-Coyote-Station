// ╔═════════╤═══════════════════════════════════╗
// ║ File    │ visualchat_subsystem.dm           ║
// ║ Date    │ 1979-12-25                        ║
// ║ Author  │ Daniel "ThroatYoate" Kelly        ║
// ║ License │ CMYK-Pubic-Domain-1.0             ║
// ║ Quote   │ "I can see your cute voice"       ║
// ╟─────────┼───────────────────────────────────╨───────────────────────────────────────────────────╖
// ║         │                                                                                       ║
// ║  ####   │ Welcome to VisualChat, a visual novel chat destruction system for SS13                ║
// ║  ####   │                                                                                       ║
// ║  ####   │ Got soem stuff parts to it!                                                           ║
// ║  ####   │ - Player settings! in depth and customizable! (with a lot of options)                 ║
// ║  ####   │ --- Saved as jsons cus thats kinda hot                                                ║
// ║  ####   │ - Say data extractor, to get the data from say messages!                              ║
// ║         │                                                                                       ║
// ╟─────────┼───────────────────────────────────────────────────────────────────────────────────────╢
// ║  ----   │  ===================================================================================  ║
// ╚═════════╧═══════════════════════════════════════════════════════════════════════════════════════╝

#define VC_PATH                  "data/visualchat/"
#define VC_LOGS                  "data/visualchat/logs/"
#define VC_METRIX                "data/visualchat/metrix/"
#define VC_SAVES                 "data/visualchat/saves/"
#define VC_SAVE_FILE(ckey, slot) "data/visualchat/saves/[ckey]_[slot].json"
#define VC_PREVIEW_SAVE          "data/visualchat/preview_saves/cutie_cat.json"
SUBSYSTEM_DEF(visualchat)
	name = "VisualChat"
	wait = 10 SECONDS
	/// format: list("[ckey]" = list("[prefslot]" = /datum/vc_prefs_holder, "[prefslot]" = /datum/vc_prefs_holder, ...))
	var/list/chatprefs = list()
	var/datum/vc_metrix/metrix

/datum/controller/subsystem/visualchat/Initialize(start_timeofday)
	LoadVCSettings()
	to_chat(world, span_captaincast("Initialized !"))

/datum/controller/subsystem/visualchat/proc/LoadVCSettings()
	//? todo this

/datum/controller/subsystem/visualchat/proc/SaveVCSettings()
	//? todo this

/datum/controller/subsystem/visualchat/proc/Hornify(mob/reader, list/message_data)
	if(!reader || !LAZYLEN(message_data))
		return

// im a small clever foxxie with a cute face, and a small butt, and my butt smells nice, and I like to kiss my own butt

// ╔════════════════════════════════════════╗
// ║ ╔════════════════════════════════════╗ ║
// ║ ║ VISUAL CHAT PREFERENCES MANAGEMENT ║ ║
// ║ ╚════════════════════════════════════╝ ╚══════════════════════════╗
// ║ Manages the cluster of a player's current visual chat preferences ║
// ║ Ckey for player account, slot for the character slot, plus some   ║
// ║ extras for mobs and such                                          ║
// ╚═══════════════════════════════════════════════════════════════════╝

/datum/vc_account_prefs_manager
	var/owner_ckey
	/// So! this is the directory for the unholy clusters of visual chat preferences per player.
	/// prefs_per_slot_human: for normal-spawned characters from the character setup menu
	///   Generally whats used for the vast majority of players
	///   format: "[slot]" = /datum/vc_prefs_holder
	var/list/prefs_per_slot_human = list()
	/// prefs_per_slot_silicon: for silicon characters, like AIs or robots
	///   dogborgs and such pull from this, though it'll fallback to the human slot if it doesn't exist... maybe
	///   format: "[slot]" = /datum/vc_prefs_holder
	var/list/prefs_per_slot_silicon = list()
	/// prefs_per_mob: for mobs that arent borne of the character setup menu, like rats and ash drakes
	///   Checked when this ckey acts as a mob, of this type or any subtype of it
	///   Has a default of /mob
	///   format: "[mob_type]" = /datum/vc_prefs_holder
	var/list/prefs_per_mob = list()
	/// cooldown for showing the whole VC message, for like, repeat similar-style messages
	var/last_saymode
	var/last_saymode_time = 0
	var/saymode_cooldown = 30 SECONDS // or theres a gap or somethign
	/// the almightly clipboard, because there is gonna be a LOT of copying and pasting of preferences
	var/list/clipboard = list()
	/// color swatchboard!
	var/list/color_swatches = list()

/datum/vc_preference_holder
	var/datum/vc_account_prefs_manager/parent_manager
	/// format: "[saymode]" = /datum/vc_preference
	var/list/saymode_prefs = list()

/datum/vc_preference
	var/datum/vc_preference_holder/parent_holder
	var/saymode = SAYMODE_SAY // Braixen Brai!
	var/preview_text = ""
	/// The link to the profile picture associated with this preference.
	var/pfp_link = ""
	/// now a metric crunchload of Web 2.0 CSS-adjacent styling preferences for this particular saymode
	/// outer box styling: border
	var/outer_box_border_color = "#000000FF"
	var/outer_box_border_width = 1
	var/outer_box_border_radius = 0
	var/outer_box_border_style = "solid"

	/// pfp box styling: background: border, color, gradient
	var/pfp_box_background_color = "#FFFFFFFF"
	var/pfp_box_background_gradient_use = FALSE
	var/pfp_box_background_gradient_angle = 0
	var/pfp_box_background_gradient_start = "#FFFFFFFF"
	var/pfp_box_background_gradient_end = "#FFFFFFFF"
	var/pfp_box_background_opacity = 255
	var/pfp_box_background_image = "" // dunk some image in there if you want

	var/pfp_box_border_color = "#000000FF"
	var/pfp_box_border_width = 1
	var/pfp_box_border_radius = 0
	var/pfp_box_border_style = "solid"

	/// pfp image styling: shape, mostly just that
	var/pfp_image_shape = "square" // square, circle, rounded
	var/pfp_image_scaling = "cover" // cover, contain, stretch
	var/pfp_image_border_color = "#000000FF"
	var/pfp_image_border_width = 1
	var/pfp_image_border_radius = 0
	var/pfp_image_border_style = "solid"
	var/pfp_image_opacity = 255

	/// name box styling: background: border, color, gradient
	var/name_box_background_color = "#FFFFFFFF"
	var/name_box_background_gradient_use = FALSE
	var/name_box_background_gradient_angle = 0
	var/name_box_background_gradient_start = "#FFFFFFFF"
	var/name_box_background_gradient_end = "#FFFFFFFF"
	var/name_box_background_opacity = 255
	var/name_box_background_image = "" // dunk some image in there if you want

	var/name_box_border_color = "#000000FF"
	var/name_box_border_width = 1
	var/name_box_border_radius = 0
	var/name_box_border_style = "solid"

	var/name_box_text_color = "#000000FF"
	var/name_box_text_font = "!!DEFAULT!!"

	/// message box styling: background: border, color, gradient
	var/message_box_background_color = "#FFFFFFFF"
	var/message_box_background_gradient_use = FALSE
	var/message_box_background_gradient_angle = 0
	var/message_box_background_gradient_start = "#FFFFFFFF"
	var/message_box_background_gradient_end = "#FFFFFFFF"
	var/message_box_background_opacity = 255
	var/message_box_background_image = "" // dunk some image in there if you want

	var/message_box_border_color = "#000000FF"
	var/message_box_border_width = 1
	var/message_box_border_radius = 0
	var/message_box_border_style = "solid"

	var/message_box_text_color = "#000000FF"
	var/message_box_text_font = "!!DEFAULT!!"
	var/message_box_text_outline_use = FALSE
	var/message_box_text_outline_color = "#000000FF"
	var/message_box_text_outline_width = 0
	var/message_box_text_shadow_use = FALSE
	var/message_box_text_shadow_color = "#000000FF"
	var/message_box_text_shadow_offset_x = 0
	var/message_box_text_shadow_offset_y = 0
	var/message_box_text_shadow_blur = 0
	var/message_box_text_shadow_opacity = 255
	var/message_box_text_opacity = 255
	var/message_box_text_alignment = "left" // left, center, right
	var/message_box_text_line_height = 1.2
	var/message_box_text_letter_spacing = 0
	var/message_box_text_word_spacing = 0
	var/message_box_text_text_transform = "none" // none, uppercase, lowercase, capitalize
	var/message_box_text_text_decoration = "none" // none, underline, overline, line-through
	var/message_box_text_text_indent = 0
	var/message_box_text_text_white_space = "normal" // normal, nowrap, pre, pre-wrap, pre-line
	var/message_box_text_overflow = "visible" // visible, hidden, scroll, ellipsis
	var/message_box_text_white_space = "normal" // normal, nowrap, pre, pre-wrap, pre-line
	var/message_box_text_word_break = "normal" // normal, break-all, keep-all, break-word
	var/message_box_text_hyphens = "none" // none, manual, auto
	var/message_box_text_direction = "ltr" // ltr, rtl, auto
	var/message_box_text_unicode_bidi = "normal" // normal, embed, bidi-override
	var/message_box_text_tab_size = 4
	var/message_box_text_writing_mode = "horizontal-tb" // horizontal-tb, vertical-rl, vertical-lr
	var/message_box_text_text_orientation = "mixed" // mixed, upright, sideways
	var/message_box_text_text_rendering = "auto" // auto, optimizeSpeed, optimizeLegibility, geometricPrecision
	var/message_box_text_font_variant = "normal" // normal, small-caps
	var/message_box_text_font_variant_caps = "normal" // normal, small-caps, all-small-caps, petite-caps, all-petite-caps, unicase, titling-caps
	var/message_box_text_font_feature_settings = "normal" // normal, <feature-settings>
	var/message_box_text_font_kerning = "auto" // auto, normal, none
	var/message_box_text_font_language_override = "normal" // normal, <language-tag>
	var/message_box_text_font_optical_size = "auto" // auto, <number>
	var/message_box_text_font_stretch = "normal" // normal, ultra-condensed, extra-condensed, condensed, semi-condensed, semi-expanded, expanded, extra-expanded, ultra-expanded
	var

	/// toogles
	var/toggle_show_pfp = TRUE
	var/toggle_show_name = TRUE



