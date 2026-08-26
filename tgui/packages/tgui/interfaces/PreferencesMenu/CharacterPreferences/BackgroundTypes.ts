export enum TTipContentType {
  HelpGeneral,
  HelpEarly,
  HelpAdult,

  EarlyCounter,
  EarlyCounterNeedMore,
  EarlyCounterAtMax,

  AdultCounter,
  AdultCounterNeedMore,
  AdultCounterAtMax,

  EarlyButton,
  EarlyButtonDisabled,

  AdultButton,
  AdultButtonDisabled,

  AllClearButton,
  EarlyClearButton,
  AdultClearButton,

  TabAllYourBgs,
  TabEveryBg,
}

export type TTipExtraData = {
  earlyCount: number;
  earlyMaxCount: number;
  earlyMinCount: number;
  adultCount: number;
  adultMinCount: number;
  adultMaxCount: number;
  count: number;
};

export enum TTipCategory {
  TTGenInfo,
  TTEarlyInfo,
  TTAdultInfo,

  TTCountEarly,

  TTCountAdult,

  TTClearAll,
  TTClearEarly,
  TTClearAdult,

  TTButtonEarly,
  TTButtonAdult,

  TTTabAllYourBgs,
  TTTabEveryBg,
}
