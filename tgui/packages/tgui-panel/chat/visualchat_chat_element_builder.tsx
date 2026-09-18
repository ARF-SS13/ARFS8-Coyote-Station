/**
 * @file visualchat_chat_element_builder.tsx
 * @copyright 2026 Coyote ARFS (Fennicus hornificus)
 * @license You Break It You Bought It
 * @description Welcome to VisualChat, the gaudy thing that makes your chat
 * look like a silly anime visual novel! The way it works is that the backend
 * compiles a bunch of data about what was said, then this thing here turns that
 * into html clown vomit. its then directly injected into the chat message
 * payload in renderer.tsx. Enjoy!
 */
/** biome-ignore-all assist/source/organizeImports: eat me */

import { Box, Stack } from 'tgui-core/components';
import { resolveAsset } from 'tgui/assets';
import type {
  VCMessageData,
  VCSettingDataPack,
  VCSaymodeData,
} from './visualchat_types';
import { GetBgStyle, GetTextStyle } from './visualchat_utils';

const DEFAULT_PROFILE_PICTURE = resolveAsset(
  'https://files.catbox.moe/rblpt6.png',
);

// Sets the innerHTML of a chat message node (bscly a div) to a visual novel
// style chat message. Super customizable, for better or worse
// someday this'll have stuff like prefs to tone down the disco vomit nightmare!
export function VisualChatify(
  saymodeData: VCSaymodeData,
  settingsData: VCSettingDataPack,
  messageData: VCMessageData,
  // for external use
  previewify: boolean = false,
): React.ReactElement {
  const {
    body_text,
    used_verb,
    is_radio,
    displayed_name,
    radio_color,
    radio_freq_name,
    language_icon,
    ghost_link,
  } = messageData;

  const outerBoxStyle: React.CSSProperties = {
    // non-variable things (fills the width,fits the content, etc)
    // gonna just be one of these
    width: '100%',
    backgroundSize: 'cover',
    backgroundRepeat: 'no-repeat',
    backgroundPosition: 'center',
    // variable things (background color, border, etc)
    ...GetBgStyle({
      show: true, // outer box is always shown
      bgColor: settingsData.outer_box_background_color.value,
      bgGradAngle: settingsData.outer_box_background_grad_angle.value,
      bgGradEnd: settingsData.outer_box_background_grad_end.value,
      bgGradStart: settingsData.outer_box_background_grad_start.value,
      bgGradUse: settingsData.outer_box_background_grad_use.value,
      bgOpacity: settingsData.outer_box_background_opacity.value,
      bgPaddingBottom: settingsData.outer_box_background_padding_bottom.value,
      bgPaddingLeft: settingsData.outer_box_background_padding_left.value,
      bgPaddingRight: settingsData.outer_box_background_padding_right.value,
      bgPaddingTop: settingsData.outer_box_background_padding_top.value,
    }),
    borderColor: settingsData.outer_box_border_color.value,
    borderRadius: settingsData.outer_box_border_radius.value,
    borderStyle: settingsData.outer_box_border_style.value,
    borderWidth: settingsData.outer_box_border_width.value,
  };
  const pfpBoxStyle: React.CSSProperties = settingsData.pfp_show.value
    ? {
        ...GetBgStyle({
          show: settingsData.pfp_show.value,
          bgColor: settingsData.pfp_background_color.value,
          bgGradAngle: settingsData.pfp_background_grad_angle.value,
          bgGradEnd: settingsData.pfp_background_grad_end.value,
          bgGradStart: settingsData.pfp_background_grad_start.value,
          bgGradUse: settingsData.pfp_background_grad_use.value,
          bgOpacity: settingsData.pfp_background_opacity.value,
          bgPaddingBottom: settingsData.pfp_background_padding_bottom.value,
          bgPaddingLeft: settingsData.pfp_background_padding_left.value,
          bgPaddingRight: settingsData.pfp_background_padding_right.value,
          bgPaddingTop: settingsData.pfp_background_padding_top.value,
        }),
      }
    : {};
  const pfpImageStyle: React.CSSProperties = settingsData.pfp_show.value
    ? {
        width: settingsData.pfp_image_width.value,
        height: settingsData.pfp_image_height.value,
        opacity: settingsData.pfp_image_opacity.value,
        objectFit: settingsData.pfp_image_scaling.value as
          | 'cover'
          | 'contain'
          | 'fill'
          | 'none'
          | 'scale-down',
        borderRadius:
          settingsData.pfp_image_shape.value === 'circle' ? '50%' : '0%',
      }
    : {};
  const pfpImageElement = (
    <img
      src={DEFAULT_PROFILE_PICTURE}
      alt="A really cute furry profile picture!"
      style={pfpImageStyle}
    />
  );
  const nameStyle: React.CSSProperties = settingsData.name_show.value
    ? {
        ...GetBgStyle({
          show: settingsData.name_show.value,
          bgColor: settingsData.name_background_color.value,
          bgGradAngle: settingsData.name_background_grad_angle.value,
          bgGradEnd: settingsData.name_background_grad_end.value,
          bgGradStart: settingsData.name_background_grad_start.value,
          bgGradUse: settingsData.name_background_grad_use.value,
          bgOpacity: settingsData.name_background_opacity.value,
          bgPaddingBottom: settingsData.name_background_padding_bottom.value,
          bgPaddingLeft: settingsData.name_background_padding_left.value,
          bgPaddingRight: settingsData.name_background_padding_right.value,
          bgPaddingTop: settingsData.name_background_padding_top.value,
        }),
        borderColor: settingsData.name_border_color.value,
        borderRadius: settingsData.name_border_radius.value,
        borderStyle: settingsData.name_border_style.value,
        borderWidth: settingsData.name_border_width.value,
        ...GetTextStyle({
          align: settingsData.name_text_align.value,
          color: settingsData.name_text_color.value,
          decoration: settingsData.name_text_decoration.value,
          font: settingsData.name_text_font.value,
          letter_spacing: settingsData.name_text_letter_spacing.value,
          line_height: settingsData.name_text_line_height.value,
          opacity: settingsData.name_text_opacity.value,
          padding_bottom: settingsData.name_text_padding_bottom.value,
          padding_left: settingsData.name_text_padding_left.value,
          padding_right: settingsData.name_text_padding_right.value,
          padding_top: settingsData.name_text_padding_top.value,
          shadow_blur: settingsData.name_text_shadow_blur.value,
          shadow_blur2: settingsData.name_text_shadow_blur2.value,
          shadow_color: settingsData.name_text_shadow_color.value,
          shadow_color2: settingsData.name_text_shadow_color2.value,
          shadow_offset_x: settingsData.name_text_shadow_offset_x.value,
          shadow_offset_x2: settingsData.name_text_shadow_offset_x2.value,
          shadow_offset_y: settingsData.name_text_shadow_offset_y.value,
          shadow_offset_y2: settingsData.name_text_shadow_offset_y2.value,
          shadow_use: settingsData.name_text_shadow_use.value,
          shadow_use2: settingsData.name_text_shadow_use2.value,
          size: settingsData.name_text_size.value,
          transform: settingsData.name_text_transform.value,
          word_spacing: settingsData.name_text_word_spacing.value,
        }),
      }
    : {};
  // home stretch!
  const messageStyle: React.CSSProperties = settingsData.message_show.value
    ? {
        // stretch!
        ...GetTextStyle({
          align: settingsData.message_text_align.value,
          color: settingsData.message_text_color.value,
          decoration: settingsData.message_text_decoration.value,
          font: settingsData.message_text_font.value,
          letter_spacing: settingsData.message_text_letter_spacing.value,
          line_height: settingsData.message_text_line_height.value,
          opacity: settingsData.message_text_opacity.value,
          padding_bottom: settingsData.message_text_padding_bottom.value,
          padding_left: settingsData.message_text_padding_left.value,
          padding_right: settingsData.message_text_padding_right.value,
          padding_top: settingsData.message_text_padding_top.value,
          shadow_blur: settingsData.message_text_shadow_blur.value,
          shadow_blur2: settingsData.message_text_shadow_blur2.value,
          shadow_color: settingsData.message_text_shadow_color.value,
          shadow_color2: settingsData.message_text_shadow_color2.value,
          shadow_offset_x: settingsData.message_text_shadow_offset_x.value,
          shadow_offset_x2: settingsData.message_text_shadow_offset_x2.value,
          shadow_offset_y: settingsData.message_text_shadow_offset_y.value,
          shadow_offset_y2: settingsData.message_text_shadow_offset_y2.value,
          shadow_use: settingsData.message_text_shadow_use.value,
          shadow_use2: settingsData.message_text_shadow_use2.value,
          size: settingsData.message_text_size.value,
          transform: settingsData.message_text_transform.value,
          word_spacing: settingsData.message_text_word_spacing.value,
        }),
        ...GetBgStyle({
          show: settingsData.message_show.value,
          bgColor: settingsData.message_background_color.value,
          bgGradAngle: settingsData.message_background_grad_angle.value,
          bgGradEnd: settingsData.message_background_grad_end.value,
          bgGradStart: settingsData.message_background_grad_start.value,
          bgGradUse: settingsData.message_background_grad_use.value,
          bgOpacity: settingsData.message_background_opacity.value,
          bgPaddingBottom: settingsData.message_background_padding_bottom.value,
          bgPaddingLeft: settingsData.message_background_padding_left.value,
          bgPaddingRight: settingsData.message_background_padding_right.value,
          bgPaddingTop: settingsData.message_background_padding_top.value,
        }),
        borderColor: settingsData.message_border_color.value,
        borderRadius: settingsData.message_border_radius.value,
        borderStyle: settingsData.message_border_style.value,
        borderWidth: settingsData.message_border_width.value,
      }
    : {};
  // some last minute adjustments
  const radioBit = is_radio ? (
    <span style={{ color: radio_color }}>{radio_freq_name}</span>
  ) : null;
  const languageBit = language_icon ? <span>{language_icon}</span> : null;
  const ghostLinkBit = ghost_link ? <span>{ghost_link}</span> : null;
  const nameFull = (
    <>
      {radioBit}
      {languageBit}
      {ghostLinkBit}
      {displayed_name}
      {used_verb}
    </>
  );

  const theElement: React.ReactElement = (
    <Box style={outerBoxStyle}>
      <Stack fill>
        {/* Profile picture */}
        <Stack.Item style={pfpBoxStyle} shrink>
          {pfpImageElement}
        </Stack.Item>
        {/* Name and message */}
        <Stack.Item grow>
          <Stack fill vertical>
            <Stack.Item style={nameStyle}>{nameFull},</Stack.Item>
            <Stack.Item style={messageStyle} grow>
              <Box as="span" dangerouslySetInnerHTML={{ __html: body_text }} />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
  // however we need to return a string, so we gotta do some janky stuff to get the html out of the react element
  return theElement;
}

/*

    body_text,
    body_spans,
    used_verb,
    is_radio,
    is_emote,
    is_emote_quick,
    am_ghost,
    displayed_name,
    radio_color,
    radio_freq_name,
    language_icon,
    language_understood,
    ghost_link,
    body_span_class,
    body_span_color,
    msg_splice_timeout,
    msg_splice_last_saymode,

*/
