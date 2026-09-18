import React from 'react';
import { ModifyHSLA } from '../PreferencesMenu/CharacterPreferences/BackgroundsColorsAndStyle';

export enum ColorMap {
  HeaderBackground,
  HeaderBorder,
  HeaderText,

  InfoButton,
  WindowBackground,
  WindowBorder,

  TopTabBackground,
  TopTabBorder,
  TopTabText,

  TopTabBackgroundSelected,
  TopTabBorderSelected,
  TopTabTextSelected,

  SaymodeTabBackground,
  SaymodeTabBorder,
  SaymodeTabText,

  SaymodeTabBackgroundSelected,
  SaymodeTabBorderSelected,
  SaymodeTabTextSelected,
}

/* biome-ignore format: keep aligned object keys */
enum BaseColors {
  RoyalPurple  = 'hsla(270, 100%,  20%, 1)',
  Midnight     = 'hsla(240, 100%,  20%, 1)',
  DarkTeal     = 'hsla(180, 100%,  20%, 1)',
  CoolTeal     = 'hsla(180, 100%,  50%, 1)',
  CutePale     = 'hsla(270, 100%,  80%, 1)',
  AdultGreen   = 'hsla(120, 100%,  20%, 1)',
  EarlyCyan    = 'hsla(180, 100%,  20%, 1)',
  TextOnDark   = 'hsla(  0,   0%, 100%, 1)',
  TextOnLight  = 'hsla(  0,   0%,   0%, 1)',
}

export enum BorderMap {
  WindowBorderWidth = '2px',
  WindowBorderRadius = '4px',
}

export enum FontMap {
  HeaderTopFontSize = '2rem',
  HeaderTopFontWeight = 'bold',

  HeaderBottomFontSize = '1.8rem',
  HeaderBottomFontWeight = 'normal',

  CounterFontSize = '2rem',
  CounterFontWeight = 'bold',

  PageSelectorFontSize = '1rem',
  PageSelectorFontWeight = 'normal',

  TabFontSize = '1rem',
  TabFontWeight = 'bold',

  CardTitleFontSize = '1.2rem',
  CardTitleFontWeight = 'bold',

  CardTextFontSize = '1rem',
  CardTextFontWeight = 'normal',

  CardEarlyButtonFontSize = '1.2rem',
  CardEarlyButtonFontWeight = 'bold',

  CardAdultButtonFontSize = '1.2rem',
  CardAdultButtonFontWeight = 'bold',
}

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

function GetBaseColor(colorName: ColorMap): string {
  // switch (colorName) {
  //   case ColorMap.InfoButton:
  //     return BaseColors.Midnight;
  //   case ColorMap.CounterBackground:
  //   case ColorMap.CounterBorder:
  //   case ColorMap.CounterText:
  //   case ColorMap.CounterNeedMoreBackground:
  //   case ColorMap.CounterNeedMoreBorder:
  //   case ColorMap.CounterNeedMoreText:
  //   case ColorMap.CounterAtMaxBackground:
  //   case ColorMap.CounterAtMaxBorder:
  //   case ColorMap.CounterAtMaxText:
  //     return BaseColors.Midnight;
  //   // Purple!
  //   case ColorMap.WindowBorder:
  //   case ColorMap.HeaderBorder:
  //   case ColorMap.CardBorder:
  //   case ColorMap.CardSelectedBorder:
  //   case ColorMap.TabBorder:
  //   case ColorMap.TabSelectedBorder:
  //     return BaseColors.Midnight;
  //   // Midnight!
  //   case ColorMap.WindowBackground:
  //   case ColorMap.HeaderBackground:
  //   case ColorMap.HeaderText:
  //   case ColorMap.CardBackground:
  //   case ColorMap.CardText:
  //   case ColorMap.CardSelectedBackground:
  //   case ColorMap.CardSelectedText:
  //   case ColorMap.TabBackground:
  //   case ColorMap.TabText:
  //   case ColorMap.TabSelectedBackground:
  //   case ColorMap.TabSelectedText:
  //     return BaseColors.Midnight;
  //   // Adult Green!
  //   case ColorMap.CardAdultButtonBackground:
  //   case ColorMap.CardAdultButtonBorder:
  //   case ColorMap.CardAdultButtonText:
  //   case ColorMap.CardAdultButtonSelectedBackground:
  //   case ColorMap.CardAdultButtonSelectedBorder:
  //   case ColorMap.CardAdultButtonSelectedText:
  //   case ColorMap.CardAdultButtonDisabledBackground:
  //   case ColorMap.CardAdultButtonDisabledBorder:
  //   case ColorMap.CardAdultButtonDisabledText:
  //     return BaseColors.AdultGreen;
  //   // Early Cyan!
  //   case ColorMap.CardEarlyButtonBackground:
  //   case ColorMap.CardEarlyButtonBorder:
  //   case ColorMap.CardEarlyButtonText:
  //   case ColorMap.CardEarlyButtonSelectedBackground:
  //   case ColorMap.CardEarlyButtonSelectedBorder:
  //   case ColorMap.CardEarlyButtonSelectedText:
  //   case ColorMap.CardEarlyButtonDisabledBackground:
  //   case ColorMap.CardEarlyButtonDisabledBorder:
  //   case ColorMap.CardEarlyButtonDisabledText:
  //     return BaseColors.EarlyCyan;
  // default:
  //   return BaseColors.RoyalPurple;
  // }
}

const GetColorMapOperations = (colorName: ColorMap): ColorMapOperations[] => {
  // switch (colorName) {
  //   // Info Button
  //   case ColorMap.InfoButton:
  //     return [ColorMapOperations.Brighten2, ColorMapOperations.Saturate];
  //   // Counters
  //   case ColorMap.CounterBackground:
  //     return [ColorMapOperations.Darken, ColorMapOperations.Desaturate];
  //   case ColorMap.CounterNeedMoreBackground:
  //     return [ColorMapOperations.Invert, ColorMapOperations.Transparify];
  //   case ColorMap.CounterAtMaxBackground:
  //     return [ColorMapOperations.Saturate];
  //   case ColorMap.CounterBorder:
  //   case ColorMap.CounterNeedMoreBorder:
  //   case ColorMap.CounterAtMaxBorder:
  //     return [
  //       ...GetColorMapOperations(ColorMap.CounterBackground),
  //       ColorMapOperations.Brighten2,
  //       ColorMapOperations.Saturate,
  //       ColorMapOperations.Transparify,
  //     ];
  //   // Base Backgrounds
  //   case ColorMap.WindowBackground:
  //     return [ColorMapOperations.Darken2, ColorMapOperations.Desaturate];
  //   // selecteds?
  //   case ColorMap.CardSelectedBackground:
  //   case ColorMap.TabSelectedBackground:
  //     return [
  //       ColorMapOperations.Brighten,
  //       ColorMapOperations.Desaturate,
  //       ColorMapOperations.Desaturate,
  //       ColorMapOperations.Desaturate,
  //       ColorMapOperations.Transparify,
  //     ];
  //   // Borders
  //   case ColorMap.WindowBorder:
  //   case ColorMap.HeaderBorder:
  //   case ColorMap.CardBorder:
  //   case ColorMap.TabBorder:
  //     return [
  //       ...GetColorMapOperations(ColorMap.CardBackground),
  //       ColorMapOperations.Brighten2,
  //       ColorMapOperations.Saturate,
  //       ColorMapOperations.Transparify,
  //     ];
  //   case ColorMap.CardBackground:
  //   case ColorMap.TabBackground:
  //   case ColorMap.HeaderBackground:
  //     return [ColorMapOperations.Desaturate2, ColorMapOperations.Transparify];
  //   case ColorMap.CardSelectedBorder:
  //   case ColorMap.TabSelectedBorder:
  //     return [
  //       ...GetColorMapOperations(ColorMap.CardSelectedBackground),
  //       ColorMapOperations.Brighten2,
  //       ColorMapOperations.Saturate,
  //       ColorMapOperations.Transparify,
  //     ];
  //   // texts
  //   case ColorMap.CounterText:
  //   case ColorMap.CounterNeedMoreText:
  //   case ColorMap.CounterAtMaxText:
  //   case ColorMap.HeaderText:
  //   case ColorMap.CardText:
  //   case ColorMap.CardSelectedText:
  //   case ColorMap.TabText:
  //   case ColorMap.TabSelectedText:
  //   case ColorMap.CardAdultButtonText:
  //   case ColorMap.CardAdultButtonSelectedText:
  //   case ColorMap.CardAdultButtonDisabledText:
  //   case ColorMap.CardEarlyButtonText:
  //   case ColorMap.CardEarlyButtonSelectedText:
  //   case ColorMap.CardEarlyButtonDisabledText:
  //     return [
  //       ColorMapOperations.Brighten2,
  //       ColorMapOperations.Brighten2,
  //       ColorMapOperations.Darken,
  //       ColorMapOperations.Desaturate,
  //       ColorMapOperations.Opaque,
  //     ];
  //   // adult/early buttons
  //   case ColorMap.CardAdultButtonBackground:
  //   case ColorMap.CardEarlyButtonBackground:
  //     return [ColorMapOperations.Darken, ColorMapOperations.Desaturate];
  //   case ColorMap.CardAdultButtonBorder:
  //   case ColorMap.CardEarlyButtonBorder:
  //     return [
  //       ColorMapOperations.Brighten,
  //       ColorMapOperations.Desaturate,
  //       ColorMapOperations.Transparify,
  //     ];
  //   case ColorMap.CardAdultButtonSelectedBackground:
  //   case ColorMap.CardEarlyButtonSelectedBackground:
  //     return [
  //       ColorMapOperations.Saturate,
  //       ColorMapOperations.Saturate,
  //       ColorMapOperations.Brighten,
  //       ColorMapOperations.Transparify,
  //     ];
  //   case ColorMap.CardAdultButtonSelectedBorder:
  //   case ColorMap.CardEarlyButtonSelectedBorder:
  //     return [
  //       ColorMapOperations.Brighten2,
  //       ColorMapOperations.Saturate,
  //       ColorMapOperations.Opaque,
  //     ];
  //   case ColorMap.CardAdultButtonDisabledBackground:
  //   case ColorMap.CardEarlyButtonDisabledBackground:
  //     return [ColorMapOperations.Darken, ColorMapOperations.Desaturate2];
  //   default:
  //     return [ColorMapOperations.NoOp];
  // }
};

// takes a base colormap value, modifies it based on
export function GetColorFromMap(colorName: ColorMap): string {
  const baseColor = GetBaseColor(colorName);
  const operations = GetColorMapOperations(colorName);

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

  return modifiedColor;
}

export enum VCStyleKeys {
  Window,
  HeaderContainer,
  HeaderDropdown,
  HeaderTab,
  HeaderHelp,
  MainContent,
  OverviewContent,
  OverviewItem,
  Setting,
}

// styles to be output for the visual chat setup wizard
// key: VCStyleKeys, value: React.CSSProperties
export const VCStyle = {
  [VCStyleKeys.Window]: {
    backgroundColor: GetColorFromMap(ColorMap.CardBackground),
  },
  [VCStyleKeys.HeaderContainer]: {
    backgroundColor: GetColorFromMap(ColorMap.CardBackground),
  },
  [VCStyleKeys.HeaderDropdown]: {
    backgroundColor: GetColorFromMap(ColorMap.CardBackground),
  },
  [VCStyleKeys.HeaderTab]: {
    backgroundColor: GetColorFromMap(ColorMap.CardBackground),
  },
  [VCStyleKeys.HeaderHelp]: {
    backgroundColor: GetColorFromMap(ColorMap.CardBackground),
  },
  [VCStyleKeys.MainContent]: {
    backgroundColor: GetColorFromMap(ColorMap.CardBackground),
  },
  [VCStyleKeys.OverviewContent]: {
    backgroundColor: GetColorFromMap(ColorMap.CardBackground),
  },
  [VCStyleKeys.OverviewItem]: {
    backgroundColor: GetColorFromMap(ColorMap.CardBackground),
  },
  [VCStyleKeys.Setting]: {
    backgroundColor: GetColorFromMap(ColorMap.CardBackground),
  },
};
