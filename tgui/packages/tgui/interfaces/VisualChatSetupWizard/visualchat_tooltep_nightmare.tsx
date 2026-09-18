/** biome-ignore-all lint/correctness/noUnusedImports: sugma */
/** biome-ignore-all assist/source/organizeImports: biteme */
import {
  type VCSettingData,
  VCSettingKind,
  VCSettingCluster,
  VCSDPEnum,
} from 'tgui-panel/chat/visualchat_types';
import type React from 'react';
import { VCSettingRegion, VCTT } from 'tgui-panel/chat/visualchat_types';

type VCSettingIdentifier = {
  key: VCSDPEnum;
  region: VCSettingRegion;
  cluster: VCSettingCluster;
};

export function VCGetTooltip(
  category: VCTT,
  settingData: VCSettingData,
): React.ReactNode {
  function Slugma(children: React.ReactNode): React.ReactNode {
    return <div className="slugma-tooltip">{children}</div>;
  }

  switch (category) {
    case VCTT.CopySetting:
      return Slugma('Copy Setting Tooltip');
    case VCTT.SwatchSnatch:
      return Slugma('Swatch Snatch Tooltip');
    case VCTT.SwatchApply:
      return Slugma('Swatch Apply Tooltip');
    case VCTT.SettingInfoString:
      return Slugma(`Enter up to ${settingData.max as number} characters!`);
    case VCTT.SettingInfoNumber:
      return Slugma(
        `Select a number between ${settingData.min as number} and ${settingData.max as number}, inclusive!`,
      );
    case VCTT.SettingInfoBoolean:
      return Slugma(`Have/do/want this thing to perform its function?`);
    case VCTT.SettingInfoChoice:
      return Slugma(`Pick a something from the options!`);
    case VCTT.SettingInfoColor:
      return Slugma(`Click here to choose a color!`);
    case VCTT.SettingInfoAngle:
      return Slugma(`Select an angle for this setting!`);
    case VCTT.SettingInfoUrlChoose:
      return Slugma(
        <>
          <p>{`Pick an image host that your image is hosted on!`}</p>
          <p>{`This will be auto-updated if the file url you put in includes a suitable host!`}</p>
        </>,
      );
    case VCTT.SettingInfoUrlFile:
      return Slugma(
        <>
          <p>{`Paste in a link to your cool image!`}</p>
          <p>{`So this can work in one of two ways!`}</p>
          <p>{`First option is to paste in the filename (eg. coolphoto.jpg) and select a host from the dropdown.`}</p>
          <p>{`Second option is to paste in the full URL to your image directly, which will automatically detect the host if it's suitable.`}</p>
          <p>{`Pretty clever huh?`}</p>
        </>,
      );
    default:
      return Slugma('This supposedly does something!');
  }
}

function Setting2Identifier(settingData: VCSettingData): VCSettingIdentifier {
  let identifier: VCSettingIdentifier;
  switch (settingData.key) {
    // backgrounds
    case VCSDPEnum.message_background_color:
    case VCSDPEnum.message_background_grad_angle:
    case VCSDPEnum.message_background_grad_end:
    case VCSDPEnum.message_background_grad_start:
    case VCSDPEnum.message_background_grad_use:
    case VCSDPEnum.message_background_image:
    case VCSDPEnum.message_background_img_opacity:
    case VCSDPEnum.message_background_opacity:
    case VCSDPEnum.message_background_padding_bottom:
    case VCSDPEnum.message_background_padding_left:
    case VCSDPEnum.message_background_padding_right:
    case VCSDPEnum.message_background_padding_top:
      return {
        key: settingData.key,
        region: VCSettingRegion.Message,
        cluster: VCSettingCluster.Background,
      };
    case VCSDPEnum.name_background_color:
    case VCSDPEnum.name_background_grad_angle:
    case VCSDPEnum.name_background_grad_end:
    case VCSDPEnum.name_background_grad_start:
    case VCSDPEnum.name_background_grad_use:
    case VCSDPEnum.name_background_image:
    case VCSDPEnum.name_background_img_opacity:
    case VCSDPEnum.name_background_opacity:
    case VCSDPEnum.name_background_padding_bottom:
    case VCSDPEnum.name_background_padding_left:
    case VCSDPEnum.name_background_padding_right:
    case VCSDPEnum.name_background_padding_top:
      return {
        key: settingData.key,
        region: VCSettingRegion.Name,
        cluster: VCSettingCluster.Background,
      };
    case VCSDPEnum.outer_box_background_color:
    case VCSDPEnum.outer_box_background_grad_angle:
    case VCSDPEnum.outer_box_background_grad_end:
    case VCSDPEnum.outer_box_background_grad_start:
    case VCSDPEnum.outer_box_background_grad_use:
    case VCSDPEnum.outer_box_background_image:
    case VCSDPEnum.outer_box_background_img_opacity:
    case VCSDPEnum.outer_box_background_opacity:
    case VCSDPEnum.outer_box_background_padding_bottom:
    case VCSDPEnum.outer_box_background_padding_left:
    case VCSDPEnum.outer_box_background_padding_right:
    case VCSDPEnum.outer_box_background_padding_top:
      return {
        key: settingData.key,
        region: VCSettingRegion.OuterBox,
        cluster: VCSettingCluster.Background,
      };
    case VCSDPEnum.pfp_background_color:
    case VCSDPEnum.pfp_background_grad_angle:
    case VCSDPEnum.pfp_background_grad_end:
    case VCSDPEnum.pfp_background_grad_start:
    case VCSDPEnum.pfp_background_grad_use:
    case VCSDPEnum.pfp_background_image:
    case VCSDPEnum.pfp_background_img_opacity:
    case VCSDPEnum.pfp_background_opacity:
    case VCSDPEnum.pfp_background_padding_bottom:
    case VCSDPEnum.pfp_background_padding_left:
    case VCSDPEnum.pfp_background_padding_right:
    case VCSDPEnum.pfp_background_padding_top:
      return {
        key: settingData.key,
        region: VCSettingRegion.PFP,
        cluster: VCSettingCluster.Background,
      };
    // Borders
    case VCSDPEnum.message_border_color:
    case VCSDPEnum.message_border_radius:
    case VCSDPEnum.message_border_style:
    case VCSDPEnum.message_border_width:
      return {
        key: settingData.key,
        region: VCSettingRegion.OuterBox,
        cluster: VCSettingCluster.Border,
      };
    case VCSDPEnum.name_border_color:
    case VCSDPEnum.name_border_radius:
    case VCSDPEnum.name_border_style:
    case VCSDPEnum.name_border_width:
      return {
        key: settingData.key,
        region: VCSettingRegion.Name,
        cluster: VCSettingCluster.Border,
      };
    case VCSDPEnum.outer_box_border_color:
    case VCSDPEnum.outer_box_border_radius:
    case VCSDPEnum.outer_box_border_style:
    case VCSDPEnum.outer_box_border_width:
      return {
        key: settingData.key,
        region: VCSettingRegion.OuterBox,
        cluster: VCSettingCluster.Border,
      };
    case VCSDPEnum.pfp_border_color:
    case VCSDPEnum.pfp_border_radius:
    case VCSDPEnum.pfp_border_style:
    case VCSDPEnum.pfp_border_width:
      return {
        key: settingData.key,
        region: VCSettingRegion.PFP,
        cluster: VCSettingCluster.Border,
      };
    // text
    case VCSDPEnum.message_text_align:
    case VCSDPEnum.message_text_color:
    case VCSDPEnum.message_text_decoration:
    case VCSDPEnum.message_text_font:
    case VCSDPEnum.message_text_letter_spacing:
    case VCSDPEnum.message_text_line_height:
    case VCSDPEnum.message_text_opacity:
    case VCSDPEnum.message_text_padding_bottom:
    case VCSDPEnum.message_text_padding_left:
    case VCSDPEnum.message_text_padding_right:
    case VCSDPEnum.message_text_padding_top:
    case VCSDPEnum.message_text_shadow_blur:
    case VCSDPEnum.message_text_shadow_blur2:
    case VCSDPEnum.message_text_shadow_color:
    case VCSDPEnum.message_text_shadow_color2:
    case VCSDPEnum.message_text_shadow_offset_x:
    case VCSDPEnum.message_text_shadow_offset_x2:
    case VCSDPEnum.message_text_shadow_offset_y:
    case VCSDPEnum.message_text_shadow_offset_y2:
    case VCSDPEnum.message_text_shadow_use:
    case VCSDPEnum.message_text_shadow_use2:
    case VCSDPEnum.message_text_size:
    case VCSDPEnum.message_text_transform:
    case VCSDPEnum.message_text_word_spacing:
      return {
        key: settingData.key,
        region: VCSettingRegion.Message,
        cluster: VCSettingCluster.Text,
      };
    case VCSDPEnum.name_text_color:
    case VCSDPEnum.name_text_decoration:
    case VCSDPEnum.name_text_font:
    case VCSDPEnum.name_text_letter_spacing:
    case VCSDPEnum.name_text_line_height:
    case VCSDPEnum.name_text_opacity:
    case VCSDPEnum.name_text_padding_bottom:
    case VCSDPEnum.name_text_padding_left:
    case VCSDPEnum.name_text_padding_right:
    case VCSDPEnum.name_text_padding_top:
    case VCSDPEnum.name_text_shadow_blur:
    case VCSDPEnum.name_text_shadow_blur2:
    case VCSDPEnum.name_text_shadow_color:
    case VCSDPEnum.name_text_shadow_color2:
    case VCSDPEnum.name_text_shadow_offset_x:
    case VCSDPEnum.name_text_shadow_offset_x2:
    case VCSDPEnum.name_text_shadow_offset_y:
    case VCSDPEnum.name_text_shadow_offset_y2:
    case VCSDPEnum.name_text_shadow_use:
    case VCSDPEnum.name_text_shadow_use2:
    case VCSDPEnum.name_text_size:
    case VCSDPEnum.name_text_transform:
    case VCSDPEnum.name_text_word_spacing:
      return {
        key: settingData.key,
        region: VCSettingRegion.Name,
        cluster: VCSettingCluster.Text,
      };
    // shows
    case VCSDPEnum.pfp_show:
      return {
        key: settingData.key,
        region: VCSettingRegion.PFP,
        cluster: VCSettingCluster.Show,
      };
    case VCSDPEnum.name_show:
      return {
        key: settingData.key,
        region: VCSettingRegion.Name,
        cluster: VCSettingCluster.Show,
      };
    case VCSDPEnum.message_show:
      return {
        key: settingData.key,
        region: VCSettingRegion.Message,
        cluster: VCSettingCluster.Show,
      };
    // pfp stuff
    case VCSDPEnum.pfp_image_width:
    case VCSDPEnum.pfp_image_height:
    case VCSDPEnum.pfp_image_link_url_filename:
    case VCSDPEnum.pfp_image_link_url_host:
    case VCSDPEnum.pfp_image_opacity:
    case VCSDPEnum.pfp_image_scaling:
    case VCSDPEnum.pfp_image_shape:
      return {
        key: settingData.key,
        region: VCSettingRegion.PFP,
        cluster: VCSettingCluster.Image,
      };
    // last few bits
    case VCSDPEnum.preview_text:
      return {
        key: settingData.key,
        region: VCSettingRegion.Preview,
        cluster: VCSettingCluster.Text,
      };
    default:
      return {
        key: VCSDPEnum.message_show,
        region: VCSettingRegion.Message,
        cluster: VCSettingCluster.Text,
      };
  }
}
