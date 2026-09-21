/**
 * @file visualchat_chat_element_builder.tsx
 * @copyright 2026 Coyote ARFS (Fennicus hornificus)
 * @license You Break It You Bought It
 * @description Welcome to VisualChat, the gaudy thing that makes your chat
 * look like a silly anime visual novel! The way it works is that the backend
 * compiles a bunch of data about what was said, then this thing here turns that
 * into html clown vomit. its then directly injected into the chat message
 * payload in renderer.tsx. Enjoy!
 */
/** biome-ignore-all assist/source/organizeImports: eat me */

import { Box, Stack, Image } from 'tgui-core/components';
import { resolveAsset } from 'tgui/assets';
import {
  type VCMessageData,
  type VCSettingDataPack,
  type VCSaymodeData,
  type VCAssemblerHolder,
  VCSettingRegion,
  VCSDPEnum,
  VCSaymode,
} from './visualchat_types';
import { GetVCEBStyle } from 'tgui/interfaces/VisualChatSetupWizard/visualchat_styles';
import {
  VCStylePackEnum,
  GetVCChatStylePack,
} from 'tgui/interfaces/VisualChatSetupWizard/visualchat_styles_for_chat';
import { createLogger } from 'tgui/logging';

const logger = createLogger('chatRenderer');

const DEFAULT_PROFILE_PICTURE = resolveAsset(
  'https://files.catbox.moe/rblpt6.png',
);

// Sets the innerHTML of a chat message node (bscly a div) to a visual novel
// style chat message. Super customizable, for better or worse
// someday this'll have stuff like prefs to tone down the disco vomit nightmare!
export function VisualChatify(
  saymodeData: VCSaymodeData,
  messageData: VCMessageData,
  theme: string = 'dark',
): VCAssemblerHolder {
  const { name_displayed, displayed_saymode, body_text, compiled_message } =
    messageData;
  const settingsData = saymodeData.settings;

  const vcaOut: VCAssemblerHolder = {} as VCAssemblerHolder;

  // oh yeah, strip out any script tags from the body text
  const coolbody = body_text
    .replace(/<script*?>.*?<\/script>/gi, '')
    // and deactivate any inline event handlers by adding in a zero-width space before and after the 'on' part
    .replace(/\son\w+=".*?"/gi, (match) => {
      return `\u200B${match}\u200B`; // noob 2oob~
    });
  const coolname = name_displayed
    .replace(/<script*?>.*?<\/script>/gi, '')
    .replace(/\son\w+=".*?"/gi, (match) => {
      return `\u200B${match}\u200B`;
    });
  const coolcompiled = compiled_message
    .replace(/<script*?>.*?<\/script>/gi, '')
    .replace(/\son\w+=".*?"/gi, (match) => {
      return `\u200B${match}\u200B`;
    });

  vcaOut.pfpImageLink =
    settingsData[VCSDPEnum.pfp_image_link]?.value || DEFAULT_PROFILE_PICTURE;

  vcaOut.saymode = saymodeData.saymode_kind;
  vcaOut.nameFull = `${coolname} ${displayed_saymode}, `; // WeedGoku says;
  vcaOut.body_text = coolbody;
  vcaOut.compiled_message = coolcompiled;

  if (!messageData.use_settings) {
    // use what we got, but good
    const stylePack =
      theme === 'light'
        ? GetVCChatStylePack(VCStylePackEnum.light)
        : GetVCChatStylePack(VCStylePackEnum.default);
    logger.log(`using style pack ${theme === 'light' ? 'light' : 'def'}`);
    vcaOut.outerBoxStyle = {
      ...stylePack.Swag,
      ...stylePack.OuterBackground,
      ...stylePack.OuterBorders,
      ...stylePack.Text,
    };
    vcaOut.nameStyle = {
      ...stylePack.Swag,
      ...stylePack.InnerBackgrounds,
      ...stylePack.InnerBorders,
      ...stylePack.Text,
    };
    vcaOut.messageStyle = {
      ...stylePack.Swag,
      ...stylePack.InnerBackgrounds,
      ...stylePack.InnerBorders,
      ...stylePack.Text,
    };
    vcaOut.pfpBoxStyle = {
      ...stylePack.Swag,
      ...stylePack.PFPBorders,
      ...stylePack.PFPBackground,
      ...stylePack.Text,
    };
    vcaOut.pfpImageStyle = { ...stylePack.PFPImageStyle };
    logger.log('pack contents', stylePack);
    return vcaOut;
  }
  logger.log('using settings');

  vcaOut.outerBoxStyle = GetVCEBStyle(settingsData, VCSettingRegion.OuterBox);
  vcaOut.pfpBoxStyle = GetVCEBStyle(settingsData, VCSettingRegion.PFP);
  vcaOut.messageStyle = GetVCEBStyle(settingsData, VCSettingRegion.Message);
  vcaOut.nameStyle = GetVCEBStyle(settingsData, VCSettingRegion.Name);

  vcaOut.pfpImageStyle = {
    width: `${settingsData[VCSDPEnum.pfp_image_width].value}px`,
    height: `${settingsData[VCSDPEnum.pfp_image_height].value}px`,
    opacity: `${settingsData[VCSDPEnum.pfp_image_opacity].value}%`,
    objectFit: 'contain',
    margin: '5px',
    borderRadius:
      settingsData[VCSDPEnum.pfp_image_shape].value === 'circle' ? '50%' : '0%',
  };

  return vcaOut;
}

// wraps a piece of the assembled element with `wrapRegion` so callers (like
// the setup wizard) can hang hover/click behavior off each region; the chat
// renderer just leaves it as a no-op passthrough
export function AssembleVisualChatElement(
  vch: VCAssemblerHolder,
  flash?: boolean,
): React.ReactElement {
  // so which builder do we use? yes it does matter
  let displayMode: VCDisplayMode = DetermineDisplayMode(vch.saymode);
  if (!IsPFPLink(vch.pfpImageLink)) {
    switch (displayMode) {
      case VCDisplayMode.Full:
        displayMode = VCDisplayMode.FullWithoutImage;
        break;
      case VCDisplayMode.Combined:
        displayMode = VCDisplayMode.CombinedWithoutImage;
        break;
      case VCDisplayMode.PreCompiled:
        displayMode = VCDisplayMode.PreCompiledWithoutImage;
        break;
    }
  }

  // style inkection!
  const injectedStyle = (
    <style>{`
      @keyframes coolFlash {
        0% { color: inherit; }
        50% {
        filter: saturate(2);
        text-shadow: 3px 3px 5px teal;
        color: yellow; }
        100% { color: inherit;
        text-shadow: none; }
      }
      .coolcoolflash {
        animation: coolFlash 1s;
        filter: saturate(1);
      }
      `}</style>
  );

  const coolImage = (
    <Stack.Item shrink style={{ ...vch.pfpBoxStyle }}>
      <Image src={vch.pfpImageLink} style={{ ...vch.pfpImageStyle }} />
    </Stack.Item>
  );

  switch (displayMode) {
    case VCDisplayMode.FullWithoutImage:
    case VCDisplayMode.Full:
      return (
        <Box style={{ ...vch.outerBoxStyle }}>
          {injectedStyle}
          <Stack fill>
            {/* Profile picture */}
            {displayMode !== VCDisplayMode.FullWithoutImage && coolImage}
            {/* Name and message */}
            <Stack.Item grow>
              <Stack fill vertical>
                {/* Name box */}
                <Stack.Item style={vch.nameStyle}>
                  <Box
                    as="span"
                    dangerouslySetInnerHTML={{
                      __html: vch.nameFull,
                    }}
                  />
                </Stack.Item>
                {/* Message box */}

                <Stack.Item
                  style={{ ...vch.messageStyle }}
                  className="coolcoolflash"
                  grow
                >
                  <Box
                    id="vcmsg"
                    dangerouslySetInnerHTML={{ __html: vch.body_text }}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Box>
      );
    case VCDisplayMode.Combined:
    case VCDisplayMode.CombinedWithoutImage:
      return (
        <Box style={{ ...vch.outerBoxStyle }}>
          <Stack fill>
            {/* Profile picture */}
            {displayMode !== VCDisplayMode.CombinedWithoutImage && coolImage}
            {/* Name and message */}
            <Stack.Item
              grow
              style={{ ...vch.messageStyle }}
              className="coolcoolflash"
            >
              <span>{vch.nameFull}</span>
              <Box
                id="vcmsg"
                dangerouslySetInnerHTML={{ __html: vch.body_text }}
              />
            </Stack.Item>
          </Stack>
        </Box>
      );
    case VCDisplayMode.PreCompiled:
    case VCDisplayMode.PreCompiledWithoutImage:
      return (
        <Box style={{ ...vch.outerBoxStyle }}>
          <Stack fill style={{ gap: '0px' }}>
            {/* Profile picture */}
            {displayMode !== VCDisplayMode.PreCompiledWithoutImage && coolImage}
            {/* Name and message */}
            <Stack.Item
              grow
              style={{ ...vch.messageStyle }}
              className="coolcoolflash"
            >
              <Box
                id="vcmsg"
                dangerouslySetInnerHTML={{ __html: vch.compiled_message }} // this one has everything
              />
            </Stack.Item>
          </Stack>
        </Box>
      );

    default:
      return (
        <div>
          {vch.nameFull}
          {vch.body_text}
        </div>
      );
  }
}

function IsPFPLink(link: string): boolean {
  try {
    const url = new URL(link);
    return url.protocol === 'http:' || url.protocol === 'https:';
  } catch {
    return false;
  }
}

enum VCDisplayMode {
  Full = 'Full',
  Combined = 'Combined',
  PreCompiled = 'PreCompiled',
  FullWithoutImage = 'FullWithoutImage',
  CombinedWithoutImage = 'CombinedWithoutImage',
  PreCompiledWithoutImage = 'PreCompiledWithoutImage',
}

function DetermineDisplayMode(saymode: VCSaymode): VCDisplayMode {
  let displayMode: VCDisplayMode;
  switch (saymode) {
    case VCSaymode.Emote:
    case VCSaymode.Subtle:
      displayMode = VCDisplayMode.PreCompiled;
      break;
    case VCSaymode.EmoteQuick:
      displayMode = VCDisplayMode.PreCompiledWithoutImage;
      break;
    case VCSaymode.Radio:
      displayMode = VCDisplayMode.PreCompiledWithoutImage;
      break;
    default:
      displayMode = VCDisplayMode.Full;
      break;
  }
  return displayMode;
}

// goes through every single setting provided, and logs what settings are not present
function DebugWhatsMissing(settingsData: VCSettingDataPack) {
  for (const key in VCSDPEnum) {
    if (settingsData[VCSDPEnum[key]] === undefined) {
      logger.error(`Missing settingsData for key: ${VCSDPEnum[key]}`);
      continue;
    }
    if (settingsData[VCSDPEnum[key]].value === undefined) {
      logger.error(`Missing value for settingsData key: ${VCSDPEnum[key]}`);
    }
  }
}

function cssPropertiesToString(style: React.CSSProperties): string {
  return Object.entries(style)
    .map(([key, value]) => `${key}: ${value}`)
    .join('; ');
}
