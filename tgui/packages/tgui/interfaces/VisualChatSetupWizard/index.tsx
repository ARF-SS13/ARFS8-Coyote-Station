/**
 * @file Visual Chat Setup Wizard
 * @copyright 2026 Coyote ARFS (Fennicus hornificus)
 * @license YouBreakItYouBoughtIt
 * @description
 * Wizard for setting up the visual chat feature! Its not reallyh a wizard
 * strictly speaking like from windows 95, but more like a control panel like
 * from windows 98!
 */

import React, { useMemo, useState } from 'react';
import { createLogger } from 'tgui/logging';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Input,
  Knob,
  NumberInput,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import {
  AssembleVisualChatElement,
  VisualChatify,
} from 'tgui-panel/chat/visualchat_chat_element_builder';
import {
  type VCAssemblerHolder,
  VCCopyMode,
  VCDiff,
  type VCMessageData,
  VCSaymode,
  type VCSaymodeData,
  type VCSettingData,
  VCSettingKind,
  VCSettingRegion,
  VCTT,
  type VCWizardPack,
} from '../../../tgui-panel/chat/visualchat_types';
import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import HelpContent from './visualchat_help_doc';
import { SettingsControlPanel } from './visualchat_settings_control_panels';
import { VCStyle } from './visualchat_styles';
import { VCGetTooltip } from './visualchat_tooltep_nightmare';

const logger = createLogger('VisualChatSetupWizard');
enum HeaderTab {
  Overview = 'Overview',
  Settings = 'Settings',
  Help = 'Help',
}

enum HumanOrSilicon {
  Human = 'Human',
  Silicon = 'Silicon',
}

type VCLocalStateHolder = {
  humanOrSilicon: HumanOrSilicon;
  setHumanOrSilicon: (value: HumanOrSilicon) => void;
  currentHeaderTab: HeaderTab;
  setCurrentHeaderTab: (value: HeaderTab) => void;
  selectedSwatchIndex: number;
  setSelectedSwatchIndex: (value: number) => void;
  currentSaymodeSelected: VCSaymode;
  setCurrentSaymodeSelected: (value: VCSaymode) => void;
  currentRegion: VCSettingRegion;
  setCurrentRegion: (value: VCSettingRegion) => void;
};

// fallback so anything reading this context never has to null-check; only
// matters if a consumer somehow renders outside the wizard's own provider
const DEFAULT_VC_STATE: VCLocalStateHolder = {
  humanOrSilicon: HumanOrSilicon.Human,
  setHumanOrSilicon: () => {},
  currentHeaderTab: HeaderTab.Overview,
  setCurrentHeaderTab: () => {},
  selectedSwatchIndex: 0,
  setSelectedSwatchIndex: () => {},
  currentSaymodeSelected: VCSaymode.Say,
  setCurrentSaymodeSelected: () => {},
  currentRegion: VCSettingRegion.PFP,
  setCurrentRegion: () => {},
};

const VCUIContext = React.createContext<VCLocalStateHolder>(DEFAULT_VC_STATE);

function useLocalVC(): VCLocalStateHolder {
  return React.useContext(VCUIContext);
}

export function VisualChatSetupWizard() {
  const [humanOrSilicon, setHumanOrSilicon] = useState(
    DEFAULT_VC_STATE.humanOrSilicon,
  );
  const [currentHeaderTab, setCurrentHeaderTab] = useState(
    DEFAULT_VC_STATE.currentHeaderTab,
  );
  const [selectedSwatchIndex, setSelectedSwatchIndex] = useState(
    DEFAULT_VC_STATE.selectedSwatchIndex,
  );
  const [currentRegion, setCurrentRegion] = useState(
    DEFAULT_VC_STATE.currentRegion,
  );
  const [currentSaymodeSelected, setCurrentSaymodeSelected] = useState(
    DEFAULT_VC_STATE.currentSaymodeSelected,
  );

  const vcUIstate: VCLocalStateHolder = {
    humanOrSilicon,
    setHumanOrSilicon,
    currentHeaderTab,
    setCurrentHeaderTab,
    selectedSwatchIndex,
    setSelectedSwatchIndex,
    currentRegion,
    setCurrentRegion,
    currentSaymodeSelected,
    setCurrentSaymodeSelected,
  };
  // const bg_hell = [
  //   HorribleLaggyColorMangler(0),
  //   HorribleLaggyColorMangler(1),
  //   HorribleLaggyColorMangler(2),
  //   HorribleLaggyColorMangler(3),
  // ];
  const gradientio = `linear-gradient(38deg, #000, #111, #222, #333)`;

  return (
    <Window width={768} height={600} title={`Visual Chat Setup Wizard`}>
      <Window.Content style={{ background: gradientio }}>
        <VCUIContext.Provider value={vcUIstate}>
          <Stack fill vertical>
            <Stack.Item shrink style={VCStyle.MainBlock}>
              <HeaderControls />
            </Stack.Item>
            <Stack.Item grow style={VCStyle.MainContent}>
              <MainContent />
            </Stack.Item>
            {/* <Stack.Item shrink style={VCStyle.MainBlock}>
              <FooterControls />
            </Stack.Item> */}
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
// region header controls
function HeaderControls() {
  const vcUIstate = useLocalVC();
  const { act, data } = useBackend<VCWizardPack>();
  const { valid_hosts } = data;

  const buttstyle: React.CSSProperties = { ...VCStyle.MainButton };
  const selstyle: React.CSSProperties = {
    ...buttstyle,
    ...VCStyle.MainButtonSelected,
  };

  function hostButton(host: string): React.ReactElement {
    return (
      <Button
        style={buttstyle}
        tooltip={VCGetTooltip(VCTT.HostButton, null)}
        onClick={() =>
          act('open_host', {
            clicked_host: host,
          })
        }
      >
        {host}
      </Button>
    );
  }

  return (
    <Box style={VCStyle.HeaderContainer}>
      <Stack fill>
        <Stack fill>
          {/* {valid_hosts.map((host) => (
            <Stack.Item shrink key={host}>
              {hostButton(host)}
            </Stack.Item>
          ))} */}
          <Stack.Item grow />
          {/* VC toggles */}
          <Stack.Item shrink>
            <Button
              style={data.show_own_pfp ? selstyle : buttstyle}
              selected={data.show_own_pfp}
              tooltip={VCGetTooltip(VCTT.VCToggleShowOwn, null)}
              onClick={() => act('toggle_show_own_pfp', {})}
            >
              Show Own PFP? {data.show_own_pfp ? 'Yes' : 'No'}
            </Button>
          </Stack.Item>
          <Stack.Item shrink>
            <Button
              style={!data.suppress_account ? selstyle : buttstyle}
              selected={!data.suppress_account}
              tooltip={VCGetTooltip(VCTT.VCToggleSend, null)}
              onClick={() =>
                act('toggle_vc_send', {
                  ckey: data.user_ckey,
                  human_or_silicon: data.human_or_silicon,
                })
              }
            >
              Send Visualchat? {!data.suppress_account ? 'Yes' : 'No'}
            </Button>
          </Stack.Item>
          <Stack.Item shrink>
            <Button
              style={data.see_visualchat ? selstyle : buttstyle}
              selected={data.see_visualchat}
              tooltip={VCGetTooltip(VCTT.VCToggleSee, null)}
              onClick={() =>
                act('toggle_vc', {
                  ckey: data.user_ckey,
                  human_or_silicon: data.human_or_silicon,
                })
              }
            >
              See Visualchat? {data.see_visualchat ? 'Yes' : 'No'}
            </Button>
          </Stack.Item>
          {data.see_visualchat ? (
            <Stack.Item shrink>
              <Tooltip content={VCGetTooltip(VCTT.VCRange, null)}>
                Max Distance:
                <NumberInput
                  value={data.see_visualchat_range}
                  step={1}
                  stepPixelSize={10}
                  minValue={data.see_visualchat_range_min}
                  maxValue={data.see_visualchat_range_max}
                  onChange={(value) =>
                    act('set_see_visualchat_range', {
                      ckey: data.user_ckey,
                      human_or_silicon: data.human_or_silicon,
                      range: value,
                    })
                  }
                />
              </Tooltip>
            </Stack.Item>
          ) : null}
        </Stack>
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
      style={VCStyle.HeaderDropdown}
      options={[HumanOrSilicon.Human, HumanOrSilicon.Silicon]}
      selected={humanOrSilicon}
      onSelected={(e) => setHumanOrSilicon(e)}
    />
  );
}

function TabsForMain() {
  const { currentHeaderTab, setCurrentHeaderTab } = useLocalVC();

  function tabButton(tab: HeaderTab) {
    return (
      <Button
        style={VCStyle.HeaderTab}
        selected={currentHeaderTab === tab}
        onClick={() => setCurrentHeaderTab(tab)}
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
  const { currentHeaderTab, setCurrentHeaderTab } = useLocalVC();

  const clickact =
    currentHeaderTab === HeaderTab.Help
      ? () => setCurrentHeaderTab(HeaderTab.Overview)
      : () => setCurrentHeaderTab(HeaderTab.Help);

  return (
    <Button
      style={VCStyle.HeaderHelp}
      selected={currentHeaderTab === HeaderTab.Help}
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
 // region MainContent
 */
function MainContent() {
  const { currentHeaderTab } = useLocalVC();

  let cuntent = <div>hi</div>;
  switch (currentHeaderTab) {
    case HeaderTab.Overview:
      cuntent = <OverviewContent />;
      break;
    // case HeaderTab.Settings:
    //   cuntent = <SettingsSkeleton />;
    //   break;
    case HeaderTab.Help:
      cuntent = <HelpContent />;
      break;
    default:
      return <div>hi!</div>;
  }
  return <>{cuntent}</>;
}

/**
 * @returns {JSX.Element} The content for the overview tab.
 * @description generates and holds a frickhuge list of SaymodeOverview items.
 * @example
 * <KissMe />
 // endregion MainContent
 // region OverviewContent
 */
function OverviewContent() {
  const { act, data } = useBackend<VCWizardPack>();
  const { humanOrSilicon } = useLocalVC();
  const saymodes: Record<string, VCSaymodeData> = data.saymodes;
  // memo!

  return (
    <Section
      fill
      fitted
      scrollable
      overflowX="auto"
      overflowY="auto"
      style={VCStyle.OverviewContent}
    >
      {Object.values(saymodes)
        .filter((m) => m.saymode_kind !== VCSaymode.EmoteQuick && m.sayname != "Cool Mode")
        .map((item) => {
          return <BuildPreviewBingus key={item.sayname} saymode_dat={item} />;
        })}
    </Section>
  );
}

/**
 * @returns {JSX.Element} The holder for the hellmess, and the other stuff
 * @description layout layouter for the unholy settings glontchpile.
 * @example
 * <SettingsSkeleton />
 // endregion OverviewContent
 // region SettingsContent
 */
function SettingsSkeleton(): React.ReactElement {
  const { act, data } = useBackend<VCWizardPack>();
  const { saymodes, changed_time } = data;
  const {
    currentRegion,
    setCurrentRegion,
    humanOrSilicon,
    setHumanOrSilicon,
    currentSaymodeSelected,
    setCurrentSaymodeSelected,
  } = useLocalVC();

  const previewPanel = useMemo(() => {
    return (
      <BuildPreviewBingus
        key={'hi'}
        saymode_dat={saymodes[currentSaymodeSelected]}
      />
    );
  }, [currentSaymodeSelected, humanOrSilicon, changed_time]);
  // check if clipboard has a saymode clipboarded
  const clipboardHasSaymode = data.clipboard?.source_kind
    ?.toLowerCase()
    .includes(currentSaymodeSelected.toString().toLowerCase());

  const buttstyle: React.CSSProperties = { ...VCStyle.MainButton };
  const selstyle: React.CSSProperties = {
    ...buttstyle,
    ...VCStyle.MainButtonSelected,
  };

  const saymodeTabs: React.ReactElement = (
    <>
      {Object.values(saymodes).map((item) => (
        <React.Fragment key={`saymode-tab-${item.saymode_kind}`}>
          <Button
            style={buttstyle}
            icon="copy"
            tooltip={VCGetTooltip(VCTT.CopySaymode, null)}
            onClick={() =>
              act('copy', {
                human_or_silicon: data.human_or_silicon,
                saymode: item.saymode_kind,
                copy_mode: VCCopyMode.Saymode,
              })
            }
          />
          {clipboardHasSaymode && (
            <Button
              icon="paste"
              style={buttstyle}
              tooltip={VCGetTooltip(VCTT.PasteSaymode, null)}
              onClick={() =>
                act('paste', {
                  human_or_silicon: data.human_or_silicon,
                  saymode: item.saymode_kind,
                  paste_mode: VCCopyMode.Saymode,
                })
              }
            />
          )}
          <Button
            fluid
            style={
              item.saymode_kind === currentSaymodeSelected
                ? selstyle
                : buttstyle
            }
            key={item.sayname}
            onClick={() => setCurrentSaymodeSelected(item.saymode_kind)}
          >
            {item.sayname}
          </Button>
        </React.Fragment>
      ))}
    </>
  );
  function regionButton(region: VCSettingRegion, label: string) {
    return (
      <Stack.Item shrink>
        <Button
          fluid
          style={currentRegion === region ? selstyle : buttstyle}
          onMouseOver={() => {}}
          key={`region-tab-${region}`}
          onClick={() => setCurrentRegion(region)}
        >
          {label}
        </Button>
      </Stack.Item>
    );
  }
  const regionTabs: React.ReactElement = (
    <>
      <Stack fill>
        {regionButton(VCSettingRegion.PFP, 'PFP')}
        {regionButton(VCSettingRegion.OuterBox, 'OuterBox')}
        {regionButton(VCSettingRegion.Name, 'Name')}
        {regionButton(VCSettingRegion.Message, 'Message')}
        {regionButton(VCSettingRegion.Preview, 'Preview')}
      </Stack>
    </>
  );

  return (
    <Box
      style={{
        ...VCStyle.MainContent,
        display: 'flex-inline',
        flexDirection: 'column',
        justifyContent: 'stretch',
        alignItems: 'stretch',
        height: '100%',
      }}
    >
      <Stack fill>
        <Stack.Item basis="150px">
          {/* tabs! */}
          <Section fill fitted scrollable style={VCStyle.SaymodeTabsSection}>
            {saymodeTabs}
          </Section>
        </Stack.Item>
        <Stack.Item grow>
          <Stack fill vertical>
            <Stack.Item shrink>
              {/* region tabs! */}
              {regionTabs}
            </Stack.Item>
            {/* settings! */}
            <Stack.Item grow>
              <Section fill fitted scrollable style={VCStyle.SettingsSection}>
                <SettingsControlPanel // gonna have to be an import
                  saymode={currentSaymodeSelected}
                  saymode_dat={saymodes[currentSaymodeSelected]}
                  currentRegion={currentRegion}
                />
              </Section>
            </Stack.Item>
            {/* preview! */}
            <Stack.Item shrink>{previewPanel}</Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
}

/**
 * The stuff at the bottom of the thing
 * has some buttons! links to catbox, gyazo, f-list
 * tooglebuttons for
 // region Footer Controls
 */
function FooterControls() {
  return <Section fill style={VCStyle.FooterSection} />;
}

// region Builder of PREVUE
function BuildPreviewBingus(props: {
  key: string;
  saymode_dat: VCSaymodeData;
}): React.ReactElement {
  // so this'll end up making a cool preview of the saymode
  // more or less identical to that in chat, but with some... changes!
  // for that we need three things:
  // VCSaymodeData ( got this )
  // VCMessageData ( gotta make it ourselves )
  const messageData: VCMessageData = GenerateMessageData(props.saymode_dat);

  // then visualchatify it
  const vcParts: VCAssemblerHolder = VisualChatify(
    props.saymode_dat,
    messageData,
  );

  // package it all up and let coolWrap slap a hover/click layer on each region
  const assembledElephant = AssembleVisualChatElement(vcParts);

  const framehoker = (
    <Box style={{ ...VCStyle.OverviewContainer }}>
      <Stack fill vertical>
        <Stack.Item
          shrink
          style={{ ...VCStyle.OverviewTopBottom, textAlign: 'center' }}
        >
          <span>{props.saymode_dat.sayname}</span>
        </Stack.Item>
        <Stack.Item shrink style={{ ...VCStyle.OverviewMiddle }}>
          {assembledElephant}
        </Stack.Item>
        <Stack.Item
          shrink
          style={{ ...VCStyle.OverviewTopBottom, textAlign: 'center' }}
        >
          <UnderBarrelSettingChunk saydat={props.saymode_dat} />
        </Stack.Item>
      </Stack>
    </Box>
  );

  return framehoker;
}

function UnderBarrelSettingChunk({
  saydat,
}: {
  saydat: VCSaymodeData;
}): React.ReactElement {
  const { data, act } = useBackend<VCWizardPack>();
  const { human_or_silicon } = data;

  const buttstyle = { ...VCStyle.MainButton };
  const selstyle = { ...buttstyle, ...VCStyle.MainButtonSelected };

  const identSlug = {
    saymode: saydat.saymode_kind,
    h_or_s: human_or_silicon,
  };
  const copyToUserWindowsClipboard = () => {
    navigator.clipboard.writeText(saydat.pfp_image_link);
  }
  const showPaste = !!data.clipboard;
  return (
    <Stack fill style={{ alignItems: 'center', gap: '2px' }}>

      {/* {showPaste && (
        <Stack.Item shrink>
          <Button
            tooltip={VCGetTooltip(VCTT.PasteSaymode, null)}
            icon="paste"
            style={buttstyle}
            onClick={pasteHere}
          />
        </Stack.Item>
      )} */}
      <Stack.Item shrink>
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoUrlFile, saydat)}>
          <span style={{fontWeight: 'bold', paddingRight: '5px', paddingLeft: '5px'}}>Profile Pic Link:</span>
        </Tooltip>
      </Stack.Item>
      <Stack.Item shrink>
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoUrlFile, data)}>
          <Input
            fluid
            width="300px"
            autoSelect
            style={buttstyle}
            placeholder="Enter a link to a cute picture!"
            value={saydat.pfp_image_link as string}
            onClick={(e) => (e.currentTarget.select())}
            onBlur={(value) =>
              (act('set_link', {
                ...identSlug,
                link: value,
              }))
            }
          />
        </Tooltip>
      </Stack.Item>
      <Stack.Item shrink>
        <Box style={{ cursor: 'pointer' }}>
          <Button
            tooltip={VCGetTooltip(VCTT.CopySaymode, null)}
            icon="copy"
            style={buttstyle}
            onClick={copyToUserWindowsClipboard}
          />
        </Box>
      </Stack.Item>
      {/* <Stack.Item shrink>
        <Button // doesnt actually do anything, it just gets players to click out of the input thing
          style={buttstyle}
          onClick={() => act('update')} // """"update""""
        >
          Update!
        </Button>
      </Stack.Item> */}
    </Stack>
  );
}

function GenerateMessageData(saydat: VCSaymodeData): VCMessageData {
  const { data } = useBackend<VCWizardPack>();
  // generate a VCMessageData object based on the saymode_dat
  let preview = saydat.settings.preview_text.toString();
  let named = data.user_name;
  let smode = saydat.example_verb as string;
  if (saydat.saymode_kind === VCSaymode.EmoteQuick) {
    preview = `${data.user_name} gekkers like a cute fox!`;
    named = '';
    smode = '';
  }
  const ourMessageData: VCMessageData = {
    body_text: preview,
    compiled_message: preview,
    displayed_saymode: smode,
    am_ghost: false,
    name_displayed: named,
    ghost_link: '',
    msg_splice_timeout: 0,
    msg_splice_last_saymode: '',
    use_settings: false,
    merge_name_too: false,
    hide_pfp: false,
    differentiator: {h:0,s:0,v:0} as VCDiff
  };
  return ourMessageData; // ya know i was expecting a lot more stuff
}
// name_displayed
// displayed_saymode
// body_text
// compiled_message
// am_ghost
// ghost_link
// msg_splice_timeout
// msg_splice_last_saymode

// region Setting
export function Setting(
  setting: VCSettingData,
  saydat: VCSaymodeData,
  data: VCWizardPack,
  act,
): React.ReactElement | null {
  const { selectedSwatchIndex } = useLocalVC();

  const { path, name, key, value, kind, min, max, choices } = setting;
  // clibbord the big red clipboard
  const cbord = data.clipboard;
  const showPaste =
    cbord.haz &&
    cbord.source_kind &&
    cbord.source_kind.toLowerCase().includes(kind.toLowerCase());
  const showSwatchButt = kind === VCSettingKind.Color;
  const swatches = data.color_swatches;
  const identSlug = {
    setting_path: path,
    setting_key: key,
    setting_kind: kind,
    setting_oldvalue: value,
    saymode: saydat.saymode_kind,
    h_or_s: data.human_or_silicon,
  };

  const buttstyle = { ...VCStyle.MainButton };
  const selstyle = { ...buttstyle, ...VCStyle.MainButtonSelected };

  function CopyButton() {
    return (
      <Button
        tooltip={VCGetTooltip(VCTT.CopySetting, setting)}
        style={buttstyle}
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
        tooltip={VCGetTooltip(VCTT.PasteSetting, null)}
        icon="paste"
        style={buttstyle}
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
            style={buttstyle}
            tooltip={VCGetTooltip(VCTT.SwatchSnatch, setting)}
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
            style={buttstyle}
            tooltip={VCGetTooltip(VCTT.SwatchApply, setting)}
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

  function SetupBaseBox(
    settingElement: React.ReactElement,
  ): React.ReactElement {
    return (
      <Box
        style={{
          ...VCStyle.Setting,
          width: '100%',
          flexDirection: 'row',
          display: 'flex-inline',
          justifyContent: 'stretch',
          alignItems: 'stretch',
          verticalAlign: 'middle',
          border: '1px solid black',
        }}
      >
        <Stack fill>
          <Stack.Item shrink>
            <CopyButton />
          </Stack.Item>
          {showPaste && (
            <Stack.Item shrink>
              <PasteButton />
            </Stack.Item>
          )}
          <Stack.Item shrink style={{ verticalAlign: 'middle' }}>
            <Tooltip content={VCGetTooltip(VCTT.SettingInfo, setting)}>
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
      ...identSlug,
      new_value: newValue, // <-- thats the new one!
    });
  }
  const settingElement: React.ReactNode = null;
  switch (kind) {
    case VCSettingKind.String:
      return SetupBaseBox(
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoString, setting)}>
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
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoNumber, setting)}>
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
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoBoolean, setting)}>
          <Button
            style={value ? selstyle : buttstyle}
            selected={value as boolean}
            onClick={() => doAct(!(value as boolean))}
          >
            {(value as boolean) ? 'Yes' : 'No'}
          </Button>
        </Tooltip>,
      );
    case VCSettingKind.Choice:
      return SetupBaseBox(
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoChoice, setting)}>
          <Dropdown
            style={VCStyle.MainDropdown}
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
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoColor, setting)}>
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
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoAngle, setting)}>
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
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoUrlChoose, setting)}>
          <Dropdown
            style={VCStyle.MainDropdown}
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
        <Tooltip content={VCGetTooltip(VCTT.SettingInfoUrlFile, setting)}>
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
