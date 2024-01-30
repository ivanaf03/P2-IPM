import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const apiKey = 'cur_live_8wNpeTiYmtprT2jLbwJrKfgZFFmMYwEIkEEwrG0o';
const exchangeRatesAPIURL = 'https://open.er-api.com/v6/latest/';

class CurrencyPickerDialog extends StatefulWidget {
  final bool isBaseCurrency;

  CurrencyPickerDialog({required this.isBaseCurrency});

  @override
  _CurrencyPickerDialogState createState() => _CurrencyPickerDialogState();
}

List<String> currencies = [
  'USD',
  'AED',
  'AFN',
  'ALL',
  'AMD',
  'ANG',
  'AOA',
  'ARS',
  'AUD',
  'AWG',
  'AZN',
  'BAM',
  'BBD',
  'BDT',
  'BGN',
  'BHD',
  'BIF',
  'BMD',
  'BND',
  'BOB',
  'BRL',
  'BSD',
  'BTN',
  'BWP',
  'BYN',
  'BZD',
  'CAD',
  'CDF',
  'CHF',
  'CLP',
  'CNY',
  'COP',
  'CRC',
  'CUP',
  'CVE',
  'CZK',
  'DJF',
  'DKK',
  'DOP',
  'DZD',
  'EGP',
  'ERN',
  'ETB',
  'EUR',
  'FJD',
  'FKP',
  'FOK',
  'GBP',
  'GEL',
  'GGP',
  'GHS',
  'GIP',
  'GMD',
  'GNF',
  'GTQ',
  'GYD',
  'HKD',
  'HNL',
  'HRK',
  'HTG',
  'HUF',
  'IDR',
  'ILS',
  'IMP',
  'INR',
  'IQD',
  'IRR',
  'ISK',
  'JEP',
  'JMD',
  'JOD',
  'JPY',
  'KES',
  'KGS',
  'KHR',
  'KID',
  'KMF',
  'KRW',
  'KWD',
  'KYD',
  'KZT',
  'LAK',
  'LBP',
  'LKR',
  'LRD',
  'LSL',
  'LYD',
  'MAD',
  'MDL',
  'MGA',
  'MKD',
  'MMK',
  'MNT',
  'MOP',
  'MRU',
  'MUR',
  'MVR',
  'MWK',
  'MXN',
  'MYR',
  'MZN',
  'NAD',
  'NGN',
  'NIO',
  'NOK',
  'NPR',
  'NZD',
  'OMR',
  'PAB',
  'PEN',
  'PGK',
  'PHP',
  'PKR',
  'PLN',
  'PYG',
  'QAR',
  'RON',
  'RSD',
  'RUB',
  'RWF',
  'SAR',
  'SBD',
  'SCR',
  'SDG',
  'SEK',
  'SGD',
  'SHP',
  'SLE',
  'SLL',
  'SOS',
  'SRD',
  'SSP',
  'STN',
  'SYP',
  'SZL',
  'THB',
  'TJS',
  'TMT',
  'TND',
  'TOP',
  'TRY',
  'TTD',
  'TVD',
  'TWD',
  'TZS',
  'UAH',
  'UGX',
  'UYU',
  'UZS',
  'VES',
  'VND',
  'VUV',
  'WST',
  'XAF',
  'XCD',
  'XDR',
  'XOF',
  'XPF',
  'YER',
  'ZAR',
  'ZMW',
  'ZWL',
];

class _CurrencyPickerDialogState extends State<CurrencyPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Text(
        widget.isBaseCurrency
            ? "Seleccionar Moneda de Origen"
            : "Seleccionar Moneda de Destino",
        style: TextStyle(
          color: Color(0xFFA5582C),
        ),
      ),
      content: Container(
        width: double.minPositive,
        child: ListView(
          key: Key('currencyListView'),
          shrinkWrap: true,
          children: <Widget>[
            for (String currency in currencies)
              ListTile(
                title: Text(
                  currency,
                  style: TextStyle(
                    color: Color(0xFFA5582C),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(currency);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class CurrencyData with ChangeNotifier {
  Map<String, dynamic> _exchangeRates = {};

  Map<String, dynamic> get exchangeRates => _exchangeRates;

  Future<void> fetchExchangeRates(
      BuildContext context, String baseCurrency) async {
    try {
      final response =
          await http.get(Uri.parse('$exchangeRatesAPIURL$baseCurrency'));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        _exchangeRates = decodedData['rates'];
        notifyListeners();
      } else {
        throw Exception('Error en la solicitud');
      }
    } catch (e) {
      // Captura la excepción ClientException y muestra el diálogo de error.
      showErrorDialog(context);
    }
  }
}




void main() {
  runApp(
     MyApp(),
  );
}



class MyApp extends StatelessWidget with ChangeNotifier {
  TextEditingController amountController = TextEditingController();
  String baseCurrency = 'USD';
  String targetCurrency = 'EUR';
  List<String> selectedCurrencies = [];
  List<double> convertedAmounts = [];

  void ConvertCurrency(BuildContext context) async {
    final amount = double.tryParse(amountController.text) ?? 0;
    await Provider.of<CurrencyData>(context, listen: false)
        .fetchExchangeRates(context, baseCurrency);
    final exchangeRates =
        Provider.of<CurrencyData>(context, listen: false).exchangeRates;

    for (int i = 0; i < selectedCurrencies.length; i++) {
      final target = selectedCurrencies[i];
      if (exchangeRates.containsKey(target)) {
        convertedAmounts[i] = amount * exchangeRates[target];
      } else {
        convertedAmounts[i] = 0.0;
      }
    }
    notifyListeners();
  }

  void addCurrency(int index, String element) {
    selectedCurrencies.insert(index, element);
  }

  void removeCurrency(int index) {
    selectedCurrencies = List.from(selectedCurrencies)..removeAt(index);
    convertedAmounts = List.from(convertedAmounts)..removeAt(index);
  }

  void addToAmount(String digit, BuildContext context) {
    amountController.text += digit;
    ConvertCurrency(context);
  }

  void deleteLastDigit(BuildContext context) {
    if (amountController.text.isNotEmpty) {
      amountController.text =
          amountController.text.substring(0, amountController.text.length - 1);
      ConvertCurrency(context);
    }
  }

  void addDecimalPoint(BuildContext context) {
    if (!amountController.text.contains('.')) {
      amountController.text += '.';
      ConvertCurrency(context);
    }
  }

  void showCurrencyPicker(BuildContext context, bool isBaseCurrency) {
    showDialog(
      context: context,
      builder: (context) {
        return CurrencyPickerDialog(isBaseCurrency: isBaseCurrency);
      },
    ).then((selectedCurrency) {
      if (selectedCurrency != null) {
        // Actualizar el estado sin setState
        baseCurrency = isBaseCurrency ? selectedCurrency : baseCurrency;
        targetCurrency = isBaseCurrency ? targetCurrency : selectedCurrency;
        if (!isBaseCurrency) {
          selectedCurrencies.add(targetCurrency);
          convertedAmounts.add(0.0);
          ConvertCurrency(context);
        } else {
          Provider.of<CurrencyData>(context, listen: false).notifyListeners();
        }
      }
    });
  }

  void showCurrencyPicker2(
      BuildContext context, bool isBaseCurrency, String selectedCurrency) {
    // Actualizar el estado sin setState
    baseCurrency = isBaseCurrency ? selectedCurrency : baseCurrency;
    targetCurrency = isBaseCurrency ? targetCurrency : selectedCurrency;
    if (!isBaseCurrency) {
      selectedCurrencies.add(targetCurrency);
      convertedAmounts.add(0.0);
      ConvertCurrency(context);
    } else {
      Provider.of<CurrencyData>(context, listen: false).notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (context) => CurrencyData(),
        builder: (context, child) {
          // No longer throws
          return MaterialApp(
            theme: ThemeData.dark().copyWith(
              primaryColor: Color.fromARGB(255, 236, 194, 148),
              scaffoldBackgroundColor: Color.fromARGB(255, 236, 194, 148),
              textTheme: const TextTheme(
                titleLarge: TextStyle(
                  color: Color.fromARGB(255, 236, 194, 148),
                  fontSize: 24,
                ),
              ),
              dialogTheme:
              DialogTheme(backgroundColor: Color.fromARGB(255, 236, 194, 148)),
            ),
            home:  Scaffold(body: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Expanded(
                          flex: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFA5582C),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.26),
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                  offset: Offset(0.0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                          const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          child: Image(
                                            image:
                                            AssetImage('assets/Images/change.png'),
                                            color: Color(0xFF452212),
                                            width: 70,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                          const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                          child: const Text(
                                            "Currency\nConverter",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Color(0xFF452212),
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            margin:
                                            const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: IconButton(
                                              key: Key('myIconButton1'),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AboutDialog();
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.info,
                                                color: Color(0xFF452212),
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    alignment: Alignment.topCenter,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Moneda de Origen',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            transformAlignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            margin:
                                            const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                            child: Consumer<CurrencyData>(
                                              builder: (context,currencyData, child) {
                                                return TextButton(
                                                  onPressed: () {
                                                    showCurrencyPicker(context, true);
                                                  },
                                                  child: Text(
                                                    // Currency actual
                                                    baseCurrency,
                                                    style: TextStyle(
                                                      color: Color(0xFFA5582C),
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 6,
                            child: Consumer<CurrencyData>(
                              builder: (context, currencyData, child) {
                                return ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: selectedCurrencies.length,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                                      child: Dismissible(
                                        direction: DismissDirection.endToStart,
                                        key: UniqueKey(),
                                        onDismissed: (direction) {
                                          removeCurrency(index);
                                        },
                                        background: Container(
                                          color: Colors.transparent,
                                        ),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF452212),
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30),
                                            ),
                                          ),
                                          child: Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 1000,
                                              maxHeight: 35,
                                            ),
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 10, 20, 10),
                                            child: RichText(
                                              text: TextSpan(
                                                text:
                                                " ${convertedAmounts[index].toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  overflow: TextOverflow.fade,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                    " ${NumberFormat.simpleCurrency(
                                                      name: selectedCurrencies[index],
                                                      decimalDigits: 2,
                                                    ).currencySymbol}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.fade,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                    " - ${selectedCurrencies[index]}",
                                                    style: const TextStyle(
                                                      color: Color(0xFFA5582C),
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.fade,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            )),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFA5582C),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.26),
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                  offset: Offset(0.0, 0),
                                ),
                              ],
                            ),
                            child: Consumer<CurrencyData>(
                              builder: (context, currencyData, child) {
                                return Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    margin: const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                    child: TextField(
                                                      key: Key('amountTextField'),

                                                      textAlign: TextAlign.start,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                            r'^\d+\.?\d{0,2}')),
                                                      ],
                                                      controller: amountController,
                                                      keyboardType:
                                                      TextInputType.number,
                                                      style: const TextStyle(
                                                        overflow: TextOverflow.visible,
                                                        fontSize: 35,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                      decoration: const InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: '0.00',
                                                        hintStyle: TextStyle(
                                                          fontSize: 35,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        ConvertCurrency(context);
                                                      },
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    margin: const EdgeInsets.fromLTRB(
                                                        0, 0, 10, 0),
                                                    alignment: Alignment.centerRight,
                                                    child: Text(
                                                      " ${NumberFormat.simpleCurrency(
                                                        name: baseCurrency,
                                                        decimalDigits: 2,
                                                      ).currencySymbol}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          )),
                                    ),
                                    Expanded(
                                      flex: 0,
                                      child: Container(
                                        margin:
                                        const EdgeInsets.fromLTRB(0, 10, 15, 10),
                                        alignment: Alignment.centerRight,
                                        child: FloatingActionButton(
                                          key: Key('convertButton'),
                                          onPressed: () {
                                            showCurrencyPicker(context, false);
                                          },
                                          child: const Icon(Icons.add),
                                          elevation: 10,
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFA5582C),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.26),
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                  offset: Offset(0.0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin:
                                          const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                          child: Image(
                                            image:
                                            AssetImage('assets/Images/change.png'),
                                            color: Color(0xFF452212),
                                            width: 70,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                          const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                          child: const Text(
                                            "Currency\nConverter",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Color(0xFF452212),
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            margin:
                                            const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            child: IconButton(
                                              key: Key('myIconButton2'),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AboutDialog();
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.info,
                                                color: Color(0xFF452212),
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 0,
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                    alignment: Alignment.topCenter,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Moneda de Origen',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            transformAlignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            margin:
                                            const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                            child: Consumer<CurrencyData>(
                                              builder: (context, currencyData, child) {
                                                return TextButton(
                                                  onPressed: () {
                                                    showCurrencyPicker(context, true);
                                                  },
                                                  child: Text(
                                                    // Currency actual
                                                    baseCurrency,
                                                    style: TextStyle(
                                                      color: Color(0xFFA5582C),
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 6,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF452212),
                                        borderRadius: BorderRadius.only(),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.26),
                                            blurRadius: 5.0,
                                            spreadRadius: 3.0,
                                            offset: Offset(0.0, 0),
                                          ),
                                        ],
                                      ),
                                      child: Consumer<CurrencyData>(
                                        builder: (context, currencyData, child) {
                                          return ListView.builder(
                                            physics: const BouncingScrollPhysics(),
                                            itemCount: selectedCurrencies.length,
                                            padding:
                                            const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: const EdgeInsets.fromLTRB(
                                                    0, 10, 20, 10),
                                                child: Dismissible(
                                                  direction:
                                                  DismissDirection.endToStart,
                                                  key: UniqueKey(),
                                                  onDismissed: (direction) {
                                                    removeCurrency(index);
                                                  },
                                                  background: Container(
                                                    color: Colors.transparent,
                                                  ),
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 236, 194, 148),
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(30),
                                                        bottomRight:
                                                        Radius.circular(30),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      constraints: const BoxConstraints(
                                                        maxWidth: 1000,
                                                        maxHeight: 35,
                                                      ),
                                                      margin: const EdgeInsets.fromLTRB(
                                                          0, 10, 20, 10),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text:
                                                          " ${convertedAmounts[index].toStringAsFixed(2)}",
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontWeight: FontWeight.bold,
                                                            overflow: TextOverflow.fade,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                              " ${NumberFormat.simpleCurrency(
                                                                name:
                                                                selectedCurrencies[
                                                                index],
                                                                decimalDigits: 2,
                                                              ).currencySymbol}",
                                                              style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                overflow:
                                                                TextOverflow.fade,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                              " - ${selectedCurrencies[index]}",
                                                              style: const TextStyle(
                                                                color:
                                                                Color(0xFFA5582C),
                                                                fontSize: 30,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                overflow:
                                                                TextOverflow.fade,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        textAlign: TextAlign.left,
                                                        overflow: TextOverflow.fade,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )),
                                ),
                                Expanded(
                                  child: Container(
                                    //align elements inside to right
                                      alignment: Alignment.centerRight,
                                      transformAlignment: Alignment.centerRight,
                                      child: Consumer<CurrencyData>(
                                        builder: (context, currencyData, child) {
                                          return ListView.builder(
                                            key: Key('dissmissableListView'),
                                            physics: const BouncingScrollPhysics(),
                                            itemCount: currencies.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                transformAlignment:
                                                Alignment.centerRight,
                                                alignment: Alignment.centerRight,
                                                margin: const EdgeInsets.fromLTRB(
                                                    20, 10, 0, 10),
                                                child: Dismissible(
                                                  direction:
                                                  DismissDirection.startToEnd,
                                                  key: UniqueKey(),
                                                  onDismissed: (direction) {
                                                    showCurrencyPicker2(context, false,
                                                        currencies[index]);
                                                    removeCurrency(index);
                                                  },
                                                  background: Container(
                                                    color: Colors.transparent,
                                                  ),
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFF452212),
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(30),
                                                        bottomLeft: Radius.circular(30),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      constraints: const BoxConstraints(
                                                        maxWidth: 1000,
                                                        maxHeight: 35,
                                                      ),
                                                      margin: const EdgeInsets.fromLTRB(
                                                          20, 10, 10, 10),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text: currencies[index],
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontWeight: FontWeight.bold,
                                                            overflow: TextOverflow.fade,
                                                          ),
                                                        ),
                                                        textAlign: TextAlign.right,
                                                        overflow: TextOverflow.fade,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )),
                                ),
                              ],
                            )),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFA5582C),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.26),
                                  blurRadius: 5.0,
                                  spreadRadius: 3.0,
                                  offset: Offset(0.0, 0),
                                ),
                              ],
                            ),
                            child: Consumer<CurrencyData>(
                              builder: (context, currencyData, child) {
                                return Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    margin: const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                    child: TextField(
                                                      key: Key('amountTextField'),
                                                      textAlign: TextAlign.start,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                            r'^\d+\.?\d{0,2}')),
                                                      ],
                                                      controller: amountController,
                                                      keyboardType:
                                                      TextInputType.number,
                                                      style: const TextStyle(
                                                        overflow: TextOverflow.visible,
                                                        fontSize: 35,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                      decoration: const InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: '0.00',
                                                        hintStyle: TextStyle(
                                                          fontSize: 35,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        ConvertCurrency(context);
                                                      },
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    margin: const EdgeInsets.fromLTRB(
                                                        0, 0, 20, 0),
                                                    alignment: Alignment.centerRight,
                                                    child: Text(
                                                      " ${NumberFormat.simpleCurrency(
                                                        name: baseCurrency,
                                                        decimalDigits: 2,
                                                      ).currencySymbol}",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          )),
                                    ),
                                    Expanded(
                                      flex: 0,
                                      child: Container(
                                        margin:
                                        const EdgeInsets.fromLTRB(0, 10, 15, 10),
                                        alignment: Alignment.centerRight,
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            )),
          );
        }

    );



  }
}

Future<void> showErrorDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text('Error', style: TextStyle(color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/Images/no-wifi.png',
              width: 100,
              height: 100,
            ),
            Text(
              'No tienes conexión a Internet',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Back',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//Pop up animado con los autores de la app
class AboutDialog extends StatelessWidget {
  const AboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFA5582C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        height: 300,
        width: 300,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(35, 25, 0, 0),
                child: Text(
                  "Autores - 💱",
                  style: TextStyle(
                    color: Color(0xFF452212),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Divider(
              color: Colors.white,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            )),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                alignment: Alignment.topLeft,
                child: Text(
                  "👨‍💻 Ivan Álvarez",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                alignment: Alignment.topLeft,
                child: Text(
                  "🧑‍💻 Fer Álvarez",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                alignment: Alignment.topLeft,
                child: Text(
                  "👩‍💻 Ivanna Pombo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
