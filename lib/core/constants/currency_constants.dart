class CurrencyOption {
  final String code; // ISO Code (USD)
  final String symbol; // 符號 ($)
  final String name; // 中文名稱 (美金)

  const CurrencyOption(this.code, this.symbol, this.name);
}

// 常用旅遊貨幣白名單
const List<CurrencyOption> kSupportedCurrencies = [
  CurrencyOption('TWD', '\$', '新台幣'),
  CurrencyOption('JPY', '¥', '日圓'),
  CurrencyOption('USD', '\$', '美金'),
  CurrencyOption('KRW', '₩', '韓元'),
  CurrencyOption('CNY', '¥', '人民幣'),
  CurrencyOption('HKD', '\$', '港幣'),
  CurrencyOption('EUR', '€', '歐元'),
  CurrencyOption('GBP', '£', '英鎊'),
  CurrencyOption('THB', '฿', '泰銖'),
  CurrencyOption('SGD', '\$', '新加坡幣'),
  CurrencyOption('VND', '₫', '越南盾'),
  CurrencyOption('MYR', 'RM', '馬來西亞林吉特'),
  CurrencyOption('AUD', '\$', '澳幣'),
  CurrencyOption('CAD', '\$', '加幣'),
  CurrencyOption('PHP', '₱', '菲律賓披索'),
  CurrencyOption('IDR', 'Rp', '印尼盾'),
];
