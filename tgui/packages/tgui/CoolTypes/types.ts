// Data for a single rumor, as stored in the rumor mill.
export type RumorData = {
  uid: string;
  text: string;
  horny: number;
  public: number;
  secret: number;
  specificable: number;
  position: RumorPosition;
  times_spread: number;
  deleted_time: number | null;
  created_time: number;
  modified_time: number;
};

// Data for a character slot, which is held in a RumorHolderData object
export type RumorSlotData = {
  slot: number;
  character_name: Record<string, unknown>; // this is a list of names, because you can have multiple characters in a single slot, and they all share the same rumor list
  rumors: RumorData[];
  // only really used for the RumorMuncher2000, but we can keep it here for now
  rumor_keys?: string[];
};

// Data for a character's rumor holder, which contains all the rumors for all the characters (slots) that player (ckey) has
export type RumorHolderData = {
  ckey: string;
  last_online: number;
  is_online: boolean;
  slot_holder: RumorSlotData[];
};

export type RumorMuncher2000Data = {
  // ckey to RumorHolderData
  rumor_database: Record<string, RumorHolderData>;
};

export type RumorExamineData = {
  horny_ones: RumorData[];
  tame_ones: RumorData[];
};

// Keys that are sent back from TGUI to BYOND to mess with the rumor mill
// Invoke is required for the middleware to attempt anything
// Uid is required for that to do anything meaningful
export enum RumorActKeys {
  Invoke = 'operate_rumormill',
  Action = 'rumor_act',
  Add = 'rumor_add',
  Delete = 'rumor_delete',
  EditText = 'rumor_edit_text',
  ToggleNSFW = 'rumor_toggle_nsfw',
  TogglePublic = 'rumor_toggle_public',
  ToggleSpecifiable = 'rumor_toggle_specifiable',
  MoveUp = 'rumor_move_up',
  MoveDown = 'rumor_move_down',
  CopySingle = 'rumor_copy_single',
  CopyAll = 'rumor_copy_all',
  Paste = 'rumor_paste',
  ToggleSecret = 'rumor_toggle_secret',
  Ckey = 'rumor_ckey',
  Slot = 'rumor_slot',
  AmAdmin = 'rumor_am_admin',
  AllRumors = 'rumor_uid_list',
  // always needed
  Uid = 'rumor_uid',
}

// Defines where a rumor is positioned in a character's rumor list
// used so you can move em around
export enum RumorPosition {
  Top = 'top',
  Bottom = 'bottom',
  Middle = 'middle',
  Hidden = 'hidden',
}

// yes, and no, very important, cant live without it
export enum RumorYesNo {
  Yes = 'yes',
  No = 'no',
}

export enum RumorColorSet {
  Horny = '#ff00FF',
  NotHorny = '#63a3b3',
  Delete = '#270000',
  Text = '#FFFFFF',
  MoveUp = '#00ddff',
  MoveDown = '#00ddff',
  ButtonBackground = '#0016a8',
  ButtonBackgroundDisabled = 'rgba(0, 22, 168, 0.42)',
  Background = '#000b4f50',
  Border = '#000b4f50',
  BackgroundHorny = '#5b164450',
  BorderHorny = '#5b1644',
}

export const MiniButtonStyle = {
  fontSize: '1rem',
  height: '2rem',
  width: '2rem',
  padding: '1px',
  margin: '0px',
  display: 'flex' as const,
  flexDirection: 'column' as const,
  justifyContent: 'center' as const,
  alignItems: 'center' as const,
  textAlign: 'center' as const,
  borderRadius: '5px',
  border: `1px solid ${RumorColorSet.Border}`,
  backgroundColor: RumorColorSet.ButtonBackground,
  color: RumorColorSet.Text,
};

export type MiniButtonProps = {
  uid: string;
  position: RumorPosition;
  tooltipCategory: RumorTooltipCategory;
  isHorny: boolean;
  isPublic: boolean;
  isSpecifiable: boolean;
  styleOverrides?: React.CSSProperties;
  act: (key: string, params?: Record<string, unknown>) => void;
  actParams: Record<RumorActKeys, unknown>;
};

export enum RumorTooltipCategory {
  Add = 'Add',
  Delete = 'Delete',
  EditText = 'Edit Text',
  ToggleNSFW = 'Toggle NSFW',
  TogglePublic = 'Toggle Public',
  ToggleSpecifiable = 'Toggle Specifiable',
  MoveUp = 'Move Up',
  MoveDown = 'Move Down',
  CopySingle = 'Copy Single',
  CopyAll = 'Copy All',
  Paste = 'Paste',
  ToggleSecret = 'Toggle Secret',
}
