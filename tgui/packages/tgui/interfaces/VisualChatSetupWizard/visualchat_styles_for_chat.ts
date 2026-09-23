import type React from 'react';
import { VCDiff } from 'tgui-panel/chat/visualchat_types';
import { ModifyHSLA, ConvertToHSLA } from '../PreferencesMenu/CharacterPreferences/BackgroundsColorsAndStyle';
import { createLogger } from 'tgui/logging';

const logger = createLogger('chatRenderer');

/*
PP OU - #384148 NB OU - #092626 MMB OU - #284148
PP IN - #151515 NB IN- #151515 MBIN- #151515

PP OU - #3B414B NB OU - #092626 MB OU - #384148
PP IN - #DDDDDD NB IN #DDDDDD- MB IN - #DDDDDD // king DDDDDD drooling while eating
*/

export type VCStylePack = {
  Swag?: React.CSSProperties;
  OuterBorders?: React.CSSProperties;
  InnerBorders?: React.CSSProperties;
  PFPBorders?: React.CSSProperties;
  OuterBackground?: React.CSSProperties;
  InnerBackgrounds?: React.CSSProperties;
  PFPBackground?: React.CSSProperties;
  Text?: React.CSSProperties;
  PFPImageStyle?: React.CSSProperties;
};

export enum VCStylePackEnum {
  default = 'default',
  light = 'light',
  coolCurvy = 'coolCurvy',
}

// overwrites `base` with whatever properties `overrides` defines; anything
// `overrides` doesn't set just falls through to `base` unchanged
export function MergeStyle(
  base?: React.CSSProperties,
  overrides?: React.CSSProperties,
  diff?: VCDiff,
): React.CSSProperties {
  const merged: React.CSSProperties = {...base, ...overrides}
  // apply the hsl diffs to colors if diff is given
  if (diff) {
    const innerBGdiff = {h: diff.h * 5, s: diff.s * 0, v: diff.v * 0}
    const outerBGdiff = {h: diff.h * 20, s: diff.s * 10, v: diff.v * 5}
    const borderDiff = {h: diff.h * 3, s: diff.s * 1, v: diff.v * 1}
    for (const k in merged) {
      const v = merged[k];
      if (typeof v === 'string') {
        if (k.includes('outlineColor')) {
          let coolerdiff = borderDiff
          merged[k] = ModifyHSLA(v, coolerdiff.h, coolerdiff.s, coolerdiff.v, 0);
        }
        // gradient shifter!
        else if (k.includes('background')) {
          // first one goes up, second gets inverted values
          let diff = innerBGdiff;
          if(v.includes('radial')) diff = outerBGdiff;
          const parts = v.match(/hsl\([^)]+\)/g)
          if(parts) {
            for(let i=0;i<parts.length;i++){
              merged[k] = merged[k].replace(parts[i], ModifyHSLA(parts[i], diff.h, diff.s, diff.v, 0))
            }
          }
        }
      }
    }
  }
  return merged;
}

export const defaultVCStyle: VCStylePack = {
  Swag: {
    gap: '0px',
    wordBreak: 'break-word',
  },
  OuterBorders: {
    outlineColor: 'hsl(193, 29%, 22%)',
    outlineWidth: '1px',
    outlineStyle: 'solid',
    borderRadius: '4px',
    padding: '4px',
  },
  InnerBorders: {
    outlineColor: 'hsl(180, 62%, 9%)',
    outlineWidth: '1px',
    outlineStyle: 'solid',
    borderRadius: '2px',
    padding: '1px',
  },
  PFPBorders: {
    outlineColor: 'hsl(180, 62%, 9%)',
    outlineWidth: '1px',
    outlineStyle: 'solid',
    borderRadius: '1px',
    padding: '1px',
  },
  PFPBackground: {
    background: 'linear-gradient(0deg, hsl(193, 29%, 22%), hsl(180, 61%, 9%))',
    padding: '2px',
    alignItems: 'center',
    justifyContent: 'center',

    display: 'flex',
  },
  OuterBackground: {
    background: 'radial-gradient(0deg, hsl(206, 13%, 25%), hsl(180, 62%, 9%))',
    padding: '2px',
  },
  InnerBackgrounds: {
    background: 'linear-gradient(0deg, hsl(193, 29%, 22%), hsl(180, 62%, 9%))',
    padding: '2px',
  },
  Text: {},
  PFPImageStyle: {
    display: 'block',
    width: '120px',
    height: '120px',
    maxHeight: '100%',
    maxWidth: '100%',
    objectFit: 'contain',
    objectPosition: 'center',
  },
};

export const lightVCStyle: VCStylePack = {
  PFPBackground: {
    background: '#DDDDDD',
  },
  OuterBackground: {
    background: 'radial-gradient( #DDDDDD, #deeaf1)',
    padding: '2px',
  },
  InnerBackgrounds: {
    background: 'linear-gradient( #DDDDDD, #deeaf1)',
    padding: '2px',
  },
};

export const coolCurvy: VCStylePack = {
  OuterBorders: {
    outlineColor: 'hsl(240, 100%, 30%)',
    outlineWidth: '1px',
    outlineStyle: 'double',
    borderRadius: '4px',
  },
  InnerBorders: {
    outlineColor: 'hsl(240, 100%, 20%)',
    outlineWidth: '1px',
    outlineStyle: 'solid',
    borderRadius: '2px',
  },
  PFPBorders: {
    outlineColor: 'hsl(240, 100%, 20%)',
    outlineWidth: '1px',
    outlineStyle: 'solid',
    borderRadius: '1px',
  },
  OuterBackground: {
    background:
      'linear-gradient( to bottom right, hsla(196, 100%, 11%, 0.38), hsla(196, 100%, 7%, 0.44))',
    padding: '2px',
  },
  InnerBackgrounds: {
    background: 'linear-gradient( #284148, #092626)',
    padding: '2px',
  },
};

// preset lookup so callers only ever need VCStylePackEnum, not the individual
// *VCStyle consts above
const VC_STYLE_PACKS: Record<VCStylePackEnum, VCStylePack> = {
  [VCStylePackEnum.default]: defaultVCStyle,
  [VCStylePackEnum.light]: lightVCStyle,
  [VCStylePackEnum.coolCurvy]: coolCurvy,
};

// merges a whole preset onto the default pack, piece by piece, so a preset
// only has to specify the bits it wants to change
export function GetVCChatStylePack(stylepls: VCStylePackEnum, diff?: VCDiff): VCStylePack {
  const preset = VC_STYLE_PACKS[stylepls] ?? defaultVCStyle;
  const merged = {} as VCStylePack;
  for (const part of Object.keys(defaultVCStyle) as (keyof VCStylePack)[]) {
    merged[part] = MergeStyle(defaultVCStyle[part], preset[part], diff);
  }
  return merged;
}

// grabs just one already-merged piece (e.g. 'OuterBorders') of a preset -
// this is the one to reach for from other files, no other imports needed
export function GetVCChatStyle(
  stylepls: VCStylePackEnum,
  part: keyof VCStylePack,
): React.CSSProperties {
  return GetVCChatStylePack(stylepls)[part] ?? {};
}
