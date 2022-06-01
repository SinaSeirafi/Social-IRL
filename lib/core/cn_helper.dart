import 'dart:math';

// import '../Model/Models.dart';

// import '../CnImport.dart';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

// import 'package:intl/intl.dart';

// import 'app_constants.dart';

// ----- URL Launcher
launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      // forceWebView: false,
      // forceSafariVC: false,
    );
  } else {
    throw 'Could not launch $url';
  }
}

Helper h = Helper.instance;

class Helper {
  static final Helper _helper = Helper();
  static Helper get instance => _helper;

  String pycheck(String? string, String defaultv) {
    if (string == null || string.trim().isEmpty) {
      return defaultv;
    }
    return string;
  }

  String encryptPassword(String password) {
    return password;
  }

  double? doubleOk(var data) {
    if (data == null) return null;

    if (data is double) {
      return data;
    } else if (data is String) {
      try {
        return double.parse(data);
      } catch (e) {
        return null;
      }
    } else if (data is int) {
      return data.toDouble();
    }
    return null;
  }

  int? intOk(var data) {
    if (data == null) return null;

    if (data is int) {
      return data;
    } else if (data is String) {
      try {
        return int.parse(data);
      } catch (e) {
        return null;
      }
    } else if (data is double) {
      return data.toInt();
    }
    return null;
  }

  bool? boolOk(var data) {
    if (data == null) return null;

    if (data is bool) {
      return data;
    } else if (data is String) {
      if (data.toLowerCase() == 'false' || data == '0') {
        return false;
      } else if (data.toLowerCase() == 'true' || data == '1') {
        return true;
      }

      return null;
    } else if (data is int || data is double) {
      if (data == 1) return true;
      if (data == 0) return false;

      return null;
    }

    return null;
  }

  String? strOk(var data) {
    if (data == null) return null;

    if (data is String) {
      return data;
    } else {
      return data.toString();
    }
  }

  double? roundDouble(double? value) {
    if (value == null) return null;

    return ((value * 10).roundToDouble()) / 10;
  }

  double? roundDouble2(double? value) {
    if (value == null) return null;

    return ((value * 1000).roundToDouble()) / 1000;
  }

  int? roundToInt(double value, {double threshold = 0.5}) {
    double round = h.roundDouble(value)!;
    double? decimal = round - h.intOk(round)!;

    int integer = intOk(round - decimal)!;

    if (decimal >= threshold) {
      return integer + 1;
    } else {
      return integer;
    }
  }

  double? showLessDecimalsDouble(double? value, [int decimalPoints = 3]) {
    if (value == null) return null;

    int decimalValue = pow(10, decimalPoints).toInt();

    return intOk(value * decimalValue)! / decimalValue;
  }

  Color? colorFromString(String? color) {
    if (color == null) return null;
    if (color.length < 7) return null;

    String colorCode = color;
    colorCode = color.substring(1);

    return Color(intOk('0xFF$colorCode')!);
  }

  String? colorToString(Color? color) {
    if (color == null) return null;

    return '#' + color.toString().substring(10, 16);
  }

  String? colorToStringWithAlpha(Color? color) {
    if (color == null) return null;

    String colorString = color.toString();

    String colorCode = colorString.substring(10, 16);
    String alpha = colorString.substring(8, 10);

    return '#' + colorCode + alpha;
  }

  Color? colorFromStringWithAlpha(String? color) {
    if (color == null) return null;
    if (color.length < 9) return null;

    String numberSignRemoved = color.substring(1); // #000000FF

    String colorCode = numberSignRemoved.substring(0, 6);
    String alpha = numberSignRemoved.substring(6);

    return Color(intOk('0X$alpha$colorCode')!);
  }

  String? normalizeDateFromServer(String? date) {
    if (date == null) return null;
    // Date from server looks like: 2018-12-19T08:16:23.000Z
    // Date from server looks like: 2020-04-18T10:32:13.933,
    return date.substring(0, 10); // 2018-12-19
  }

  DateTime? dateTimeFromString(String? date) {
    if (date == null) return null;

    // Date from server looks like: 2020-04-18T10:32:13.933,

    int year = intOk(date.substring(0, 4))!; // 2020
    int month = intOk(date.substring(5, 7))!; // 04
    int day = intOk(date.substring(8, 10))!; // 18

    return DateTime(year, month, day);
  }

  String readableDateFromDateTime(DateTime dateTime) {
    return "${dateTime.year}/${dateTime.month}/${dateTime.day}";
  }

  String? normalizeDateFromStringAsDateTime(String? date) {
    if (date == null) return null;

    DateTime dateTime = dateTimeFromString(date)!;

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String normalizePriceString(
    double price, {
    int decimalPoints = 3,
    int reduceDecimalPointsTo = 0,
  }) {
    // return showLessDecimalsDouble(price).toString();

    // ---- the client didn't want this feature

    // double priceValue = price;

    // for (var i = 0; i < decimalPoints - reduceDecimalPointsTo; i++) {
    //   if (priceValue.toStringAsFixed(decimalPoints).endsWith('0'))
    //     decimalPoints--;
    // }

    return price.toStringAsFixed(decimalPoints);
  }

  TextDirection getTextDirectionByFirstLetter(String v) {
    final string = v.trim();
    if (string.isEmpty) return TextDirection.ltr;
    final firstUnit = string.codeUnitAt(0);
    if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }
}
//   String localizedAndNormalizedPriceString(
//     double price, {
//     int decimalPoints = 3,
//     int reduceDecimalPointsTo = 0,
//     bool showPerM2 = false,
//   }) {
//     if (textDirectionLtr)
//       return '${lstring('KD')} ${normalizePriceString(price)}${showPerM2 ? ' /m2' : ''}';

//     return '${normalizePriceString(price)} ${lstring('KD')} ${showPerM2 ? ' /m2' : ''}';
//   }

//   String localizedPriceString(double price) {
//     if (textDirectionLtr) return '$price ${lstring('KD')}';

//     return '${lstring('KD')} $price ';
//   }

//   String normalizeDate(String date) {
//     // Date is "2019-10-31"
//     // we want "31 Oct 2019"
//     String day = date.split('-')[2];
//     int month = h.intOk(date.split('-')[1]);
//     String year = date.split('-')[0];

//     return '$day ${monthAbbreviations[month - 1]} $year';
//   }

//   String separatePhoneNumber(String phoneNumber) {
//     var str = phoneNumber.toString();

//     if (str.length < 11) return str;

//     return str.substring(0, 4) +
//         ' ' +
//         str.substring(4, 7) +
//         ' ' +
//         str.substring(7);
//   }

//   Widget localizedPrice(
//     double price, {
//     bool strikeThrough = false,
//     double fontSize,
//     bool discountedPrice = false,
//   }) {
//     if (price == null) return Container();

//     if (fontSize == null) fontSize = defaultFontSize;

//     Widget _buildSeparator() {
//       return Container(
//         child: SizedBox(width: 3),
//       );
//     }

//     Color priceAndM2Color = defaultTextColor;
//     // discountedPrice ? defaultTextColor : defaultTextColor.withOpacity(0.4);

//     Widget priceWidget = Row(
//       children: <Widget>[
//         if (textDirectionLtr) ...[
//           CnText(
//             'KD',
//             fontSize: fontSize,
//             isBold: discountedPrice,
//           ),
//           _buildSeparator(),
//         ],
//         CnText(
//           normalizePriceString(price),
//           isBold: discountedPrice,
//           fontSize: fontSize,
//           color: priceAndM2Color,
//           localize: false,
//         ),
//         if (!textDirectionLtr) ...[
//           _buildSeparator(),
//           CnText(
//             'KD',
//             fontSize: fontSize,
//             isBold: discountedPrice,
//           ),
//         ],
//         _buildSeparator(),
//         CnText(
//           '/m2',
//           fontSize: fontSize,
//           isBold: discountedPrice,
//           color: priceAndM2Color,
//         ),
//       ],
//     );

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         if (!discountedPrice)
//           CnText(
//             'From',
//             fontSize: fontSize,
//           ),
//         _buildSeparator(),
//         !strikeThrough
//             ? priceWidget
//             : Stack(
//                 alignment: Alignment.center,
//                 children: <Widget>[
//                   priceWidget,
//                   Positioned(
//                     right: 0,
//                     left: 0,
//                     bottom: 8,
//                     child: Container(
//                       height: 1,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//       ],
//     );
//   }

//   final _priceFormatter = NumberFormat("#,##0", "en_US");

//   String showPrice(num price, {bool addTomanString = true}) {
//     if (price == null) return 'Null price';

//     String formattedPrice = _priceFormatter.format(price);

//     return addTomanString ? '$formattedPrice تومان' : formattedPrice;
//   }
// }

// class CalcWidth {
//   static Map calcWidth({
//     @required double deviceWidth,
//     @required double preferedWidth,
//     double minSpacing = 10,
//     double range = 0.15,
//   }) {
//     double calcCount(double width, double spacing) {
//       return (deviceWidth - spacing) / (spacing + width);
//     }

//     double calcRemaining(double width, double spacing) {
//       return (deviceWidth - spacing) % (spacing + width);
//     }

//     double spacing = minSpacing;
//     double width = preferedWidth * (1 - range); // Former minWidth
//     // dprint('spacing : $spacing');

//     double count = calcCount(width, minSpacing);
//     double remaining = calcRemaining(width, spacing);

//     // dprint(
//     //   'Begin ---> width: ${width.toInt()}, remaining: ${remaining.toInt()} px,',
//     // );

//     double maxAddition = preferedWidth * (range + 0.1);
//     double possibleAddition = (remaining / count);

//     // dprint('Possible addition : $possibleAddition, Max add: $maxAddition');

//     width += min(maxAddition, possibleAddition);

//     remaining = calcRemaining(width, spacing);

//     // dprint(
//     //   'Final ---> width: ${width.toInt()}, remaining: ${remaining.toInt()} px,',
//     // );

//     count = calcCount(width, spacing);

//     spacing = (remaining + (count + 1) * spacing) / (count + 1);
//     // dprint('spacing : $spacing');
//     width += (spacing - minSpacing) / count;
//     remaining = remaining - ((spacing - minSpacing));
//     spacing = (remaining + (count + 1) * spacing) / (count + 1);
//     // remaining = calcRemaining(width, spacing);
//     // dprint('spacing : $spacing');
//     // dprint(
//     //   'Final ---> width: ${width.toInt()}, remaining: ${remaining.toInt()} px,',
//     // );

//     Map mesurements = {
//       'width': width,
//       'spacing': spacing,
//       'itemsPerRow': count.toInt()
//     };
//     return mesurements;
//   }
// }

// -------------------------Adjust Width------------------------------

// class CalcWidth {
//   static Map calcWidth({
//     @required double deviceWidth,
//     @required double preferedWidth,
//     double minSpacing = 10,
//     double range = 0.15,
//   }) {
//     double calcCount(double width, double spacing) {
//       return (deviceWidth - spacing) / (spacing + width);
//     }

//     double calcRemaining(double width, double spacing) {
//       return (deviceWidth - spacing) % (spacing + width);
//     }

//     double spacing = minSpacing;
//     double width = preferedWidth * (1 - range); // Former minWidth
//     // dprint('spacing : $spacing');

//     double count = calcCount(width, minSpacing);
//     double remaining = calcRemaining(width, spacing);

//     // dprint(
//     //   'Begin ---> width: ${width.toInt()}, remaining: ${remaining.toInt()} px,',
//     // );

//     double maxAddition = preferedWidth * (range + 0.1);
//     double possibleAddition = (remaining / count);

//     // dprint('Possible addition : $possibleAddition, Max add: $maxAddition');

//     width += min(maxAddition, possibleAddition);

//     remaining = calcRemaining(width, spacing);

//     // dprint(
//     //   'Final ---> width: ${width.toInt()}, remaining: ${remaining.toInt()} px,',
//     // );

//     count = calcCount(width, spacing);

//     spacing = (remaining + (count + 1) * spacing) / (count + 1);
//     // dprint('spacing : $spacing');
//     width += (spacing - minSpacing) / count;
//     remaining = remaining - ((spacing - minSpacing));
//     spacing = (remaining + (count + 1) * spacing) / (count + 1);
//     // remaining = calcRemaining(width, spacing);
//     // dprint('spacing : $spacing');
//     // dprint(
//     //   'Final ---> width: ${width.toInt()}, remaining: ${remaining.toInt()} px,',
//     // );

//     Map mesurements = {
//       'width': width,
//       'spacing': spacing,
//       'itemsPerRow': count.toInt()
//     };
//     return mesurements;
//   }
// }

// -------------------------Search------------------------------

// List<Vendor> localSearchOperation(String searchText, List<Vendor> dataSource) {
//   List<Vendor> searchresult = [];

//   String searchTextLowerCase = searchText.toLowerCase();

//   // dprint('Starting the search operation for $searchText', priority: 4);

//   for (int i = 0; i < dataSource.length; i++) {
//     Vendor item = dataSource[i];

//     String itemName = item?.name;

//     if (itemName != null &&
//         itemName.toLowerCase().contains(searchTextLowerCase)) {
//       // dprint('Search result found $itemName with the same name');
//       searchresult.add(item);
//     }
//   }

//   return searchresult;
// }
