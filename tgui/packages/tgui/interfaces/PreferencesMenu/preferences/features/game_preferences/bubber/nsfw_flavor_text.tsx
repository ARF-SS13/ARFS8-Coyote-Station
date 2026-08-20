import type { FeatureChoiced } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const show_flavor_text_nsfw: FeatureChoiced = {
  name: 'NSFW Description Visibility',
  description:
    'How you would like your NSFW description to be shown. Silicons always show NSFW flavor text, unless set to "never".',
  category: 'ERP',
  component: FeatureDropdownInput,
};
