import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Section,
  Stack,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { SideDropdown } from '../../../bubber_components/SideDropdown'; // BUBBER EDIT ADDITION
import { CharacterPreview } from '../../common/CharacterPreview';
import { LoadingScreen } from '../../common/LoadingScreen';
import {
  createSetPreference,
  Food,
  type Perk,
  type PreferencesMenuData,
  type ServerData,
  type Species,
  type SpeciesCatTree,
} from '../types';
import { useServerPrefs } from '../useServerPrefs';
import { CharacterControls } from './MainPage';

type SpeciesPageInnerProps = {
  handleClose: () => void;
  species: ServerData['species'];
};

function SpeciesPageInner(props: SpeciesPageInnerProps) {
  const { act, data } = useBackend<PreferencesMenuData>();
  const setSpecies = createSetPreference(act, 'species');
  const [currentTab, setCurrentTab] = useState(1);
  const serverData = useServerPrefs();
  if (!serverData) {
    return <LoadingScreen />;
  }

  const speciesList: [string, Species][] = Object.entries(
    props.species.species_data,
  ).map(([species, data]) => {
    return [species, data];
  });
  const categoryMap: [string, SpeciesCatTree][] = Object.entries(
    props.species.category_map,
  ).map(([species, data]) => {
    return [species, data];
  });

  // categories! we got 3 slots, well, 2 slots, 3 will be for a todo
  const slot1: Species[] = [];
  const slot2: Species[] = [];
  const slot3: Species[] = [];

  for (const [speciesKey, species] of speciesList) {
    const categoryTree = categoryMap.find(([key]) => key === speciesKey)?.[1];

    if (!categoryTree) {
      continue;
    }

    if (categoryTree.slot_1) {
      slot1.push(species);
    } else if (categoryTree.slot_2) {
      slot2.push(species);
    } else if (categoryTree.slot_3) {
      slot3.push(species);
    }
  }

  // then sort the slots by order
  slot1.sort((a, b) => {
    return a.order - b.order;
  });
  slot2.sort((a, b) => {
    return a.order - b.order;
  });
  slot3.sort((a, b) => {
    return a.order - b.order;
  });

  const currentSpecies = speciesList.filter(([speciesKey]) => {
    return speciesKey === data.character_preferences.misc.species;
  })[0][1]; // we'll get to it!

  type DropdownEntry = {
    displayText: React.ReactNode;
    value: string;
  };

  function makeDropdownMenu(options: Species[]): React.ReactNode {
    const menuOptions: DropdownEntry[] = options.map((species) => {
      return { displayText: species.name, value: species.id };
    });
    return (
      <div style={{ display: 'flex', flexDirection: 'row', gap: '0.5rem' }}>
        <Dropdown
          options={menuOptions}
          selected={data.character_preferences.misc.species}
          onSelected={setSpecies}
        />
      </div>
    );
  }

  const dropdownMenu1 = makeDropdownMenu(slot1);
  const dropdownMenu2 = makeDropdownMenu(slot2);
  const dropdownMenu3 = makeDropdownMenu(slot3);
  const dropdownCluster = (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
      {dropdownMenu1}
      {dropdownMenu2}
      {dropdownMenu3}
    </div>
  );
  const leftsideContainer = (
    <Stack fill vertical>
      <Stack.Item>{dropdownCluster}</Stack.Item>
      <Stack.Item>
        <CharacterPreview
          height="100%"
          width="270px"
          id={data.character_preview_view}
        />
      </Stack.Item>
      <Stack.Item position="relative">
        <SideDropdown
          selected={data.character_preferences.misc.background_state}
          options={serverData?.background_state.choices || []}
          onSelected={(value) =>
            act('update_background', {
              new_background: value,
            })
          }
        />
      </Stack.Item>
      <Stack.Item>
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
      </Stack.Item>
      <Stack.Item>
        {/* BUBBER EDIT ADDITION BEGIN: Preview Selection */}
        <SideDropdown
          selected={data.preview_selection}
          options={data.preview_options}
          onSelected={(value) =>
            act('update_preview', {
              updated_preview: value,
            })
          }
        />
      </Stack.Item>
      <Stack.Item position="relative">
        <SideDropdown
          selected={data.character_preferences.misc.background_state}
          options={serverData?.background_state.choices || []}
          onSelected={(value) =>
            act('update_background', {
              new_background: value,
            })
          }
        />
      </Stack.Item>
      <Stack.Item>
        <Box
          className={classes(['species64x64', currentSpecies.icon])}
          style={{ height: '100%', width: '100%' }}
          ml={-1}
        />
      </Stack.Item>
    </Stack>
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
      title="Species Selector PRO"
      buttons={
        <Button icon="arrow-left" onClick={props.handleClose}>
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

type SpeciesPageProps = {
  closeSpecies: () => void;
};

export function SpeciesPage(props: SpeciesPageProps) {
  const serverData = useServerPrefs();
  if (!serverData) {
    return <LoadingScreen />;
  }

  return (
    <SpeciesPageInner
      handleClose={props.closeSpecies}
      species={serverData.species}
    />
  );
}

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
