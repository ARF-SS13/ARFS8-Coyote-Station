import { describe, expect, it } from 'bun:test';
import {
  GetVCChatStylePack,
  VCStylePackEnum,
} from 'tgui/interfaces/VisualChatSetupWizard/visualchat_styles_for_chat';
import { VisualChatify } from './visualchat_chat_element_builder';
import {
  type VCMessageData,
  type VCSaymodeData,
  type VCSettingDataPack,
  VCSaymode,
} from './visualchat_types';

const saymodeData: VCSaymodeData = {
  example_verb: 'says',
  sayname: 'Say',
  saymode_kind: VCSaymode.Say,
  custom: false,
  invoke_token: '',
  settings: {} as VCSettingDataPack,
  pfp_image_link: '',
  has_profile_pic_link: false,
  style_pack_name: '',
};

const messageData: VCMessageData = {
  name_displayed: 'Test',
  displayed_saymode: 'says',
  body_text: 'Hello',
  compiled_message: 'Test says, Hello',
  am_ghost: false,
  ghost_link: '',
  msg_splice_timeout: 0,
  msg_splice_last_saymode: '',
  use_settings: false,
  merge_name_too: false,
  hide_pfp: true,
  differentiator: { h: 1, s: 2, v: 3 },
  uniqueish_id: 'test',
};

describe('VisualChatify theme', () => {
  it('uses the light style pack with the message differentiator', () => {
    const result = VisualChatify(saymodeData, messageData, 'light');
    const pack = GetVCChatStylePack(
      VCStylePackEnum.light,
      messageData.differentiator,
    );

    expect(result.outerBoxStyle.background).toBe(
      'radial-gradient( #DDDDDD, #deeaf1)',
    );
    expect(result.messageStyle.background).toBe(
      'linear-gradient( #DDDDDD, #deeaf1)',
    );
    expect(result.pfpBoxStyle.background).toBe(pack.PFPBackground?.background);
    expect(result.outerBoxStyle.outlineColor).toBe(
      pack.OuterBorders?.outlineColor,
    );
    expect(result.hidePfp).toBe(true);
  });

  it('uses the default style pack for dark and unspecified themes', () => {
    const pack = GetVCChatStylePack(
      VCStylePackEnum.default,
      messageData.differentiator,
    );
    for (const theme of ['dark', undefined]) {
      const result = VisualChatify(saymodeData, messageData, theme);
      expect(result.outerBoxStyle.background).toBe(
        pack.OuterBackground?.background,
      );
      expect(result.messageStyle.background).toBe(
        pack.InnerBackgrounds?.background,
      );
    }
  });
});
