const cachedModdedColors: Record<string, string> = {};

function ModifyHSLA(
  hsla: string,
  hDelta: number,
  sDelta: number,
  lDelta: number,
  aDelta: number,
): string {
  //check if the args stringed together are in CachedModdedColors, if so return that value
  const cacheKey = `${hsla}_${hDelta}_${sDelta}_${lDelta}_${aDelta}`;
  const cachedColor = cachedModdedColors[cacheKey];
  if (cachedColor) {
    return cachedColor;
  }
  // convert any incompatible formats to hsla, then modify the values and return the new color
  hsla = ConvertToHSLA(hsla);

  const regex = /hsla\((\d+),\s*(\d+)%,\s*(\d+)%,\s*([\d.]+)\)/;
  const match = hsla.match(regex);

  if (!match) {
    throw new Error('Invalid HSLA color format');
  }

  let [_, h, s, l, a] = match;
  h = `${(parseInt(h, 10) + hDelta) % 360}`;
  s = `${Math.min(Math.max(parseInt(s, 10) + sDelta, 0), 100)}`;
  l = `${Math.min(Math.max(parseInt(l, 10) + lDelta, 0), 100)}`;
  a = `${Math.min(Math.max(parseFloat(a) + aDelta, 0), 1)}`;

  const modifiedColor = `hsla(${h}, ${s}%, ${l}%, ${a})`;
  cachedModdedColors[cacheKey] = modifiedColor;
  return modifiedColor;
}

function ConvertToHSLA(color: string): string {
  // regex
  const hslaRegex = /^hsla\(\d+,\s*\d+%,\s*\d+%,\s*[\d.]+\)$/;
  if (hslaRegex.test(color)) {
    return color;
  }
  // is it HSL format? (3 ,)
  const hslRegex = /^hsl\(\d+,\s*\d+%,\s*\d+%\)$/;
  if (hslRegex.test(color)) {
    return color.replace('hsl', 'hsla').replace(')', ', 1)');
  }
  // is it RGB format? (3 ,)
  const rgbRegex = /^rgb\(\d+,\s*\d+,\s*\d+\)$/;
  if (rgbRegex.test(color)) {
    const rgbValues = color
      .replace('rgb(', '')
      .replace(')', '')
      .split(',')
      .map((v) => parseInt(v.trim(), 10));
    const [r, g, b] = rgbValues;
    const a = 1; // default alpha value
    return RGBAToHSLA(r, g, b, a);
  }
  // is it RGBA format? (4 ,)
  const rgbaRegex = /^rgba\(\d+,\s*\d+,\s*\d+,\s*[\d.]+\)$/;
  if (rgbaRegex.test(color)) {
    const rgbaValues = color
      .replace('rgba(', '')
      .replace(')', '')
      .split(',')
      .map((v) => parseFloat(v.trim()));
    const [r, g, b, a] = rgbaValues;
    return RGBAToHSLA(r, g, b, a);
  }
  // is it hex format? (#)
  const hexRegex = /^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/;
  if (hexRegex.test(color)) {
    const hex = color.slice(1);
    let r,
      g,
      b,
      a = 1; // default alpha value
    switch (hex.length) {
      case 3:
        r = parseInt(hex[0] + hex[0], 16);
        g = parseInt(hex[1] + hex[1], 16);
        b = parseInt(hex[2] + hex[2], 16);
        break;
      case 6:
        r = parseInt(hex.slice(0, 2), 16);
        g = parseInt(hex.slice(2, 4), 16);
        b = parseInt(hex.slice(4, 6), 16);
        break;
      case 8:
        r = parseInt(hex.slice(0, 2), 16);
        g = parseInt(hex.slice(2, 4), 16);
        b = parseInt(hex.slice(4, 6), 16);
        a = parseInt(hex.slice(6, 8), 16) / 255;
        break;
      default:
        throw new Error('Invalid hex color format');
    }
    return RGBAToHSLA(r, g, b, a);
  }
  throw new Error('Idfk wtf color format this is');
}

function RGBAToHSLA(r: number, g: number, b: number, a: number): string {
  r /= 255;
  g /= 255;
  b /= 255;

  const max = Math.max(r, g, b);
  const min = Math.min(r, g, b);
  let h = 0,
    s = 0,
    l = (max + min) / 2;

  if (max !== min) {
    const d = max - min;
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    switch (max) {
      case r:
        h = (g - b) / d + (g < b ? 6 : 0);
        break;
      case g:
        h = (b - r) / d + 2;
        break;
      case b:
        h = (r - g) / d + 4;
        break;
    }
    h /= 6;
  }

  h = Math.round(h * 360);
  s = Math.round(s * 100);
  l = Math.round(l * 100);

  return `hsla(${h}, ${s}%, ${l}%, ${a})`;
}

export enum ColorMap {
  HeaderBackground,
  HeaderBorder,
  HeaderText,

  InfoButton,
  WindowBackground,
  WindowBorder,

  CounterBackground,
  CounterBorder,
  CounterText,

  CounterNeedMoreBackground,
  CounterNeedMoreBorder,
  CounterNeedMoreText,

  CounterAtMaxBackground,
  CounterAtMaxBorder,
  CounterAtMaxText,

  TabBackground,
  TabBorder,
  TabText,

  TabSelectedBackground,
  TabSelectedBorder,
  TabSelectedText,

  CardBackground,
  CardBorder,
  CardText,

  CardSelectedBackground,
  CardSelectedBorder,
  CardSelectedText,

  CardEarlyButtonBackground,
  CardEarlyButtonBorder,
  CardEarlyButtonText,

  CardEarlyButtonSelectedBackground,
  CardEarlyButtonSelectedBorder,
  CardEarlyButtonSelectedText,

  CardEarlyButtonDisabledBackground,
  CardEarlyButtonDisabledBorder,
  CardEarlyButtonDisabledText,

  CardAdultButtonBackground,
  CardAdultButtonBorder,
  CardAdultButtonText,

  CardAdultButtonSelectedBackground,
  CardAdultButtonSelectedBorder,
  CardAdultButtonSelectedText,

  CardAdultButtonDisabledBackground,
  CardAdultButtonDisabledBorder,
  CardAdultButtonDisabledText,
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

  HeaderBorderWidth = '2px',
  HeaderBorderRadius = '4px',

  CounterBorderWidth = '2px',
  CounterBorderRadius = '4px',

  PageSelectorBorderWidth = '2px',
  PageSelectorBorderRadius = '4px',

  TabBorderWidth = '2px',
  TabBorderRadius = '4px',

  CardBorderWidth = '2px',
  CardBorderRadius = '4px',

  CardEarlyBorderWidth = '1px',
  CardEarlyBorderRadius = '8px',

  CardAdultBorderWidth = '1px',
  CardAdultBorderRadius = '8px',
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
  switch (colorName) {
    case ColorMap.InfoButton:
      return BaseColors.Midnight;

    case ColorMap.CounterBackground:
    case ColorMap.CounterBorder:
    case ColorMap.CounterText:
    case ColorMap.CounterNeedMoreBackground:
    case ColorMap.CounterNeedMoreBorder:
    case ColorMap.CounterNeedMoreText:
    case ColorMap.CounterAtMaxBackground:
    case ColorMap.CounterAtMaxBorder:
    case ColorMap.CounterAtMaxText:
      return BaseColors.Midnight;

    // Purple!
    case ColorMap.WindowBorder:
    case ColorMap.HeaderBorder:
    case ColorMap.CardBorder:
    case ColorMap.CardSelectedBorder:
    case ColorMap.TabBorder:
    case ColorMap.TabSelectedBorder:
      return BaseColors.Midnight;

    // Midnight!
    case ColorMap.WindowBackground:
    case ColorMap.HeaderBackground:
    case ColorMap.HeaderText:
    case ColorMap.CardBackground:
    case ColorMap.CardText:
    case ColorMap.CardSelectedBackground:
    case ColorMap.CardSelectedText:
    case ColorMap.TabBackground:
    case ColorMap.TabText:
    case ColorMap.TabSelectedBackground:
    case ColorMap.TabSelectedText:
      return BaseColors.Midnight;

    // Adult Green!
    case ColorMap.CardAdultButtonBackground:
    case ColorMap.CardAdultButtonBorder:
    case ColorMap.CardAdultButtonText:
    case ColorMap.CardAdultButtonSelectedBackground:
    case ColorMap.CardAdultButtonSelectedBorder:
    case ColorMap.CardAdultButtonSelectedText:
    case ColorMap.CardAdultButtonDisabledBackground:
    case ColorMap.CardAdultButtonDisabledBorder:
    case ColorMap.CardAdultButtonDisabledText:
      return BaseColors.AdultGreen;

    // Early Cyan!
    case ColorMap.CardEarlyButtonBackground:
    case ColorMap.CardEarlyButtonBorder:
    case ColorMap.CardEarlyButtonText:
    case ColorMap.CardEarlyButtonSelectedBackground:
    case ColorMap.CardEarlyButtonSelectedBorder:
    case ColorMap.CardEarlyButtonSelectedText:
    case ColorMap.CardEarlyButtonDisabledBackground:
    case ColorMap.CardEarlyButtonDisabledBorder:
    case ColorMap.CardEarlyButtonDisabledText:
      return BaseColors.EarlyCyan;

    default:
      return BaseColors.RoyalPurple;
  }
}

const GetColorMapOperations = (colorName: ColorMap): ColorMapOperations[] => {
  switch (colorName) {
    // Info Button
    case ColorMap.InfoButton:
      return [ColorMapOperations.Brighten2, ColorMapOperations.Saturate];
    // Counters
    case ColorMap.CounterBackground:
      return [ColorMapOperations.Darken, ColorMapOperations.Desaturate];
    case ColorMap.CounterNeedMoreBackground:
      return [ColorMapOperations.Invert, ColorMapOperations.Transparify];
    case ColorMap.CounterAtMaxBackground:
      return [ColorMapOperations.Saturate];
    case ColorMap.CounterBorder:
    case ColorMap.CounterNeedMoreBorder:
    case ColorMap.CounterAtMaxBorder:
      return [
        ...GetColorMapOperations(ColorMap.CounterBackground),
        ColorMapOperations.Brighten2,
        ColorMapOperations.Saturate,
        ColorMapOperations.Transparify,
      ];
    // Base Backgrounds
    case ColorMap.WindowBackground:
      return [ColorMapOperations.Darken, ColorMapOperations.Desaturate];
    // selecteds?
    case ColorMap.CardSelectedBackground:
    case ColorMap.TabSelectedBackground:
      return [ColorMapOperations.Brighten2, ColorMapOperations.Saturate];
    // Borders
    case ColorMap.WindowBorder:
    case ColorMap.HeaderBorder:
    case ColorMap.CardBorder:
    case ColorMap.TabBorder:
      return [
        ...GetColorMapOperations(ColorMap.CardBackground),
        ColorMapOperations.Brighten2,
        ColorMapOperations.Saturate,
        ColorMapOperations.Transparify,
      ];
    case ColorMap.CardBackground:
    case ColorMap.TabBackground:
    case ColorMap.HeaderBackground:
      return [ColorMapOperations.Desaturate2];
    case ColorMap.CardSelectedBorder:
    case ColorMap.TabSelectedBorder:
      return [
        ...GetColorMapOperations(ColorMap.CardSelectedBackground),
        ColorMapOperations.Brighten2,
        ColorMapOperations.Saturate,
        ColorMapOperations.Transparify,
      ];
    // texts
    case ColorMap.CounterText:
    case ColorMap.CounterNeedMoreText:
    case ColorMap.CounterAtMaxText:
    case ColorMap.HeaderText:
    case ColorMap.CardText:
    case ColorMap.CardSelectedText:
    case ColorMap.TabText:
    case ColorMap.TabSelectedText:
    case ColorMap.CardAdultButtonText:
    case ColorMap.CardAdultButtonSelectedText:
    case ColorMap.CardAdultButtonDisabledText:
    case ColorMap.CardEarlyButtonText:
    case ColorMap.CardEarlyButtonSelectedText:
    case ColorMap.CardEarlyButtonDisabledText:
      return [
        ColorMapOperations.Brighten2,
        ColorMapOperations.Brighten2,
        ColorMapOperations.Darken,
        ColorMapOperations.Desaturate,
        ColorMapOperations.Opaque,
      ];
    // adult/early buttons
    case ColorMap.CardAdultButtonBackground:
    case ColorMap.CardEarlyButtonBackground:
      return [ColorMapOperations.Darken, ColorMapOperations.Desaturate];
    case ColorMap.CardAdultButtonBorder:
    case ColorMap.CardEarlyButtonBorder:
      return [
        ColorMapOperations.Brighten,
        ColorMapOperations.Desaturate,
        ColorMapOperations.Transparify,
      ];
    case ColorMap.CardAdultButtonSelectedBackground:
    case ColorMap.CardEarlyButtonSelectedBackground:
      return [ColorMapOperations.Brighten, ColorMapOperations.Saturate];
    case ColorMap.CardAdultButtonSelectedBorder:
    case ColorMap.CardEarlyButtonSelectedBorder:
      return [
        ColorMapOperations.Brighten2,
        ColorMapOperations.Saturate,
        ColorMapOperations.Opaque,
      ];
    case ColorMap.CardAdultButtonDisabledBackground:
    case ColorMap.CardEarlyButtonDisabledBackground:
      return [ColorMapOperations.Darken, ColorMapOperations.Desaturate2];
    default:
      return [ColorMapOperations.NoOp];
  }
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
