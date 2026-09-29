import { sortBy } from 'es-toolkit';
import {
  Button,
  Collapsible,
  Divider,
  Modal,
  NoticeBox,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { formatMoney } from 'tgui-core/format';
import type { BooleanLike } from 'tgui-core/react';
import { toTitleCase } from 'tgui-core/string';

import { useBackend } from '../backend';
import { Window } from '../layouts';

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
};

export const MatMarket = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    isPrivateOrder,
    canOrderCargo, // access
    creditBalance,
    orderBalance,
    materials = [],
    fancyMaterials = [],
    catastrophe,
    whichBudgetKey,
    whichBudgetName,
    updateTime,
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
  } as ExtraData;

  return (
    <Window width={1110} height={600}>
      <Window.Content scrollable>
        {!!catastrophe && <MarketCrashModal />}
        <Section title="Materials for sale">
          <NoticeBox info>
            <Collapsible title="Instructions" color="blue">
              Buy orders for material sheets placed here will be ordered on the
              next cargo shipment.
              <br /> <br />
              To prevent market manipulation, all registered traders can buy a
              total of 10 full stacks of materials at a time.
              <br /> <br />
              All new purchases will include the cost of the shipped crate,
              which may be recycled afterwards.
            </Collapsible>
          </NoticeBox>
          <Section fill>
            <Stack fill fontSize="1.2rem">
              <Stack.Item align="center">
                Selected Account:{' '}
                <b>
                  {<BudgetButton extra={extraData} data={data} act={act} />}
                </b>
              </Stack.Item>
              <Stack.Item>
                balance: <b>{formatMoney(creditBalance)}</b>
              </Stack.Item>
              <Stack.Item>
                Current Order: <b>{formatMoney(orderBalance)}</b>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="times"
                  color="transparent"
                  onClick={() => act('clear')}
                >
                  Empty Cart
                </Button>
              </Stack.Item>
              <Stack.Item
                shrink
                color={data.updateTime > 150 ? 'green' : '#ad7526'}
              >
                <b>{Math.round(data.updateTime / 10)} seconds</b> until next
                update
              </Stack.Item>
            </Stack>
          </Section>
        </Section>
        <Section title="Standard Materials">
          {sortBy(materials, [(tempmat: Material) => tempmat.rarity]).map(
            (mat: Material) => (
              <MaterialRow
                key={mat.name}
                material={mat}
                extraData={extraData}
                data={data}
                multiplier={multiplier}
                act={act}
              />
            ),
          )}
        </Section>
        <Section title="Exotic Materials">
          {sortBy(fancyMaterials, [(tempmat: Material) => tempmat.rarity]).map(
            (mat: Material) => (
              <MaterialRow
                key={mat.name}
                material={mat}
                extraData={extraData}
                data={data}
                multiplier={multiplier}
                act={act}
              />
            ),
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

function MaterialRow({
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
  return (
    <Section key={material.name}>
      <Stack fill>
        <Stack.Item width="75%">
          <Stack>
            <Stack.Item
              textColor={material.color ? material.color : 'white'}
              fontSize="125%"
              width="15%"
              pr="3%"
            >
              <Tooltip content={material.desc}>
                {toTitleCase(material.name)}
              </Tooltip>
            </Stack.Item>
            {/* <Stack.Item
              width="10%"
              pr="2%"
              textColor={
                material.elastic < 33
                  ? 'red'
                  : material.elastic < 66
                    ? 'orange'
                    : 'green'
              }
            >
              Elast: <b>{Math.round(material.elastic)}</b>%
            </Stack.Item> */}

            <Stack.Item width="15%" pr="2%">
              Price Per Unit: <b>{formatMoney(material.price)}</b> cr.
            </Stack.Item>
            {!material.available ? (
              <Stack.Item width="33%" ml={2} textColor="grey">
                Material currently unavailable!
                <br />
                <b>Check back later!</b>
              </Stack.Item>
            ) : (
              <Stack.Item width="33%" ml={2}>
                <b>Available: </b>
                {material.quantity || 'Zero'} units
                <br />
                <b>In Cart:</b> {material.requested || 'Zero'} units
              </Stack.Item>
            )}

            <Stack.Item
              width="40%"
              color={
                material.trend === 'up'
                  ? 'green'
                  : material.trend === 'down'
                    ? 'red'
                    : 'white'
              }
            >
              <b>Value</b> is trending <b>{material.trend}</b>!
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          {!material.available || material.quantity <= 0 ? (
            'Currently out of stock!'
          ) : (
            <>
              <BuyButton
                material={material}
                data={data}
                extraData={extraData}
                act={act}
                multiplier={multiplier}
                amount={1}
              />
              <BuyButton
                material={material}
                data={data}
                extraData={extraData}
                act={act}
                multiplier={multiplier}
                amount={5}
              />
              <BuyButton
                material={material}
                data={data}
                extraData={extraData}
                act={act}
                multiplier={multiplier}
                amount={10}
              />
              <BuyButton
                material={material}
                data={data}
                extraData={extraData}
                act={act}
                multiplier={multiplier}
                amount={25}
              />
              <BuyButton
                material={material}
                data={data}
                extraData={extraData}
                act={act}
                multiplier={multiplier}
                amount={50}
              />
            </>
          )}
        </Stack.Item>
      </Stack>
    </Section>
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
      ml="2px"
      disabled={isDisabled}
      tooltip={`Cost: ${cost} credits`}
      onClick={() =>
        act('buy', {
          quantity: amount,
          material: material.name,
          account: whichBudgetKey || 'private',
        })
      }
    >
      {amount}
    </Button>
  );
}

function BudgetButton({
  data,
  extra,
  act,
}: {
  data: Data;
  extra: ExtraData;
  act: any;
}): React.ReactElement {
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
