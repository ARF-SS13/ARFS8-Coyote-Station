import { sortBy } from 'es-toolkit';
import React, { useState } from 'react';
import {
  Box,
  Button,
  Divider,
  Modal,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { formatMoney } from 'tgui-core/format';
import type { BooleanLike } from 'tgui-core/react';
import { toTitleCase } from 'tgui-core/string';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { ModifyHSLA } from './PreferencesMenu/CharacterPreferences/BackgroundsColorsAndStyle';

enum HeaderTab {
  Info,
  Mats,
  Fancy,
}

type MatMarketState = {
  currentHeaderTab: HeaderTab;
  setCurrentHeaderTab: (v: HeaderTab) => void;
  extraData: ExtraData;
};

// fallback so anything reading this context never has to null-check; only
// matters if a consumer somehow renders outside the wizard's own provider
const DEFAULT_STATE: MatMarketState = {
  currentHeaderTab: HeaderTab.Mats,
  setCurrentHeaderTab: () => {},
  extraData: {} as ExtraData,
};

const MatMarketContext = React.createContext<MatMarketState>(DEFAULT_STATE);

function useLocalMMS(): MatMarketState {
  return React.useContext(MatMarketContext);
}

type Material = {
  name: string;
  desc: string;
  visible: boolean;
  available: number;
  price: number;
  rarity: number;
  threshold: number;
  quantity: number;
  trend: string;
  color: string;
  requested: number;
  elastic: number;
};

type Data = {
  isPrivateOrder: BooleanLike;
  canOrderCargo: BooleanLike;
  creditBalance: number;
  orderBalance: number;
  materials: Material[];
  fancyMaterials: Material[];
  catastrophe: BooleanLike;
  CARGO_CRATE_VALUE: number;
  updateTime: number;
  whichBudgetName: string;
  whichBudgetKey: string;
};

type ExtraData = {
  isPrivateOrder: BooleanLike;
  canOrderCargo: BooleanLike;
  total_order_cost: number;
  multiplier: number;
};

export const MatMarket = () => {
  const { data } = useBackend<Data>();
  const [currentHeaderTab, setCurrentHeaderTab] = useState(
    DEFAULT_STATE.currentHeaderTab,
  );
  const {
    isPrivateOrder,
    canOrderCargo, // access
    orderBalance,
    catastrophe,
    CARGO_CRATE_VALUE,
  } = data;

  // offset cost with crate value if there is currently nothing in the order
  const total_order_cost = orderBalance || CARGO_CRATE_VALUE;
  // multiplier of 1.1 for private orders
  const multiplier = isPrivateOrder ? 1.1 : 1;
  const extraData = {
    isPrivateOrder,
    canOrderCargo,
    total_order_cost,
    multiplier,
  } as ExtraData;

  const matMarketUIstate: MatMarketState = {
    currentHeaderTab,
    setCurrentHeaderTab,
    extraData: extraData,
  };

  return (
    <Window title="ARFS-LINK Material Wholesale" width={1250} height={600}>
      <Window.Content style={backgroundStyle}>
        <MatMarketContext.Provider value={matMarketUIstate}>
          {catastrophe ? (
            <MarketCrashModal />
          ) : (
            <span style={{ fontSize: '1.2rem' }}>
              <Stack fill vertical>
                <Stack.Item shrink>
                  <MatHead />
                </Stack.Item>
                <Stack.Item grow>
                  <MatBody />
                </Stack.Item>
                <Stack.Item shrink>
                  <MatFooter />
                </Stack.Item>
              </Stack>
            </span>
          )}
        </MatMarketContext.Provider>
      </Window.Content>
    </Window>
  );
};

function MatHead(): React.ReactElement {
  const { data, act } = useBackend<Data>();
  const { currentHeaderTab, setCurrentHeaderTab } = useLocalMMS();
  return (
    <Section
      style={headElement}
      // title="ARFS-LINK Material Wholesale"
    >
      <Stack fill vertical>
        <Stack.Item>
          <Stack fill>
            <Stack.Item shrink>
              <Button
                icon="list"
                style={
                  currentHeaderTab === HeaderTab.Mats
                    ? buttonStyleSelected
                    : buttonStyle
                }
                onClick={() => setCurrentHeaderTab(HeaderTab.Mats)}
              >
                Basic Materials
              </Button>
            </Stack.Item>
            <Stack.Item shrink>
              <Button
                icon="star"
                style={
                  currentHeaderTab === HeaderTab.Fancy
                    ? buttonStyleSelected
                    : buttonStyle
                }
                onClick={() => setCurrentHeaderTab(HeaderTab.Fancy)}
              >
                Exotic Materials
              </Button>
            </Stack.Item>
            {/* <Stack.Item shrink>
              <Button
                icon="info"
                color={
                  currentHeaderTab === HeaderTab.Info
                    ? 'primary'
                    : 'transparent'
                }
                onClick={() => setCurrentHeaderTab(HeaderTab.Info)}
              >
                Info
              </Button>
            </Stack.Item> */}

            <Stack.Item shrink style={{ whiteSpace: 'nowrap' }}>
              <BudgetButton />
            </Stack.Item>
            <Stack.Item grow />
            <Stack.Item shrink style={balanceStyle}>
              <span>
                Balance: <b>{data.creditBalance}¢</b>
              </span>
            </Stack.Item>
            <Stack.Item shrink style={balanceStyle}>
              <div style={{ display: 'flex', alignItems: 'center' }}>
                <div style={{ display: 'flex', flexGrow: 1 }}>
                  {`Cart: ${data.orderBalance}¢`}
                </div>
                <div style={{ display: 'flex' }}>
                  <Button
                    icon="times"
                    color="transparent"
                    onClick={() => act('clear')}
                  />
                </div>
              </div>
            </Stack.Item>

            <Button
              icon="question"
              style={
                currentHeaderTab === HeaderTab.Info
                  ? buttonStyleSelected
                  : buttonStyle
              }
              iconSize={1.2}
              onClick={() =>
                setCurrentHeaderTab(
                  currentHeaderTab === HeaderTab.Info
                    ? HeaderTab.Mats
                    : HeaderTab.Info,
                )
              }
            />
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
}

function MatBody(): React.ReactElement {
  const { currentHeaderTab } = useLocalMMS();
  let displayContent = <></>;
  switch (currentHeaderTab) {
    case HeaderTab.Info:
      displayContent = <InfoDisplay />;
      break;
    case HeaderTab.Mats:
      displayContent = <MatsList fancy={false} />;
      break;
    case HeaderTab.Fancy:
      displayContent = <MatsList fancy />;
      break;
  }
  return (
    <Section fill fitted scrollable>
      {displayContent}
    </Section>
  );
}

function MatFooter() {
  const { data } = useBackend<Data>();
  return (
    <Section style={{ textAlign: 'center' }}>
      <Box>
        <b>Next Market Update: </b>
        {Math.round(data.updateTime / 10)
          .toString()
          .padStart(2, '0')}
        {' seconds'}
      </Box>
    </Section>
  );
}

function InfoDisplay() {
  return <Section title="Info">Some info here</Section>;
}

function MatsList({ fancy }: { fancy: boolean }) {
  const { data, act } = useBackend<Data>();
  const { extraData } = useLocalMMS();
  const matList = fancy ? data.fancyMaterials : data.materials;
  return (
    <Box
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(4, minmax(0, 1fr))',
        gridAutoRows: '1fr',
        alignItems: 'stretch',
        gap: '8px',
        padding: '8px',
        width: '100%',
        minWidth: 0,
        boxSizing: 'border-box',
      }}
    >
      {sortBy(matList, [(tempmat: Material) => tempmat.rarity]).map(
        (mat: Material) => (
          <MaterialChunk
            key={mat.name}
            material={mat}
            extraData={extraData}
            data={data}
            multiplier={1}
            act={act}
          />
        ),
      )}
    </Box>
  );
}

function MaterialChunk({
  material,
  data,
  extraData,
  multiplier,
  act,
}: {
  material: Material;
  data: Data;
  extraData: ExtraData;
  multiplier: number;
  act: any;
}) {
  const titleBGcolor = backgroundify(material.color || 'white');

  const matUnavailable = !material.available || material.quantity <= 0;
  const decs = material.desc;

  return (
    <Box style={materialChunkStyle}>
      <div style={materialChunkHeaderStyle}>
        <b
          style={{
            ...materialChunkTitle,
            outlineColor: material.color,
            outlineStyle: 'solid',
            outlineWidth: '1px',
            borderRadius: '20px 5px 20px 5px',
            background: titleBGcolor,
            color: 'white',
          }}
        >
          {toTitleCase(material.name)}
        </b>
        <span style={materialChunkCostStyle}>
          Cost: {formatMoney(material.price)}¢
        </span>
      </div>
      <div style={materialChunkContentStyle}>
        {(matUnavailable && <UnavailableModal material={material} />) || (
          <>
            <div style={materialStatsStyle}>
              <b>Available</b>
              <span>{material.quantity || 'Zero'}</span>
              <b>In Cart</b>
              <span>{material.requested || 'Zero'}</span>
            </div>
            <Box
              style={materialDescriptionStyle}
              dangerouslySetInnerHTML={{ __html: decs }}
            />
          </>
        )}
      </div>
      <div style={materialChunkActionsStyle}>
        <Divider />
        <div style={buyOptionsStyle}>
          {[1, 5, 10, 25, 50].map((amount) => (
            <BuyButton
              key={amount}
              material={material}
              data={data}
              extraData={extraData}
              act={act}
              multiplier={multiplier}
              amount={amount}
            />
          ))}
        </div>
      </div>
    </Box>
  );
}

function BuyButton({
  data,
  material,
  extraData,
  amount,
  multiplier,
  act,
}: {
  data: Data;
  material: Material;
  extraData: ExtraData;
  amount: number;
  multiplier: number;
  act: any;
}) {
  const available = material.available;
  const { creditBalance, catastrophe, whichBudgetKey } = data;
  const { total_order_cost } = extraData;

  const cost = material.price * amount * multiplier;

  const isDisabled =
    catastrophe === 1 ||
    material.price < material.threshold ||
    creditBalance - total_order_cost < cost ||
    material.requested + amount > material.quantity ||
    !available;

  return (
    <Button
      width="100%"
      height="1.7em"
      bold
      style={{ ...buttonStyle, padding: '0px', opacity: isDisabled ? 0.5 : 1 }}
      textAlign="center"
      // disabled={isDisabled}
      tooltip={`Cost: ${cost} credits`}
      onClick={() =>
        act('buy', {
          quantity: amount,
          material: material.name,
          account: whichBudgetKey || 'private',
        })
      }
    >
      +{amount}
    </Button>
  );
}

function BudgetButton(): React.ReactElement {
  const { data, act } = useBackend<Data>();
  const { extraData: extra } = useLocalMMS();
  const hasAccess = extra.canOrderCargo;
  const isPrivate = extra.isPrivateOrder || !hasAccess;
  const budgetName = isPrivate ? 'Private' : data.whichBudgetName;
  const budgetKey = isPrivate ? 'private' : data.whichBudgetKey;

  let color = '';
  if (isPrivate) {
    color = 'rgb(22, 149, 0)';
  } else
    switch (budgetKey) {
      case 'CIV':
        color = 'rgb(94, 95, 95)';
        break;
      case 'ENG':
        color = 'rgb(101, 123, 0)';
        break;
      case 'SCI':
        color = 'rgb(143, 0, 74)';
        break;
      case 'MED':
        color = 'rgb(0, 140, 103)';
        break;
      case 'SRV':
        color = '#050';
        break;
      case 'CAR':
        color = 'rgb(167, 122, 68)';
        break;
      case 'SEC':
        color = 'rgb(135, 17, 17)';
        break;
      case 'CMD':
        color = '#260098';
        break;
      default:
        color = '#222';
        break;
    }
  // const accName = isPrivate
  //   ? 'Ordering via your personal account'
  //   : 'Ordering via ' + budgetName;

  const canToggle = hasAccess;

  return (
    <Box style={balanceStyle}>
      Account:{'\u00A0\u00A0'}
      <Button
        icon="dollar"
        tooltip="Click to swap between your personal account and your department's budget... if you have access to it!"
        disabled={!canToggle}
        style={{
          backgroundColor: color,
        }}
        onClick={() => canToggle && act('toggle_budget')}
      >
        {isPrivate ? 'Personal' : budgetName}
      </Button>
    </Box>
  );
}

const MarketCrashModal = (props) => {
  return (
    <Modal textAlign="center" mr={1.5}>
      ATTENTION! THE MARKET HAS CRASHED
      <br /> <br />
      ALL MATERIALS ARE NOW WORTHLESS
      <br /> <br />
      TRADING CIRCUIT BREAKER HAS BEEN ENGAGED FOR ALL TRADERS
      <br /> <br />
      <b>DO NOT PANIC, WE ARE FIXING THIS</b>
    </Modal>
  );
};

function UnavailableModal(props) {
  const { material } = props as { material: Material };

  // why not available?
  let innertext = 'It just isnt, bite me.';
  if (material.quantity <= 0)
    innertext = 'Supply inventory content insufficient. Check later.';
  else if (material.price <= 0)
    innertext =
      'Economic value mismatch error: value is NaN. Contact tech support.';
  else if (!material.available)
    innertext = 'Temporary logistical stop: Supplier unavailable. Check later.';

  return (
    <NoticeBox align="center">
      <b>MATERIAL UNAVAILABLE:</b>
      <br />
      {innertext}
    </NoticeBox>
  );
}

// takes a color (name, or hex), darkens them in two different ways, to make gradient
function backgroundify(color) {
  if (!color) return '';
  if (color.toLowerCase().startsWith('#')) {
    const color1 = ModifyHSLA(color, 0, 1, 0.2, 0, true);
    const color2 = ModifyHSLA(color, 0, 1.5, 0.5, 0, true);
    return `linear-gradient(90deg, ${color1}, ${color2} 80%, ${color1})`;
  }
  return color;
}

// styles
const baseStyle: React.CSSProperties = {
  background: 'linear-gradient(0deg, hsl(193, 29%, 22%), hsl(180, 61%, 9%))',
};

const headElement: React.CSSProperties = {
  ...baseStyle,
  fontWeight: 'bold',
};

const materialChunkStyle: React.CSSProperties = {
  background: 'linear-gradient(0deg, hsl(196, 24%, 22%), hsl(193, 24%, 12%))',
  border: '1px solid hsl(193, 24%, 32%)',
  borderRadius: '2px',
  display: 'grid',
  gridTemplateRows: 'auto 1fr auto',
  gap: '8px',
  minHeight: '160px',
  minWidth: 0,
  width: '100%',
  height: '100%',
  padding: '8px',
  boxSizing: 'border-box',
};
const materialChunkHeaderStyle: React.CSSProperties = {
  display: 'flex',
  alignItems: 'baseline',
  justifyContent: 'space-between',
  gap: '8px',
  minWidth: 0,
  paddingBottom: '4px',
  borderBottom: '2px solid hsl(193, 24%, 32%)',
};
const materialChunkContentStyle: React.CSSProperties = {
  minWidth: 0,
};
const materialChunkActionsStyle: React.CSSProperties = {
  alignSelf: 'end',
};
const materialChunkTitle: React.CSSProperties = {
  textShadow:
    '-1px 1px 2px black, 1px -1px 1px black, 1px 1px 1px black, 0 0 2px black',
  fontWeight: 'bold',
  width: '100%',
  minWidth: 0,
  overflowWrap: 'anywhere',
  textAlign: 'center',
};
const materialChunkCostStyle: React.CSSProperties = {
  whiteSpace: 'nowrap',
};
const materialStatsStyle: React.CSSProperties = {
  display: 'grid',
  borderBottom: '1px solid hsl(193, 24%, 32%)',
  gridTemplateColumns: '1fr 1fr 1fr 1fr',
  gap: '4px 8px',
};
const buyOptionsStyle: React.CSSProperties = {
  display: 'grid',
  gridTemplateColumns: 'repeat(5, minmax(0, 1fr))',
  gap: '4px',
};
const balanceStyle: React.CSSProperties = {
  whiteSpace: 'nowrap',
  alignContent: 'center',
  fontSize: '1.3rem',
  background: 'hsl(193, 24%, 16%)',
  border: '1px solid hsl(193, 24%, 32%)',
  borderRadius: '2px',
  padding: '4px',
  minWidth: '150px',
};
const buttonStyle: React.CSSProperties = {
  whiteSpace: 'nowrap',
  alignContent: 'center',
  fontSize: '1.3rem',
  background: 'hsl(195, 37%, 26%)',
  border: '1px solid hsl(193, 24%, 32%)',
  borderRadius: '2px',
  padding: '4px',
};
const buttonStyleSelected: React.CSSProperties = {
  whiteSpace: 'nowrap',
  alignContent: 'center',
  fontSize: '1.3rem',
  background: 'hsl(136, 52%, 31%)',
  border: '1px solid hsl(193, 24%, 32%)',
  borderRadius: '2px',
  padding: '4px',
};
const backgroundStyle: React.CSSProperties = {
  background: 'linear-gradient(0deg, hsl(193, 29%, 22%), hsl(180, 61%, 9%))',
};
const materialDescriptionStyle: React.CSSProperties = {
  marginTop: '4px',
  fontFamily: 'courier new',
  lineHeight: '0.8',
};
