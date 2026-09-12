/// ╔════════════════════════════════════════════════════════════════════════════╗
/// ║                        Visual Chat Settings Datum                          ║
/// ╚════════════════════════════════════════════════════════════════════════════╝
/datum/vc_setting
	/// displays the name of the setting in the UI
	var/st_name = ""
	var/st_key = ""
	var/st_kind = "text" // text, color, number, angle, boolean, choose, url
	var/st_category = ""
	var/st_subgroup = ""
	var/st_default_value = ""
	/// numberlike: min and max values, textlike: min and max length, unused for other types
	var/st_min_value = 0
	/// numberlike: min and max values, textlike: min and max length, unused for other types
	var/st_max_value = 0
	var/st_value = ""
	var/list/st_choices = list() // for list kind only
	var/datum/vc_saymode/parent_saymode
	var/st_buddy_key // for buddy settings, this is the key of the setting it is a buddy to. if empty, it is not a buddy

/datum/vc_setting/New(datum/vc_saymode/parent_saymode)
	. = ..()
	src.parent_saymode = parent_saymode
	if(st_kind == "url_choose") // zoop
		st_choices = list("None!")
		for(var/host in SSvisualchat.valid_hosts)
			st_choices += host
		st_default_value = LAZYACCESS(st_choices, 1)

/datum/vc_setting/Destroy(force)
	parent_saymode = null
	. = ..()

/datum/vc_setting/proc/update_terminal_setting(new_value)
	// reject invalid values based on the kind of setting
	switch(st_kind)
		if("number")
			if(!isnum(new_value))
				return
			st_value = clamp(new_value, st_min_value, st_max_value)
		if("text")
			if(!istext(new_value))
				return
			st_value = copytext(new_value, 0, st_max_value)
		if("url_choose")
			if(!istext(new_value))
				return
			// treat as choose
			if(new_value in st_choices)
				st_value = new_value
			else
				st_value = st_default_value || LAZYACCESS(st_choices, 1) || "If u can read this, call an admin!!!"
		if("url_file")
			if(!istext(new_value))
				return
			var/list/splitex = SSvisualchat.SplitUrlFilename(new_value)
			// splitex[1] is the prefix, splitex[2] is the filename
			if(LAZYLEN(splitex) != 2)
				CRASH("Unhandled url file format for vc_setting: [new_value]!!! Expected a url with a filename. ERROR CODE: BEDBOUND-OVERFED-MILKY")
			var/prefix = splitex[1]
			var/filename = splitex[2]
			if(filename != "DISREGARD")
				st_value = filename
			if(prefix != "DISREGARD")
				parent_saymode.get_setting(st_buddy_key)?.update_terminal_setting(prefix) // i get to pretend im in c#
		if("angle")
			if(!isnum(new_value))
				return
			st_value = new_value % 360
		if("boolean")
			// it'll turn into a boolean
			st_value = !!new_value
		if("choose")
			if(new_value in st_choices)
				st_value = new_value
			else
				st_value = st_default_value || LAZYACCESS(st_choices, 1) || "If u can read this, call an admin!!!"
		if("color")
			if(!istext(new_value))
				return
			st_value = SSvisualchat.ValidateColor(new_value)
		else
			st_value = ""
			CRASH("Invalid kind for vc_setting: [st_kind]!!! Expected one of: text, color, number, angle, boolean, choose, url. ERROR CODE: BLOBLIKE-PANCAKE-EXPIE")

/datum/vc_setting/proc/try_paste(list/seri)
	if(!LAZYLEN(seri) || seri["kind"] != st_kind)
		return
	update_terminal_setting(seri["value"])

/datum/vc_setting/proc/deserialize(list/seri)
	if(!LAZYLEN(seri) || !seri["path"] || seri["path"] != "[type]")
		return
	update_terminal_setting(seri["value"])

/datum/vc_setting/proc/serialize_setting(for_tgui)
	var/list/seri = list()
	seri["path"]  = "[type]" // some kind of error checking
	seri["key"]  =  st_key // some kind of error checking
	seri["value"] = st_value
	if(for_tgui)
		seri["kind"]      = st_kind
		seri["name"]      = st_name
		seri["min"]       = st_min_value
		seri["max"]       = st_max_value
		seri["choices"]   = st_choices
		seri["category"]  = parent_saymode.saymode
		seri["subgroup"]  = st_subgroup
	return seri

/datum/vc_setting/proc/is_empty_or_default()
	if(st_value == "" || st_value == st_default_value)
		return TRUE
	return FALSE

/// ╔════════════════════════════════════════════════════════════════════════════╗
/// ║                        Visual Chat Settings Builders                       ║
/// ╚════════════════════════════════════════════════════════════════════════════╝
#define VC_SETTING_FULL(key, name, kind, category, subgroup, default_value, min_val, max_val, choices, buddy_key) ;\
/datum/vc_setting/##key{; \
	st_key = #key; \
	st_name = name; \
	st_kind = kind; \
	st_category = category; \
	st_subgroup = subgroup; \
	st_default_value = default_value; \
	st_min_value = min_val; \
	st_max_value = max_val; \
	st_value = default_value; \
	st_choices = choices;\
	st_buddy_key = buddy_key;\
}

#define VC_SETTING(key, name, kind, category, subgroup, default_value, min_val, max_val, choices)\
VC_SETTING_FULL(key, name, kind, category, subgroup, default_value, min_val, max_val, choices, "")


#define VCS_DEF_BORDER_WIDTH            1
#define VCS_DEF_BORDER_WIDTH_MAX        5
#define VCS_DEF_BORDER_RADIUS           2
#define VCS_DEF_BORDER_RADIUS_MAX       50
#define VCS_DEF_BORDER_COLOR            "#343160"
#define VCS_DEF_BORDER_STYLE_CHOICES    list("solid", "dashed", "dotted", "double", "none")
#define VCS_DEF_BORDER_STYLE            "solid"
#define VCS_DEF_OPACITY_MAX             255
#define VCS_DEF_OPACITY_MIN             128
#define VCS_DEF_OPACITY                 255

#define VCS_DEF_TEXT_ALIGNMENT_CHOICES  list("left", "center", "right")
#define VCS_DEF_TEXT_ALIGNMENT_DEFAULT "left"
#define VCS_DEF_TEXT_TRANSFORM_CHOICES  list("none", "uppercase", "lowercase", "capitalize")
#define VCS_DEF_TEXT_TRANSFORM_DEFAULT "none"
#define VCS_DEF_TEXT_DECORATION_CHOICES list("none", "underline", "overline", "line-through")
#define VCS_DEF_TEXT_DECORATION_DEFAULT "none"


#define VCS_DEF_IMAGE_WIDTH_DEFAULT     100
#define VCS_DEF_IMAGE_WIDTH_MIN         25
#define VCS_DEF_IMAGE_WIDTH_MAX         150
#define VCS_DEF_IMAGE_HEIGHT_DEFAULT    100
#define VCS_DEF_IMAGE_HEIGHT_MIN        25
#define VCS_DEF_IMAGE_HEIGHT_MAX        150

#define VCS_DEF_IMG_SHAPE_CHOICES       list("square", "circle", "rounded")
#define VCS_DEF_IMG_SHAPE_DEFAULT       "square"

#define VCS_DEF_IMG_SCALING_CHOICES     list("cover", "contain", "stretch")
#define VCS_DEF_IMG_SCALING_DEFAULT     "cover"

#define VCS_DEF_FONT_CHOICES        list("Arial", "Verdana", "Times New Roman", "Courier New", "Comic Sans MS")
#define VCS_DEF_FONT_DEFAULT        "Comic Sans MS"
#define VCS_DEF_FONT_SIZE_DEFAULT   12
#define VCS_DEF_FONT_SIZE_MIN       8
#define VCS_DEF_FONT_SIZE_MAX       36
#define VCS_DEF_FONT_COLOR_DEFAULT  "#d0d0ff"

#define VCS_DEF_TEXT_COLOR              "#d0d0ff"
#define VCS_DEF_BG_COLOR_1              "#343140"
#define VCS_DEF_BG_COLOR_2              "#343130"
#define VCS_DEF_BG_ANGLE                45

// in REMs
#define VCS_DEF_PADDING_TOP_DEFAULT     1
#define VCS_DEF_PADDING_BOTTOM_DEFAULT  1
#define VCS_DEF_PADDING_LEFT_DEFAULT    1
#define VCS_DEF_PADDING_RIGHT_DEFAULT   1
#define VCS_DEF_PADDING_TOP_MIN         0
#define VCS_DEF_PADDING_BOTTOM_MIN      0
#define VCS_DEF_PADDING_LEFT_MIN        0
#define VCS_DEF_PADDING_RIGHT_MIN       0
#define VCS_DEF_PADDING_TOP_MAX         5
#define VCS_DEF_PADDING_BOTTOM_MAX      5
#define VCS_DEF_PADDING_LEFT_MAX        5
#define VCS_DEF_PADDING_RIGHT_MAX       5



#define VCS_DEF_TEXT_WORD_SPACING_DEFAULT     1
#define VCS_DEF_TEXT_WORD_SPACING_MIN         1
#define VCS_DEF_TEXT_WORD_SPACING_MAX         1

#define VCS_DEF_TEXT_LETTER_SPACING_DEFAULT   1
#define VCS_DEF_TEXT_LETTER_SPACING_MIN       1
#define VCS_DEF_TEXT_LETTER_SPACING_MAX       1

#define VCS_DEF_TEXT_LINE_HEIGHT_DEFAULT      1
#define VCS_DEF_TEXT_LINE_HEIGHT_MIN          1
#define VCS_DEF_TEXT_LINE_HEIGHT_MAX          1

#define VCS_DEF_TEXT_SHADOW_COLOR_DEFAULT     1
#define VCS_DEF_TEXT_SHADOW_OFFSET_X_DEFAULT  1
#define VCS_DEF_TEXT_SHADOW_OFFSET_X_MIN      1
#define VCS_DEF_TEXT_SHADOW_OFFSET_X_MAX      1
#define VCS_DEF_TEXT_SHADOW_OFFSET_Y_DEFAULT  1
#define VCS_DEF_TEXT_SHADOW_OFFSET_Y_MIN      1
#define VCS_DEF_TEXT_SHADOW_OFFSET_Y_MAX      1
#define VCS_DEF_TEXT_SHADOW_BLUR_DEFAULT      1
#define VCS_DEF_TEXT_SHADOW_BLUR_MIN          1
#define VCS_DEF_TEXT_SHADOW_BLUR_MAX          1


#define VCS_SET_STRING(  key, name, category, subgroup, default_value                  ) VC_SETTING(##key, name, "text",    category, subgroup, default_value, 0,       1024,    list())
#define VCS_SET_NUMBER(  key, name, category, subgroup, default_value, min_val, max_val) VC_SETTING(##key, name, "number",  category, subgroup, default_value, min_val, max_val, list())
#define VCS_SET_COLOR(   key, name, category, subgroup, default_value                  ) VC_SETTING(##key, name, "color",   category, subgroup, default_value, 0,       0,       list())
#define VCS_SET_ANGLE(   key, name, category, subgroup, default_value                  ) VC_SETTING(##key, name, "angle",   category, subgroup, default_value, 0,       360,     list())
#define VCS_SET_BOOLEAN( key, name, category, subgroup, default_value                  ) VC_SETTING(##key, name, "boolean", category, subgroup, default_value, 0,       0,       list())
#define VCS_SET_CHOOSE(  key, name, category, subgroup, default_value, choices         ) VC_SETTING(##key, name, "choose",  category, subgroup, default_value, 0,       0,       choices)

#define VCS_SET_BORDER_CLUSTER(key, category) \
VC_SETTING(##key##_border_style,  "Border Style",  "choose", category, "Border", VCS_DEF_BORDER_STYLE,  0, 0,                         VCS_DEF_BORDER_STYLE_CHOICES);\
VC_SETTING(##key##_border_width,  "Border Width",  "number", category, "Border", VCS_DEF_BORDER_WIDTH,  0, VCS_DEF_BORDER_WIDTH_MAX,  list());\
VC_SETTING(##key##_border_radius, "Border Radius", "number", category, "Border", VCS_DEF_BORDER_RADIUS, 0, VCS_DEF_BORDER_RADIUS_MAX, list());\
VC_SETTING(##key##_border_color,  "Border Color",  "color",  category, "Border", VCS_DEF_BORDER_COLOR,  0, 0,                         list());

#define VCS_SET_BACKGROUND_CLUSTER(key, category) \
VC_SETTING(##key##_background_grad_use,       "Use Gradient?",            "boolean", category, "Gradient",         TRUE,                           0,                                0,                                list());\
VC_SETTING(##key##_background_grad_start,     "Gradient Start Color",     "color",   category, "Gradient",         VCS_DEF_BG_COLOR_1,             0,                                0,                                list());\
VC_SETTING(##key##_background_grad_end,       "Gradient End Color",       "color",   category, "Gradient",         VCS_DEF_BG_COLOR_2,             0,                                0,                                list());\
VC_SETTING(##key##_background_grad_angle,     "Gradient Angle",           "angle",   category, "Gradient",         VCS_DEF_BG_ANGLE,               0,                                360,                              list());\
VC_SETTING(##key##_background_color,          "Background Color",         "color",   category, "Background",       VCS_DEF_BG_COLOR_1,             0,                                0,                                list());\
VC_SETTING(##key##_background_opacity,        "Background Opacity",       "number",  category, "Background",       VCS_DEF_OPACITY,                VCS_DEF_OPACITY_MIN,              VCS_DEF_OPACITY_MAX,              list());\
VC_SETTING(##key##_background_image,          "Background Image Link",    "url",     category, "Background Image", "",                             0,                                1024,                             list());\
VC_SETTING(##key##_background_img_opacity,    "Background Image Opacity", "choose",  category, "Background Image", VCS_DEF_OPACITY,                VCS_DEF_OPACITY_MIN,              VCS_DEF_OPACITY_MAX,              list());\
VC_SETTING(##key##_background_padding_top,    "Padding Top",              "number",  category, "Padding",          VCS_DEF_PADDING_TOP_DEFAULT,    VCS_DEF_PADDING_TOP_MIN,          VCS_DEF_PADDING_TOP_MAX,          list());\
VC_SETTING(##key##_background_padding_bottom, "Padding Bottom",           "number",	category, "Padding",          VCS_DEF_PADDING_BOTTOM_DEFAULT, VCS_DEF_PADDING_BOTTOM_MIN,       VCS_DEF_PADDING_BOTTOM_MAX,       list());\
VC_SETTING(##key##_background_padding_left,   "Padding Left",             "number",	category, "Padding",          VCS_DEF_PADDING_LEFT_DEFAULT,   VCS_DEF_PADDING_LEFT_MIN,         VCS_DEF_PADDING_LEFT_MAX,         list());\
VC_SETTING(##key##_background_padding_right,  "Padding Right",            "number",	category, "Padding",          VCS_DEF_PADDING_RIGHT_DEFAULT,  VCS_DEF_PADDING_RIGHT_MIN,        VCS_DEF_PADDING_RIGHT_MAX,        list());

#define VCS_SET_TEXT_CLUSTER(key, category) \
VC_SETTING(##key##_text_font,             "Font",                   "choose",  category, "Appearance", VCS_DEF_FONT_DEFAULT,                 0,                                0,                                VCS_DEF_FONT_CHOICES);\
VC_SETTING(##key##_text_size,             "Font Size",              "number",  category, "Appearance", VCS_DEF_FONT_SIZE_DEFAULT,            VCS_DEF_FONT_SIZE_MIN,            VCS_DEF_FONT_SIZE_MAX,            list());\
VC_SETTING(##key##_text_color,            "Font Color",             "color",   category, "Appearance", VCS_DEF_FONT_COLOR_DEFAULT,           0,                                0,                                list());\
VC_SETTING(##key##_text_transform,        "Text Transform",         "choose",  category, "Appearance", VCS_DEF_TEXT_TRANSFORM_DEFAULT,       0,                                0,                                VCS_DEF_TEXT_TRANSFORM_CHOICES);\
VC_SETTING(##key##_text_decoration,       "Text Decoration",        "choose",  category, "Appearance", VCS_DEF_TEXT_DECORATION_DEFAULT,      0,                                0,                                VCS_DEF_TEXT_DECORATION_CHOICES);\
VC_SETTING(##key##_text_opacity,          "Text Opacity",           "number",  category, "Appearance", VCS_DEF_OPACITY,                      VCS_DEF_OPACITY_MIN,              VCS_DEF_OPACITY_MAX,              list());\
VC_SETTING(##key##_text_align,            "Text Alignment",         "choose",  category, "Formatting", VCS_DEF_TEXT_ALIGNMENT_DEFAULT,       0,                                0,                                VCS_DEF_TEXT_ALIGNMENT_CHOICES);\
VC_SETTING(##key##_text_word_spacing,     "Word Spacing",           "number",  category, "Formatting", VCS_DEF_TEXT_WORD_SPACING_DEFAULT,    VCS_DEF_TEXT_WORD_SPACING_MIN,    VCS_DEF_TEXT_WORD_SPACING_MAX,    list());\
VC_SETTING(##key##_text_letter_spacing,   "Letter Spacing",         "number",  category, "Formatting", VCS_DEF_TEXT_LETTER_SPACING_DEFAULT,  VCS_DEF_TEXT_LETTER_SPACING_MIN,  VCS_DEF_TEXT_LETTER_SPACING_MAX,  list());\
VC_SETTING(##key##_text_line_height,      "Line Height",            "number",  category, "Formatting", VCS_DEF_TEXT_LINE_HEIGHT_DEFAULT,     VCS_DEF_TEXT_LINE_HEIGHT_MIN,     VCS_DEF_TEXT_LINE_HEIGHT_MAX,     list());\
VC_SETTING(##key##_text_shadow_use,       "Use Text Shadow 1?",     "boolean", category, "Shadow #1",  FALSE,                                0,                                0,                                list());\
VC_SETTING(##key##_text_shadow_color,     "Text Shadow 1 Color",    "color",   category, "Shadow #1",  VCS_DEF_TEXT_SHADOW_COLOR_DEFAULT,    0,                                0,                                list());\
VC_SETTING(##key##_text_shadow_offset_x,  "Text Shadow 1 X Offset", "number",  category, "Shadow #1",  VCS_DEF_TEXT_SHADOW_OFFSET_X_DEFAULT, VCS_DEF_TEXT_SHADOW_OFFSET_X_MIN, VCS_DEF_TEXT_SHADOW_OFFSET_X_MAX, list());\
VC_SETTING(##key##_text_shadow_offset_y,  "Text Shadow 1 Y Offset", "number",  category, "Shadow #1",  VCS_DEF_TEXT_SHADOW_OFFSET_Y_DEFAULT, VCS_DEF_TEXT_SHADOW_OFFSET_Y_MIN, VCS_DEF_TEXT_SHADOW_OFFSET_Y_MAX, list());\
VC_SETTING(##key##_text_shadow_blur,      "Text Shadow 1 Blur",     "number",  category, "Shadow #1",  VCS_DEF_TEXT_SHADOW_BLUR_DEFAULT,     VCS_DEF_TEXT_SHADOW_BLUR_MIN,     VCS_DEF_TEXT_SHADOW_BLUR_MAX,     list());\
VC_SETTING(##key##_text_shadow_use2,      "Use Text Shadow 2?",     "boolean", category, "Shadow #2",  FALSE,                                0,                                0,                                list());\
VC_SETTING(##key##_text_shadow_color2,    "Text Shadow 2 Color",    "color",   category, "Shadow #2",  VCS_DEF_TEXT_SHADOW_COLOR_DEFAULT,    0,                                0,                                list());\
VC_SETTING(##key##_text_shadow_offset_x2, "Text Shadow 2 X Offset", "number",  category, "Shadow #2",  VCS_DEF_TEXT_SHADOW_OFFSET_X_DEFAULT, VCS_DEF_TEXT_SHADOW_OFFSET_X_MIN, VCS_DEF_TEXT_SHADOW_OFFSET_X_MAX, list());\
VC_SETTING(##key##_text_shadow_offset_y2, "Text Shadow 2 Y Offset", "number",  category, "Shadow #2",  VCS_DEF_TEXT_SHADOW_OFFSET_Y_DEFAULT, VCS_DEF_TEXT_SHADOW_OFFSET_Y_MIN, VCS_DEF_TEXT_SHADOW_OFFSET_Y_MAX, list());\
VC_SETTING(##key##_text_shadow_blur2,     "Text Shadow 2 Blur",     "number",  category, "Shadow #2",  VCS_DEF_TEXT_SHADOW_BLUR_DEFAULT,     VCS_DEF_TEXT_SHADOW_BLUR_MIN,     VCS_DEF_TEXT_SHADOW_BLUR_MAX,     list());\
VC_SETTING(##key##_text_padding_top,       "Padding Top",           "number",  category, "Padding",    VCS_DEF_PADDING_TOP_DEFAULT,          VCS_DEF_PADDING_TOP_MIN,          VCS_DEF_PADDING_TOP_MAX,          list());\
VC_SETTING(##key##_text_padding_bottom,    "Padding Bottom",        "number",	category, "Padding",    VCS_DEF_PADDING_BOTTOM_DEFAULT,       VCS_DEF_PADDING_BOTTOM_MIN,       VCS_DEF_PADDING_BOTTOM_MAX,       list());\
VC_SETTING(##key##_text_padding_left,      "Padding Left",          "number",	category, "Padding",    VCS_DEF_PADDING_LEFT_DEFAULT,         VCS_DEF_PADDING_LEFT_MIN,         VCS_DEF_PADDING_LEFT_MAX,         list());\
VC_SETTING(##key##_text_padding_right,     "Padding Right",         "number",	category, "Padding",    VCS_DEF_PADDING_RIGHT_DEFAULT,        VCS_DEF_PADDING_RIGHT_MIN,        VCS_DEF_PADDING_RIGHT_MAX,        list());
// you see, its complicated to make it seem more big brain developper than i really am

/// surprised, its a cluster
//the domain slector, and the write-in
#define VCS_SET_URL(key, name, category, subgroup)\
VC_SETTING_FULL(##key##_url_host, "URL Prefix", "url_choose", category, subgroup, "None!", 0, 0, list(), #key);\
VC_SETTING_FULL(##key##_url_filename, "URL Filenix", "url_file", category, subgroup, "", 0, 0, list(), #key);


/// heres some stuff                name,      kind    category,  subgroup,  default_value
VC_SETTING(preview_text,            "Preview", "text", "Preview", "Preview", "!!PREVIEWTEXT!!", 0, 99999, list())
/// outer box
VCS_SET_BORDER_CLUSTER(outer_box,     "Outer Box")
VCS_SET_BACKGROUND_CLUSTER(outer_box, "Outer Box")

/// profile picture box key, name, category, subgroup, default_value, choices
VCS_SET_URL(pfp_image_link,         "Profile Picture", "Picture", "Picture")
VCS_SET_CHOOSE(pfp_image_shape,     "Profile Picture", "Picture", "Picture Settings", VCS_DEF_IMG_SHAPE_DEFAULT,    VCS_DEF_IMG_SHAPE_CHOICES)
VCS_SET_CHOOSE(pfp_image_scaling,   "Profile Picture", "Picture", "Picture Settings", VCS_DEF_IMG_SCALING_DEFAULT,  VCS_DEF_IMG_SCALING_CHOICES)
VCS_SET_NUMBER(pfp_image_opacity,   "Profile Picture", "Picture", "Picture Settings", VCS_DEF_OPACITY,              VCS_DEF_OPACITY_MIN,       VCS_DEF_OPACITY_MAX)
VCS_SET_NUMBER(pfp_image_width,     "Profile Picture", "Picture", "Picture Settings", VCS_DEF_IMAGE_WIDTH_DEFAULT,  VCS_DEF_IMAGE_WIDTH_MIN,   VCS_DEF_IMAGE_WIDTH_MAX)
VCS_SET_NUMBER(pfp_image_height,    "Profile Picture", "Picture", "Picture Settings", VCS_DEF_IMAGE_HEIGHT_DEFAULT, VCS_DEF_IMAGE_HEIGHT_MIN,  VCS_DEF_IMAGE_HEIGHT_MAX)
VCS_SET_BACKGROUND_CLUSTER(pfp,     "Profile Picture")
VCS_SET_BORDER_CLUSTER(pfp,         "Profile Picture")
VCS_SET_BOOLEAN(pfp_show,           "Show Profile Picture?", "Profile Picture", "Profile Picture", TRUE)

/// name box
VCS_SET_BACKGROUND_CLUSTER(name,    "Name")
VCS_SET_BORDER_CLUSTER(name,        "Name")
VCS_SET_TEXT_CLUSTER(name,          "Name")
VCS_SET_BOOLEAN(name_show,          "Show Name Box?", "Name", "Name", TRUE)

/// message box
VCS_SET_BACKGROUND_CLUSTER(message, "Message")
VCS_SET_BORDER_CLUSTER(message,     "Message")
VCS_SET_TEXT_CLUSTER(message,       "Message")
VCS_SET_BOOLEAN(message_show,       "Show Message Box?", "Message", "Message", TRUE)





