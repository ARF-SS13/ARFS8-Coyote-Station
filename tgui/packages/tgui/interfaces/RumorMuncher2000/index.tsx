// THIS IS A NOVA SECTOR UI FILE

import React from 'react';
import { Button, Section, Stack } from 'tgui-core/components';
import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import type { RumorMuncher2000Data } from './types';

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

  return (
    <Window width={700} height={600} title={`Rumor Muncher 2000 Admin "Tool"`}>
      <Window.Content scrollable>
        <Section title={`Mess em up!`}>
          <Stack vertical fill>
            {Object.keys(rumor_database).map((ckey) => (
              <Stack.Item key={ckey}>
                <Button fluid onClick={() => handleCkeyClick(ckey)}>
                  {openCkeyTab === ckey ? '▼' : '▶'} {ckey}
                </Button>
                {openCkeyTab === ckey &&
                  rumor_database[ckey].slot_holder.map((slot) => (
                    <Stack.Item key={slot.slot}>
                      <Button
                        fluid
                        onClick={() => handleSlotClick(slot.slot.toString())}
                      >
                        {openSlotTab === slot.slot.toString() ? '▼' : '▶'} Slot{' '}
                        {slot.slot}: {slot.character_name}
                      </Button>
                      {openSlotTab === slot.slot.toString() && (
                        <Stack vertical fill>
                          {rumor_database[openCkeyTab].slot_holder
                            .find(
                              (slot) => slot.slot.toString() === openSlotTab,
                            ) // ??
                            ?.rumors.map((rumor) => (
                              <Stack.Item key={rumor.uid}>
                                <div>
                                  <strong>Rumor UID:</strong> {rumor.uid}
                                  <br />
                                  <strong>Text:</strong> {rumor.text}
                                  <br />
                                  <strong>Horny:</strong>{' '}
                                  {rumor.horny ? 'Yes' : 'No'}
                                  <br />
                                  <strong>Public:</strong>{' '}
                                  {rumor.public ? 'Yes' : 'No'}
                                  <br />
                                  <strong>Specifiable:</strong>{' '}
                                  {rumor.specifiable ? 'Yes' : 'No'}
                                  <br />
                                  <strong>Position:</strong> {rumor.position}
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
