/**
 * @file
 * @copyright 2026 Coyote ARFS (Fennicus hornificus)
 * @license Free Use Vixen
 * @description Utility functions for VisualChat, including validation checks
 * for visual chat data.
 */
import type { VCDataPack } from './visualchat_types';

export function is_valid_vc_data(
  vcData: VCDataPack | null | undefined,
): vcData is VCDataPack {
  if (vcData === null || vcData === undefined) return false;
  if (!vcData) return false;
  if (!vcData.saymode_data) return false;
  if (!vcData.message_data) return false;
  return true;
}

export function AssembleImageUrl(host: string, filename: string): string {
  if (!host || !filename) {
    return '';
  }
  if (host.endsWith('/')) {
    host = host.slice(0, -1);
  }
  if (filename.startsWith('/')) {
    filename = filename.slice(1);
  }
  return `${host}/${filename}`;
}
