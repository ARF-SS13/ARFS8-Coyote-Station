/**
 * @file
 * @copyright 2026 Coyote ARFS (Fennicus hornificus)
 * @license Free Use Vixen
 * @description Utility functions for VisualChat, including validation checks
 * for visual chat data.
 */
import type { bgCluster, textCluster, VCDataPack } from './visualchat_types';

export function is_valid_vc_data(
  vcData: VCDataPack | null | undefined,
): vcData is VCDataPack {
  if (vcData === null || vcData === undefined) return false;
  if (!vcData) return false;
  if (!vcData.saymode_data) return false;
  if (!vcData.message_data) return false;
  return true;
}

export function AssembleImageUrl(host: string, filename: string): string {
  if (!host || !filename) {
    return '';
  }
  if (host.endsWith('/')) {
    host = host.slice(0, -1);
  }
  if (filename.startsWith('/')) {
    filename = filename.slice(1);
  }
  return `${host}/${filename}`;
}

export function GetTextStyle(textData: textCluster): React.CSSProperties {
  const {
    align,
    color,
    decoration,
    font,
    letter_spacing,
    line_height,
    opacity,
    padding_bottom,
    padding_left,
    padding_right,
    padding_top,
    shadow_blur,
    shadow_blur2,
    shadow_color,
    shadow_color2,
    shadow_offset_x,
    shadow_offset_x2,
    shadow_offset_y,
    shadow_offset_y2,
    shadow_use,
    shadow_use2,
    size,
    transform,
    word_spacing,
  } = textData;
  return {
    textAlign: align as 'left' | 'right' | 'center' | 'justify',
    color: color || '#ffffff',
    textDecoration: decoration as
      | 'none'
      | 'underline'
      | 'overline'
      | 'line-through',
    fontFamily: font || 'Arial, sans-serif',
    letterSpacing: letter_spacing || 0,
    lineHeight: line_height || 1.2,
    wordSpacing: word_spacing || 0,
    fontSize: size || 14,
    textTransform: transform as
      | 'none'
      | 'capitalize'
      | 'uppercase'
      | 'lowercase',
    opacity: opacity || 1,
    paddingBottom: padding_bottom || 0,
    paddingLeft: padding_left || 0,
    paddingRight: padding_right || 0,
    paddingTop: padding_top || 0,
    textShadow:
      (shadow_use
        ? `${shadow_offset_x}px ${shadow_offset_y}px ${shadow_blur}px ${shadow_color}`
        : '') +
      (shadow_use2
        ? `, ${shadow_offset_x2}px ${shadow_offset_y2}px ${shadow_blur2}px ${shadow_color2}`
        : ''),
  };
}

export function GetBgStyle(bgData: bgCluster): React.CSSProperties {
  const {
    show,
    bgColor,
    bgGradAngle,
    bgGradEnd,
    bgGradStart,
    bgGradUse,
    bgOpacity,
    bgPaddingBottom,
    bgPaddingLeft,
    bgPaddingRight,
    bgPaddingTop,
  } = bgData;
  if (!show) {
    return { display: 'none' };
  }
  // background color/gradient
  const bgGradient = bgGradUse
    ? `linear-gradient(${bgGradAngle}deg, ${bgGradStart}, ${bgGradEnd})`
    : bgColor || '#ff00ea';
  return {
    background: bgGradient,
    backgroundSize: 'cover',
    backgroundRepeat: 'no-repeat',
    backgroundPosition: 'center',
    paddingTop: bgPaddingTop,
    paddingBottom: bgPaddingBottom,
    paddingLeft: bgPaddingLeft,
    paddingRight: bgPaddingRight,
    opacity: bgOpacity,
  };
}
