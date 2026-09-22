import type React from 'react';
import {
  type VCBgCluster,
  VCSDPEnum,
  type VCSettingDataPack,
  VCSettingRegion,
  type VCTextCluster,
} from 'tgui-panel/chat/visualchat_types';
import { ModifyHSLA } from '../PreferencesMenu/CharacterPreferences/BackgroundsColorsAndStyle';

const colorCache = new Map<string, string>();
const colorOpCache = new Map<ColorMap, ColorMapOperations[]>();

export enum ColorMap {
  InfoButton,

  WindowBackground,
  WindowBorder,
  WindowText,

  HeaderFooterBackground,
  HeaderFooterBorder,
  HeaderFooterText,

  MainContentBackground,
  MainContentBorder,
  MainContentText,

  PreviewTopBottomBackground,
  PreviewBorder,

  ButtonBackground,
  ButtonBorder,
  ButtonHover,
  ButtonSelected,
  ButtonText,
  ButtonTextSelected,

  FooterBackground,
  FooterBorder,
  FooterText,
}
/*
* Background / Main Panel: #2D221E (Dark Coffee Bean)
* Secondary Containers / Input Boxes: #42342E (Toasted Walnut)
* Primary Text: #F7EBE1 (Warm Milk Foam)
* Highlights & Active Selections: #D99B6C (Soft Chestnut / Autumn Orange)
* Muted Text / Secondary Labels: #A38F85 (Warm Ash)
* Secondary Containers / Card Sections: #332C2E (Muted Cocoa)
* Primary Text: #FAF5F0 (Off-White Fluff)
* Highlights & Chat Nameplates: #E0A3A5 (Dusty Rose / Soft Pink)
* Active Links / Interactive Buttons: #9DB4C0 (Muted Sky Blue)

*/
/* biome-ignore format: keep aligned object keys */
enum BaseColors {
  // control panel colors
  ChatBackground  = 'hsla(160,  0%, 13%, 0.999)',
  DarkCoffeeBean  = '#284148',
  MutedCocoa      = '#384148',
  ToastedWalnut   = '#092626',
  DeepWalnut      = '#284148',
  WarmAsh         = '#384148',
  SoftChestnut    = '#384148',
  DustyRose       = '#384148',
  MutedSkyBlue    = 'rgb(58, 94, 109)',
  WarmMilkFoam    = 'hsla(27,  58%, 93%, 0.999)',
  OffWhiteFluff   = 'rgb(19, 46, 58)',
}

/*
284148
092626
092626
151515
384148
284148
092626 */

export enum BorderMap {
  WindowBorderWidth = '2px',
  WindowBorderRadius = '4px',
}

export enum TextMap {}

enum ColorMapOperations {
  NoOp,
  Brighten,
  Brighten2,
  Brighten3,
  Darken,
  Darken2,
  Saturate,
  Desaturate,
  Desaturate2,
  Invert,
  Grayscale,
  Sepia,
  HueRotate,
  Transparify,
  Opaque,
}

function GetBaseColor(colorName: any): string {
  switch (colorName) {
    // Base color for main structural elements
    case ColorMap.WindowBackground:
    case ColorMap.HeaderFooterBackground:
    case ColorMap.PreviewTopBottomBackground:
    case ColorMap.FooterBackground:
      return BaseColors.DarkCoffeeBean;
    case ColorMap.MainContentBackground:
      return BaseColors.ChatBackground;
    case ColorMap.WindowBorder:
    case ColorMap.HeaderFooterBorder:
    case ColorMap.MainContentBorder:
    case ColorMap.PreviewBorder:
    case ColorMap.FooterBorder:
      return BaseColors.DeepWalnut;
    case ColorMap.InfoButton:
    case ColorMap.ButtonBackground:
      return BaseColors.OffWhiteFluff;
    case ColorMap.ButtonBorder:
      return BaseColors.MutedSkyBlue;
    case ColorMap.ButtonHover:
      return BaseColors.SoftChestnut;
    case ColorMap.ButtonSelected:
      return BaseColors.MutedSkyBlue;
    case ColorMap.ButtonText:
      return BaseColors.WarmMilkFoam;
    case ColorMap.ButtonTextSelected:
      return BaseColors.DarkCoffeeBean;
    case ColorMap.WindowText:
    case ColorMap.HeaderFooterText:
    case ColorMap.MainContentText:
    case ColorMap.FooterText:
      return BaseColors.WarmMilkFoam;
    default:
      return BaseColors.ChatBackground;
  }
}

const GetColorMapOperations = (colorName: any): ColorMapOperations[] => {
  const cached = colorOpCache.get(colorName);
  if (cached !== undefined) {
    return cached;
  }
  let operations: ColorMapOperations[];
  switch (colorName) {
    // Base color for main structural elements
    case ColorMap.WindowBackground:
      operations = [ColorMapOperations.NoOp];
      break;
    case ColorMap.HeaderFooterBackground:
    case ColorMap.FooterBackground:
    case ColorMap.MainContentBackground:
      operations = [ColorMapOperations.NoOp];
      break;
    // Base color for borders
    case ColorMap.WindowBorder:
    case ColorMap.HeaderFooterBorder:
    case ColorMap.FooterBorder:
    case ColorMap.MainContentBorder:
      operations = [ColorMapOperations.NoOp];
      break;
    case ColorMap.WindowText:
    case ColorMap.HeaderFooterText:
    case ColorMap.FooterText:
    case ColorMap.MainContentText:
      operations = [ColorMapOperations.NoOp];
      break;
    // and the rest
    case ColorMap.InfoButton:
      operations = [ColorMapOperations.NoOp];
      break;
    default:
      operations = [ColorMapOperations.NoOp];
      break;
  }
  colorOpCache.set(colorName, operations);
  return operations;
};

// styles to be output for the visual chat setup wizard
// key: VCStyleKeys, value: React.CSSProperties
export const VCStyle: Record<string, React.CSSProperties> = {
  Window: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
  MainButton: {
    // backgroundColor: GetColorFromMap(ColorMap.ButtonBackground),
    // color: GetColorFromMap(ColorMap.ButtonText),
    // border: `1px solid ${GetColorFromMap(ColorMap.ButtonBorder)}`,
    // borderRadius: '4px',
    // padding: '4px',
    // cursor: 'pointer',
  },
  MainButtonHover: {
    backgroundColor: GetColorFromMap(ColorMap.ButtonHover),
  },
  MainButtonActive: {
    backgroundColor: GetColorFromMap(ColorMap.ButtonSelected),
    color: GetColorFromMap(ColorMap.ButtonTextSelected),
  },
  Tooltip: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
    border: `1px solid ${GetColorFromMap(ColorMap.WindowBorder)}`,
    borderRadius: '4px',
    padding: '8px',
    boxShadow: '0 2px 10px rgba(0, 0, 0, 0.2)',
    backdropFilter: 'blur(5px)',
    color: 'white',
    maxWidth: '250px',
    pointerEvents: 'none',
    textAlign: 'left',
  },
  MainBlock: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
    border: `1px solid ${GetColorFromMap(ColorMap.WindowBorder)}`,
  },
  MainDropdown: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
  HelpButton: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
  MainContent: {
    backgroundColor: GetColorFromMap(ColorMap.MainContentBackground),
    border: `2px solid ${GetColorFromMap(ColorMap.WindowBorder)}`,
    borderRadius: '4px',
    boxSizing: 'border-box',
  },
  OverviewContainer: {
    backgroundColor: GetColorFromMap(ColorMap.MainContentBackground),
    border: `2px solid ${GetColorFromMap(ColorMap.WindowBorder)}`,
    borderRadius: '4px',
    boxSizing: 'border-box',
    margin: '4px',
  },
  OverviewTopBottom: {
    backgroundColor: GetColorFromMap(ColorMap.PreviewTopBottomBackground),
    textAlign: 'center',
  },
  OverviewMiddle: {
    backgroundColor: GetColorFromMap(ColorMap.MainContentBackground),
    padding: '4px',
  },

  Setting: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
  SettingsSection: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
  SaymodeTabsSection: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
  SaymodeTab: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
  SaymodeTabSelected: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
  RegionTab: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
  RegionTabSelected: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
  FooterSection: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
  RegionHoverOverlay: {
    position: 'absolute',
    inset: 0,
    backgroundColor: 'rgba(255, 255, 255, 0.15)',
    pointerEvents: 'none',
  } as React.CSSProperties,
  PreviewBox: {
    backgroundColor: GetColorFromMap(ColorMap.WindowBackground),
  },
};

export function GetColorFromMap(colorName: ColorMap): string {
  const baseColor = GetBaseColor(colorName);
  const operations: ColorMapOperations[] = GetColorMapOperations(colorName);

  const cached = colorCache.get(`${colorName}-${operations.join(',')}`);
  if (cached !== undefined) {
    return cached;
  }

  let modifiedColor = baseColor;

  for (const operation of operations) {
    switch (operation) {
      case ColorMapOperations.Brighten:
        modifiedColor = ModifyHSLA(modifiedColor, 0, 0, 10, 0);
        break;
      case ColorMapOperations.Brighten2:
        modifiedColor = ModifyHSLA(modifiedColor, 0, 0, 40, 0);
        break;
      case ColorMapOperations.Darken:
        modifiedColor = ModifyHSLA(modifiedColor, 0, 0, -10, 0);
        break;
      case ColorMapOperations.Darken2:
        modifiedColor = ModifyHSLA(modifiedColor, 0, 0, -20, 0);
        break;
      case ColorMapOperations.Saturate:
        modifiedColor = ModifyHSLA(modifiedColor, 0, 10, 0, 0);
        break;
      case ColorMapOperations.Desaturate:
        modifiedColor = ModifyHSLA(modifiedColor, 0, -10, 0, 0);
        break;
      case ColorMapOperations.Desaturate2:
        modifiedColor = ModifyHSLA(modifiedColor, 0, -40, 0, 0);
        break;
      case ColorMapOperations.Invert:
        modifiedColor = ModifyHSLA(modifiedColor, 180, 0, 0, 0);
        break;
      case ColorMapOperations.Grayscale:
        modifiedColor = ModifyHSLA(modifiedColor, 0, -100, 0, 0);
        break;
      case ColorMapOperations.Sepia:
        modifiedColor = ModifyHSLA(modifiedColor, 30, -20, 10, 0);
        break;
      case ColorMapOperations.HueRotate:
        modifiedColor = ModifyHSLA(modifiedColor, 90, 0, 0, 0);
        break;
      case ColorMapOperations.Transparify:
        modifiedColor = ModifyHSLA(modifiedColor, 0, 0, 0, -0.2);
        break;
      case ColorMapOperations.Opaque:
        modifiedColor = ModifyHSLA(modifiedColor, 0, 0, 0, 1.0);
        break;
      default:
        break;
    }
  }
  const cacheKey = `${colorName}-${operations.join(',')}`;
  colorCache.set(cacheKey, modifiedColor);
  return modifiedColor;
}

export function GetVCEBStyle(
  settingsData: VCSettingDataPack,
  region: VCSettingRegion,
): React.CSSProperties {
  // styles we all get
  const swag: React.CSSProperties = {
    position: 'relative',
    display: 'flex-inline',
    alignItems: 'stretch',
    justifyContent: 'stretch',
    gap: '0px',
  };
  switch (region) {
    case VCSettingRegion.OuterBox:
      return {
        ...swag,
        width: '100%',
        backgroundSize: 'cover',
        backgroundRepeat: 'no-repeat',
        backgroundPosition: 'center',
        // variable things (background color, border, etc)
        ...GetBgStyle({
          show: true, // outer box is always shown
          bgColor: settingsData[VCSDPEnum.outer_box_background_color].value,
          bgGradAngle:
            settingsData[VCSDPEnum.outer_box_background_grad_angle].value,
          bgGradEnd:
            settingsData[VCSDPEnum.outer_box_background_grad_end].value,
          bgGradStart:
            settingsData[VCSDPEnum.outer_box_background_grad_start].value,
          bgGradUse:
            settingsData[VCSDPEnum.outer_box_background_grad_use].value,
          bgOpacity: settingsData[VCSDPEnum.outer_box_background_opacity].value,
          bgPaddingBottom:
            settingsData[VCSDPEnum.outer_box_background_padding_bottom].value,
          bgPaddingLeft:
            settingsData[VCSDPEnum.outer_box_background_padding_left].value,
          bgPaddingRight:
            settingsData[VCSDPEnum.outer_box_background_padding_right].value,
          bgPaddingTop:
            settingsData[VCSDPEnum.outer_box_background_padding_top].value,
        }),
        outlineColor: settingsData[VCSDPEnum.outer_box_border_color].value,
        outlineRadius: settingsData[VCSDPEnum.outer_box_border_radius].value,
        outlineStyle: settingsData[VCSDPEnum.outer_box_border_style].value,
        outlineWidth: settingsData[VCSDPEnum.outer_box_border_width].value,
      } as React.CSSProperties;
    case VCSettingRegion.PFP:
      // Return the style for the profile picture
      return {
        ...swag,
        ...GetBgStyle({
          show: settingsData[VCSDPEnum.show_pfp].value,
          bgColor: settingsData[VCSDPEnum.pfp_background_color].value,
          bgGradAngle: settingsData[VCSDPEnum.pfp_background_grad_angle].value,
          bgGradEnd: settingsData[VCSDPEnum.pfp_background_grad_end].value,
          bgGradStart: settingsData[VCSDPEnum.pfp_background_grad_start].value,
          bgGradUse: settingsData[VCSDPEnum.pfp_background_grad_use].value,
          bgOpacity: settingsData[VCSDPEnum.pfp_background_opacity].value,
          bgPaddingBottom:
            settingsData[VCSDPEnum.pfp_background_padding_bottom].value,
          bgPaddingLeft:
            settingsData[VCSDPEnum.pfp_background_padding_left].value,
          bgPaddingRight:
            settingsData[VCSDPEnum.pfp_background_padding_right].value,
          bgPaddingTop:
            settingsData[VCSDPEnum.pfp_background_padding_top].value,
        }),
        outlineColor: settingsData[VCSDPEnum.pfp_border_color].value,
        outlineRadius: settingsData[VCSDPEnum.pfp_border_radius].value,
        outlineStyle: settingsData[VCSDPEnum.pfp_border_style].value,
        outlineWidth: settingsData[VCSDPEnum.pfp_border_width].value,
        opacity: settingsData[VCSDPEnum.pfp_image_opacity].value,
        alignSelf: 'flex-start',
        justifySelf: 'start',
        // width: `${settingsData[VCSDPEnum.pfp_image_width].value}px`,
        // height: `auto`,
        display: 'inline',
        objectFit: 'contain',
        textAlign: 'center',
        verticalAlign: 'middle',
      } as React.CSSProperties;
    case VCSettingRegion.Name:
      // Return the style for the message box
      return {
        ...swag,
        ...GetBgStyle({
          show: settingsData[VCSDPEnum.show_name]?.value,
          bgColor: settingsData[VCSDPEnum.name_background_color].value,
          bgGradAngle: settingsData[VCSDPEnum.name_background_grad_angle].value,
          bgGradEnd: settingsData[VCSDPEnum.name_background_grad_end].value,
          bgGradStart: settingsData[VCSDPEnum.name_background_grad_start].value,
          bgGradUse: settingsData[VCSDPEnum.name_background_grad_use].value,
          bgOpacity: settingsData[VCSDPEnum.name_background_opacity].value,
          bgPaddingBottom:
            settingsData[VCSDPEnum.name_background_padding_bottom].value,
          bgPaddingLeft:
            settingsData[VCSDPEnum.name_background_padding_left].value,
          bgPaddingRight:
            settingsData[VCSDPEnum.name_background_padding_right].value,
          bgPaddingTop:
            settingsData[VCSDPEnum.name_background_padding_top].value,
        }),
        outlineColor: settingsData[VCSDPEnum.name_border_color].value,
        outlineRadius: settingsData[VCSDPEnum.name_border_radius].value,
        outlineStyle: settingsData[VCSDPEnum.name_border_style].value,
        outlineWidth: settingsData[VCSDPEnum.name_border_width].value,
        ...GetTextStyle({
          align: settingsData[VCSDPEnum.name_text_align].value,
          color: settingsData[VCSDPEnum.name_text_color].value,
          decoration: settingsData[VCSDPEnum.name_text_decoration].value,
          font: settingsData[VCSDPEnum.name_text_font].value,
          letter_spacing:
            settingsData[VCSDPEnum.name_text_letter_spacing].value,
          line_height: settingsData[VCSDPEnum.name_text_line_height].value,
          opacity: settingsData[VCSDPEnum.name_text_opacity].value,
          padding_bottom:
            settingsData[VCSDPEnum.name_text_padding_bottom].value,
          padding_left: settingsData[VCSDPEnum.name_text_padding_left].value,
          padding_right: settingsData[VCSDPEnum.name_text_padding_right].value,
          padding_top: settingsData[VCSDPEnum.name_text_padding_top].value,
          shadow_blur: settingsData[VCSDPEnum.name_text_shadow_blur].value,
          shadow_blur2: settingsData[VCSDPEnum.name_text_shadow_blur2].value,
          shadow_color: settingsData[VCSDPEnum.name_text_shadow_color].value,
          shadow_color2: settingsData[VCSDPEnum.name_text_shadow_color2].value,
          shadow_offset_x:
            settingsData[VCSDPEnum.name_text_shadow_offset_x].value,
          shadow_offset_x2:
            settingsData[VCSDPEnum.name_text_shadow_offset_x2].value,
          shadow_offset_y:
            settingsData[VCSDPEnum.name_text_shadow_offset_y].value,
          shadow_offset_y2:
            settingsData[VCSDPEnum.name_text_shadow_offset_y2].value,
          shadow_use: settingsData[VCSDPEnum.name_text_shadow_use].value,
          shadow_use2: settingsData[VCSDPEnum.name_text_shadow_use2].value,
          size: settingsData[VCSDPEnum.name_text_size].value,
          transform: settingsData[VCSDPEnum.name_text_transform].value,
          word_spacing: settingsData[VCSDPEnum.name_text_word_spacing].value,
        }),
      } as React.CSSProperties;
    case VCSettingRegion.Message:
      // Return the style for the nameplate
      return {
        ...swag,
        ...GetTextStyle({
          align: settingsData[VCSDPEnum.message_text_align].value,
          color: settingsData[VCSDPEnum.message_text_color].value,
          decoration: settingsData[VCSDPEnum.message_text_decoration].value,
          font: settingsData[VCSDPEnum.message_text_font].value,
          letter_spacing:
            settingsData[VCSDPEnum.message_text_letter_spacing].value,
          line_height: settingsData[VCSDPEnum.message_text_line_height].value,
          opacity: settingsData[VCSDPEnum.message_text_opacity].value,
          padding_bottom:
            settingsData[VCSDPEnum.message_text_padding_bottom].value,
          padding_left: settingsData[VCSDPEnum.message_text_padding_left].value,
          padding_right:
            settingsData[VCSDPEnum.message_text_padding_right].value,
          padding_top: settingsData[VCSDPEnum.message_text_padding_top].value,
          shadow_blur: settingsData[VCSDPEnum.message_text_shadow_blur].value,
          shadow_blur2: settingsData[VCSDPEnum.message_text_shadow_blur2].value,
          shadow_color: settingsData[VCSDPEnum.message_text_shadow_color].value,
          shadow_color2:
            settingsData[VCSDPEnum.message_text_shadow_color2].value,
          shadow_offset_x:
            settingsData[VCSDPEnum.message_text_shadow_offset_x].value,
          shadow_offset_x2:
            settingsData[VCSDPEnum.message_text_shadow_offset_x2].value,
          shadow_offset_y:
            settingsData[VCSDPEnum.message_text_shadow_offset_y].value,
          shadow_offset_y2:
            settingsData[VCSDPEnum.message_text_shadow_offset_y2].value,
          shadow_use: settingsData[VCSDPEnum.message_text_shadow_use].value,
          shadow_use2: settingsData[VCSDPEnum.message_text_shadow_use2].value,
          size: settingsData[VCSDPEnum.message_text_size].value,
          transform: settingsData[VCSDPEnum.message_text_transform].value,
          word_spacing: settingsData[VCSDPEnum.message_text_word_spacing].value,
        }),
        ...GetBgStyle({
          show: settingsData[VCSDPEnum.show_message]?.value,
          bgColor: settingsData[VCSDPEnum.message_background_color].value,
          bgGradAngle:
            settingsData[VCSDPEnum.message_background_grad_angle].value,
          bgGradEnd: settingsData[VCSDPEnum.message_background_grad_end].value,
          bgGradStart:
            settingsData[VCSDPEnum.message_background_grad_start].value,
          bgGradUse: settingsData[VCSDPEnum.message_background_grad_use].value,
          bgOpacity: settingsData[VCSDPEnum.message_background_opacity].value,
          bgPaddingBottom:
            settingsData[VCSDPEnum.message_background_padding_bottom].value,
          bgPaddingLeft:
            settingsData[VCSDPEnum.message_background_padding_left].value,
          bgPaddingRight:
            settingsData[VCSDPEnum.message_background_padding_right].value,
          bgPaddingTop:
            settingsData[VCSDPEnum.message_background_padding_top].value,
        }),
        outlineColor: settingsData[VCSDPEnum.message_border_color].value,
        outlineRadius: settingsData[VCSDPEnum.message_border_radius].value,
        outlineStyle: settingsData[VCSDPEnum.message_border_style].value,
        outlineWidth: settingsData[VCSDPEnum.message_border_width].value,
      } as React.CSSProperties;
    default:
      return {} as React.CSSProperties;
  }
}

export function GetTextStyle(textData: VCTextCluster): React.CSSProperties {
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
    wordBreak: 'break-word',
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

export function GetBgStyle(bgData: VCBgCluster): React.CSSProperties {
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
  if (show === false) {
    return { display: 'none' };
  }
  // background color/gradient
  const bgGradient = bgGradUse
    ? `linear-gradient(${bgGradAngle}deg, ${bgGradStart}, ${bgGradEnd})`
    : bgColor || '#ff00ea';
  return {
    position: 'relative',
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

export function HorribleLaggyColorMangler(seed: number): string {
  const hexDigits = '0123456789ABCDEF#';
  const startcol = '#DABBEE';
  let numberwang = 0;
  for (let i = 0; i < startcol.length; i++) {
    for (let j = 0; j < hexDigits.length; j++) {
      numberwang += startcol.charCodeAt(i) * hexDigits.charCodeAt(j) ** seed;
    }
  }
  let numberwanger = 0;
  for (let i = 0; i < numberwang.toString().length; i++) {
    const next = i + 1 < numberwang.toString().length ? i + 1 : 0;
    numberwanger +=
      parseInt(numberwang.toString()[i], 10) +
      parseInt(numberwang.toString()[next], 10) * seed;
  }
  numberwang += numberwanger;
  for (let i = 0; i < numberwang.toString().length; i++) {
    numberwang += parseInt(numberwang.toString()[i], 10) * seed;
  }
  const piecedOut = numberwang.toString().split('');
  if (piecedOut.length % 6 !== 0) {
    let a = 0;
    while (piecedOut.length % 6 !== 0) {
      piecedOut.push(piecedOut[a]);
      a++;
    }
  }
  let finalColor = '#';
  for (let i = 0; i < 6; i += 1) {
    let iterations = piecedOut.length / 6;
    let numberval = 0;
    while (iterations > 0) {
      numberval += parseInt(piecedOut[i], 10);
      i += 6;
      iterations--;
    }
    finalColor += (numberval % 16).toString(16);
  }
  return finalColor;
}

/**
 * @returns {string} A background color based on the index.
 * @description uses an absolutely nonsense unreadable obfuscated hellscape of
 * functions and mathematical wizardry to determine the color.
 * somehow deterministic
 * @example
 * const bgColor = absoluteNonsense(0);
 */
function absoluteNonsense(index: number, total_items: number): string[] {
  // gonna turn this thing into two colors somehow
  const colorstart = '#0f33a1';
  const bindex = (index + 1) / total_items;
  // unpack into an enormous number
  let enormousNumber = 0;
  for (let i = 0; i < colorstart.length; i++) {
    for (let j = 0; j < colorstart.length; j++) {
      enormousNumber +=
        colorstart.charCodeAt(i) * colorstart.charCodeAt(j) * bindex;
    }
  }

  // we're not even close to done
  // swap numbers in the enormous number to add more chaos
  for (let i = 0; i < colorstart.length; i++) {
    for (let j = 0; j < colorstart.length; j++) {
      enormousNumber =
        (enormousNumber << 5) -
        enormousNumber +
        colorstart.charCodeAt(i) * colorstart.charCodeAt(j) * bindex;
    }
  }
  const hexlist = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  let hendex = 0;
  while (enormousNumber > 0) {
    if (hendex > 10) hendex = 0;
    const numbo = index ** hendex * 15;
    enormousNumber -= numbo;
    hexlist[hendex] = numbo % 16;
    hendex++;
  }
  return [
    `#${hexlist
      .slice(0, 6)
      .map((n) => n.toString(16))
      .join('')}`,
    `#${hexlist
      .slice(6, 12)
      .map((n) => n.toString(16))
      .join('')}`,
  ];
}
