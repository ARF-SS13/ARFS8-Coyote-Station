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
import { Gender } from '../preferences/gender';

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
  const gendie = data.character_preferences.misc.gender;

  const slot1: string[] = Object.values(speciesList)
    .filter(
      (species) => !species.category || (species.category && species.is_folder),
    )
    .map((species) => species.id);

  const slot2: string[] = currentSpecies.category
    ? Object.values(speciesList)
        .filter((species) => species.category === currentSpecies.category)
        .map((species) => species.id)
    : [];

  const slot3: string[] = currentSpecies.sub_category && currentSpecies.category
    ? Object.values(speciesList)
        .filter((species) => species.sub_category === currentSpecies.sub_category)
        .map((species) => species.id)
    : [];

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
        onSelected={(value) => {
          act('handle_species_thing', { species: value });
        }}
      />
    );
  }

  const leftsideContainer = (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', width: '285px' }}>
      <CharacterPreview
        height="265px"
        width="calc(100% - 1rem)" // SKYRAT EDIT
        id={data.character_preview_view}
      />
      <div style={{ display: 'flex', justifyContent: 'center', gap: '0.5rem' }}>
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
      </div>
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
      <div style={{ display: 'flex', justifyContent: 'center', gap: '0.5rem', width: '50%'}}>
        <Box
          // its a sproite sheet, but we want to scale it up so tyhe
          // 64x64px sprite fills a larger box
          className={classes(['species64x64', currentSpecies.icon])}
          style={{
            transform: 'scale(3)',
            transformOrigin: 'top left',
            border: '1px solid hsl(210, 37.5%, 45%)',
            borderRadius: '0.25rem',
            padding: '0.25rem',
            backgroundColor: 'hsl(210, 37.5%, 10%)',
          }}
          ml={-1}
        >
          {/* Hi my name is Human */}
          <Box
            style={{
              position: 'absolute',
              top: currentSpecies.category === "pogies" ? '0' : undefined,
              bottom: currentSpecies.category === "pogies" ? undefined : '0',
              right: '0',
              backgroundColor: 'hsl(210, 37.5%, 10%)',
              border: '1px solid hsl(210, 37.5%, 45%)',
              borderRadius: '0.1rem',
              padding: '0.1rem',
              fontSize: '0.35rem',
              fontFamily: 'comic sans ms',
            }}
          >
            <div style={{ fontSize: '0.25rem', color: 'hsl(210, 37.5%, 45%)', fontFamily: 'comic sans ms' }}>Hi, my name is:</div>
            {gendie === Gender.Male ? 'Mr. ' : gendie === Gender.Female ? 'Ms. ' : 'Mx. '} {currentSpecies.name}
          </Box>
        </Box>
      </div>
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
    <div style={{ display: 'flex', flexDirection: 'row', gap: '0.5rem', margin: '0.5rem', fontWeight: 'bold' }}>
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
      <Section title="Dietary Considerations">
        <Diet diet={currentSpecies.diet} />
      </Section>
      <Section title="Special Features">
        <SpeciesPerks perks={currentSpecies.perks} />
      </Section>
    </div>
  );

  const content = currentTab === 1 ? descriptionContent : mechanicsContent;
  const contentContainerStyle: React.CSSProperties = {
    minHeight: 0,
    overflowX: 'hidden',
    overflowY: 'auto',
    padding: '0.5rem',
    boxSizing: 'border-box',
    margin: '0.5rem',
  };

  return (
    <Section
      fill
      title="Species Selector PRO"
      overflowY="hidden"
      buttons={
        <Button icon="arrow-left" onClick={closeSpecies}>
          Save and Close
        </Button>
      }
    >
      <Stack fill overflow="hidden">
        <Stack.Item width="300px">{leftsideContainer}</Stack.Item>
        <Stack.Item grow style={{ minHeight: 0 }}>
          <Section fill title={currentSpecies.name} fitted>
            <Stack vertical fill>
              <Stack.Item>{rightTabs}</Stack.Item>
              <Stack.Item grow style={contentContainerStyle}>
                {content}
              </Stack.Item>
            </Stack>
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
    return (
      <Box>
        This species has no particular dietary preferences or restrictions, not
        accounting for personal taste.
      </Box>
    );
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

    const holderStyle: React.CSSProperties = {
      display: 'flex',
      flexDirection: 'row',
      alignItems: 'center',
      alignSelf: 'stretch',
      gap: '0.5rem',
      padding: '0.25rem',
      borderRadius: '0.25rem',
      fontWeight: 'bold',
      width: '100%',
      backgroundColor:
        cat === FoodCategory.Liked
          ? 'hsla(328, 100%, 50%, 0.10)'
          : cat === FoodCategory.Disliked
            ? 'hsla(0, 100%, 50%, 0.10)'
            : 'hsla(37, 100%, 50%, 0.10)',
      border:
        cat === FoodCategory.Liked
          ? '1px solid hsla(328, 100%, 50%, 0.25)'
          : cat === FoodCategory.Disliked
            ? '1px solid hsla(0, 100%, 50%, 0.25)'
            : '1px solid hsla(37, 100%, 50%, 0.25)',
    };

    return (
      <div className={className} style={holderStyle}>
        <div style={{ flexGrow: 1, textAlign: 'center', fontSize: '0.75rem' }} />
        <Icon className={className} name={icon} size={1.4} />
        <div>{name}</div>
        <div style={{ flexGrow: 1, textAlign: 'center', fontSize: '0.75rem' }} />
      </div>
    );
  }

  const foodGridStyle: React.CSSProperties = {
    display: 'grid',
    gridTemplateColumns: 'repeat(4, 1fr)',
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
    <div style={{ display: 'flex', flexDirection: 'column', padding: '1rem', gap: '0.5rem' }}>
      {likedFood}
      {dislikedFood}
      {toxicFood}
    </div>
  );
}

enum PerkCategory {
  Positive = "color-bg-green",
  Negative = "color-bg-red",
  Neutral = "color-bg-grey",
}

type SpeciesPerkProps = {
  kind: PerkCategory;
  perk: Perk;
};

function SpeciesPerk(props: SpeciesPerkProps) {
  const { kind, perk } = props;

  const sectStyle: React.CSSProperties = {
    gap: '0.5rem',
    borderRadius: '0.25rem',
    border: '2px solid hsl(210, 37.5%, 45%)',
    backgroundColor:
      kind === PerkCategory.Positive
        ? 'hsl(120, 37.5%, 10%)'
        : kind === PerkCategory.Negative
        ? 'hsl(0, 37.5%, 10%)'
        : 'hsl(210, 37.5%, 10%)',
    padding: '0.25rem',
  };
  const leftIconStyle: React.CSSProperties = {
    flexShrink: 1,
    padding: '0.25rem',
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    float: 'inline-start',
    width: '100%',
  };
  const rightTextStyle: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'flex-start',
    padding: '0.25rem',
  };

  return (
    <div style={sectStyle}>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
        <div className={kind} style={leftIconStyle}>
          <Icon
            style={{ paddingRight: '0.5rem' }}
            name={perk.ui_icon}
            size={1.5}
          />
          <div style={{ fontWeight: 'bold',
            textShadow: '1px 1px 0px black, -1px -1px 0px black, 1px -1px 0px black, -1px 1px 0px black',
          }}>{perk.name}</div>
        </div>
        <div style={rightTextStyle}>
          <Box>{perk.description}</Box>
        </div>
      </div>
    </div>
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
    flexBasis: '45%',
    alignSelf: 'stretch',
    alignItems: 'stretch',
  };

  const goodPerks =
    positive.length > 0 ? (
        positive.map((perk) => {
          return (
            <div key={perk.name} style={perkStyle}>
              <SpeciesPerk kind={PerkCategory.Positive} perk={perk} />
            </div>
          );
        })
    ) : null;

  const badPerks =
    negative.length > 0 ? (
        negative.map((perk) => {
          return (
            <div key={perk.name} style={perkStyle}>
              <SpeciesPerk kind={PerkCategory.Negative} perk={perk} />
            </div>
          );
        })

    ) : null;

  const neutralPerks =
    neutral.length > 0 ? (
      neutral.map((perk) => {
        return (
          <div key={perk.name} style={perkStyle}>
            <SpeciesPerk kind={PerkCategory.Neutral} perk={perk} />
          </div>
        );
      })
    ) : null;

  return (
    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0.5rem' }}>
      {goodPerks}
      {badPerks}
      {neutralPerks}
    </div>
  );
}
