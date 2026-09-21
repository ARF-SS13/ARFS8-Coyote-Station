import type React from 'react';

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
): React.CSSProperties {
  return { ...base, ...overrides };
}

export const defaultVCStyle: VCStylePack = {
  Swag: {
    gap: '0px',
    wordBreak: 'break-word',
  },
  OuterBorders: {
    outlineColor: '#284148',
    outlineWidth: '1px',
    outlineStyle: 'solid',
    borderRadius: '4px',
    padding: '4px',
  },
  InnerBorders: {
    outlineColor: '#092626',
    outlineWidth: '1px',
    outlineStyle: 'solid',
    borderRadius: '2px',
    padding: '1px',
  },
  PFPBorders: {
    outlineColor: '#092626',
    outlineWidth: '1px',
    outlineStyle: 'solid',
    borderRadius: '1px',
    padding: '1px',
  },
  PFPBackground: {
    background: '#151515',
    alignItems: 'center',
    justifyContent: 'center',
    display: 'flex',
  },
  OuterBackground: {
    background: 'radial-gradient( #384148, #092626)',
    padding: '2px',
  },
  InnerBackgrounds: {
    background: 'linear-gradient( #284148, #092626)',
    padding: '2px',
  },
  Text: {},
  PFPImageStyle: {
    height: '120px',
    width: '120px',
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
export function GetVCChatStylePack(stylepls: VCStylePackEnum): VCStylePack {
  const preset = VC_STYLE_PACKS[stylepls] ?? defaultVCStyle;
  const merged = {} as VCStylePack;
  for (const part of Object.keys(defaultVCStyle) as (keyof VCStylePack)[]) {
    merged[part] = MergeStyle(defaultVCStyle[part], preset[part]);
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
