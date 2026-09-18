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
};

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
}

export enum VCCopyMode {
  Setting = 'setting',
  Saymode = 'saymode',
  Character = 'character',
}

export type VCDataPack = {
  saymode_data: VCSaymodeData;
  message_data: VCMessageData;
};

export type VCSaymodeData = {
  example_verb: string;
  sayname: string;
  saymode_kind: string;
  custom: boolean;
  invoke_token: string;
  settings: VCSettingDataPack;
  profile_pic_link: string;
  has_profile_pic_link: boolean;
};

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

export type VCClipboardData = {
  valid_contents: string[];
  has_stuff: boolean;
};

export enum VCTT {
  CopySetting = 'copy_setting',
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
}

export type VCMessageData = {
  body_text: string;
  body_spans: string;
  used_verb: string;
  is_radio: boolean;
  is_emote: boolean;
  is_emote_quick: boolean;
  am_ghost: boolean;
  displayed_name: string;
  radio_color: string;
  radio_freq_name: string;
  language_icon: string;
  language_understood: boolean;
  ghost_link: string;
  body_span_class: string;
  body_span_color: string;
  msg_splice_timeout: number;
  msg_splice_last_saymode: string;
};

export enum VCSDPEnum {
  message_background_color = 'message_background_color',
  message_background_grad_angle = 'message_background_grad_angle',
  message_background_grad_end = 'message_background_grad_end',
  message_background_grad_start = 'message_background_grad_start',
  message_background_grad_use = 'message_background_grad_use',
  message_background_image = 'message_background_image',
  message_background_img_opacity = 'message_background_img_opacity',
  message_background_opacity = 'message_background_opacity',
  message_background_padding_bottom = 'message_background_padding_bottom',
  message_background_padding_left = 'message_background_padding_left',
  message_background_padding_right = 'message_background_padding_right',
  message_background_padding_top = 'message_background_padding_top',
  message_border_color = 'message_border_color',
  message_border_radius = 'message_border_radius',
  message_border_style = 'message_border_style',
  message_border_width = 'message_border_width',
  message_show = 'message_show',
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
  name_background_image = 'name_background_image',
  name_background_img_opacity = 'name_background_img_opacity',
  name_background_opacity = 'name_background_opacity',
  name_background_padding_bottom = 'name_background_padding_bottom',
  name_background_padding_left = 'name_background_padding_left',
  name_background_padding_right = 'name_background_padding_right',
  name_background_padding_top = 'name_background_padding_top',
  name_border_color = 'name_border_color',
  name_border_radius = 'name_border_radius',
  name_border_style = 'name_border_style',
  name_border_width = 'name_border_width',
  name_show = 'name_show',
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
  outer_box_background_image = 'outer_box_background_image',
  outer_box_background_img_opacity = 'outer_box_background_img_opacity',
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
  pfp_background_image = 'pfp_background_image',
  pfp_background_img_opacity = 'pfp_background_img_opacity',
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
  pfp_show = 'pfp_show',
  preview_text = 'preview_text',
}

export type VCSettingDataPack = {
  [VCSDPEnum.message_background_color]: VCSettingData;
  [VCSDPEnum.message_background_grad_angle]: VCSettingData;
  [VCSDPEnum.message_background_grad_end]: VCSettingData;
  [VCSDPEnum.message_background_grad_start]: VCSettingData;
  [VCSDPEnum.message_background_grad_use]: VCSettingData;
  [VCSDPEnum.message_background_image]: VCSettingData;
  [VCSDPEnum.message_background_img_opacity]: VCSettingData;
  [VCSDPEnum.message_background_opacity]: VCSettingData;
  [VCSDPEnum.message_background_padding_bottom]: VCSettingData;
  [VCSDPEnum.message_background_padding_left]: VCSettingData;
  [VCSDPEnum.message_background_padding_right]: VCSettingData;
  [VCSDPEnum.message_background_padding_top]: VCSettingData;
  [VCSDPEnum.message_border_color]: VCSettingData;
  [VCSDPEnum.message_border_radius]: VCSettingData;
  [VCSDPEnum.message_border_style]: VCSettingData;
  [VCSDPEnum.message_border_width]: VCSettingData;
  [VCSDPEnum.message_show]: VCSettingData;
  [VCSDPEnum.message_text_align]: VCSettingData;
  [VCSDPEnum.message_text_color]: VCSettingData;
  [VCSDPEnum.message_text_decoration]: VCSettingData;
  [VCSDPEnum.message_text_font]: VCSettingData;
  [VCSDPEnum.message_text_letter_spacing]: VCSettingData;
  [VCSDPEnum.message_text_line_height]: VCSettingData;
  [VCSDPEnum.message_text_opacity]: VCSettingData;
  [VCSDPEnum.message_text_padding_bottom]: VCSettingData;
  [VCSDPEnum.message_text_padding_left]: VCSettingData;
  [VCSDPEnum.message_text_padding_right]: VCSettingData;
  [VCSDPEnum.message_text_padding_top]: VCSettingData;
  [VCSDPEnum.message_text_shadow_blur]: VCSettingData;
  [VCSDPEnum.message_text_shadow_blur2]: VCSettingData;
  [VCSDPEnum.message_text_shadow_color]: VCSettingData;
  [VCSDPEnum.message_text_shadow_color2]: VCSettingData;
  [VCSDPEnum.message_text_shadow_offset_x]: VCSettingData;
  [VCSDPEnum.message_text_shadow_offset_x2]: VCSettingData;
  [VCSDPEnum.message_text_shadow_offset_y]: VCSettingData;
  [VCSDPEnum.message_text_shadow_offset_y2]: VCSettingData;
  [VCSDPEnum.message_text_shadow_use]: VCSettingData;
  [VCSDPEnum.message_text_shadow_use2]: VCSettingData;
  [VCSDPEnum.message_text_size]: VCSettingData;
  [VCSDPEnum.message_text_transform]: VCSettingData;
  [VCSDPEnum.message_text_word_spacing]: VCSettingData;

  [VCSDPEnum.name_background_color]: VCSettingData;
  [VCSDPEnum.name_background_grad_angle]: VCSettingData;
  [VCSDPEnum.name_background_grad_end]: VCSettingData;
  [VCSDPEnum.name_background_grad_start]: VCSettingData;
  [VCSDPEnum.name_background_grad_use]: VCSettingData;
  [VCSDPEnum.name_background_image]: VCSettingData;
  [VCSDPEnum.name_background_img_opacity]: VCSettingData;
  [VCSDPEnum.name_background_opacity]: VCSettingData;
  [VCSDPEnum.name_background_padding_bottom]: VCSettingData;
  [VCSDPEnum.name_background_padding_left]: VCSettingData;
  [VCSDPEnum.name_background_padding_right]: VCSettingData;
  [VCSDPEnum.name_background_padding_top]: VCSettingData;
  [VCSDPEnum.name_border_color]: VCSettingData;
  [VCSDPEnum.name_border_radius]: VCSettingData;
  [VCSDPEnum.name_border_style]: VCSettingData;
  [VCSDPEnum.name_border_width]: VCSettingData;
  [VCSDPEnum.name_show]: VCSettingData;
  [VCSDPEnum.name_text_align]: VCSettingData;
  [VCSDPEnum.name_text_color]: VCSettingData;
  [VCSDPEnum.name_text_decoration]: VCSettingData;
  [VCSDPEnum.name_text_font]: VCSettingData;
  [VCSDPEnum.name_text_letter_spacing]: VCSettingData;
  [VCSDPEnum.name_text_line_height]: VCSettingData;
  [VCSDPEnum.name_text_opacity]: VCSettingData;
  [VCSDPEnum.name_text_padding_bottom]: VCSettingData;
  [VCSDPEnum.name_text_padding_left]: VCSettingData;
  [VCSDPEnum.name_text_padding_right]: VCSettingData;
  [VCSDPEnum.name_text_padding_top]: VCSettingData;
  [VCSDPEnum.name_text_shadow_blur]: VCSettingData;
  [VCSDPEnum.name_text_shadow_blur2]: VCSettingData;
  [VCSDPEnum.name_text_shadow_color]: VCSettingData;
  [VCSDPEnum.name_text_shadow_color2]: VCSettingData;
  [VCSDPEnum.name_text_shadow_offset_x]: VCSettingData;
  [VCSDPEnum.name_text_shadow_offset_x2]: VCSettingData;
  [VCSDPEnum.name_text_shadow_offset_y]: VCSettingData;
  [VCSDPEnum.name_text_shadow_offset_y2]: VCSettingData;
  [VCSDPEnum.name_text_shadow_use]: VCSettingData;
  [VCSDPEnum.name_text_shadow_use2]: VCSettingData;
  [VCSDPEnum.name_text_size]: VCSettingData;
  [VCSDPEnum.name_text_transform]: VCSettingData;
  [VCSDPEnum.name_text_word_spacing]: VCSettingData;

  [VCSDPEnum.outer_box_background_color]: VCSettingData;
  [VCSDPEnum.outer_box_background_grad_angle]: VCSettingData;
  [VCSDPEnum.outer_box_background_grad_end]: VCSettingData;
  [VCSDPEnum.outer_box_background_grad_start]: VCSettingData;
  [VCSDPEnum.outer_box_background_grad_use]: VCSettingData;
  [VCSDPEnum.outer_box_background_image]: VCSettingData;
  [VCSDPEnum.outer_box_background_img_opacity]: VCSettingData;
  [VCSDPEnum.outer_box_background_opacity]: VCSettingData;
  [VCSDPEnum.outer_box_background_padding_bottom]: VCSettingData;
  [VCSDPEnum.outer_box_background_padding_left]: VCSettingData;
  [VCSDPEnum.outer_box_background_padding_right]: VCSettingData;
  [VCSDPEnum.outer_box_background_padding_top]: VCSettingData;
  [VCSDPEnum.outer_box_border_color]: VCSettingData;
  [VCSDPEnum.outer_box_border_radius]: VCSettingData;
  [VCSDPEnum.outer_box_border_style]: VCSettingData;
  [VCSDPEnum.outer_box_border_width]: VCSettingData;

  [VCSDPEnum.pfp_background_color]: VCSettingData;
  [VCSDPEnum.pfp_background_grad_angle]: VCSettingData;
  [VCSDPEnum.pfp_background_grad_end]: VCSettingData;
  [VCSDPEnum.pfp_background_grad_start]: VCSettingData;
  [VCSDPEnum.pfp_background_grad_use]: VCSettingData;
  [VCSDPEnum.pfp_background_image]: VCSettingData;
  [VCSDPEnum.pfp_background_img_opacity]: VCSettingData;
  [VCSDPEnum.pfp_background_opacity]: VCSettingData;
  [VCSDPEnum.pfp_background_padding_bottom]: VCSettingData;
  [VCSDPEnum.pfp_background_padding_left]: VCSettingData;
  [VCSDPEnum.pfp_background_padding_right]: VCSettingData;
  [VCSDPEnum.pfp_background_padding_top]: VCSettingData;
  [VCSDPEnum.pfp_border_color]: VCSettingData;
  [VCSDPEnum.pfp_border_radius]: VCSettingData;
  [VCSDPEnum.pfp_border_style]: VCSettingData;
  [VCSDPEnum.pfp_border_width]: VCSettingData;
  [VCSDPEnum.pfp_image_height]: VCSettingData;
  [VCSDPEnum.pfp_image_link]: VCSettingData;
  [VCSDPEnum.pfp_image_link_url_filename]: VCSettingData;
  [VCSDPEnum.pfp_image_link_url_host]: VCSettingData;
  [VCSDPEnum.pfp_image_opacity]: VCSettingData;
  [VCSDPEnum.pfp_image_scaling]: VCSettingData;
  [VCSDPEnum.pfp_image_shape]: VCSettingData;
  [VCSDPEnum.pfp_image_width]: VCSettingData;
  [VCSDPEnum.pfp_show]: VCSettingData;

  [VCSDPEnum.preview_text]: VCSettingData;
};

export type bgCluster = {
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
export type textCluster = {
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
export type borderCluster = {
  bColor: string;
  bRadius: number;
  bStyle: string;
  bWidth: number;
};
