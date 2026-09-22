// ------------------------------------------------------------------
// Wizard pack: the top-level backend -> tgui payload
// ------------------------------------------------------------------

export type VCWizardPack = {
  saymodes: Record<string, VCSaymodeData>;
  suppress_account: boolean;
  suppress_character: boolean;
  see_visualchat: boolean;
  see_visualchat_range: number;
  see_visualchat_range_max: number;
  see_visualchat_range_min: number;
  human_or_silicon: 'human' | 'silicon' | string;
  color_swatches: string[];
  clipboard: VCClipboardData;
  changed_time: number; // how bout you memo my butt
  valid_hosts: string[];
  valid_extensions: string[];
  user_name: string;
  user_ckey: string;
};

export type VCClipboardData = {
  haz: boolean;
  source_datakind: string;
  source_kind: string;
  source_slot: string;
  source_saymode: string;
  source_setting: string;
  source_value: string;
  source_setting_kind: string;
};

// ------------------------------------------------------------------
// Setting metadata: what kind a setting is, and where/how it groups
// ------------------------------------------------------------------

export enum VCSettingKind {
  Number = 'number',
  String = 'text',
  Color = 'color',
  Angle = 'angle',
  Boolean = 'boolean',
  Choice = 'choose',
  URLChoose = 'url_choose',
  URLFile = 'url_file',
}

export enum VCSettingRegion {
  Name,
  Message,
  PFP,
  OuterBox,
  Preview,
}

export enum VCSettingCluster {
  Background,
  Border,
  Text,
  Image,
  Show,
  Other,
}

export enum VCCopyMode {
  Setting = 'setting',
  Cluster = 'cluster',
  Saymode = 'saymode',
  Character = 'character',
}

export type VCSettingData = {
  path: string;
  name: string;
  key: string;
  value: any; // just trust me bro
  kind: VCSettingKind;
  min: number;
  max: number;
  choices: string[];
};

// ------------------------------------------------------------------
// Saymodes: the thing being previewed/configured
// ------------------------------------------------------------------

export enum VCSaymode {
  Say = 'saymode_say', // braixen brai!
  Whisper = 'saymode_whisper',
  Ask = 'saymode_ask',
  Exclaim = 'saymode_exclaim',
  Yell = 'saymode_yell',
  Sing = 'saymode_sing',
  Subtle = 'saymode_subtle',
  Emote = 'saymode_emote',
  EmoteQuick = 'saymode_emote_quick',
  Radio = 'saymode_radio',
  Succumb = 'saymode_succumb',
  Custom = 'saymode_custom',
}

export type VCSaymodeData = {
  example_verb: string;
  sayname: string;
  saymode_kind: VCSaymode;
  custom: boolean;
  invoke_token: string;
  settings: VCSettingDataPack;
  pfp_image_link: string;
  has_profile_pic_link: boolean;
  style_pack_name: string;
};

// ------------------------------------------------------------------
// Chat message payload, and the assembled/renderable result of it
// ------------------------------------------------------------------

export type VCMessageData = {
  name_displayed: string;
  displayed_saymode: string;
  body_text: string;
  compiled_message: string;
  am_ghost: boolean;
  ghost_link: string;
  msg_splice_timeout: number;
  msg_splice_last_saymode: string;
  use_settings: boolean; // if to use custom style settings... in a later build
  merge_name_too: boolean; // merge into oncoming traffic BEEP BEEP *ded*
};

export type VCDataPack = {
  saymode_data: VCSaymodeData;
  message_data: VCMessageData;
};

export type VCAssemblerHolder = {
  outerBoxStyle: React.CSSProperties;
  nameStyle: React.CSSProperties;
  messageStyle: React.CSSProperties;
  pfpBoxStyle: React.CSSProperties;
  pfpImageStyle: React.CSSProperties;
  pfpImageLink: string;
  saymode: VCSaymode;
  nameFull: string;
  body_text: string;
  compiled_message: string;
};

export enum VCTT {
  SwatchSnatch = 'swatch_snatch',
  SwatchApply = 'swatch_apply',

  SettingInfo = 'setting_info',
  SettingInfoString = 'setting_info_string',
  SettingInfoNumber = 'setting_info_number',
  SettingInfoBoolean = 'setting_info_boolean',
  SettingInfoChoice = 'setting_info_choice',
  SettingInfoColor = 'setting_info_color',
  SettingInfoAngle = 'setting_info_angle',
  SettingInfoUrlChoose = 'setting_info_url_choose',
  SettingInfoUrlFile = 'setting_info_url_file',

  CopySetting = 'copy_setting',
  CopyCluster = 'copy_cluster',
  CopySaymode = 'copy_saymode',
  CopyCharacter = 'copy_character',

  PasteSetting = 'paste_setting',
  PasteCluster = 'paste_cluster',
  PasteSaymode = 'paste_saymode',
  PasteCharacter = 'paste_character',

  HostButton = 'host_button',
  VCToggle = 'vc_toggle',
  VCToggleSend = 'vc_toggle_send',
  VCToggleSee = 'vc_toggle_see',
  VCRange = 'vc_range',
}

// ------------------------------------------------------------------
// Setting data pack: every configurable style knob, grouped by region
// (message_*, name_*, outer_box_*, pfp_*) plus the standalone preview text
// ------------------------------------------------------------------

export enum VCSDPEnum {
  message_background_color = 'message_background_color',
  message_background_grad_angle = 'message_background_grad_angle',
  message_background_grad_end = 'message_background_grad_end',
  message_background_grad_start = 'message_background_grad_start',
  message_background_grad_use = 'message_background_grad_use',
  // message_background_image = 'message_background_image',
  // message_background_img_opacity = 'message_background_img_opacity',
  message_background_opacity = 'message_background_opacity',
  message_background_padding_bottom = 'message_background_padding_bottom',
  message_background_padding_left = 'message_background_padding_left',
  message_background_padding_right = 'message_background_padding_right',
  message_background_padding_top = 'message_background_padding_top',
  message_border_color = 'message_border_color',
  message_border_radius = 'message_border_radius',
  message_border_style = 'message_border_style',
  message_border_width = 'message_border_width',
  show_message = 'show_message',
  message_text_align = 'message_text_align',
  message_text_color = 'message_text_color',
  message_text_decoration = 'message_text_decoration',
  message_text_font = 'message_text_font',
  message_text_letter_spacing = 'message_text_letter_spacing',
  message_text_line_height = 'message_text_line_height',
  message_text_opacity = 'message_text_opacity',
  message_text_padding_bottom = 'message_text_padding_bottom',
  message_text_padding_left = 'message_text_padding_left',
  message_text_padding_right = 'message_text_padding_right',
  message_text_padding_top = 'message_text_padding_top',
  message_text_shadow_blur = 'message_text_shadow_blur',
  message_text_shadow_blur2 = 'message_text_shadow_blur2',
  message_text_shadow_color = 'message_text_shadow_color',
  message_text_shadow_color2 = 'message_text_shadow_color2',
  message_text_shadow_offset_x = 'message_text_shadow_offset_x',
  message_text_shadow_offset_x2 = 'message_text_shadow_offset_x2',
  message_text_shadow_offset_y = 'message_text_shadow_offset_y',
  message_text_shadow_offset_y2 = 'message_text_shadow_offset_y2',
  message_text_shadow_use = 'message_text_shadow_use',
  message_text_shadow_use2 = 'message_text_shadow_use2',
  message_text_size = 'message_text_size',
  message_text_transform = 'message_text_transform',
  message_text_word_spacing = 'message_text_word_spacing',
  name_background_color = 'name_background_color',
  name_background_grad_angle = 'name_background_grad_angle',
  name_background_grad_end = 'name_background_grad_end',
  name_background_grad_start = 'name_background_grad_start',
  name_background_grad_use = 'name_background_grad_use',
  // name_background_image = 'name_background_image',
  // name_background_img_opacity = 'name_background_img_opacity',
  name_background_opacity = 'name_background_opacity',
  name_background_padding_bottom = 'name_background_padding_bottom',
  name_background_padding_left = 'name_background_padding_left',
  name_background_padding_right = 'name_background_padding_right',
  name_background_padding_top = 'name_background_padding_top',
  name_border_color = 'name_border_color',
  name_border_radius = 'name_border_radius',
  name_border_style = 'name_border_style',
  name_border_width = 'name_border_width',
  show_name = 'show_name',
  name_text_align = 'name_text_align',
  name_text_color = 'name_text_color',
  name_text_decoration = 'name_text_decoration',
  name_text_font = 'name_text_font',
  name_text_letter_spacing = 'name_text_letter_spacing',
  name_text_line_height = 'name_text_line_height',
  name_text_opacity = 'name_text_opacity',
  name_text_padding_bottom = 'name_text_padding_bottom',
  name_text_padding_left = 'name_text_padding_left',
  name_text_padding_right = 'name_text_padding_right',
  name_text_padding_top = 'name_text_padding_top',
  name_text_shadow_blur = 'name_text_shadow_blur',
  name_text_shadow_blur2 = 'name_text_shadow_blur2',
  name_text_shadow_color = 'name_text_shadow_color',
  name_text_shadow_color2 = 'name_text_shadow_color2',
  name_text_shadow_offset_x = 'name_text_shadow_offset_x',
  name_text_shadow_offset_x2 = 'name_text_shadow_offset_x2',
  name_text_shadow_offset_y = 'name_text_shadow_offset_y',
  name_text_shadow_offset_y2 = 'name_text_shadow_offset_y2',
  name_text_shadow_use = 'name_text_shadow_use',
  name_text_shadow_use2 = 'name_text_shadow_use2',
  name_text_size = 'name_text_size',
  name_text_transform = 'name_text_transform',
  name_text_word_spacing = 'name_text_word_spacing',
  outer_box_background_color = 'outer_box_background_color',
  outer_box_background_grad_angle = 'outer_box_background_grad_angle',
  outer_box_background_grad_end = 'outer_box_background_grad_end',
  outer_box_background_grad_start = 'outer_box_background_grad_start',
  outer_box_background_grad_use = 'outer_box_background_grad_use',
  // outer_box_background_image = 'outer_box_background_image',
  // outer_box_background_img_opacity = 'outer_box_background_img_opacity',
  outer_box_background_opacity = 'outer_box_background_opacity',
  outer_box_background_padding_bottom = 'outer_box_background_padding_bottom',
  outer_box_background_padding_left = 'outer_box_background_padding_left',
  outer_box_background_padding_right = 'outer_box_background_padding_right',
  outer_box_background_padding_top = 'outer_box_background_padding_top',
  outer_box_border_color = 'outer_box_border_color',
  outer_box_border_radius = 'outer_box_border_radius',
  outer_box_border_style = 'outer_box_border_style',
  outer_box_border_width = 'outer_box_border_width',
  pfp_background_color = 'pfp_background_color',
  pfp_background_grad_angle = 'pfp_background_grad_angle',
  pfp_background_grad_end = 'pfp_background_grad_end',
  pfp_background_grad_start = 'pfp_background_grad_start',
  pfp_background_grad_use = 'pfp_background_grad_use',
  pfp_background_opacity = 'pfp_background_opacity',
  pfp_background_padding_bottom = 'pfp_background_padding_bottom',
  pfp_background_padding_left = 'pfp_background_padding_left',
  pfp_background_padding_right = 'pfp_background_padding_right',
  pfp_background_padding_top = 'pfp_background_padding_top',
  pfp_border_color = 'pfp_border_color',
  pfp_border_radius = 'pfp_border_radius',
  pfp_border_style = 'pfp_border_style',
  pfp_border_width = 'pfp_border_width',
  pfp_image_height = 'pfp_image_height',
  pfp_image_link = 'pfp_image_link',
  pfp_image_link_url_filename = 'pfp_image_link_url_filename',
  pfp_image_link_url_host = 'pfp_image_link_url_host',
  pfp_image_opacity = 'pfp_image_opacity',
  pfp_image_scaling = 'pfp_image_scaling',
  pfp_image_shape = 'pfp_image_shape',
  pfp_image_width = 'pfp_image_width',
  show_pfp = 'show_pfp',
  preview_text = 'preview_text',
}

export type VCSettingDataPack = Record<VCSDPEnum, VCSettingData>;

// ------------------------------------------------------------------
// Style building blocks shared by GetBgStyle / GetTextStyle in
// visualchat_utils.tsx
// ------------------------------------------------------------------

export type VCBgCluster = {
  show: boolean;
  bgColor: string;
  bgGradAngle: number;
  bgGradEnd: string;
  bgGradStart: string;
  bgGradUse: boolean;
  bgOpacity: number;
  bgPaddingBottom: number;
  bgPaddingLeft: number;
  bgPaddingRight: number;
  bgPaddingTop: number;
};
export type VCTextCluster = {
  align: string;
  color: string;
  decoration: string;
  font: string;
  letter_spacing: number;
  line_height: number;
  opacity: number;
  padding_bottom: number;
  padding_left: number;
  padding_right: number;
  padding_top: number;
  shadow_blur: number;
  shadow_blur2: number;
  shadow_color: string;
  shadow_color2: string;
  shadow_offset_x: number;
  shadow_offset_x2: number;
  shadow_offset_y: number;
  shadow_offset_y2: number;
  shadow_use: boolean;
  shadow_use2: boolean;
  size: number;
  transform: string;
  word_spacing: number;
};
export type VCBorderCluster = {
  bColor: string;
  bRadius: number;
  bStyle: string;
  bWidth: number;
};

export enum VCChatStyleEnum {
  BorderColor,
  BorderRadius,
  BorderStyle,
  BorderWidth,
  BgColor1,
  BgColor2,
  BgGradAngle,
  BgOpacity,
  ElemPadding,
  TextColor,
  TextFont,
}
