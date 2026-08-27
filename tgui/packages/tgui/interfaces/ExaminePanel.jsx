// THIS IS A SKYRAT UI FILE
import { useState } from 'react';
import {
  Box,
  Button,
  ByondUi,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';

// no enums? no problem! any struct is an enum if you believe hard enough!
const ExaminePanelTabs = Object.freeze({
  FlavorText: 1,
  NSFW: 2,
  CustomSpecies: 3,
});

const ExaminePanelLowerTabs = Object.freeze({
  OOCNotes: 1,
  CharacterAdvert: 2,
  Rumors: 3,
});

const formatURLs = (text) => {
  if (!text) return;
  const parts = [];
  const regex = /https?:\/\/[^\s/$.?#].[^\s]*/gi;
  let lastIndex = 0;

  text.replace(regex, (url, index) => {
    parts.push(text.substring(lastIndex, index));
    parts.push(
      <a
        style={{
          color: '#0591e3',
          'text-decoration': 'none',
        }}
        href={url}
      >
        {url}
      </a>,
    );
    lastIndex = index + url.length;
    return url;
  });

  parts.push(text.substring(lastIndex));

  return <div>{parts}</div>;
};

export const ExaminePanel = () => {
  const [tabIndex, setTabIndex] = useState(ExaminePanelTabs.FlavorText);
  const [showRumorsNSFW, toggleShowRumorsNSFW] = useState(false);
  const [lowerTabIndex, setLowerTabIndex] = useState(
    ExaminePanelLowerTabs.OOCNotes,
  );
  const [page, setPage] = useState('main');
  const { act, data } = useBackend();

  const {
    character_name,
    obscured,
    assigned_map,
    flavor_text,
    flavor_text_nsfw,
    ooc_notes,
    custom_species,
    custom_species_lore,
    character_ad,
    rumors, // [{ rumor_text: "text", is_nsfw: "yes"/"no", unique_id: "uid" }, ...]
    headshot,
    headshot_nsfw,
    art_ref,
    art_ref_nsfw,
  } = data;

  const handlePageChange = (page, newPage) => {
    setPage(newPage);
  };

  const Rumor = ({ rumor_text, rumor_nsfw }) => {
    return (
      <div style={{ marginBottom: '5px', width: '100%' }}>
        {rumor_nsfw ? (
          <>
            <span style={{ color: 'pink' }}>• </span>
            <span>{formatURLs(rumor_text)}</span>
          </>
        ) : (
          <>
            <span>• </span>
            <span>{formatURLs(rumor_text)}</span>
          </>
        )}
        ;
      </div>
    );
  };

  const has_at_least_one_visible_rumor = rumors.some(
    (rumor) => !rumor.is_nsfw || (showRumorsNSFW && rumor.is_nsfw),
  );
  const rumorsDisplay =
    rumors.length > 0 ? (
      <Stack fill vertical>
        <Stack.Item shrink>
          <div
            style={{
              fontSize: '10px',
              lineHeight: '1.5',
              fontFamily: 'cursive',
              fontStyle: 'italic',
            }}
          >
            Rumor has it...
          </div>
        </Stack.Item>
        {rumors.map((rumor, index) =>
          rumor.is_nsfw && !showRumorsNSFW ? null : (
            <Rumor
              key={index}
              rumor_text={rumor.rumor_text}
              rumor_nsfw={rumor.is_nsfw}
            />
          ),
        )}
      </Stack>
    ) : (
      <div>
        {formatURLs(
          `No common gossip or rumors are yet known to you ` +
            `about ${character_name}, ` +
            `maybe go ask around about them? Surely there's something ` +
            `interesting (or salacious) to discover!`,
        )}
      </div>
    );

  //This does not fix the problem, however, it does make it work right now. I am so sorry.
  const [previewKey, setPreviewKey] = useState(0);
  if (previewKey === 0 && assigned_map) {
    setTimeout(() => {
      setPreviewKey(1);
    }, 200);
  }

  return (
    <Window
      title={`${character_name}'s Examine Panel`}
      width={900}
      height={670}
    >
      <Window.Content>
        {page === 'main' ? (
          <>
            {art_ref && (
              <Button
                color={data.art_ref_nsfw ? 'pink' : 'green'}
                tooltip={
                  data.art_ref_nsfw ? 'NSFW Reference Image' : 'Reference Image'
                }
                icon="image"
                style={{
                  position: 'absolute',
                  bottom: '10px',
                  right: '10px',
                  zIndex: 1,
                }}
                onClick={() => handlePageChange(setPage, 'image')}
              />
            )}
            <Stack>
              <Stack.Item style={{ width: '30%' }}>
                {!headshot ? (
                  <Section
                    fill
                    style={{ textAlign: 'center' }}
                    title="Character Preview"
                  >
                    <ByondUi
                      key={previewKey}
                      height="100%"
                      width="100%"
                      className="ExaminePanel__map"
                      params={{
                        id: assigned_map,
                        type: 'map',
                      }}
                    />
                  </Section>
                ) : (
                  <>
                    <Section
                      maxheight="310px"
                      title="Character Preview"
                      style={{ textAlign: 'center' }}
                    >
                      <ByondUi
                        key={previewKey}
                        height="260px"
                        width="100%"
                        className="ExaminePanel__map"
                        params={{
                          id: assigned_map,
                          type: 'map',
                        }}
                      />
                    </Section>

                    <Section
                      maxheight="310px"
                      title="Headshot"
                      style={{ textAlign: 'center' }}
                    >
                      <img
                        src={
                          tabIndex === ExaminePanelTabs.NSFW
                            ? resolveAsset(headshot_nsfw)
                            : resolveAsset(headshot)
                        }
                        height="250px"
                        width="250px"
                      />
                    </Section>
                  </>
                )}
              </Stack.Item>
              <Stack.Item style={{ width: '70%' }}>
                <Box height="610px">
                  <Tabs fluid>
                    <Tabs.Tab
                      selected={tabIndex === ExaminePanelTabs.FlavorText}
                      onClick={() => setTabIndex(ExaminePanelTabs.FlavorText)}
                    >
                      <Section
                        fitted
                        title={'Flavor Text'}
                        style={{ textAlign: 'center' }}
                      />
                    </Tabs.Tab>
                    <Tabs.Tab
                      selected={tabIndex === ExaminePanelTabs.NSFW}
                      onClick={() => setTabIndex(ExaminePanelTabs.NSFW)}
                    >
                      <Section
                        fitted
                        title={'NSFW (Warning)'}
                        style={{ textAlign: 'center' }}
                      />
                    </Tabs.Tab>
                    <Tabs.Tab
                      selected={tabIndex === ExaminePanelTabs.CustomSpecies}
                      onClick={() =>
                        setTabIndex(ExaminePanelTabs.CustomSpecies)
                      }
                    >
                      <Section
                        fitted
                        title={
                          custom_species ? custom_species : 'Unnamed Species'
                        }
                        style={{ textAlign: 'center' }}
                      />
                    </Tabs.Tab>
                  </Tabs>
                  {tabIndex === ExaminePanelTabs.FlavorText && (
                    <Section
                      style={{ 'overflow-y': 'scroll' }}
                      fitted
                      preserveWhitespace
                      minHeight="50%"
                      maxHeight="50%"
                      fontSize="14px"
                      lineHeight="1.7"
                      textIndent="3em"
                    >
                      {formatURLs(flavor_text)}
                    </Section>
                  )}
                  {tabIndex === ExaminePanelTabs.NSFW && (
                    <Section
                      style={{ 'overflow-y': 'scroll' }}
                      fitted
                      preserveWhitespace
                      minHeight="50%"
                      maxHeight="50%"
                      fontSize="14px"
                      lineHeight="1.7"
                      textIndent="3em"
                    >
                      {formatURLs(flavor_text_nsfw)}
                    </Section>
                  )}
                  {tabIndex === ExaminePanelTabs.CustomSpecies && (
                    <Section
                      style={{ 'overflow-y': 'scroll' }}
                      fitted
                      preserveWhitespace
                      minHeight="50%"
                      maxHeight="50%"
                      fontSize="14px"
                      lineHeight="1.7"
                      textIndent="3em"
                    >
                      {custom_species
                        ? formatURLs(custom_species_lore)
                        : 'Just a normal space dweller.'}
                    </Section>
                  )}
                  <Tabs fluid>
                    <Tabs.Tab
                      selected={
                        lowerTabIndex === ExaminePanelLowerTabs.OOCNotes
                      }
                      onClick={() =>
                        setLowerTabIndex(ExaminePanelLowerTabs.OOCNotes)
                      }
                    >
                      <Section
                        fitted
                        title={'OOC Notes'}
                        style={{ textAlign: 'center' }}
                      />
                    </Tabs.Tab>
                    <Tabs.Tab
                      selected={
                        lowerTabIndex === ExaminePanelLowerTabs.CharacterAdvert
                      }
                      onClick={() =>
                        setLowerTabIndex(ExaminePanelLowerTabs.CharacterAdvert)
                      }
                    >
                      <Section
                        fitted
                        title={'Character Advert'}
                        style={{ textAlign: 'center' }}
                      />
                    </Tabs.Tab>
                    <Tabs.Tab
                      selected={lowerTabIndex === ExaminePanelLowerTabs.Rumors}
                      onClick={() =>
                        setLowerTabIndex(ExaminePanelLowerTabs.Rumors)
                      }
                    >
                      <Section
                        fitted
                        title={'Rumors'}
                        style={{ textAlign: 'center' }}
                        buttons={
                          <Button
                            color={rumors_nsfw ? 'pink' : 'default'}
                            tooltip={
                              rumors_nsfw
                                ? 'Hide NSFW Rumors'
                                : 'Show NSFW Rumors'
                            }
                            onClick={() => {
                              act('toggleShowRumorsNSFW');
                            }}
                          >
                            🍆
                          </Button>
                        }
                      />
                    </Tabs.Tab>
                  </Tabs>
                  {lowerTabIndex === ExaminePanelLowerTabs.OOCNotes && (
                    <Section
                      style={{ 'overflow-y': 'scroll' }}
                      preserveWhitespace
                      fitted
                      minHeight="35%"
                      maxHeight="35%"
                      fontSize="14px"
                      lineHeight="1.5"
                    >
                      <Stack.Item>{formatURLs(ooc_notes)}</Stack.Item>
                    </Section>
                  )}
                  {lowerTabIndex === ExaminePanelLowerTabs.CharacterAdvert && (
                    <Section
                      style={{ 'overflow-y': 'scroll' }}
                      preserveWhitespace
                      fitted
                      minHeight="35%"
                      maxHeight="35%"
                      fontSize="14px"
                      lineHeight="1.5"
                    >
                      <Stack.Item>{formatURLs(character_ad)}</Stack.Item>
                    </Section>
                  )}
                  {lowerTabIndex === ExaminePanelLowerTabs.Rumors && (
                    <Section
                      style={{ 'overflow-y': 'scroll' }}
                      preserveWhitespace
                      fitted
                      minHeight="35%"
                      maxHeight="35%"
                      fontSize="14px"
                      lineHeight="1.5"
                    >
                      <Stack.Item>{formatURLs(rumorsDisplay)}</Stack.Item>
                    </Section>
                  )}
                </Box>
              </Stack.Item>
            </Stack>
          </>
        ) : (
          <div>
            <Button
              content="Back"
              icon="arrow-left"
              style={{
                position: 'absolute',
                bottom: '10px',
                right: '10px',
                zIndex: 1,
              }}
              onClick={() => handlePageChange(setPage, 'main')}
            />
            <Section>
              <Box>
                <img
                  src={data.art_ref}
                  style={{
                    height: 'auto',
                    maxHeight: '600px',
                    width: '100%',
                    objectFit: 'contain',
                  }}
                />
              </Box>
            </Section>
          </div>
        )}
      </Window.Content>
    </Window>
  );
};
