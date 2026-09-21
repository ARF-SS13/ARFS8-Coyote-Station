import { Fragment } from 'react';
import { createLogger } from 'tgui/logging';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import {
  VCCopyMode,
  type VCSaymode,
  type VCSaymodeData,
  type VCSettingData,
  type VCSettingDataPack,
  VCSettingRegion,
  VCTT,
  type VCWizardPack,
} from 'tgui-panel/chat/visualchat_types';
import { useBackend } from '../../backend';
import { Setting } from './index';
import { VCStyle } from './visualchat_styles';
import { VCGetTooltip } from './visualchat_tooltep_nightmare';

const logger = createLogger('VisualChatSetupWizard');

enum VCSettingClusterKind {
  Image = 'Image',
  Border = 'Border',
  Background = 'Background',
  Text = 'Text',
}

export function SettingsControlPanel(props: {
  saymode: VCSaymode;
  saymode_dat: VCSaymodeData;
  currentRegion: VCSettingRegion;
}): React.ReactElement {
  const { saymode_dat } = props;
  const { settings } = saymode_dat;
  const { currentRegion } = props;
  const { act, data } = useBackend<VCWizardPack>();

  return (
    <Section fill scrollable style={VCStyle.SettingsSection}>
      {/* Render the settings control panel for the given saymode_dat */}
      <Stack fill vertical>
        <Stack.Item shrink>
          {GetCluster(
            saymode_dat,
            settings,
            currentRegion,
            VCSettingClusterKind.Image,
            data,
            act,
          )}
        </Stack.Item>
        <Stack.Item shrink>
          {GetCluster(
            saymode_dat,
            settings,
            currentRegion,
            VCSettingClusterKind.Background,
            data,
            act,
          )}
        </Stack.Item>
        <Stack.Item shrink>
          {GetCluster(
            saymode_dat,
            settings,
            currentRegion,
            VCSettingClusterKind.Border,
            data,
            act,
          )}
        </Stack.Item>
        <Stack.Item shrink>
          {GetCluster(
            saymode_dat,
            settings,
            currentRegion,
            VCSettingClusterKind.Text,
            data,
            act,
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
}

function GetCluster(
  saydat: VCSaymodeData,
  settings: VCSettingDataPack,
  currentRegion: VCSettingRegion,
  clusterKind: VCSettingClusterKind,
  data,
  act,
): React.ReactElement {
  // settings to load into the thing
  let workCluster: VCSettingData[] = [];
  // Get this clussy
  switch (clusterKind) {
    case VCSettingClusterKind.Image:
      switch (currentRegion) {
        case VCSettingRegion.PFP:
          workCluster = [
            settings.pfp_image_height,
            settings.pfp_image_link_url_filename,
            settings.pfp_image_link_url_host,
            settings.pfp_image_opacity,
            settings.pfp_image_scaling,
            settings.pfp_image_shape,
            settings.pfp_image_width,
          ];
          break;
        default: // nothing else has image settings
          return <Fragment />;
      }
      break;
    case VCSettingClusterKind.Border:
      switch (currentRegion) {
        case VCSettingRegion.PFP:
          workCluster = [
            settings.pfp_border_color,
            settings.pfp_border_radius,
            settings.pfp_border_style,
            settings.pfp_border_width,
          ];
          break;
        case VCSettingRegion.Name:
          workCluster = [
            settings.name_border_color,
            settings.name_border_radius,
            settings.name_border_style,
            settings.name_border_width,
          ];
          break;
        case VCSettingRegion.Message:
          workCluster = [
            settings.message_border_color,
            settings.message_border_radius,
            settings.message_border_style,
            settings.message_border_width,
          ];
          break;
        case VCSettingRegion.OuterBox:
          workCluster = [
            settings.outer_box_border_color,
            settings.outer_box_border_radius,
            settings.outer_box_border_style,
            settings.outer_box_border_width,
          ];
          break;
        default:
          return <Fragment />;
      }
      break;
    case VCSettingClusterKind.Background:
      switch (currentRegion) {
        case VCSettingRegion.PFP:
          workCluster = [
            settings.pfp_background_color,
            settings.pfp_background_grad_use,
            settings.pfp_background_grad_angle,
            settings.pfp_background_grad_end,
            settings.pfp_background_grad_start,
            settings.pfp_background_opacity,
            settings.pfp_background_padding_bottom,
            settings.pfp_background_padding_left,
            settings.pfp_background_padding_right,
            settings.pfp_background_padding_top,
          ];
          break;
        case VCSettingRegion.Name:
          workCluster = [
            settings.name_background_color,
            settings.name_background_grad_use,
            settings.name_background_grad_angle,
            settings.name_background_grad_end,
            settings.name_background_grad_start,
            settings.name_background_opacity,
            settings.name_background_padding_bottom,
            settings.name_background_padding_left,
            settings.name_background_padding_right,
            settings.name_background_padding_top,
          ];
          break;
        case VCSettingRegion.Message:
          workCluster = [
            settings.message_background_color,
            settings.message_background_grad_use,
            settings.message_background_grad_angle,
            settings.message_background_grad_end,
            settings.message_background_grad_start,
            settings.message_background_opacity,
            settings.message_background_padding_bottom,
            settings.message_background_padding_left,
            settings.message_background_padding_right,
            settings.message_background_padding_top,
          ];
          break;
        case VCSettingRegion.OuterBox:
          workCluster = [
            settings.outer_box_background_color,
            settings.outer_box_background_grad_use,
            settings.outer_box_background_grad_angle,
            settings.outer_box_background_grad_end,
            settings.outer_box_background_grad_start,
            settings.outer_box_background_opacity,
            settings.outer_box_background_padding_bottom,
            settings.outer_box_background_padding_left,
            settings.outer_box_background_padding_right,
            settings.outer_box_background_padding_top,
          ];
          break;
        default:
          return <Fragment />;
      }
      break;
    case VCSettingClusterKind.Text:
      switch (currentRegion) {
        case VCSettingRegion.PFP:
        case VCSettingRegion.OuterBox:
          return <Fragment />; // no text here!
        case VCSettingRegion.Name:
          workCluster = [
            settings.name_text_align,
            settings.name_text_color,
            settings.name_text_decoration,
            settings.name_text_font,
            settings.name_text_letter_spacing,
            settings.name_text_line_height,
            settings.name_text_opacity,
            settings.name_text_padding_bottom,
            settings.name_text_padding_left,
            settings.name_text_padding_right,
            settings.name_text_padding_top,
            settings.name_text_shadow_blur,
            settings.name_text_shadow_blur2,
            settings.name_text_shadow_color,
            settings.name_text_shadow_color2,
            settings.name_text_shadow_offset_x,
            settings.name_text_shadow_offset_x2,
            settings.name_text_shadow_offset_y,
            settings.name_text_shadow_offset_y2,
            settings.name_text_shadow_use,
            settings.name_text_shadow_use2,
            settings.name_text_size,
            settings.name_text_transform,
            settings.name_text_word_spacing,
          ];
          break;
        case VCSettingRegion.Message:
          workCluster = [
            settings.message_text_align,
            settings.message_text_color,
            settings.message_text_decoration,
            settings.message_text_font,
            settings.message_text_letter_spacing,
            settings.message_text_line_height,
            settings.message_text_opacity,
            settings.message_text_padding_bottom,
            settings.message_text_padding_left,
            settings.message_text_padding_right,
            settings.message_text_padding_top,
            settings.message_text_shadow_blur,
            settings.message_text_shadow_blur2,
            settings.message_text_shadow_color,
            settings.message_text_shadow_color2,
            settings.message_text_shadow_offset_x,
            settings.message_text_shadow_offset_x2,
            settings.message_text_shadow_offset_y,
            settings.message_text_shadow_offset_y2,
            settings.message_text_shadow_use,
            settings.message_text_shadow_use2,
            settings.message_text_size,
            settings.message_text_transform,
            settings.message_text_word_spacing,
          ];
          break;
        default:
          return <Fragment />;
      }
      break;
    default:
      return <Fragment />;
  }
  if (workCluster.length === 0) {
    return <Fragment />;
  }
  // still here? good, turn those things into a list of settings
  // logger.log('building settings list');
  const settingsList: React.ReactNode[] = [];
  for (const setting of workCluster) {
    if (setting === undefined) {
      logger.error('skip undefined', setting);
      continue;
    }
    // logger.log('adding', setting.key);
    const settin = Setting(setting, saydat, data, act);
    settingsList.push(settin);
  }
  // wrap it up all good and prettylike
  let clustername: string = '';
  switch (clusterKind) {
    case VCSettingClusterKind.Image:
      clustername = 'Image Settings';
      break;
    case VCSettingClusterKind.Border:
      clustername = 'Border Settings';
      break;
    case VCSettingClusterKind.Background:
      clustername = 'Background Settings';
      break;
    case VCSettingClusterKind.Text:
      clustername = 'Text Fonting';
      break;
    default:
      clustername = 'Some kind of settings!';
      break;
  }
  return (
    <SettingsCluster
      name={clustername}
      saymode={saydat.saymode_kind}
      cluster={clusterKind}
      settings={settingsList}
    />
  );
}

function SettingsCluster({
  name,
  saymode,
  cluster,
  settings,
}: {
  name: string;
  saymode: VCSaymode;
  cluster: VCSettingClusterKind;
  settings: React.ReactNode[];
}) {
  const { act, data } = useBackend<VCWizardPack>();
  const identSlug = {
    saymode: saymode,
    h_or_s: data.human_or_silicon,
  };
  // clibbord the big red clipboard
  const cbord = data.clipboard;
  const { valid_contents: vc, has_stuff } = cbord;
  const showPaste =
    has_stuff &&
    vc &&
    vc.some((content) =>
      content.toLowerCase().includes(cluster.toString().toLowerCase()),
    );

  function CopyButton() {
    return (
      <Button
        tooltip={VCGetTooltip(VCTT.CopyCluster, null)}
        icon="copy"
        onClick={() => {
          act('copy', {
            ...identSlug,
            copy_mode: VCCopyMode.Cluster, // <-- thats the new one!
          });
        }}
      />
    );
  }

  function PasteButton() {
    return (
      <Button
        icon="paste"
        tooltip={VCGetTooltip(VCTT.PasteCluster, null)}
        onClick={() => {
          act('paste', {
            ...identSlug, // backend knows what pasting
            paste_mode: VCCopyMode.Cluster, // <-- thats the new one!
          });
        }}
      />
    );
  }

  // logger.log('cluster', cluster);
  // logger.log('settings', settings[0]);

  return (
    <Section
      title={name}
      buttons={
        <Stack fill>
          <Stack.Item>
            <CopyButton />
          </Stack.Item>
          <Stack.Item>{showPaste && <PasteButton />}</Stack.Item>
        </Stack>
      }
    >
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
        {settings.map((setting, index) => (
          <Box
            key={index}
            style={{
              display: 'flex',
              alignItems: 'stretch',
              height: '100%',
              width: '100%',
            }}
          >
            {setting}
          </Box>
        ))}
      </Box>
    </Section>
  );
}
