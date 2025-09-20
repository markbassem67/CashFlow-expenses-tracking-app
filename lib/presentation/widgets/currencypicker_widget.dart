import 'package:currency_picker/currency_picker.dart';

class CurrencypickerWidget {
  static Future<void> pickCurrency(context) async {
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        String selectedCurrency =
            '${currency.code} (${currency.symbol})'; //TODO: Use this value
      },
    );
  }
}
