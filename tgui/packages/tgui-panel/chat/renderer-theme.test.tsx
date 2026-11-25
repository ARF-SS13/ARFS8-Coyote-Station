import { describe, expect, it } from 'bun:test';
import { act, renderHook } from '@testing-library/react';
import { Provider } from 'jotai';
import { store } from '../events/store';
import {
  defaultSettings,
  settingsAtom,
  settingsLoadedAtom,
} from '../settings/atoms';
import { useSettings } from '../settings/use-settings';
import { chatRenderer } from './renderer';
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
  pfp_image_link: 'https://example.com/image.png',
  has_profile_pic_link: true,
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
  hide_pfp: false,
  differentiator: { h: 1, s: 2, v: 3 },
  uniqueish_id: 'test',
};

describe('VisualChat theme updates', () => {
  it('restyles existing messages across tabs without replacing their content', () => {
    const saved = {
      loaded: chatRenderer.loaded,
      rootNode: chatRenderer.rootNode,
      page: chatRenderer.page,
      messages: chatRenderer.messages,
      visibleMessages: chatRenderer.visibleMessages,
      scrollTracking: chatRenderer.scrollTracking,
      highlightParsers: chatRenderer.highlightParsers,
      settings: store.get(settingsAtom),
      settingsLoaded: store.get(settingsLoadedAtom),
    };
    const root = document.createElement('div');
    chatRenderer.loaded = true;
    chatRenderer.rootNode = root;
    chatRenderer.page = { acceptedTypes: { localchat: true } };
    chatRenderer.messages = [];
    chatRenderer.visibleMessages = [];
    chatRenderer.scrollTracking = false;
    chatRenderer.highlightParsers = null;
    store.set(settingsAtom, { ...defaultSettings, theme: 'dark' });
    store.set(settingsLoadedAtom, true);

    const hook = renderHook(() => useSettings(), {
      wrapper: ({ children }) => <Provider store={store}>{children}</Provider>,
    });

    try {
      chatRenderer.processBatch([
        {
          type: 'localchat',
          extraData: { saymode_data: saymodeData, message_data: messageData },
        },
        {
          type: 'radio',
          extraData: {
            saymode_data: {
              ...saymodeData,
              saymode_kind: VCSaymode.Radio,
              pfp_image_link: '',
            },
            message_data: { ...messageData, uniqueish_id: 'radio' },
          },
        },
        { type: 'localchat', text: 'Ordinary message' },
      ]);
      const [visible, hidden, ordinary] = chatRenderer.messages;
      const outer = visible.node.querySelector('.VisualChat__outer');
      const message = visible.node.querySelector('.VisualChat__message');
      const pfp = visible.node.querySelector('.VisualChat__pfp');
      const hiddenOuter = hidden.node.querySelector('.VisualChat__outer');
      const image = pfp.querySelector('img');
      const text = message.querySelector('#vcmsg');
      const marker = document.createElement('span');
      marker.className = 'Chat__highlight';
      text.appendChild(marker);
      const darkOuterStyle = outer.getAttribute('style');
      const darkMessageStyle = message.getAttribute('style');
      const darkPfpStyle = pfp.getAttribute('style');
      const darkHiddenStyle = hiddenOuter.getAttribute('style');
      const ordinaryHtml = ordinary.node.outerHTML;
      const customNode = document.createElement('div');
      customNode.innerHTML = '<div style="background: purple">Custom</div>';
      const customHtml = customNode.outerHTML;
      chatRenderer.messages.push({
        type: 'localchat',
        node: customNode,
        extraData: {
          saymode_data: saymodeData,
          message_data: { ...messageData, use_settings: true },
        },
      });
      // Visible history can outlive the smaller persisted-message limit.
      chatRenderer.messages = chatRenderer.messages.filter((m) => m !== visible);

      expect(root.contains(visible.node)).toBe(true);
      expect(root.contains(hidden.node)).toBe(false);
      act(() => hook.result.current.updateSettings({ theme: 'light' }));

      expect(outer.getAttribute('style')).toContain('#DDDDDD');
      expect(message.getAttribute('style')).toContain('#DDDDDD');
      expect(pfp.getAttribute('style')).toContain('#DDDDDD');
      expect(hiddenOuter.getAttribute('style')).toContain('#DDDDDD');
      expect(visible.node.querySelector('#vcmsg')).toBe(text);
      expect(text.contains(marker)).toBe(true);
      expect(pfp.querySelector('img')).toBe(image);
      expect(ordinary.node.outerHTML).toBe(ordinaryHtml);
      expect(customNode.outerHTML).toBe(customHtml);
      expect(chatRenderer.visibleMessages).toHaveLength(2);

      act(() => hook.result.current.updateSettings({ theme: 'dark' }));
      expect(outer.getAttribute('style')).toBe(darkOuterStyle);
      expect(message.getAttribute('style')).toBe(darkMessageStyle);
      expect(pfp.getAttribute('style')).toBe(darkPfpStyle);
      expect(hiddenOuter.getAttribute('style')).toBe(darkHiddenStyle);

      act(() => store.set(settingsAtom, { ...defaultSettings, theme: 'light' }));
      expect(outer.getAttribute('style')).toContain('#DDDDDD');
      chatRenderer.processBatch([
        {
          type: 'localchat',
          extraData: {
            saymode_data: saymodeData,
            message_data: { ...messageData, uniqueish_id: 'new' },
          },
        },
      ]);
      const newMessage = chatRenderer.messages[chatRenderer.messages.length - 1];
      expect(
        newMessage.node
          .querySelector('.VisualChat__outer')
          .getAttribute('style'),
      ).toContain('#DDDDDD');
    } finally {
      hook.unmount();
      chatRenderer.messages = [];
      store.set(settingsAtom, saved.settings);
      store.set(settingsLoadedAtom, saved.settingsLoaded);
      Object.assign(chatRenderer, {
        loaded: saved.loaded,
        rootNode: saved.rootNode,
        page: saved.page,
        messages: saved.messages,
        visibleMessages: saved.visibleMessages,
        scrollTracking: saved.scrollTracking,
        highlightParsers: saved.highlightParsers,
      });
    }
  });
});
