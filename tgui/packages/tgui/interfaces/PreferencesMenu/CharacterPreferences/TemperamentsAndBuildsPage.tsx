import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  NoticeBox,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import type { PreferencesMenuData, TemperamentBuild } from '../types';

export function TemperamentsAndBuildsPage() {
  // the actual menu
  // dicolumnar terraflex abjugar
  return (
    <Stack fill overflow="hidden" g={1}>
      <Stack.Item basis="50%">{tnbColumn('Temperaments')}</Stack.Item>
      <Stack.Item basis="50%">{tnbColumn('Builds')}</Stack.Item>
    </Stack>
  );
}

// list of sys_tnbs that are in a set that the player has already selected a tnb from
type SetReplacementThing = {
  player_tnb_path: string;
  server_tnb_path: string;
  // the name of the tnb that would be replaced if the player clicked on this tnb
  replaced_tnb_name: string;
};

function tnbColumn(category: 'Temperaments' | 'Builds') {
  const { act, data } = useBackend<PreferencesMenuData>();

  // serverside static-ish data
  const sys_tnbs_raw =
    category === 'Temperaments' ? data.server_temperaments : data.server_builds;
  const max4cat =
    category === 'Temperaments' ? data.max_temperaments : data.max_builds;

  //presort the server tnb list by set_key and then by order
  //then sort everything that doesnt have a set_key alphabetically by name
  //then insert the set_key groups into the second list, still grouped, by set_key
  const grouped_sys_tnbs: Record<string, TemperamentBuild[]> = {};
  const ungrouped_sys_tnbs: TemperamentBuild[] = [];
  for (const tnb of sys_tnbs_raw) {
    if (tnb.set_key) {
      if (!grouped_sys_tnbs[tnb.set_key]) {
        grouped_sys_tnbs[tnb.set_key] = [];
      }
      grouped_sys_tnbs[tnb.set_key].push(tnb);
    } else {
      ungrouped_sys_tnbs.push(tnb);
    }
  }
  for (const set_key in grouped_sys_tnbs) {
    grouped_sys_tnbs[set_key].sort((a, b) => a.order - b.order);
  }
  ungrouped_sys_tnbs.sort((a, b) => a.name.localeCompare(b.name));
  const sys_tnbs: TemperamentBuild[] = [
    ...ungrouped_sys_tnbs,
    ...Object.values(grouped_sys_tnbs).flat(),
  ];

  // playerside chosem data
  const char_tnbs =
    category === 'Temperaments' ? data.player_temperaments : data.player_builds;

  const char_tnb_count = char_tnbs?.length || 0;
  const max_tnb = max4cat === -1 ? '∞' : max4cat;
  const has_max_tnb = max4cat !== -1 && char_tnb_count >= max4cat;
  const has_this_tnb = (tnb: TemperamentBuild) =>
    char_tnbs?.some((char_tnb) => char_tnb.name === tnb.name);
  const sys_tnbs_minus_char_tnbs = sys_tnbs.filter(
    (sys_tnb) => !has_this_tnb(sys_tnb),
  );

  function getSetKeyInfo(tnb: TemperamentBuild): SetReplacementThing | null {
    if (!tnb.set_key) return null;
    const player_tnb_in_set = char_tnbs.find(
      (char_tnb) => char_tnb.set_key === tnb.set_key,
    );
    if (!player_tnb_in_set) return null;
    return {
      player_tnb_path: player_tnb_in_set.path,
      server_tnb_path: tnb.path,
      replaced_tnb_name: player_tnb_in_set.name,
    };
  }

  const catDescription =
    category === 'Temperaments'
      ? 'Temperaments describe the general personality vibe your ' +
        'character gives off to other people at a glance. Like someone would ' +
        'take a look at you and say, wow, that person is brooding as heck! ' +
        'Note that none of these have any actual mechanical effect on ' +
        'your character, it is purely for flavor and roleplay purposes.'
      : 'Builds describe the general physical traits of your character, ' +
        'highlighting the most prominent features. Like someone would take a ' +
        'look at you and say, wow, that person is REALLY buttsome! ' +
        'Note that none of these have any actual mechanical effect on ' +
        'your character, it is purely for flavor and roleplay purposes.';

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section fitted>
          {/* The info header */}
          <Stack align="center" fill bold>
            <Stack.Item shrink fontSize="32px">
              <Tooltip content={catDescription} position="bottom">
                <Icon name="circle-question" color="yellow" p={2} />
              </Tooltip>
            </Stack.Item>
            <Stack.Item grow align="center">
              <Stack vertical>
                <Stack.Item
                  grow
                  verticalAlign="center"
                  textAlign="center"
                  fontSize="24px"
                >
                  <Box>{category}</Box>
                </Stack.Item>
                {(max4cat > 0 && has_max_tnb && (
                  <Stack.Item grow align="center" width="100%">
                    <NoticeBox
                      mb={1}
                      color="yellow"
                      width="100%"
                      textAlign="center"
                      fontSize="14px"
                    >
                      You have {char_tnb_count} / {max_tnb} {category} selected!
                    </NoticeBox>
                  </Stack.Item>
                )) || (
                  <Stack.Item grow align="center" width="100%">
                    <Box mb={1} width="100%" textAlign="center">
                      You have {char_tnb_count} / {max_tnb} {category} selected.
                    </Box>
                  </Stack.Item>
                )}
              </Stack>
            </Stack.Item>
            <Stack.Item shrink>
              <Button
                color="red"
                icon="trash"
                fontSize="32px"
                disabled={!char_tnb_count}
                style={{
                  cursor: char_tnb_count ? 'pointer' : undefined,
                }}
                onClick={() => {
                  act('operate_tnb', {
                    tnb_clear_cat: category === 'Temperaments' ? 'T' : 'B',
                  });
                }}
                tooltip={`Clear all ${category}`}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack vertical fill>
            {/* The actual list of stuff */}
            <Stack.Item grow>
              <Stack vertical fill>
                <Stack vertical g={0}>
                  {char_tnbs.map((tnb) => (
                    <Stack.Item key={tnb.name}>
                      <TemperamentBuildButton
                        onClick={() => {
                          act('operate_tnb', {
                            tnb_string_path: tnb.path,
                          });
                        }}
                        whichTnb={tnb}
                        maxTnbCategory={max4cat}
                        hasMax={has_max_tnb}
                        hasThis={has_this_tnb(tnb)}
                        wouldReplace={getSetKeyInfo(tnb)}
                      />
                    </Stack.Item>
                  ))}
                  {sys_tnbs_minus_char_tnbs.map((tnb) => (
                    <Stack.Item key={tnb.name}>
                      <TemperamentBuildButton
                        onClick={() => {
                          act('operate_tnb', {
                            tnb_string_path: tnb.path,
                          });
                        }}
                        whichTnb={tnb}
                        maxTnbCategory={max4cat}
                        hasMax={has_max_tnb}
                        hasThis={has_this_tnb(tnb)}
                        wouldReplace={getSetKeyInfo(tnb)}
                      />
                    </Stack.Item>
                  ))}
                </Stack>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
}

type ButtonProps = {
  whichTnb: TemperamentBuild & {
    max_temperaments?: number;
    max_builds?: number;
  };
  maxTnbCategory: number;
  hasMax: boolean;
  hasThis: boolean;
  onClick: () => void;
  wouldReplace: SetReplacementThing | null;
};

function TemperamentBuildButton(props: ButtonProps) {
  const { whichTnb, maxTnbCategory, hasMax, hasThis, wouldReplace, onClick } =
    props;

  const maxDisplay = maxTnbCategory === -1 ? '∞' : maxTnbCategory;
  const diabolest = !!(hasMax && !hasThis);
  // i cant fukcin remember how i spelled the damn categories
  const trueCat = whichTnb.category.toLowerCase().startsWith('t')
    ? 'Temperment'
    : whichTnb.category.toLowerCase().startsWith('b')
      ? 'Build'
      : 'Unknown';

  const hadesolen = !!wouldReplace;

  const seld = hasThis;

  enum ColorState {
    default = 'default',
    selosted = 'selosted',
    diabolest = 'diabolest',
    hadesolen = 'hadesolen',
  }
  enum TnbCategory {
    Temperament = 'Temperment',
    Build = 'Build',
    Unknown = 'Unknown',
  }
  //priorities: seld > hadesolen > diabolest > default
  const whichState = seld
    ? ColorState.selosted
    : hadesolen
      ? ColorState.hadesolen
      : diabolest
        ? ColorState.diabolest
        : ColorState.default;

  const categorio =
    trueCat === 'Temperment'
      ? TnbCategory.Temperament
      : trueCat === 'Build'
        ? TnbCategory.Build
        : TnbCategory.Unknown;

  type ColorPalette = {
    default: string;
    selosted: string;
    diabolest: string;
    hadesolen: string;
  };

  const bgColorPalette: Record<TnbCategory, ColorPalette> = {
    Temperment: {
      default: 'hsla(247, 100%, 20%, 0.50)',
      selosted: 'hsla(247, 100%, 65%, 0.50)',
      diabolest: 'hsla(247, 25%, 20%, 0.50)',
      hadesolen: 'hsla(200, 100%, 20%, 0.50)',
    },
    Build: {
      default: 'hsla(284, 100%, 20%, 0.50)',
      selosted: 'hsla(284, 100%, 65%, 0.50)',
      diabolest: 'hsla(284, 25%, 20%, 0.50)',
      hadesolen: 'hsla(175, 100%, 20%, 0.50)',
    },
    Unknown: {
      default: 'hsla(0, 0%, 0%, 0.50)',
      selosted: 'hsla(0, 0%, 0%, 0.50)',
      diabolest: 'hsla(0, 0%, 0%, 0.50)',
      hadesolen: 'hsla(0, 0%, 0%, 0.50)',
    },
  };

  const borderColorPalette: Record<TnbCategory, ColorPalette> = {
    Temperment: {
      default: 'hsla(247, 100%, 20%, 1.00)',
      selosted: 'hsla(247, 100%, 65%, 1.00)',
      diabolest: 'hsla(247, 25%, 20%, 1.00)',
      hadesolen: 'hsla(200, 100%, 20%, 1.00)',
    },
    Build: {
      default: 'hsla(284, 100%, 20%, 1.00)',
      selosted: 'hsla(284, 100%, 65%, 1.00)',
      diabolest: 'hsla(284, 25%, 20%, 1.00)',
      hadesolen: 'hsla(175, 100%, 20%, 1.00)',
    },
    Unknown: {
      default: 'rgb(0, 0, 0)',
      selosted: 'rgb(0, 0, 0)',
      diabolest: 'rgb(0, 0, 0)',
      hadesolen: 'rgb(0, 0, 0)',
    },
  };

  type TooltipPalette = {
    default: string;
    selosted: string;
    diabolest: string;
    hadesolen: string;
  };

  const tooltipPalette: TooltipPalette = {
    default: `Click to select this ${categorio}!`,
    selosted: `Click to remove this ${categorio}!`,
    diabolest: `You already have ${maxDisplay} ${categorio}(s)!`,
    hadesolen: `You already have a similar ${categorio}! Clicking this will replace ${wouldReplace?.replaced_tnb_name} with this!`,
  };

  const backgroundColor = bgColorPalette[categorio][whichState];
  const borderColor = borderColorPalette[categorio][whichState];
  const tooltip = tooltipPalette[whichState];

  return (
    <Button
      onClick={onClick}
      style={{
        cursor: 'pointer',
        borderColor: borderColor,
        borderStyle: 'solid',
        borderWidth: '0.2em',
        borderRadius: '0.33em',
        margin: '0.2em',
        padding: '0.2em',
      }}
      fluid
      minHeight="120px"
      backgroundColor={backgroundColor}
      tooltip={tooltip}
    >
      <Stack vertical wrap justify="center">
        <Stack.Item
          textAlign="center"
          bold
          fontSize="16px"
          inline
          p={0.5}
          style={{
            whiteSpace: 'normal',
            wordBreak: 'break-word',
            paddingLeft: '0.5em',
          }}
        >
          {whichTnb.name}
        </Stack.Item>
        <Stack.Item
          color="#999999"
          mt={-1}
          pt={0.2}
          style={{
            whiteSpace: 'normal',
            wordBreak: 'break-word',
            borderTop: '0.2em solid #444444',
            borderLeft: '0.2em solid #444444',
            paddingLeft: '0.5em',
          }}
        >
          {whichTnb.desc}
        </Stack.Item>
        <Stack.Item
          color="#999999"
          mt={-1}
          pt={0.2}
          style={{
            whiteSpace: 'normal',
            wordBreak: 'break-word',
            borderTop: '0.2em solid #444444',
            borderLeft: '0.2em solid #444444',
            paddingLeft: '0.5em',
          }}
        >
          {whichTnb.example}
        </Stack.Item>
      </Stack>
    </Button>
  );
}
