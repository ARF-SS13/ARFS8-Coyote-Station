import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { SideDropdown } from '../../../bubber_components/SideDropdown'; // BUBBER EDIT ADDITION
import { CharacterPreview } from '../../common/CharacterPreview';
import {
  createSetPreference,
  Food,
  type Perk,
  type PreferencesMenuData,
  type ServerData,
  type Species,
} from '../types';
import { CharacterControls } from './MainPage';

type SpeciesPageInnerProps = {
  handleClose: () => void;
  species: ServerData['species'];
};

type SpeciesPageProps = {
  closeSpecies: () => void;
};

export function SpeciesPage(props: SpeciesPageProps) {
  const { act, data } = useBackend<PreferencesMenuData>();
  const { closeSpecies } = props;
  const [currentTab, setCurrentTab] = useState(1);
  const speciesList: Record<string, Species> =
    data.server_species_data.species_list;
  const currentSpecies: Species =
    speciesList[data.character_preferences.misc.species] ||
    Object.values(speciesList)[0];

  const slot1: string[] = Object.values(speciesList)
    .filter(
      (species) => !species.category || (species.category && species.is_folder),
    )
    .map((species) => species.id);

  const slot2: string[] = Object.values(speciesList)
    .filter((species) => species.category === currentSpecies.category)
    .map((species) => species.id);

  const slot3: string[] = Object.values(speciesList)
    .filter((species) => species.sub_category === currentSpecies.sub_category)
    .map((species) => species.id);

  //the proper displayed selected things for each visible slot, based on the current species
  const slot1Selected: string = currentSpecies.category
    ? Object.values(speciesList).filter(
        (species) =>
          species.category === currentSpecies.category && species.is_folder,
      )[0]?.name || currentSpecies.name
    : currentSpecies.name;
  const slot2Selected: string = currentSpecies.sub_category
    ? Object.values(speciesList).filter(
        (species) =>
          species.sub_category === currentSpecies.sub_category &&
          species.is_folder,
      )[0]?.name || currentSpecies.name
    : currentSpecies.name;
  const slot3Selected: string = currentSpecies.sub_sub_category
    ? Object.values(speciesList).filter(
        (species) =>
          species.sub_sub_category === currentSpecies.sub_sub_category &&
          species.is_folder,
      )[0]?.name || currentSpecies.name
    : currentSpecies.name;

  type DropdownEntry = {
    displayText: React.ReactNode;
    value: string;
  };

  function makeDropdownMenu(
    options: string[],
    selected: string,
  ): React.ReactNode {
    if (!options || options.length === 0) {
      return null;
    }
    const menuOptions: DropdownEntry[] = options.map((speciesId) => {
      const species = speciesList[speciesId];
      return { displayText: species.name, value: species.id };
    });
    return (
      <SideDropdown
        options={menuOptions}
        selected={selected}
        onSelected={(value) => act('handle_species_thing', { species: value })}
      />
    );
  }

  const leftsideContainer = (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
      {makeDropdownMenu(slot1, slot1Selected)}
      {makeDropdownMenu(slot2, slot2Selected)}
      {makeDropdownMenu(slot3, slot3Selected)}
      <SideDropdown
        selected={data.preview_selection}
        options={data.preview_options}
        onSelected={(value) =>
          act('update_preview', {
            updated_preview: value,
          })
        }
      />
      <SideDropdown
        selected={data.character_preferences.misc.background_state}
        options={data.background_choices || []}
        onSelected={(value) =>
          act('update_background', {
            new_background: value,
          })
        }
      />
      <CharacterPreview
        height="250px"
        width="calc(100% - 1rem)" // SKYRAT EDIT
        id={data.character_preview_view}
      />

      <CharacterControls
        gender={data.character_preferences.misc.gender}
        handleOpenSpecies={() => {}}
        handleDeleteCharacter={() => {}}
        handleRotate={(value) => {
          act('rotate', { backwards: value }); // BUBBER EDIT CHANGE - Original: handleRotate={() => { act('rotate'); }}
        }}
        // BUBBER EDIT ADDITION BEGIN
        handleFood={() => {
          act('open_food');
        }}
        // BUBBER EDIT ADDITION END
        setGender={createSetPreference(act, 'gender')}
        showGender={currentSpecies ? !!currentSpecies.sexes : true}
        canDeleteCharacter={false}
        showSpecies={false}
        showDelete={false}
      />
      <Box
        // its a sproite sheet, but we want to scale it up so tyhe
        // 64x64px sprite fills a larger box
        className={classes(['species64x64', currentSpecies.icon])}
        style={{
          transform: 'scale(4)',
          transformOrigin: 'top left',
          width: '100%',
          height: '100%',
        }}
        ml={-1}
      />
    </div>
  );

  const tabbuttonStyle = {
    width: '100%',
    height: '100%',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  };
  // the right side!
  const rightTabs = (
    <div style={{ display: 'flex', flexDirection: 'row', gap: '0.5rem' }}>
      <Button
        selected={currentTab === 1}
        onClick={() => setCurrentTab(1)}
        style={tabbuttonStyle}
      >
        Description
      </Button>
      <Button
        selected={currentTab === 2}
        onClick={() => setCurrentTab(2)}
        style={tabbuttonStyle}
      >
        Mechanics
      </Button>
    </div>
  );

  const descStyle = {
    padding: '0.5rem',
    marginBottom: '1rem',
  };

  const aOrAn = (word: string) => {
    const vowels = ['a', 'e', 'i', 'o', 'u'];
    return vowels.includes(word[0].toLowerCase()) ? 'an' : 'a';
  };
  const descriptionContent = (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
      <Section
        title={`What's ${aOrAn(currentSpecies.name)} ${currentSpecies.name}?`}
      >
        {currentSpecies.desc.map((text, index) => (
          <Box key={index} maxWidth="100%" style={descStyle}>
            {text}
          </Box>
        ))}
      </Section>
      <Section title={`What's the deal with ${currentSpecies.name}(s)?`}>
        {currentSpecies.lore.map((text, index) => (
          <Box key={index} maxWidth="100%" style={descStyle}>
            {text}
          </Box>
        ))}
      </Section>
    </div>
  );

  const mechanicsContent = (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
      <Section title="Special Features">
        <SpeciesPerks perks={currentSpecies.perks} />
      </Section>
      {currentSpecies.diet && (
        <Section title="Dietary Considerations">
          <Diet diet={currentSpecies.diet} />
        </Section>
      )}
    </div>
  );

  const content = currentTab === 1 ? descriptionContent : mechanicsContent;
  const contentContainerStyle: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'column',
    gap: '0.5rem',
  };

  return (
    <Section
      fill
      position="relative"
      fitted
      title="Species Selector PRO"
      buttons={
        <Button icon="arrow-left" onClick={closeSpecies}>
          Save and Close
        </Button>
      }
    >
      <Stack fill>
        <Stack.Item width="300px">{leftsideContainer}</Stack.Item>
        <Stack.Item grow>
          <Section title={currentSpecies.name}>
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                gap: '0.5rem',
              }}
            >
              {rightTabs}
              <div style={contentContainerStyle}>{content}</div>
            </div>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
}

//   <Stack.Item grow>
//     <Stack fill>
//       <Stack.Item>
//         <Box height="calc(100vh - 170px)" overflowY="auto" pr={3}>
//           {speciesList.map(([speciesKey, species]) => {
//             // BUBBER EDIT START - Species selction
//             const speciesPage = (

//             );

//             return speciesPage;
//             // BUBBER EDIT END
//           })}
//         </Box>
//       </Stack.Item>

//       <Stack.Item grow>
//         <Box>
//           <Box>
//             <Stack fill>
//               <Stack.Item width="70%">
//                 <Section
//                   title={currentSpecies.name}
//                   buttons={
//                     // NOHUNGER species have no diet (diet = null),
//                     // so we have nothing to show
//                     currentSpecies.diet && (
//                       <Diet diet={currentSpecies.diet} />
//                     )
//                   }
//                 >
//                   {/* SKYRAT EDIT CHANGE START - Adds maxHeight, scrollable*/}
//                   <Section maxHeight="14vh" overflowY="auto">
//                     {/* SKYRAT EDIT CHANGE END */}

//                   </Section>

//                   <Section title="Features">
//                     <SpeciesPerks perks={currentSpecies.perks} />
//                   </Section>
//                 </Section>
//               </Stack.Item>

//               <Stack.Item width="30%">
//                 <CharacterPreview
//                   id={data.character_preview_view}
//                   height="100%"
//                 />
//               </Stack.Item>
//             </Stack>
//           </Box>

//           <Box mt={1}>
//             <Section title="Lore">
//               <BlockQuote /* SKYRAT EDIT START - scrollable lore */
//                 overflowY="auto"
//                 maxHeight="45vh"
//                 mr={-1} /* SKYRAT EDIT END */
//               >
//                 {currentSpecies.lore.map((text, index) => (
//                   <Box key={index} maxWidth="100%">
//                     {text}
//                     {index !== currentSpecies.lore.length - 1 && (
//                       <>
//                         <br />
//                         <br />
//                       </>
//                     )}
//                   </Box>
//                 ))}
//               </BlockQuote>
//             </Section>
//           </Box>
//         </Box>
//       </Stack.Item>
//     </Stack>
//   </Stack.Item>
// </Stack>

const FOOD_ICONS = {
  [Food.Bugs]: 'bug',
  [Food.Cloth]: 'tshirt',
  [Food.Dairy]: 'cheese',
  [Food.Fried]: 'bacon',
  [Food.Fruit]: 'apple-alt',
  [Food.Gore]: 'skull',
  [Food.Grain]: 'bread-slice',
  [Food.Gross]: 'trash',
  [Food.Junkfood]: 'pizza-slice',
  [Food.Meat]: 'hamburger',
  [Food.Nuts]: 'seedling',
  [Food.Raw]: 'drumstick-bite',
  [Food.Seafood]: 'fish',
  [Food.Stone]: 'gem',
  [Food.Sugar]: 'candy-cane',
  [Food.Toxic]: 'biohazard',
  [Food.Vegetables]: 'carrot',
};

const FOOD_NAMES: Record<keyof typeof FOOD_ICONS, string> = {
  [Food.Bugs]: 'Bugs',
  [Food.Cloth]: 'Clothing',
  [Food.Dairy]: 'Dairy',
  [Food.Fried]: 'Fried food',
  [Food.Fruit]: 'Fruit',
  [Food.Gore]: 'Gore',
  [Food.Grain]: 'Grain',
  [Food.Gross]: 'Gross food',
  [Food.Junkfood]: 'Junk food',
  [Food.Meat]: 'Meat',
  [Food.Nuts]: 'Nuts',
  [Food.Raw]: 'Raw',
  [Food.Seafood]: 'Seafood',
  [Food.Stone]: 'Rocks',
  [Food.Sugar]: 'Sugar',
  [Food.Toxic]: 'Toxic food',
  [Food.Vegetables]: 'Vegetables',
};

type DietProps = {
  diet: Species['diet'];
};

function Diet(props: DietProps) {
  const { diet } = props;
  if (!diet) {
    return null;
  }

  const { liked_food, disliked_food, toxic_food } = diet;

  if (
    liked_food.length === 0 &&
    disliked_food.length === 0 &&
    toxic_food.length === 0
  ) {
    return (
      <Box>
        This species has no particular dietary preferences or restrictions, not
        accounting for personal taste.
      </Box>
    );
  }

  enum FoodCategory {
    Liked = 1,
    Disliked = 2,
    Toxic = 3,
  }

  function FoodEntry(props: { food: Food; cat: FoodCategory }) {
    const { food, cat } = props;
    const icon = FOOD_ICONS[food];
    const name = FOOD_NAMES[food];
    const className =
      cat === FoodCategory.Liked
        ? 'color-pink'
        : cat === FoodCategory.Disliked
          ? 'color-red'
          : 'color-olive';

    return (
      <div style={{ display: 'flex', flexDirection: 'row', gap: '0.5rem' }}>
        <Icon className={className} name={icon} size={1.4} />
        <Box>{name}</Box>
      </div>
    );
  }

  const foodGridStyle: React.CSSProperties = {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))',
    gap: '0.5rem',
  };

  const likedFood =
    liked_food.length > 0 ? (
      <Section title="Prefered Foods">
        <div style={foodGridStyle}>
          {liked_food.map((food) => (
            <FoodEntry key={food} food={food} cat={FoodCategory.Liked} />
          ))}
        </div>
      </Section>
    ) : null;

  const dislikedFood =
    disliked_food.length > 0 ? (
      <Section title="Disliked Foods">
        <div style={foodGridStyle}>
          {disliked_food.map((food) => (
            <FoodEntry key={food} food={food} cat={FoodCategory.Disliked} />
          ))}
        </div>
      </Section>
    ) : null;

  const toxicFood =
    toxic_food.length > 0 ? (
      <Section title="Toxic Foods">
        <div style={foodGridStyle}>
          {toxic_food.map((food) => (
            <FoodEntry key={food} food={food} cat={FoodCategory.Toxic} />
          ))}
        </div>
      </Section>
    ) : null;

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
      {likedFood}
      {dislikedFood}
      {toxicFood}
    </div>
  );
}

type SpeciesPerkProps = {
  className: string;
  perk: Perk;
};

function SpeciesPerk(props: SpeciesPerkProps) {
  const { className, perk } = props;

  const sectStyle: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'row',
    gap: '0.5rem',
    borderRadius: '0.25rem',
    border: '1px solid black',
  };
  const leftIconStyle: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'row',
    flexShrink: 1,
    alignItems: 'center',
    justifyContent: 'center',
  };
  const rightTextStyle: React.CSSProperties = {
    ...leftIconStyle,
    flexGrow: 0,
    flexDirection: 'column',
    alignItems: 'flex-start',
  };

  return (
    <Section title={perk.name}>
      <div style={sectStyle}>
        <Box
          className={className}
          width="32px"
          height="32px"
          style={leftIconStyle}
        >
          <Icon
            name={perk.ui_icon}
            size={1.5}
            ml={0}
            mt={1}
            style={{
              textAlign: 'center',
              height: '100%',
              width: '100%',
            }}
          />
        </Box>
        <Box style={rightTextStyle}>{perk.description}</Box>
      </div>
    </Section>
  );
}

type SpeciesPerksProps = {
  perks: Species['perks'];
};

function SpeciesPerks(props: SpeciesPerksProps) {
  const { positive, negative, neutral } = props.perks;

  if (positive.length === 0 && negative.length === 0 && neutral.length === 0) {
    return <Box>Nothing special about this species!</Box>;
  }

  const perkStyle: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'column',
    gap: '0.5rem',
    width: '100%',
  };

  const goodPerks =
    positive.length > 0 ? (
      <div style={perkStyle}>
        {positive.map((perk) => {
          return (
            <div key={perk.name} style={{ display: 'flex' }}>
              <SpeciesPerk className="color-bg-green" perk={perk} />
            </div>
          );
        })}
      </div>
    ) : null;

  const badPerks =
    negative.length > 0 ? (
      <div style={perkStyle}>
        {negative.map((perk) => {
          return (
            <div key={perk.name} style={{ display: 'flex' }}>
              <SpeciesPerk className="color-bg-red" perk={perk} />
            </div>
          );
        })}
      </div>
    ) : null;

  const neutralPerks =
    neutral.length > 0 ? (
      <div style={perkStyle}>
        {neutral.map((perk) => {
          return (
            <div key={perk.name} style={{ display: 'flex' }}>
              <SpeciesPerk className="color-bg-grey" perk={perk} />
            </div>
          );
        })}
      </div>
    ) : null;

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
      {goodPerks}
      {neutralPerks}
      {badPerks}
    </div>
  );
}
