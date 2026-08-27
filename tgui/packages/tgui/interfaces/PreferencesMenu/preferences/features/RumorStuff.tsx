import { useBackend } from 'tgui/backend';
import { Box, Button, Stack } from 'tgui-core/components';
import {
  MiniButtonStyle,
  RumorActKeys,
  RumorColorSet,
  type RumorData,
  RumorPosition,
  type RumorSlotData,
  RumorTooltipCategory,
} from '../../../RumorMuncher2000/types';
import type { PreferencesMenuData } from '../../types';
import type { Feature, FeatureValueProps } from './base';

// cool type, bro. undefined, undefined, undefined, really helpful
export type FeatureRumorManager = Feature<undefined, undefined, undefined>;

export function RumorManager(
  props: FeatureValueProps<undefined, undefined, undefined>, // sike we arent using any of em
) {
  // middleware will handle everything
  const { act, data } = useBackend<PreferencesMenuData>();

  if (!data) {
    return <Box>Loading...</Box>;
  }

  const myRumorSlot: RumorSlotData = data.player_rumor_slot;
  const rumors: RumorData[] = myRumorSlot?.rumors;

  const chungusblockStyle = {
    display: 'flex',
    flexDirection: 'column' as const,
    gap: '0.5em',
    margin: '0.5em 0px',
  };

  const copyAllButton = (
    <Button
      style={MiniButtonStyle}
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.CopyAll,
        });
      }}
    >
      📋
    </Button>
  );

  const pasteButton = (
    <Button
      style={MiniButtonStyle}
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.Paste,
        });
      }}
    >
      📋
    </Button>
  );

  return (
    <div>
      <Stack vertical fill>
        <Stack.Item>
          <div style={{ display: 'flex', flexDirection: 'row', gap: '0.5em' }}>
            <div>Copy All:</div>
            {copyAllButton}
            <div>Paste:</div>
            {pasteButton}
          </div>
        </Stack.Item>
        {rumors?.length === 0 && (
          <Stack.Item>
            <Box>
              Word around the station is quiet about this character, though that
              may change if you add some rumors! Rumors are visible on your
              examine window, and may be spread to other players via the event
              system.
            </Box>
          </Stack.Item>
        )}
        {rumors?.map((rumor: RumorData) => (
          <Stack.Item key={rumor.uid}>
            <RumorItem rumham={rumor} />
          </Stack.Item>
        ))}
        <Stack.Item>
          <Button
            style={chungusblockStyle}
            fluid
            onClick={() => {
              act(RumorActKeys.Invoke, {
                [RumorActKeys.Action]: RumorActKeys.Add,
              });
            }}
          >
            + Add Rumor
          </Button>
        </Stack.Item>
      </Stack>
    </div>
  );
}

type RumorTTprops = {
  category: RumorTooltipCategory;
  isHorny?: boolean;
  isPublic?: boolean;
  isSpecifiable?: boolean;
  position?: RumorPosition;
};

// one singular rumor item, with the text and the horny status and the position
// and the buttons to edit the text, toggle the horny status, and delete the rumor
// and the position buttons to move it up or down, and and and and and
function RumorItem({ rumham }: { rumham: RumorData }) {
  const { uid, text, horny, position } = rumham;
  const { act } = useBackend<PreferencesMenuData>();

  const hornyTT = GetRumorTooltipText({
    category: RumorTooltipCategory.ToggleNSFW,
    isHorny: horny,
  });
  const deleteTT = GetRumorTooltipText({
    category: RumorTooltipCategory.Delete,
  });
  const upTT = GetRumorTooltipText({
    category: RumorTooltipCategory.MoveUp,
    position: position,
  });
  const downTT = GetRumorTooltipText({
    category: RumorTooltipCategory.MoveDown,
    position: position,
  });
  const publicTT = GetRumorTooltipText({
    category: RumorTooltipCategory.TogglePublic,
    isPublic: rumham.public,
  });
  const specifiableTT = GetRumorTooltipText({
    category: RumorTooltipCategory.ToggleSpecifiable,
    isSpecifiable: rumham.specifiable,
  });
  const editTT = GetRumorTooltipText({
    category: RumorTooltipCategory.EditText,
  });

  const isHorny = horny === true;
  function UpDownButton(pos: RumorPosition, dir: 'up' | 'down') {
    let isDisabled = false;
    switch (pos) {
      case RumorPosition.Top:
        if (dir === 'up') isDisabled = true;
        break;
      case RumorPosition.Bottom:
        if (dir === 'down') isDisabled = true;
        break;
      case RumorPosition.Hidden:
        isDisabled = true;
        break;
      default:
        break;
    }
    const styleOverrides: React.CSSProperties = {};
    if (isDisabled) {
      styleOverrides.backgroundColor = RumorColorSet.ButtonBackgroundDisabled;
      styleOverrides.cursor = 'default';
    } else {
      styleOverrides.backgroundColor = RumorColorSet.ButtonBackground;
      styleOverrides.cursor = 'pointer';
    }
    const actParams: Record<string, string> = { [RumorActKeys.Uid]: uid };
    if (dir === 'up') {
      actParams[RumorActKeys.Action] = RumorActKeys.MoveUp;
    } else {
      actParams[RumorActKeys.Action] = RumorActKeys.MoveDown;
    }
    const UDArror = dir === 'up' ? '↑' : '↓';
    return (
      <Button
        style={{
          ...MiniButtonStyle,
          ...styleOverrides,
        }}
        tooltip={dir === 'up' ? upTT : downTT}
        tooltipPosition="right"
        onClick={() => {
          !isDisabled &&
            act(RumorActKeys.Invoke, {
              ...actParams,
            });
        }}
      >
        {UDArror}
      </Button>
    );
  }
  const uppydownyHolder = (
    <Stack.Item style={{ height: '100%' }}>
      <div
        style={{
          display: 'flex',
          flexDirection: 'column',
          justifyContent: 'space-between',
          height: '100%',
        }}
      >
        {UpDownButton(position, 'up')}
        {UpDownButton(position, 'down')}
      </div>
    </Stack.Item>
  );

  const hornyButton = (
    <Button
      style={MiniButtonStyle}
      backgroundColor={isHorny ? RumorColorSet.Horny : RumorColorSet.NotHorny}
      tooltip={hornyTT}
      tooltipPosition="left"
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.ToggleNSFW,
          [RumorActKeys.Uid]: uid,
        });
      }}
    >
      🍆
    </Button>
  );

  const deleteButton = (
    <Button
      style={MiniButtonStyle}
      color="red"
      backgroundColor={RumorColorSet.Delete}
      tooltip={deleteTT}
      tooltipPosition="left"
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.Delete,
          [RumorActKeys.Uid]: uid,
        });
      }}
    >
      X
    </Button>
  ); // confirm will be on byonds side

  const specifiableButton = (
    <Button
      style={MiniButtonStyle}
      backgroundColor={
        rumham.specifiable ? RumorColorSet.Horny : RumorColorSet.NotHorny
      }
      tooltip={specifiableTT}
      tooltipPosition="left"
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.ToggleSpecifiable,
          [RumorActKeys.Uid]: uid,
        });
      }}
    >
      {rumham.specifiable ? 'S' : 's'}
    </Button>
  );

  const publicButton = (
    <Button
      style={MiniButtonStyle}
      backgroundColor={RumorColorSet.ButtonBackground}
      tooltip={publicTT}
      tooltipPosition="left"
      disabled
    >
      {}
    </Button>
  );

  const copySingleButton = (
    <Button
      style={MiniButtonStyle}
      backgroundColor={RumorColorSet.ButtonBackground}
      tooltip={GetRumorTooltipText({
        category: RumorTooltipCategory.CopySingle,
      })}
      tooltipPosition="left"
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.CopySingle,
          [RumorActKeys.Uid]: uid,
        });
      }}
    >
      📋
    </Button>
  );

  const rightSideButtonHolder = (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(2, 1fr)',
        justifyContent: 'space-between',
        alignItems: 'center',
        gap: '0.5em',
      }}
    >
      {deleteButton}
      {hornyButton}
      {specifiableButton}
      {publicButton}
      {copySingleButton}
    </div>
  );

  const MainContainerProps = {
    backgroundColor: RumorColorSet.Background,
    color: RumorColorSet.Text,
    border: `1px solid ${RumorColorSet.Border}`,
    borderRadius: '5px',
  };

  const internalTextHolderSortabutton = (
    <Box
      style={{
        width: '100%',
        height: '100%',
        padding: '1px',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'flex-start',
        alignItems: 'flex-start',
        textAlign: 'left',
        backgroundColor: '#00000000',
      }}
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.EditText,
          [RumorActKeys.Uid]: uid,
        });
      }}
    >
      {text}
    </Box>
  );

  // ╔═══╦══════════════════╦═══╗
  // ║ ^ ║ i ate fenny's    ║ X ║
  // ╠═══╣ chicken nuggets  ╠═══╣
  // ║ V ║ it was fun to do ║ H ║
  // ╚═══╩══════════════════╩═══╝
  return (
    <Box
      style={{ ...MainContainerProps, display: 'flex', flexDirection: 'row' }}
    >
      {uppydownyHolder}
      <div
        style={{
          flex: 1,
          display: 'flex',
          flexDirection: 'row',
          justifyContent: 'space-between',
        }}
      >
        {internalTextHolderSortabutton}
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'space-between',
          }}
        >
          {hornyButton}
          {deleteButton}
        </div>
      </div>
    </Box>
  );
}

/*
"rumor_act" = -v
	"rumor_delete" -> deletes the rumor with the given uid
	"rumor_add" -> adds a new rumor with blank text and not-horny status
	"rumor_edit_text" -> popup text input for the rumor with the given uid
	"rumor_toggle_nsfw" -> toggles the horny status of the rumor with the given uid
  "rumor_move_up" -> moves the rumor with the given uid up in the list
  "rumor_move_down" -> moves the rumor with the given uid down in the list
  "rumor_uid" = "rumor to modify",
*/

function GetRumorTooltipText(props: RumorTTprops): React.ReactNode {
  switch (props.category) {
    case RumorTooltipCategory.ToggleNSFW:
      return props.isHorny
        ? 'Mark this rumor as SFW'
        : 'Mark this rumor as NSFW';
    case RumorTooltipCategory.TogglePublic:
      if (props.isPublic) {
        return (
          <div>
            This rumor is eligible for the event system to randomly spread to
            others.
            <br />
            Note: NSFW rumors are still eligible for the event system, but they
            will only be spread to other players who have opted in to see NSFW
            rumors.
          </div>
        );
      } else {
        return (
          <div>
            This rumor is not eligible for the event system to randomly spread
            to others.
            <br />
            Note: It will be visible on your examine window.
          </div>
        );
      }
    case RumorTooltipCategory.ToggleSpecifiable:
      if (props.isSpecifiable) {
        return (
          <div>
            If spread by the event system, this rumor may include additional
            identifiable info about your character.
            <br />
            Note: This does not affect the rumor's visibility on your examine
            window.
          </div>
        );
      } else {
        return (
          <div>
            If spread by the event system, this rumor will not include any
            additional identifiable info about your character.
            <br />
            Note: This does not affect the rumor's visibility on your examine
            window.
          </div>
        );
      }
    case RumorTooltipCategory.MoveUp:
      if (props.position === RumorPosition.Top) {
        return 'This rumor is already at the top of your list.';
      } else {
        return 'Move this rumor up in your list.';
      }
    case RumorTooltipCategory.MoveDown:
      if (props.position === RumorPosition.Bottom) {
        return 'This rumor is already at the bottom of your list.';
      } else {
        return 'Move this rumor down in your list.';
      }
    case RumorTooltipCategory.Delete:
      return 'Delete this rumor from your list.';
    case RumorTooltipCategory.EditText:
      return 'Click here to change the text of this rumor about your character!';
    case RumorTooltipCategory.CopySingle:
      return 'Copy this rumor to your clipboard, so you can paste it to another character!';
    case RumorTooltipCategory.CopyAll:
      return 'Copy all rumors from this character to your clipboard, so you can paste them to another character!';
    case RumorTooltipCategory.Paste:
      return 'Paste the rumors from your clipboard to this character!';
    default:
      return '';
  }
}
