import { useState } from 'react';
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
import type { PreferencesMenuData, TemperamentBuild } from '../types';
import { useServerPrefs } from '../useServerPrefs';

export function TemperamentsAndBuildsPage() {
  // the actual menu
  // dicolumnar terraflex abjugar
  return (
    <Section fill>
      <Stack fill>
        <Stack.Item basis="50%" mr={0.5}>
          {tnbColumn('Temperaments')}
        </Stack.Item>
        <Stack.Item basis="50%" ml={0.5}>
          {tnbColumn('Builds')}
        </Stack.Item>
      </Stack>
    </Section>
  );
}

function tnbColumn(
  category: "Temperaments" | "Builds",
) {
  const { act, data } = useBackend<PreferencesMenuData>();

  const server_data = useServerPrefs();
  if (!server_data)
    return;

  // serverside static-ish data
  const sys_tnbs = category === 'Temperaments'
    ? server_data.tnb.temperaments
    : server_data.tnb.builds;
  const max4cat = category === 'Temperaments'
    ? server_data.tnb.max_temperaments
    : server_data.tnb.max_builds;

  // playerside chosem data
  const char_tnbs = category === 'Temperaments'
    ? data.temperaments
    : data.builds;

  const char_tnb_count = char_tnbs?.length || 0;
  const max_tnb = max4cat === -1 ? '∞' : max4cat;
  const has_max_tnb = max4cat !== -1 && char_tnb_count >= max4cat;

  // t or b searchamus
  const [tnbSearchQuery, setTnbSearchQuery] = useState('');
  const tnbSearch = createSearch(
    tnbSearchQuery,
    (tnb: TemperamentBuild) =>
      tnb.name + tnb.description + tnb.example,
  );
  const filteredTemperaments = sys_tnbs
    .filter(tnbSearch)
    .sort((a, b) => sortTnB(a, b, char_tnbs));

  const clearTerm = category === 'Temperaments'
    ? 'clear_temperaments'
    : 'clear_builds';

  const title = category === 'Temperaments'
    ? 'Temperaments'
    : 'Builds';

  const catDescription = category === 'Temperaments'
    ? "Temperaments describe the general personality vibe your "
      + "character gives off to other people at a glance. Like someone would "
      + "take a look at you and say, wow, that person is brooding as heck!"
    : "Builds describe the general physical traits of your character, "
      + "highlighting the most prominent features. Like someone would take a "
      + "look at you and say, wow, that person is REALLY buttsome!";

  return (
    <Section
      fill
      scrollable
      title={title}
      >
    <Stack vertical fill>
      <Stack.Item
        align="center"
        textAlign="center"
        fontSize="20px"
        bold
        width="100%"
        maxHeight="50px"
        style={{
          whiteSpace: 'normal',
          wordBreak: 'break-word',
        }}
      >
        <Stack vertical>
          <Stack.Item>
            <Stack align="center" justify="center">
              <Stack.Item shrink>
                <Tooltip
                  content={catDescription}
                  position="bottom"
                >
                  <Icon name="info-circle" color="yellow" />
                </Tooltip>
              </Stack.Item>
              <Stack.Item grow>
                <Box>
                  You can select up to {max_tnb} {category}(s) for your character.
                </Box>
              </Stack.Item>
              <Stack.Item shrink>
                <Button
                  color="red"
                  icon="trash"
                  disabled={!char_tnb_count}
                  style={{
                    cursor: char_tnb_count ? 'pointer' : undefined,
                  }}
                  onClick={() => {
                    act(clearTerm);
                  }}
                  tooltip={`Clear all ${category}s`} />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          {has_max_tnb && (
            <NoticeBox mb={1} color="yellow">
              You have reached the maximum number of {category}s!
            </NoticeBox>
          )}
          <Stack.Item>
            <Input
              value={tnbSearchQuery}
              onChange={setTnbSearchQuery}
              placeholder={`Search ${category}s...`}
              width="100%"
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      {/* The actual list of stuff */}
      <Stack.Item grow>
        <Stack vertical fill>
          <Stack vertical g={0}>
            {filteredTemperaments.map((tnb) => (
              <Stack.Item key={tnb.name} m={0}>
                <TemperamentBuildButton
                  onClick={() => {
                    act('toggle_tnb', {
                      tnb_path: tnb.path,
                    });
                  }}
                  whichTnb={tnb}
                  playerTnbs={char_tnbs}
                  max4cat={max4cat}
                />
              </Stack.Item>
            ))}
          </Stack>
        </Stack>
      </Stack.Item>
    </Stack>
  </Section>
  );
}



type ButtonData = {
  backgroundColor: string;
  borderColor: string;
  tooltip: string | null;
};

function getButtonColors(
  selected: boolean | undefined,
  disabled: boolean | undefined, // too many in a categorty
  category: string  | undefined, // "Temperament" or "Build"
  max4cat:  number  | undefined, // max temperaments or builds
): ButtonData {
  if (selected) {
    disabled = false; // selected overrides disabled
  }
  if (disabled) {
    return {
      backgroundColor: 'rgba(64, 64, 64, 0.5)',
      borderColor: '#666666',
      tooltip: `You already have ${max4cat} ${category}(s)!`,
    };
  }
  if (selected) {
    return {
      backgroundColor: 'rgba(144, 255, 144, 0.5)',
      borderColor: 'green',
      tooltip: `Click to remove this ${category}!`,
    };
  }
  return {
    backgroundColor: 'rgba(34, 34, 34, 0.5)',
    borderColor: '#444444',
    tooltip: `Click to select this ${category}!`,
  };
}

type ButtonProps = {
  whichTnb: TemperamentBuild & {
    max_temperaments?: number;
    max_builds?: number;
  };
  playerTnbs: TemperamentBuild[] | null;
  max4cat: number | undefined;
  onClick: () => void;
};

function TemperamentBuildButton(props: ButtonProps) {
  const {
    whichTnb,
    playerTnbs,
    max4cat,
    onClick
  } = props;

  const nonNullPlayerTnbs = playerTnbs || [];
  const numInCategory = nonNullPlayerTnbs.filter((tnb) =>
    tnb.category === whichTnb.category).length || 0;
  const isInf = max4cat === -1 || max4cat === undefined;
  const selected = nonNullPlayerTnbs.includes(whichTnb);
  const isDisabled = !isInf && !selected && numInCategory >= max4cat!;
  const { backgroundColor, borderColor, tooltip } = getButtonColors(
    selected,
    isDisabled,
    whichTnb.category,
    max4cat,
  );
  return (
    <Button
      onClick={isDisabled ? undefined : onClick}
      p={1}
      pt={0.2}
      style={{
        cursor: isDisabled ? undefined : 'pointer',
        borderColor: borderColor,
        borderStyle: 'solid',
        borderWidth: '0.2em',
        borderRadius: '0.33em',
      }}
      fluid
      height="180px"
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
          {whichTnb.description}
        </Stack.Item>
      </Stack>
    </Button>
  );
}

// Sort by selected first, then by name
function sortTnB(
  a: TemperamentBuild,
  b: TemperamentBuild,
  selectedPersonalities: TemperamentBuild[] | null,
) {
  const aSelected = selectedPersonalities?.includes(a);
  const bSelected = selectedPersonalities?.includes(b);

  if (aSelected && !bSelected) return -1;
  if (!aSelected && bSelected) return 1;

  return a.name < b.name ? -1 : 1;
}
