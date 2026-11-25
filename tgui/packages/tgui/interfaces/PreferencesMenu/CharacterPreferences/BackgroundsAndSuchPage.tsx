/** biome-ignore-all lint/correctness/noUnusedImports: sugma */

import React, { type ReactNode } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import type { CharacterPreferencesData, TemperamentBuild } from '../types';
import {
  BorderMap,
  ColorMap,
  FontMap,
  GetColorFromMap,
} from './BackgroundsColorsAndStyle';
import {
  TTipCategory,
  TTipContentType,
  type TTipExtraData,
} from './BackgroundTypes';

type BackgroundsLocalStateHolder = {
  activeTab: string;
  setActiveTab: (nextTab: string) => void;
  searchQuery: string;
  setSearchQuery: (nextQuery: string) => void;
};

// hey i learned somethign cool today, you can use react context to
// pass states and setters down to children without having to mash
// them through props, which is pretty nice cus i hate doins that
const BackgroundsUIContext =
  React.createContext<BackgroundsLocalStateHolder | null>(null);

function useBackgroundsUI(): BackgroundsLocalStateHolder {
  const ctx = React.useContext(BackgroundsUIContext);
  if (!ctx) {
    throw new Error(
      'useBackgroundsUI must be used within BackgroundsUIContext.Provider',
    );
  }
  return ctx;
}

export function BackgroundsAndSuchPage() {
  const { data } = useBackend<CharacterPreferencesData>();
  const [activeTab, setActiveTab] = React.useState<string>(
    data.server_tabs[0] || 'your_backgrounds',
  );
  const [searchQuery, setSearchQuery] = React.useState<string>('');

  const uiState: BackgroundsLocalStateHolder = {
    activeTab,
    setActiveTab,
    searchQuery,
    setSearchQuery,
  };
  //overly complicated port from CBT's quirk thing, the best thing ive ever made
  //literally everything was downhill from that
  return (
    <BackgroundsUIContext.Provider value={uiState}>
      <Section
        fill
        fitted
        style={{
          borderColor: GetColorFromMap(ColorMap.WindowBorder),
          borderWidth: BorderMap.WindowBorderWidth,
          borderRadius: BorderMap.WindowBorderRadius,
        }}
        backgroundColor={GetColorFromMap(ColorMap.WindowBackground)}
      >
        <Stack fill vertical overflow="hidden" g={1}>
          <Stack.Item shrink>
            <BackstoryAndSuchHeader />
          </Stack.Item>
          <Stack.Item grow>
            <BackstoryAndSuchContent />
          </Stack.Item>
          <Stack.Item shrink />{' '}
          {/* dunno why but it needed this for some reason */}
        </Stack>
      </Section>
    </BackgroundsUIContext.Provider>
  );
}

enum ButtState {
  Fine,
  NeedsMore,
  AtMax,
  Selected,
}

/*
╔═══╦═════════════════════════════╗
║ ? ║         BACKGROUNDS         ║
╠═══╬══════════════════════╦══════╣
║ ? ║    Early Backgrounds ║ 1/10 ║
╠═══╬══════════════════════╬══════╣
║ ? ║    Adult Backgrounds ║ 4/10 ║
╚═══╩══════════════════════╩══════╝
*/
function BackstoryAndSuchHeader() {
  const { data, act } = useBackend<CharacterPreferencesData>();

  const plr_early_bg = data.player_early_backgrounds || [];
  const plr_adult_bg = data.player_adult_backgrounds || [];

  const early_bg_count = plr_early_bg.length;
  const adult_bg_count = plr_adult_bg.length;

  const early_counter_state = GetCounterState(
    early_bg_count,
    data.min_early_backgrounds,
    data.max_early_backgrounds,
  );
  const adult_counter_state = GetCounterState(
    adult_bg_count,
    data.min_adult_backgrounds,
    data.max_adult_backgrounds,
  );

  const TTips: Record<TTipCategory, ReactNode> = LoadToolTips(
    [
      TTipCategory.TTGenInfo,
      TTipCategory.TTEarlyInfo,
      TTipCategory.TTAdultInfo,
      TTipCategory.TTCountEarly,
      TTipCategory.TTCountAdult, // these are conditional!!!
      TTipCategory.TTClearAll,
      TTipCategory.TTClearEarly,
      TTipCategory.TTClearAdult,
    ],
    early_counter_state,
    adult_counter_state,
  );

  // const early_trash = MakeTrashButton(TTips[TTipCategory.TTClearEarly], 'E');
  // const adult_trash = MakeTrashButton(TTips[TTipCategory.TTClearAdult], 'A');
  // const all_trash = MakeTrashButton(TTips[TTipCategory.TTClearAll], 'E-A');

  const early_counter = MakeCounterBox(
    early_bg_count,
    data.max_early_backgrounds,
    early_counter_state,
    TTips[TTipCategory.TTCountEarly],
  );

  const adult_counter = MakeCounterBox(
    adult_bg_count,
    data.max_adult_backgrounds,
    adult_counter_state,
    TTips[TTipCategory.TTCountAdult],
  );

  function MakeHelpButton(words: string, content: ReactNode) {
    return (
      <Tooltip content={content}>
        <Box width="100%" height="100%">
          {MakeVerticallyAlignedText(words)}
        </Box>
      </Tooltip>
    );
  }

  const top_style = {
    color: GetColorFromMap(ColorMap.HeaderText),
    backgroundColor: GetColorFromMap(ColorMap.HeaderBackground),
    borderColor: GetColorFromMap(ColorMap.HeaderBorder),
    borderWidth: BorderMap.HeaderBorderWidth,
    borderRadius: BorderMap.HeaderBorderRadius,
    borderStyle: 'solid',
    fontSize: FontMap.HeaderTopFontSize,
    fontWeight: FontMap.HeaderTopFontWeight,
    textAlign: 'center' as const,
    padding: '5px',
    marginLeft: '5px',
    marginRight: '5px',
    marginTop: '5px',
  };
  const bottom_style = {
    ...top_style,
    marginTop: '0px',
    fontSize: FontMap.HeaderBottomFontSize,
    fontWeight: FontMap.HeaderBottomFontWeight,
  };

  const gen_totle = MakeHelpButton(
    'Backgrounds and Backstories',
    TTips[TTipCategory.TTGenInfo],
  );
  const early_totle = MakeHelpButton(
    'Early Backgrounds →',
    TTips[TTipCategory.TTEarlyInfo],
  );
  const adult_totle = MakeHelpButton(
    '← Adult Backgrounds',
    TTips[TTipCategory.TTAdultInfo],
  );

  return (
    <Stack fill vertical>
      {/* Top Header */}
      <Box style={top_style}>{gen_totle}</Box>
      <Box style={bottom_style}>
        <Stack.Item shrink>
          <Stack fill>
            {/* Early Backgrounds - middle */}
            <Stack.Item grow>
              <Stack fill>
                <Stack.Item grow>{early_totle}</Stack.Item>
                <Stack.Item shrink>{early_counter}</Stack.Item>
              </Stack>
            </Stack.Item>
            {/* Adult Backgrounds - bottom */}
            <Stack.Item grow>
              <Stack fill>
                <Stack.Item shrink>{adult_counter}</Stack.Item>
                <Stack.Item grow>{adult_totle}</Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Box>
    </Stack>
  );
}

/*
╔═══╦═════╗
║ T ║  S  ║
║ A ║  T  ║
║ B ║  U  ║
║ S ║  F  ║
╚═══╩═════╝
*/
function BackstoryAndSuchContent() {
  return (
    <Stack fill overflow="hidden">
      <Stack.Item basis="200px">
        <BackgroundsTabs />
      </Stack.Item>
      <Stack.Item grow>
        <BackgroundsStuff />
      </Stack.Item>
    </Stack>
  );
}

function BackgroundsTabs() {
  const { data } = useBackend<CharacterPreferencesData>();
  const { activeTab, setActiveTab } = useBackgroundsUI();

  const TTips: Record<TTipCategory, ReactNode> = LoadToolTips([
    TTipCategory.TTTabAllYourBgs,
    TTipCategory.TTTabEveryBg,
  ]);

  // all your backgrounds are belong to us
  const tablist = [
    MakeTab(
      'YOURS',
      TTips[TTipCategory.TTTabAllYourBgs],
      'your_backgrounds',
      activeTab,
      setActiveTab,
    ),
    // MakeTab(
    //   'ALL',
    //   TTips[TTipCategory.TTTabEveryBg],
    //   'all_backgrounds',
    //   activeTab,
    //   setActiveTab,
    // ),
  ];
  for (const tab of data.server_tabs) {
    const tab_name = tab.replace(/_/g, ' ');
    const tab_slug = tab;
    const tab_tooltip = `This tab shows all of the ${tab_name} backgrounds available to you!`;
    tablist.push(
      MakeTab(tab_name, tab_tooltip, tab_slug, activeTab, setActiveTab),
    );
  }

  return (
    <Section fill fitted scrollable width="220px" height="100%">
      <Stack fill vertical pt="10px" pl="10px" pr="5px" g="3px">
        {tablist.map((tab) => (
          <Stack.Item shrink key={tab.key}>
            {tab}
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
}

enum EarlyAdultOrBoth {
  None,
  Early,
  Adult,
  Both,
}

const Num2WhichGot = (num: number): EarlyAdultOrBoth => {
  switch (num) {
    case 0:
      return EarlyAdultOrBoth.None;
    case 1:
      return EarlyAdultOrBoth.Early;
    case 2:
      return EarlyAdultOrBoth.Adult;
    case 3:
      return EarlyAdultOrBoth.Both;
    default:
      return EarlyAdultOrBoth.None;
  }
};

function BackgroundsStuff() {
  const { data } = useBackend<CharacterPreferencesData>();
  const { activeTab, searchQuery, setSearchQuery } = useBackgroundsUI();

  const bgSearch = createSearch(
    searchQuery,
    (bground: TemperamentBuild) => bground.name,
  );

  // yeah hey i dont know how memoization works but tyhe internet says this is how you do it so i did it
  const backgroundsToDisplay: TemperamentBuild[] = (() => {
    if (activeTab === 'your_backgrounds') {
      const playerBackgrounds = data.server_backgrounds.filter(
        (bg) =>
          data.player_early_backgrounds.some(
            (pbg: TemperamentBuild) => pbg.path === bg.path,
          ) ||
          data.player_adult_backgrounds.some(
            (pbg: TemperamentBuild) => pbg.path === bg.path,
          ),
      );
      return playerBackgrounds;
    } else if (searchQuery) {
      const allBackgrounds = [...data.server_backgrounds];
      return allBackgrounds.filter(bgSearch).slice(0, 30);
    } else {
      return data.server_backgrounds.filter(
        (bg) => bg.subcategory === activeTab,
      );
    }
  })();

  return (
    <Stack fill vertical overflow="hidden">
      <Stack.Item shrink mr="5px">
        <Input
          fluid
          value={searchQuery}
          onChange={setSearchQuery}
          placeholder="Background check..."
        />
      </Stack.Item>
      <Stack.Item grow>
        <Stack fill vertical overflow="hidden">
          <Stack.Item grow>
            <Section fill fitted scrollable mr="2px" ml="2px">
              <Box
                style={{
                  display: 'grid',
                  gridTemplateColumns: 'repeat(auto-fill, minmax(320px, 1fr))',
                  gridAutoRows: 'minmax(0, 1fr)',
                  alignItems: 'stretch',
                  gap: '6px',
                  paddingTop: '10px',
                  paddingLeft: '5px',
                  paddingRight: '5px',
                  paddingBottom: '10px',
                }}
              >
                {backgroundsToDisplay.length > 0 ? (
                  backgroundsToDisplay.map((bg) => (
                    <Box
                      key={bg.path}
                      style={{
                        display: 'flex',
                        alignItems: 'stretch',
                        height: '100%',
                        width: '100%',
                      }}
                    >
                      <BackgroundCard background={bg} />
                    </Box>
                  ))
                ) : (
                  <Box
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      width: '50%',
                      height: '150px',
                      color: GetColorFromMap(ColorMap.CardText),
                      backgroundColor: GetColorFromMap(ColorMap.CardBackground),
                      borderColor: GetColorFromMap(ColorMap.CardBorder),
                      borderWidth: BorderMap.CardBorderWidth,
                      borderRadius: BorderMap.CardBorderRadius,
                      borderStyle: 'solid',
                    }}
                  >
                    {'Nothing to see here! ♥'}
                  </Box>
                )}
              </Box>
            </Section>
          </Stack.Item>
          {/* <Stack.Item shrink>
            <PageControls />
          </Stack.Item> */}
        </Stack>
      </Stack.Item>
    </Stack>
  );
}

// ╔═════════════════════╗
// ║   HELPER PROCS !!   ║
// ╠═════════════════════╣
// ║   HELPER PROCS !!   ║
// ╠═════════════════════╣
// ║   HELPER PROCS !!   ║
// ╚═════════════════════╝

function MakeVerticallyAlignedText(text: ReactNode) {
  return (
    <Box
      style={{
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
      }}
    >
      {text}
    </Box>
  );
}

function BackgroundCard({ background }: { background: TemperamentBuild }) {
  const { data, act } = useBackend<CharacterPreferencesData>();

  const earlySelected = data.player_early_backgrounds.some(
    (pbg: TemperamentBuild) => pbg.path === background.path,
  );
  const adultSelected = data.player_adult_backgrounds.some(
    (pbg: TemperamentBuild) => pbg.path === background.path,
  );
  const isSelected = earlySelected || adultSelected;
  const TTips: Record<TTipCategory, ReactNode> = LoadToolTips([
    TTipCategory.TTEarlyInfo,
    TTipCategory.TTAdultInfo,
  ]);
  const earlyCounterState = earlySelected
    ? ButtState.Selected
    : GetCounterState(
        data.player_early_backgrounds.length,
        data.min_early_backgrounds,
        data.max_early_backgrounds,
      );
  const adultCounterState = adultSelected
    ? ButtState.Selected
    : GetCounterState(
        data.player_adult_backgrounds.length,
        data.min_adult_backgrounds,
        data.max_adult_backgrounds,
      );

  enum EarlyAdult {
    Early = 'E',
    Adult = 'A',
  }

  const clickBoy = (kind: EarlyAdult, counterState: ButtState) => {
    if (counterState !== ButtState.AtMax) {
      act('operate_csnip', {
        csnip_string_path: background.path,
        csnip_back_which: kind,
      });
    }
  };

  const earlyButtonText = earlySelected ? 'Remove Early' : 'Take As Early';
  const adultButtonText = adultSelected ? 'Remove Adult' : 'Take As Adult';

  const buttonCommonStyle = {
    textAlign: 'center' as const,
    borderWidth: '2px',
  };

  const buttonEarlyStyle = {
    fontSize: FontMap.CardEarlyButtonFontSize,
    fontWeight: FontMap.CardEarlyButtonFontWeight,
    ...buttonCommonStyle,
    backgroundColor: earlySelected
      ? GetColorFromMap(ColorMap.CardEarlyButtonSelectedBackground)
      : GetColorFromMap(ColorMap.CardEarlyButtonBackground),
    color: earlySelected
      ? GetColorFromMap(ColorMap.CardEarlyButtonSelectedText)
      : GetColorFromMap(ColorMap.CardEarlyButtonText),
    borderColor: earlySelected
      ? GetColorFromMap(ColorMap.CardEarlyButtonSelectedBorder)
      : GetColorFromMap(ColorMap.CardEarlyButtonBorder),
    borderWidth: BorderMap.CardEarlyBorderWidth,
    borderRadius: BorderMap.CardEarlyBorderRadius,
    borderStyle: 'solid',
    cursor: earlyCounterState === ButtState.AtMax ? 'not-allowed' : 'pointer',
  };

  const buttonAdultStyle = {
    fontSize: FontMap.CardAdultButtonFontSize,
    fontWeight: FontMap.CardAdultButtonFontWeight,
    ...buttonCommonStyle,
    backgroundColor: adultSelected
      ? GetColorFromMap(ColorMap.CardAdultButtonSelectedBackground)
      : GetColorFromMap(ColorMap.CardAdultButtonBackground),
    color: adultSelected
      ? GetColorFromMap(ColorMap.CardAdultButtonSelectedText)
      : GetColorFromMap(ColorMap.CardAdultButtonText),
    borderColor: adultSelected
      ? GetColorFromMap(ColorMap.CardAdultButtonSelectedBorder)
      : GetColorFromMap(ColorMap.CardAdultButtonBorder),
    borderWidth: BorderMap.CardAdultBorderWidth,
    borderRadius: BorderMap.CardAdultBorderRadius,
    borderStyle: 'solid',
    cursor: adultCounterState === ButtState.AtMax ? 'not-allowed' : 'pointer',
  };

  const EarlyButton = (
    <Button
      fluid
      style={buttonEarlyStyle}
      onClick={() => clickBoy(EarlyAdult.Early, earlyCounterState)}
      tooltip={TTips[TTipCategory.TTEarlyInfo]}
    >
      {MakeVerticallyAlignedText(earlyButtonText)}
    </Button>
  );

  const AdultButton = (
    <Button
      fluid
      style={buttonAdultStyle}
      onClick={() => clickBoy(EarlyAdult.Adult, adultCounterState)}
      tooltip={TTips[TTipCategory.TTAdultInfo]}
    >
      {MakeVerticallyAlignedText(adultButtonText)}
    </Button>
  );

  const cardBackgroundColor = isSelected
    ? GetColorFromMap(ColorMap.CardSelectedBackground)
    : GetColorFromMap(ColorMap.CardBackground);
  const cardTextColor = isSelected
    ? GetColorFromMap(ColorMap.CardSelectedText)
    : GetColorFromMap(ColorMap.CardText);
  const cardBorderColor = isSelected
    ? GetColorFromMap(ColorMap.CardSelectedBorder)
    : GetColorFromMap(ColorMap.CardBorder);

  const xtraFlavor = data.player_backgrounds[background.path]
    ? data.player_backgrounds[background.path]
    : null;

  const xtraButt = (
    <Button
      style={{
        backgroundColor: GetColorFromMap(ColorMap.CardBackground),
        color: GetColorFromMap(ColorMap.CardText),
        borderColor: GetColorFromMap(ColorMap.CardBorder),
        borderWidth: BorderMap.CardBorderWidth,
        borderRadius: BorderMap.CardBorderRadius,
        borderStyle: 'solid',
        cursor: 'pointer',
        padding: '3px',
        margin: '1px',
        gap: '2px',
        position: 'absolute',
        insetInlineEnd: '0px',
        insetBlockStart: '0px',
      }}
      color="primary"
      onClick={() =>
        act('operate_csnip', { bg_flavor_mod_path: background.path })
      }
      tooltip="Modify the specifics of this background to fit your character's story!"
    >
      {MakeVerticallyAlignedText(<Icon name="pen" size={0.8} />)}
    </Button>
  );

  return (
    <Box
      style={{
        backgroundColor: cardBackgroundColor,
        color: cardTextColor,
        borderColor: cardBorderColor,
        borderWidth: BorderMap.CardBorderWidth,
        borderRadius: BorderMap.CardBorderRadius,
        borderStyle: 'solid',
        position: 'relative',
        display: 'flex',
        flexDirection: 'column',
        height: '100%',
        width: '100%',
        textAlign: 'center',
        fontSize: FontMap.CardTextFontSize,
        fontWeight: FontMap.CardTextFontWeight,
        padding: '5px',
      }}
    >
      <Box
        style={{
          display: 'flex',
          flexDirection: 'column',
          flex: '1 1 auto',
          minHeight: 0,
          gap: '5px',
        }}
      >
        <Box
          style={{
            borderBottom: '1px solid',
            fontSize: '1.3rem',
            fontWeight: 'bold',
          }}
        >
          {xtraButt}
          {MakeVerticallyAlignedText(background.name)}
        </Box>
        <Box style={{ textAlign: 'left' }}>{background.desc}</Box>
        <Box style={{ flex: '1 1 auto' }} />
        {xtraFlavor && (
          <Box
            style={{
              borderTop: '1px solid',
              fontSize: '0.9rem',
              fontWeight: 'italic',
            }}
          >
            {xtraFlavor}
          </Box>
        )}
        <Box
          style={{
            display: 'flex',
            gap: '5px',
            marginTop: 'auto',
          }}
        >
          <Box style={{ flex: '1 1 0' }}>{EarlyButton}</Box>
          <Box style={{ flex: '1 1 0' }}>{AdultButton}</Box>
        </Box>
      </Box>
    </Box>
  );
}

function MakeTab(
  name: string,
  ttip: ReactNode,
  tabkey: string,
  activeTab: string,
  setActiveTab: (nextTab: string) => void,
) {
  const seld = activeTab === tabkey;
  const tabColor = seld
    ? GetColorFromMap(ColorMap.TabSelectedBackground)
    : GetColorFromMap(ColorMap.TabBackground);
  const tabBorderColor = seld
    ? GetColorFromMap(ColorMap.TabSelectedBorder)
    : GetColorFromMap(ColorMap.TabBorder);
  const tabTextColor = seld
    ? GetColorFromMap(ColorMap.TabSelectedText)
    : GetColorFromMap(ColorMap.TabText);

  const textMagic = () => {
    // Split labels like "foo: bar" and center the separator exactly at 50%.
    if (name.includes(': ')) {
      const [first, second] = name.split(/\s*: \s*/, 2);

      if (!first || !second) {
        return MakeVerticallyAlignedText(name);
      }

      return (
        <Box
          style={{
            display: 'grid',
            gridTemplateColumns: '1fr auto 1fr',
            alignItems: 'center',
            height: '100%',
            width: '100%',
            columnGap: '4px',
          }}
        >
          <Box style={{ flex: '1 1 auto', textAlign: 'right' }}>
            {MakeVerticallyAlignedText(first)}
          </Box>
          <Box style={{ textAlign: 'center' }}>
            {MakeVerticallyAlignedText('║')}
          </Box>
          <Box style={{ flex: '1 1 auto', textAlign: 'left' }}>
            {MakeVerticallyAlignedText(second)}
          </Box>
        </Box>
      );
    }
    return MakeVerticallyAlignedText(name);
  };

  return (
    <Button
      key={tabkey}
      fontSize="12px"
      style={{
        color: tabTextColor,
        borderColor: tabBorderColor,
        borderWidth: BorderMap.TabBorderWidth,
        borderRadius: BorderMap.TabBorderRadius,
        borderStyle: 'solid',
        backgroundColor: tabColor,
      }}
      onClick={() => setActiveTab(tabkey)}
      tooltip={ttip}
      textAlign="center"
      fluid
    >
      {textMagic()}
    </Button>
  );
}
function MakeCounterBox(
  count: number,
  max: number,
  state: ButtState,
  tooltip: ReactNode,
) {
  let textColor: string;
  let backgroundColor: string;
  let borderColor: string;
  switch (state) {
    case ButtState.NeedsMore:
      textColor = GetColorFromMap(ColorMap.CounterNeedMoreText);
      backgroundColor = GetColorFromMap(ColorMap.CounterNeedMoreBackground);
      borderColor = GetColorFromMap(ColorMap.CounterNeedMoreBorder);
      break;
    case ButtState.AtMax:
      textColor = GetColorFromMap(ColorMap.CounterAtMaxText);
      backgroundColor = GetColorFromMap(ColorMap.CounterAtMaxBackground);
      borderColor = GetColorFromMap(ColorMap.CounterAtMaxBorder);
      break;
    default:
      textColor = GetColorFromMap(ColorMap.CounterText);
      backgroundColor = GetColorFromMap(ColorMap.CounterBackground);
      borderColor = GetColorFromMap(ColorMap.CounterBorder);
      break;
  }
  const superstyle = {
    width: '150px',
    height: '100%',
    backgroundColor: backgroundColor,
    color: textColor,
    borderColor: borderColor,
    borderWidth: BorderMap.CounterBorderWidth,
    borderRadius: BorderMap.CounterBorderRadius,
    borderStyle: 'solid',
    textAlign: 'center' as const,
    fontSize: FontMap.CounterFontSize,
    fontWeight: FontMap.CounterFontWeight,
    wordBreak: 'keep-all' as const,
    padding: 'var(--space-sm) var(--space-m)',
    marginBottom: 'var(--space-m)',
  };

  return (
    <Tooltip content={tooltip}>
      {state === ButtState.NeedsMore ? (
        <NoticeBox style={superstyle} info>
          {MakeVerticallyAlignedText(`${count} / ${max}`)}
        </NoticeBox>
      ) : (
        <Box style={superstyle}>
          {MakeVerticallyAlignedText(`${count} / ${max}`)}
        </Box>
      )}
    </Tooltip>
  );
}

function LoadToolTips(
  types: TTipCategory[],
  butt_state?: ButtState,
  butt_state2?: ButtState,
): Record<TTipCategory, ReactNode> {
  const { data } = useBackend<CharacterPreferencesData>();

  const TTips: Record<TTipCategory, ReactNode> = {} as Record<
    TTipCategory,
    ReactNode
  >;

  const extraData: TTipExtraData = {
    earlyCount: data.player_early_backgrounds?.length || 0,
    earlyMaxCount: data.max_early_backgrounds || 0,
    earlyMinCount: data.min_early_backgrounds || 0,

    adultCount: data.player_adult_backgrounds?.length || 0,
    adultMaxCount: data.max_adult_backgrounds || 0,
    adultMinCount: data.min_adult_backgrounds || 0,

    count:
      data.player_early_backgrounds?.length +
        data.player_adult_backgrounds?.length || 0,
  };

  for (const type of types) {
    let resultTTContentType: TTipContentType;

    // TTGenInfo,
    // TTEarlyInfo,
    // TTAdultInfo,
    switch (type) {
      case TTipCategory.TTGenInfo:
        resultTTContentType = TTipContentType.HelpGeneral;
        break;
      case TTipCategory.TTEarlyInfo:
        resultTTContentType = TTipContentType.HelpEarly;
        break;
      case TTipCategory.TTAdultInfo:
        resultTTContentType = TTipContentType.HelpAdult;
        break;
      case TTipCategory.TTCountEarly:
        switch (butt_state) {
          case ButtState.NeedsMore:
            resultTTContentType = TTipContentType.EarlyCounterNeedMore;
            break;
          case ButtState.AtMax:
            resultTTContentType = TTipContentType.EarlyCounterAtMax;
            break;
          default:
            resultTTContentType = TTipContentType.EarlyCounter;
            break;
        }
        break;
      case TTipCategory.TTCountAdult:
        switch (butt_state2) {
          case ButtState.NeedsMore:
            resultTTContentType = TTipContentType.AdultCounterNeedMore;
            break;
          case ButtState.AtMax:
            resultTTContentType = TTipContentType.AdultCounterAtMax;
            break;
          default:
            resultTTContentType = TTipContentType.AdultCounter;
            break;
        }
        break;
      case TTipCategory.TTClearAll:
        resultTTContentType = TTipContentType.AllClearButton;
        break;
      case TTipCategory.TTClearEarly:
        resultTTContentType = TTipContentType.EarlyClearButton;
        break;
      case TTipCategory.TTClearAdult:
        resultTTContentType = TTipContentType.AdultClearButton;
        break;
      case TTipCategory.TTButtonEarly:
        switch (butt_state) {
          case ButtState.Fine:
            resultTTContentType = TTipContentType.EarlyButton;
            break;
          case ButtState.AtMax:
            resultTTContentType = TTipContentType.EarlyButtonDisabled;
            break;
          default:
            resultTTContentType = TTipContentType.EarlyButton;
            break;
        }
        break;
      case TTipCategory.TTButtonAdult:
        switch (butt_state2) {
          case ButtState.Fine:
            resultTTContentType = TTipContentType.AdultButton;
            break;
          case ButtState.AtMax:
            resultTTContentType = TTipContentType.AdultButtonDisabled;
            break;
          default:
            resultTTContentType = TTipContentType.AdultButton;
            break;
        }
        break;
      case TTipCategory.TTTabAllYourBgs:
        resultTTContentType = TTipContentType.TabAllYourBgs;
        break;
      case TTipCategory.TTTabEveryBg:
        resultTTContentType = TTipContentType.TabEveryBg;
        break;
      default:
        resultTTContentType = TTipContentType.HelpGeneral;
        break;
    }
    TTips[type] = GetToolTipFor(resultTTContentType, extraData);
  }
  return TTips;
}

function GetToolTipFor(
  type: TTipContentType,
  extraData: TTipExtraData,
): ReactNode {
  switch (type) {
    case TTipContentType.HelpGeneral:
      return (
        <>
          <p>
            {`Did you know: 83.5% of roleplayers don't really define their character beyond their name, species, job, and kinks! `}
          </p>
          <p>
            {`Welcome to the backgrounds section! Here you can select your character's early and adult backgrounds. `}
            {`These are generalized segments of your character's life that can help flesh out their backstory! `}
            {`These backgrounds can be used to help define your character's personality, motivations, goals, and relationships! `}
          </p>
          <p>
            {`Note that these backgrounds have no mechanical effect ingame, and are purely for roleplay purposes. `}
            {`(I mean in a way, your character's backstory does affect how they act and react to situations, which is pretty mechanical!)`}
          </p>
          <p>
            {`You must select at least ${extraData?.earlyMinCount} early backgrounds and ${extraData?.adultMinCount} adult backgrounds. `}
          </p>
        </>
      );
    case TTipContentType.HelpEarly:
      return (
        <>
          <p>
            {`Early backgrounds are generalized segments of your character's early life, from birth to around adolescence. `}
          </p>
          <p>
            {`Where did your character grow up? What was their family like? What were their early experiences and influences? `}
            {`What kind of person were they before they became who they are now?`}
          </p>
          <p>
            {`You must select at least ${extraData?.earlyMinCount} early backgrounds. `}
          </p>
        </>
      );
    case TTipContentType.HelpAdult:
      return (
        <>
          <p>
            {`Adult backgrounds are generalized segments of your character's adult life, from adolescence to the present. `}
          </p>
          <p>
            {`What did your character do after they grew up? What were their experiences and influences as an adult? `}
            {`What kind of person are they now, and how did they become that way?`}
          </p>
          <p>
            {`You must select at least ${extraData?.adultMinCount} adult backgrounds. `}
          </p>
        </>
      );
    case TTipContentType.EarlyCounter:
      return (
        <p>
          {`You have selected ${extraData?.earlyCount} early backgrounds! `}
          {`You can select some more if you want! `}
        </p>
      );
    case TTipContentType.AdultCounter:
      return (
        <p>
          {`You have selected ${extraData?.adultCount} adult backgrounds! `}
          {`You can select some more if you want! `}
        </p>
      );
    case TTipContentType.EarlyCounterNeedMore:
      return (
        <p>
          {`You have selected ${extraData?.earlyCount} early backgrounds! `}
          {`You must select at least ${extraData?.earlyMinCount} early backgrounds to join the game! `}
        </p>
      );
    case TTipContentType.AdultCounterNeedMore:
      return (
        <p>
          {`You have selected ${extraData?.adultCount} adult backgrounds! `}
          {`You must select at least ${extraData?.adultMinCount} adult backgrounds to join the game! `}
        </p>
      );
    case TTipContentType.EarlyCounterAtMax:
      return (
        <p>
          {`You have selected ${extraData?.earlyCount} early backgrounds! `}
          {`You have reached the maximum number of ${extraData?.earlyMaxCount} early backgrounds! `}
        </p>
      );
    case TTipContentType.AdultCounterAtMax:
      return (
        <p>
          {`You have selected ${extraData?.adultCount} adult backgrounds! `}
          {`You have reached the maximum number of ${extraData?.adultMaxCount} adult backgrounds! `}
        </p>
      );
    case TTipContentType.EarlyButtonDisabled:
      return (
        <p>
          {`You have selected the maximum number of early backgrounds! `}
          {`You cannot select any more early backgrounds! At least not until you deselect some! `}
        </p>
      );
    case TTipContentType.AdultButtonDisabled:
      return (
        <p>
          {`You have selected the maximum number of adult backgrounds! `}
          {`You cannot select any more adult backgrounds! At least not until you deselect some! `}
        </p>
      );
    case TTipContentType.AllClearButton:
      return (
        <p>
          {`Clicking this button will deselect all of your selected early and adult backgrounds! `}
        </p>
      );
    case TTipContentType.EarlyClearButton:
      return (
        <p>
          {`Clicking this button will deselect all of your selected early backgrounds! `}
        </p>
      );
    case TTipContentType.AdultClearButton:
      return (
        <p>
          {`Clicking this button will deselect all of your selected adult backgrounds! `}
        </p>
      );
    case TTipContentType.TabAllYourBgs:
      return (
        <>
          <p>
            {`This tab shows all of your selected early and adult backgrounds! `}
          </p>
          <p>
            {`You've selected ${extraData.earlyCount} early backgrounds and ${extraData.adultCount} adult backgrounds! `}
          </p>
        </>
      );
    case TTipContentType.TabEveryBg:
      return (
        <>
          <p>
            {`This tab shows all of the early and adult backgrounds available to you! `}
          </p>
          <p>
            {`You can select up to ${extraData.earlyMaxCount} early backgrounds and ${extraData.adultMaxCount} adult backgrounds! `}
          </p>
        </>
      );
    default:
      return <p>{`This is a cool tooltip! Could say its a cooltip! `}</p>;
  }
}

function GetCounterState(
  count: number,
  minimo: number | undefined,
  maximo: number,
): ButtState {
  if (count >= maximo) {
    return ButtState.AtMax;
  } else if (minimo !== undefined && count < minimo) {
    return ButtState.NeedsMore;
  } else {
    return ButtState.Fine;
  }
}
