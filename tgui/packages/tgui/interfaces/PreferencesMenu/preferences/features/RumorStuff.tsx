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
} from '../../../../CoolTypes/types';
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

  const bigButtonStyle: React.CSSProperties = {
    ...MiniButtonStyle,
    width: '100%',
  };

  const cuteButtonStyle: React.CSSProperties = {
    ...bigButtonStyle,
    paddingLeft: '0.5em',
    paddingRight: '0.5em',
    width: 'auto',
  };

  const buttonBarContainerStyle: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'row',
    gap: '0.5em',
    borderWidth: '1px',
    borderStyle: 'solid',
    borderColor: RumorColorSet.Border,
    borderRadius: '5px',
    padding: '0.5em',
    marginBottom: '0.5em',
  };

  const addButton = (
    <Button
      style={bigButtonStyle}
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.Add,
        });
      }}
    >
      Add New Rumor
    </Button>
  );

  const copyAllButton = (
    <Button
      style={cuteButtonStyle}
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.CopyAll,
        });
      }}
    >
      📋 Copy
    </Button>
  );

  const pasteButton = (
    <Button
      style={cuteButtonStyle}
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.Paste,
        });
      }}
    >
      📥 Paste
    </Button>
  );

  const buttonBar = (
    <div style={buttonBarContainerStyle}>
      {addButton}
      {copyAllButton}
      {pasteButton}
    </div>
  );

  return (
    <div>
      <Stack vertical fill>
        <Stack.Item>{buttonBar}</Stack.Item>
        {rumors?.length === 0 && (
          <Stack.Item>
            <Box>
              Make some rumors about yourself, someone else, or just stuff in
              general! Rumors, if set to be public, will appear in your
              character's examine window, and may be spread to other players by
              the RumorMill event system. Check the buttons in a new rumor for
              more details!
            </Box>
          </Stack.Item>
        )}
        {rumors?.map((rumor: RumorData) => (
          <Stack.Item key={rumor.uid}>
            <RumorItem rumham={rumor} />
          </Stack.Item>
        ))}
      </Stack>
    </div>
  );
}

type RumorTTprops = {
  category: RumorTooltipCategory;
  isHorny?: number;
  isSecret?: number;
  isPublic?: number;
  isSpecifiable?: number;
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
    isSpecifiable: rumham.specificable,
  });
  const editTT = GetRumorTooltipText({
    category: RumorTooltipCategory.EditText,
  });

  const isHorny = horny === 1;
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
        // tooltip={dir === 'up' ? upTT : downTT}
        // tooltipPosition="right"
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
        onClick={(event) => {
          // don't let clicks on these buttons bubble up to the text box's edit-text onClick
          event.stopPropagation();
        }}
      >
        {UpDownButton(position, 'up')}
        {UpDownButton(position, 'down')}
      </div>
    </Stack.Item>
  );

  const hornyButton = (
    <Button
      style={{
        ...MiniButtonStyle,
        backgroundColor: isHorny
          ? RumorColorSet.Horny
          : RumorColorSet.ButtonBackground,
      }}
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
      style={{
        ...MiniButtonStyle,
        color: 'red',
        backgroundColor: RumorColorSet.Delete,
      }}
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
      style={{
        ...MiniButtonStyle,
        backgroundColor: rumham.specificable
          ? RumorColorSet.Horny
          : RumorColorSet.ButtonBackground,
      }}
      tooltip={specifiableTT}
      tooltipPosition="left"
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.ToggleSpecifiable,
          [RumorActKeys.Uid]: uid,
        });
      }}
    >
      ✉️
    </Button>
  );

  const publicButton = (
    <Button
      style={{
        ...MiniButtonStyle,
        backgroundColor: rumham.public
          ? RumorColorSet.Horny
          : RumorColorSet.ButtonBackground,
      }}
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.TogglePublic,
          [RumorActKeys.Uid]: uid,
        });
      }}
      tooltip={publicTT}
      tooltipPosition="left"
    >
      📢
    </Button>
  );

  const secretButton = (
    <Button
      style={{
        ...MiniButtonStyle,
        backgroundColor: rumham.secret
          ? RumorColorSet.Horny
          : RumorColorSet.ButtonBackground,
      }}
      onClick={() => {
        act(RumorActKeys.Invoke, {
          [RumorActKeys.Action]: RumorActKeys.ToggleSecret,
          [RumorActKeys.Uid]: uid,
        });
      }}
      tooltip={GetRumorTooltipText({
        category: RumorTooltipCategory.ToggleSecret,
        isSecret: rumham.secret,
      })}
      tooltipPosition="left"
    >
      🔒
    </Button>
  );

  const copySingleButton = (
    <Button
      style={{
        ...MiniButtonStyle,
        backgroundColor: RumorColorSet.ButtonBackground,
      }}
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
        gridTemplateColumns: 'repeat(6, 1fr)',
        alignItems: 'center',
        gap: '0.1em',
        float: 'right',
        marginLeft: '0.5em',
      }}
      onClick={(event) => {
        // don't let clicks on these buttons bubble up to the text box's edit-text onClick
        event.stopPropagation();
      }}
    >
      {hornyButton}
      {specifiableButton}
      {publicButton}
      {copySingleButton}
      {secretButton}
      {deleteButton}
    </div>
  );

  const MainContainerProps = {
    backgroundColor: isHorny
      ? RumorColorSet.BackgroundHorny
      : RumorColorSet.Background,
    color: RumorColorSet.Text,
    border: `1px solid ${RumorColorSet.Border}`,
    borderRadius: '5px',
  };

  // ╔═══╦══════════════════╦═══╗
  // ║ ^ ║ i ate fenny's    ║ X ║
  // ╠═══╣ chicken nuggets  ╠═══╣
  // ║ V ║ it was fun to do ║ H ║
  // ╚═══╩══════════════════╩═══╝
  return (
    <Box
      style={{ ...MainContainerProps, display: 'flex', flexDirection: 'row' }}
    >
      <Box
        style={{
          flex: 1,
          flexDirection: 'row',
          display: 'flex',
          height: '100%',
          padding: '0px',
          textAlign: 'left',
          backgroundColor: '#00000000',
          cursor: 'text',
        }}
        onClick={() => {
          act(RumorActKeys.Invoke, {
            [RumorActKeys.Action]: RumorActKeys.EditText,
            [RumorActKeys.Uid]: uid,
          });
        }}
      >
        {uppydownyHolder}
        <div
          style={{
            flex: 1,
            padding: '0px',
            overflowWrap: 'break-word',
            wordBreak: 'break-word',
          }}
        >
          {rightSideButtonHolder}
          <div style={{ padding: '5px' }}>{text}</div>
        </div>
      </Box>
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
      return (
        <div>
          {`This rumor is considered ${props.isHorny ? 'Horny' : 'Not Horny'}.`}
          <br />
          {`Click here to flag this rumor as ${props.isHorny ? 'Not Horny' : 'Horny'}.`}
          <br />
          <br />
          {`Horny rumors are rumors that contain explicit sexual content, such as `}
          {`your (or someone else's) kinks, horny happenings, or anything else of a sexual nature.`}
          <br />
          {`Horny rumors will not be shown to players who have opted out of seeing `}
          {`horny rumors, so don't worry about that!`}
        </div>
      );
    case RumorTooltipCategory.TogglePublic:
      return (
        <div>
          {`This rumor is ${props.isPublic ? 'Public' : 'Private'}.`}
          <br />
          {`Click here to make this rumor ${props.isPublic ? 'Private' : 'Public'}.`}
          <br />
          <br />
          {`Public rumors will be eligible to be spread via the RumorMill.`}
        </div>
      );
    case RumorTooltipCategory.ToggleSpecifiable:
      return (
        <div>
          {`This rumor is ${props.isSpecifiable ? 'Specifiable' : 'Not Specifiable'}.`}
          <br />
          {`Click here to make this rumor ${props.isSpecifiable ? 'Not Specifiable' : 'Specifiable'}.`}
          <br />
          <br />
          {`Specifiable rumors, when spread via the RumorMill, will include information `}
          {`about your character. Otherwise, the rumor will not include any additional `}
          {`information about your character.`}
          <br />
          {`Do note, it won't remove any identifiable information you write into the rumor!`}
        </div>
      );
    case RumorTooltipCategory.ToggleSecret:
      return (
        <div>
          {`This rumor is ${props.isSecret ? 'Secret' : 'Not Secret'}.`}
          <br />
          {`Click here to toggle the secret status of this rumor.`}
          <br />
          <br />
          {`Secret rumors will not appear in your examine window.`}
        </div>
      );
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
      return (
        <div>
          Copy this rumor to your clipboard!
          <br />
          <br />
          {`This is useful if you want to copy a rumor from one character to another, `}
          {`like such as for instance if you have multiple character slots that are the `}
          {`same character (but with different styles or something) and you want each one `}
          {`to have the same rumors about them!`}
        </div>
      );
    case RumorTooltipCategory.CopyAll:
      return (
        <div>
          Copy all these rumors to your clipboard!
          <br />
          <br />
          {`This is useful if you want to copy all rumors from one character to another, `}
          {`like such as for instance if you have multiple character slots that are the `}
          {`same character (but with different styles or something) and you want each one `}
          {`to have the same rumors about them!`}
        </div>
      );
    case RumorTooltipCategory.Paste:
      return (
        <div>
          Paste rumors from your clipboard!
          <br />
          <br />
          {`This will also clear your clipboard.`}
        </div>
      );
    default:
      return '';
  }
}
