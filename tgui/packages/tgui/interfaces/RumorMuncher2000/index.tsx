/** biome-ignore-all assist/source/organizeImports: <thanks biome> */

import React, { useState } from 'react';
import { Button, Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { RumorActKeys, type RumorMuncher2000Data } from '../../CoolTypes/types';

export function RumorMuncher2000() {
  const { act, data } = useBackend<RumorMuncher2000Data>();
  const { rumor_database } = data;
  const [openCkeyTab, setOpenCkeyTab] = React.useState<string | null>(null);
  const [openSlotTab, setOpenSlotTab] = React.useState<string | null>(null);
  const handleCkeyClick = (ckey: string) => {
    if (openCkeyTab === ckey) {
      setOpenCkeyTab(null); // close the tab if it's already open
      setOpenSlotTab(null); // also close the slot tab if the ckey tab is closed
    } else {
      setOpenCkeyTab(ckey); // open the tab for the clicked ckey
    }
  };
  const handleSlotClick = (slot: string) => {
    if (openSlotTab === slot) {
      setOpenSlotTab(null); // close the tab if it's already open
    } else {
      setOpenSlotTab(slot); // open the tab for the clicked slot
    }
  };
  const [searchQuery, setSearchQuery] = useState('');
  // Search the rumor database for ckeys.
  const keySearch = createSearch(searchQuery, (ckey: string) => ckey);

  return (
    <Window width={700} height={600} title={`Rumor Muncher 2000 Admin "Tool"`}>
      <Window.Content scrollable>
        <Section
          title={`Mess em up!`}
          buttons={
            <Input
              value={searchQuery}
              onChange={(e) => setSearchQuery(e)}
              placeholder="Search ckeys..."
            />
          }
        >
          <Stack vertical fill>
            {Object.keys(rumor_database)
              .filter((ckey) => keySearch(ckey))
              .map((ckey) => (
                <Stack.Item key={ckey}>
                  <Button fluid onClick={() => handleCkeyClick(ckey)}>
                    {openCkeyTab === ckey ? '▼' : '▶'} {ckey}
                  </Button>
                  {openCkeyTab === ckey &&
                    rumor_database[ckey].slot_holder
                      .filter((slot) => slot.rumors.length > 0)
                      .map((slot) => (
                        <Stack.Item key={slot.slot}>
                          <Button
                            fluid
                            onClick={() =>
                              handleSlotClick(slot.slot.toString())
                            }
                          >
                            {openSlotTab === slot.slot.toString() ? '▼' : '▶'}{' '}
                            Slot {slot.slot}:{' '}
                            {Object.keys(slot.character_name).length > 0
                              ? Object.keys(slot.character_name)[0]
                              : 'Unknown!'}
                          </Button>
                          {openSlotTab === slot.slot.toString() && (
                            <Stack vertical fill>
                              {rumor_database[openCkeyTab].slot_holder
                                .find(
                                  (slot) =>
                                    slot.slot.toString() === openSlotTab,
                                ) // ??
                                ?.rumors.map((rumor) => (
                                  <Stack.Item key={rumor.uid}>
                                    <strong>Characters Played:</strong>
                                    <br />
                                    {Object.keys(slot.character_name).length >
                                    0 ? (
                                      <ol>
                                        {Object.keys(slot.character_name)
                                          .filter((e) => e.length > 0)
                                          .map(
                                            (char, index) => (
                                              <li key={index}>{char}</li>
                                            ), // look at you breaking out the html 1.0
                                          )}
                                      </ol>
                                    ) : (
                                      <span>idk</span>
                                    )}
                                    <br />
                                    <div>
                                      <Button
                                        fluid
                                        onClick={() =>
                                          // uses the keys differently from rumormill
                                          // just here for sake of consistency, but it works
                                          act(RumorActKeys.Invoke, {
                                            [RumorActKeys.Action]:
                                              RumorActKeys.Delete,
                                            [RumorActKeys.Uid]: rumor.uid,
                                            [RumorActKeys.Ckey]: openCkeyTab,
                                            [RumorActKeys.Slot]: slot.slot,
                                            [RumorActKeys.AmAdmin]: true,
                                          })
                                        }
                                      >
                                        KILL
                                      </Button>
                                      <strong>Rumor UID:</strong> {rumor.uid}
                                      <br />
                                      <br />
                                      <strong>Text:</strong> {rumor.text}
                                      <br />
                                      <br />
                                      <strong>Horny:</strong>{' '}
                                      {rumor.horny ? 'Yes' : 'No'}
                                      <br />
                                      <strong>Public:</strong>{' '}
                                      {rumor.public ? 'Yes' : 'No'}
                                      <br />
                                      <strong>Specifiable:</strong>{' '}
                                      {rumor.specificable ? 'Yes' : 'No'}
                                      <br />
                                      <strong>Times Spread:</strong>{' '}
                                      {rumor.times_spread}
                                      <br />
                                      <strong>Created Time:</strong>{' '}
                                      {rumor.created_time}
                                      <br />
                                      <strong>Modified Time:</strong>{' '}
                                      {rumor.modified_time}
                                      <br />
                                      <strong>Deleted Time:</strong>{' '}
                                      {rumor.deleted_time}
                                    </div>
                                  </Stack.Item>
                                ))}
                            </Stack>
                          )}
                        </Stack.Item>
                      ))}
                </Stack.Item>
              ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
}
