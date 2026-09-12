/*
 * @file
 * @copyright 2026 Coyote ARFS (Fennicus hornificus)
 * @license Free Use Vixen
 * @description Welcome to VisualChat, the gaudy thing that makes your chat
 * look like a silly anime visual novel! The way it works is that the backend
 * compiles a bunch of data about what was said, then this thing here turns that
 * into html clown vomit. its then directly injected into the chat message
 * payload in renderer.tsx. Enjoy!
 */
import type { SerializedMessage } from './model';
import type { VCDataPack } from './visualchat_types';
import { is_valid_vc_data } from './visualchat_utils';

// Sets the innerHTML of a chat message node (bscly a div) to a visual novel
// style chat message. Super customizable, for better or worse
// someday this'll have stuff like prefs to tone down the disco vomit nightmare!
export function VisualChatify(message: SerializedMessage) {
  if (!is_valid_vc_data(message.visualChatData as VCDataPack)) {
    return message.html || message.text || ''; // shoulnt happen
  }
  const vcData: VCDataPack = message.visualChatData as VCDataPack;
  const saymodeData = vcData.saymode_data;
  const {
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
  } = vcData.message_data;
}
