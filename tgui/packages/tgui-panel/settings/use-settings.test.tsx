import { afterEach, describe, expect, it, spyOn } from 'bun:test';
import { act, renderHook } from '@testing-library/react';
import { storage } from 'common/storage';
import { Provider } from 'jotai';
import { store } from '../events/store';
import {
  defaultHighlights,
  defaultSettings,
  highlightsAtom,
  settingsAtom,
  settingsLoadedAtom,
} from './atoms';
import { useSettings } from './use-settings';

afterEach(() => {
  store.set(settingsAtom, defaultSettings);
  store.set(highlightsAtom, defaultHighlights);
  store.set(settingsLoadedAtom, false);
});

describe('useSettings', () => {
  it('waits for saved settings to be migrated before marking them loaded', async () => {
    let resolveSettings: (value: unknown) => void = () => {};
    const savedSettings = new Promise((resolve) => {
      resolveSettings = resolve;
    });
    const getSettings = spyOn(storage, 'get').mockReturnValue(savedSettings);
    const hook = renderHook(() => useSettings(), {
      wrapper: ({ children }) => <Provider store={store}>{children}</Provider>,
    });

    try {
      expect(store.get(settingsLoadedAtom)).toBe(false);
      await act(async () => {
        resolveSettings({
          ...defaultSettings,
          ...defaultHighlights,
          theme: 'dark',
        });
        await savedSettings;
      });

      expect(store.get(settingsAtom).theme).toBe('dark');
      expect(store.get(settingsLoadedAtom)).toBe(true);
    } finally {
      hook.unmount();
      getSettings.mockRestore();
    }
  });
});
