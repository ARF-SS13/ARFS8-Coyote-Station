/**
 * @file Visual Chat Setup Wizard
 * @copyright 2026 Coyote ARFS (Fennicus hornificus)
 * @license YouBreakItYouBoughtIt
 * @description
 * Wizard for setting up the visual chat feature! Its not reallyh a wizard
 * strictly speaking like from windows 95, but more like a control panel like
 * from windows 98!
 */

import React, { useMemo } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Input,
  Knob,
  NumberInput,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import {
  VCCopyMode,
  type VCSaymodeData,
  VCSDPEnum,
  type VCSettingData,
  type VCSettingDataPack,
  VCSettingKind,
  VCTT,
  type VCWizardPack,
} from '../../../tgui-panel/chat/visualchat_types';
import { VCGetTooltip } from './visualchat_tooltep_nightmare';
import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { VCStyle, VCStyleKeys } from './visualchat_styles';

type VCLocalStateHolder = {
  humanOrSilicon: HumanOrSilicon;
  setHumanOrSilicon: (value: HumanOrSilicon) => void;
  headerTabSelected: HeaderTab;
  setHeaderTabSelected: (value: HeaderTab) => void;
  selectedSwatchIndex: number;
  setSelectedSwatchIndex: (value: number) => void;
};

const VCUIContext = React.createContext<VCLocalStateHolder | null>(null);

function useLocalVC(): VCLocalStateHolder {
  const ctx = React.useContext(VCUIContext);
  if (!ctx) {
    throw new Error('useVCUI must be used within VCUIContext.Provider');
  }
  return ctx;
}

enum HeaderTab {
  Overview = 'Overview',
  Settings = 'Settings',
  Help = 'Help',
}

enum HumanOrSilicon {
  Human = 'Human',
  Silicon = 'Silicon',
}

export function VisualChatSetupWizard() {
  const vcUIstate = useLocalVC();

  return (
    <Window width={500} height={600} title={`Visual Chat Setup Wizard`}>
      <Window.Content style={VCStyle[VCStyleKeys.Window]}>
        <VCUIContext.Provider value={vcUIstate}>
          <Stack fill vertical>
            <Stack.Item shrink>
              <HeaderControls />
            </Stack.Item>
            <Stack.Item grow>
              <MainContent />
            </Stack.Item>
            <Stack.Item shrink>
              <FooterControls />
            </Stack.Item>
          </Stack>
        </VCUIContext.Provider>
      </Window.Content>
    </Window>
  );
}

/**
 * @returns {JSX.Element} The header controls component.
 * @description So this thing is pretty imnportant yeah, so it like has
 * the controls and such, and hows that gonna work? it has the
 * human/silicon selector box, the tabs for Overview and Settings, and the
 * all important wtf is this whole viseual chat garbage?
 */
function HeaderControls() {
  const vcUIstate = useLocalVC();

  return (
    <Box style={VCStyle[VCStyleKeys.HeaderContainer]}>
      <Stack fill>
        <Stack.Item shrink>
          <HumanOrSiliconSelector />
        </Stack.Item>
        <Stack.Item shrink>
          <TabsForMain />
        </Stack.Item>
        <Stack.Item grow />
        <Stack.Item shrink>
          <HelpPlease />
        </Stack.Item>
      </Stack>
    </Box>
  );
}

function HumanOrSiliconSelector() {
  const { humanOrSilicon, setHumanOrSilicon } = useLocalVC();

  return (
    <Dropdown
      style={VCStyle[VCStyleKeys.HeaderDropdown]}
      options={[HumanOrSilicon.Human, HumanOrSilicon.Silicon]}
      selected={humanOrSilicon}
      onSelected={(e) => setHumanOrSilicon(e)}
    />
  );
}

function TabsForMain() {
  const { headerTabSelected, setHeaderTabSelected } = useLocalVC();

  function tabButton(tab: HeaderTab) {
    return (
      <Button
        style={VCStyle[VCStyleKeys.HeaderTab]}
        selected={headerTabSelected === tab}
        onClick={() => setHeaderTabSelected(tab)}
      >
        {tab}
      </Button>
    );
  }

  return (
    <Box>
      <Stack fill>
        <Stack.Item shrink>{tabButton(HeaderTab.Overview)}</Stack.Item>
        <Stack.Item shrink>{tabButton(HeaderTab.Settings)}</Stack.Item>
      </Stack>
    </Box>
  );
}

function HelpPlease() {
  const { headerTabSelected, setHeaderTabSelected } = useLocalVC();

  const clickact =
    headerTabSelected === HeaderTab.Help
      ? () => setHeaderTabSelected(HeaderTab.Overview)
      : () => setHeaderTabSelected(HeaderTab.Help);

  return (
    <Button
      style={VCStyle[VCStyleKeys.HeaderHelp]}
      selected={headerTabSelected === HeaderTab.Help}
      onClick={clickact}
    >
      <Icon name="question" />
    </Button>
  );
}

/**
 * @returns {JSX.Element} The main content component.
 * @description A holder of what should be displayed as the main content in the visual chat setup wizard.
 * @example
 * <KissMyButt />
 */
function MainContent() {
  const { headerTabSelected } = useLocalVC();

  switch (headerTabSelected) {
    case HeaderTab.Overview:
      return <OverviewContent />;
    case HeaderTab.Settings:
      return <SettingsContent />;
    case HeaderTab.Help:
      return <HelpContent />;
    default:
      return <div>hi!</div>;
  }
}

/**
 * @returns {JSX.Element} The content for the overview tab.
 * @description generates and holds a frickhuge list of SaymodeOverview items.
 * @example
 * <KissMe />
 */
function OverviewContent() {
  const { act, data } = useBackend<VCWizardPack>();
  const { humanOrSilicon } = useLocalVC();
  const saymodes: Record<string, VCSaymodeData> = data.saymodes;
  // memo!
  const saymodeOverviewItems = useMemo(() => {
    // generate the list of SaymodeOverview items based on data
    return Object.keys(saymodes).map((item) => (
      <SaymodeOverview
        key={item}
        index={Object.keys(saymodes).indexOf(item)}
        total_items={Object.keys(saymodes).length}
        saymode_dat={saymodes[item]}
        saymode_kind={item}
      />
    ));
  }, [data.changed_time, humanOrSilicon]);

  return (
    <Box style={VCStyle[VCStyleKeys.OverviewContent]}>
      {saymodeOverviewItems}
    </Box>
  );
}

// we'll get to these
function FooterControls() {}

// stuff

function Setting(whichsetting: VCSDPEnum, saydat: VCSaymodeData) {
  const { act, data } = useBackend<VCWizardPack>();
  const { humanOrSilicon, selectedSwatchIndex } = useLocalVC();
  //depenging on how which setting is being requested, we would render the appropriate control

  const settingData: VCSettingData = saydat[whichsetting];
  const { path, name, key, value, kind, min, max, choices } = settingData;
  // clibbord the big red clipboard
  const cbord = data.clipboard;
  const { valid_contents: vc, has_stuff } = cbord;
  const showPaste =
    has_stuff &&
    vc &&
    vc.some((content) => content.toLowerCase().includes(kind.toLowerCase()));
  const showSwatchButt = kind === VCSettingKind.Color;
  const swatches = data.color_swatches;
  const identSlug = {
    setting_path: path,
    setting_key: key,
    setting_kind: kind,
    setting_oldvalue: value,
    saymode: saydat.saymode_kind,
    h_or_s: humanOrSilicon,
  };

  function CopyButton() {
    return (
      <Button
        tooltip={VCGetTooltip(VCTT.CopySetting, settingData)}
        icon="copy"
        onClick={() => {
          act('copy', {
            ...identSlug,
            copy_mode: VCCopyMode.Setting, // <-- thats the new one!
          });
        }}
      />
    );
  }

  function PasteButton() {
    return (
      <Button
        icon="paste"
        onClick={() => {
          act('paste', {
            ...identSlug, // backend knows what pasting
            paste_mode: VCCopyMode.Setting, // <-- thats the new one!
          });
        }}
      />
    );
  }

  // 2 of em, paste, and snatch
  function SwatchButtons() {
    const selectedSwatch = swatches[selectedSwatchIndex]; // #BUTTYIFF
    return (
      <Stack fill>
        <Stack.Item shrink>
          <Button
            tooltip={VCGetTooltip(VCTT.SwatchSnatch, settingData)}
            icon="eyedropper"
            onClick={() => {
              act('swatch_snatch', {
                ...identSlug, // it knows which color to pull from
              });
            }}
          />
        </Stack.Item>
        <Stack.Item shrink>
          <Button
            tooltip={VCGetTooltip(VCTT.SwatchApply, settingData)}
            icon="paint-brush"
            onClick={() => {
              act('swatch_apply', {
                ...identSlug,
                swatch_index: selectedSwatchIndex,
                swatch_color: selectedSwatch,
              });
            }}
          />
        </Stack.Item>
      </Stack>
    );
  }

  function SetupBaseBox(settingElement: React.ReactNode) {
    return (
      <Box style={VCStyle[VCStyleKeys.Setting]}>
        <Stack fill>
          <Stack.Item shrink>
            <CopyButton />
          </Stack.Item>
          {showPaste && (
            <Stack.Item shrink>
              <PasteButton />
            </Stack.Item>
          )}
          <Stack.Item shrink>
            <Tooltip content={VCGetTooltip(VCTT.SettingInfo, settingData)}>
              <strong>{name}</strong>
            </Tooltip>
          </Stack.Item>
          <Stack.Item grow />
          <Stack.Item shrink>{settingElement}</Stack.Item>
          {showSwatchButt && (
            <Stack.Item shrink>
              <SwatchButtons />
            </Stack.Item>
          )}
        </Stack>
      </Box>
    );
  }
  function doAct(newValue: any) {
    act('change_setting', {
      setting_path: path,
      setting_key: key,
      setting_kind: kind,
      saymode: saydat.saymode_kind,
      h_or_s: humanOrSilicon,
      new_value: newValue, // <-- thats the new one!
    });
  }
  const settingElement: React.ReactNode = null;
  switch (kind) {
    case VCSettingKind.String:
      return SetupBaseBox(
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoString, settingData)}>
          <Input
            placeholder={value as string}
            value={value as string}
            onBlur={(e) => doAct(e)}
            maxLength={max}
          />
        </Tooltip>,
      );
    case VCSettingKind.Number:
      return SetupBaseBox(
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoNumber, settingData)}>
          <NumberInput
            maxValue={max}
            minValue={min}
            step={1}
            value={value as number}
            onChange={(e) => doAct(e)}
          />
        </Tooltip>,
      );
    case VCSettingKind.Boolean:
      return SetupBaseBox(
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoBoolean, settingData)}>
          <Button
            selected={value as boolean}
            onClick={() => doAct(!(value as boolean))}
          >
            {(value as boolean) ? 'Yes' : 'No'}
          </Button>
        </Tooltip>,
      );
    case VCSettingKind.Choice:
      return SetupBaseBox(
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoChoice, settingData)}>
          <Dropdown
            onSelected={(value) => doAct(value)}
            options={choices}
            selected={value as string}
            buttons
            fluid
          />
        </Tooltip>,
      );
    case VCSettingKind.Color:
      return SetupBaseBox(
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoColor, settingData)}>
          <Button
            fluid
            style={{ backgroundColor: value as string }}
            onClick={() => doAct('color_me_daddy')}
          >
            {value as string}
          </Button>
        </Tooltip>,
      );
    case VCSettingKind.Angle:
      return SetupBaseBox(
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoAngle, settingData)}>
          <Knob
            maxValue={360}
            minValue={0}
            unclamped={true} // backend modulos it to a degrees
            step={15}
            value={value as number}
            onChange={(e) => doAct(e)}
          />
        </Tooltip>,
      );
    case VCSettingKind.URLChoose:
      return SetupBaseBox(
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoUrlChoose, settingData)}>
          <Dropdown
            onSelected={(value) => doAct(value)}
            options={choices}
            selected={value as string}
            buttons
            fluid
          />
        </Tooltip>,
      );
    case VCSettingKind.URLFile:
      return SetupBaseBox(
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoUrlFile, settingData)}>
          <Input
            placeholder="Enter URL"
            value={value as string}
            onChange={(e) => doAct(e)}
          />
        </Tooltip>,
      );
    default:
      return SetupBaseBox(
        <Tooltip content={'BAD!'}>
          <p>{`BAD.`}</p>
        </Tooltip>,
      );
  }
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
