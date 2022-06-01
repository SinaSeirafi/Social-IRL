import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:social_irl/core/cn_helper.dart';

import '../../../core/app_constants.dart';

class CnText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double fontSize;
  final Color? color;
  final bool isBold;
  final double lineSpacing;
  final TextAlign align;
  final List<Shadow>? shadows;
  final int? maxLines;
  final bool oneLine;
  final TextOverflow overflow;
  final bool upperCase;
  final double minFontSize;
  final bool localize;
  final TextDirection? textDirection;
  final String? fontFamily;
  final FontWeight? fontWeight;

  const CnText(
    this.text, {
    Key? key,
    this.color,
    this.fontSize = 14,
    this.style,
    this.isBold = false,
    this.lineSpacing = 1.5,
    this.align = TextAlign.start,
    this.shadows,
    this.maxLines,
    this.oneLine = true,
    this.overflow = TextOverflow.ellipsis,
    this.upperCase = false,
    this.minFontSize = 12,
    this.localize = true,
    this.textDirection,
    this.fontFamily,
    this.fontWeight,
  }) : super(key: key);

  String get _text {
    // String localizedText = localize ? lstring(text) : text;
    String localizedText = text;
    return upperCase ? localizedText.toUpperCase() : localizedText;
  }

  FontWeight get _fontWeight {
    if (fontWeight != null) return fontWeight!;

    return isBold ? FontWeight.w500 : FontWeight.normal;
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      _text,
      textAlign: align,
      maxLines: maxLines ?? (oneLine ? 1 : null),
      minFontSize: fontSize < minFontSize ? fontSize : minFontSize,
      overflow: overflow,
      textDirection: textDirection,
      style: style ??
          TextStyle(
            shadows: shadows,
            color: color ?? defaultTextColor,
            height: lineSpacing,
            fontSize: fontSize,
            fontWeight: _fontWeight,
            fontFamily: fontFamily ?? defaultFontFamily,
          ),
    );
  }
}

class CnTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color? color;
  final bool upperCase;
  final bool isBold;
  final List<Shadow>? shadows;

  final bool localize;
  final int maxLines;

  final bool hasPadding;
  final EdgeInsetsGeometry padding;

  const CnTitle(
    this.title, {
    Key? key,
    this.fontSize = 16.0,
    this.color,
    this.upperCase = false,
    this.isBold = true,
    this.shadows,
    this.localize = false,
    this.maxLines = 1,
    this.padding = const EdgeInsets.only(left: defaultPadding),
    this.hasPadding = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: hasPadding ? padding : EdgeInsets.zero,
      child: CnText(
        title,
        upperCase: upperCase,
        fontSize: fontSize,
        color: color ?? defaultTextColor,
        isBold: isBold,
        shadows: shadows,
        localize: localize,
        maxLines: maxLines,
      ),
    );
  }
}

class TitledText extends StatelessWidget {
  final String title;
  final String details;

  final bool titleUpperCase;
  final bool boldTitle;
  final bool boldDetails;
  final bool addColon;

  final bool localizeTitle;
  final bool localizeDetails;

  final double titleFontSize;
  final double detailsFontSize;

  final Color? titleTextColor;
  final Color? detailsTextColor;

  final int detailsMaxLines;

  /// making the details section expanded so that it
  /// respects the width restrictions
  final bool expandDetails;

  const TitledText({
    Key? key,
    required this.title,
    required this.details,
    this.titleUpperCase = false,
    this.boldTitle = true,
    this.boldDetails = false,
    this.addColon = true,
    this.localizeTitle = true,
    this.localizeDetails = false,
    this.titleFontSize = 14,
    this.detailsFontSize = 14,
    this.titleTextColor,
    this.detailsTextColor,
    this.detailsMaxLines = 1,
    this.expandDetails = false,
  }) : super(key: key);

  Widget _buildDetails() {
    return CnText(
      h.strOk(details) ?? "",
      isBold: boldDetails,
      localize: localizeDetails,
      fontSize: detailsFontSize,
      color: detailsTextColor,
      maxLines: detailsMaxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CnText(
          title,
          isBold: boldTitle,
          localize: localizeTitle,
          upperCase: titleUpperCase,
          fontSize: titleFontSize,
          color: titleTextColor,
        ),
        CnText(
          addColon ? ': ' : ' ',
          isBold: boldTitle,
        ),
        !expandDetails
            ? _buildDetails()
            : Expanded(
                child: _buildDetails(),
              ),
      ],
    );
  }
}

class TitleRow extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? margin;

  final bool addColon;
  final bool localize;
  final bool isBold;
  final bool upperCase;

  final List<Shadow>? shadows;
  final double fontSize;

  final int maxLines;

  final Color? color;

  const TitleRow(
    this.title, {
    this.margin,
    Key? key,
    this.addColon = false,
    this.localize = false,
    this.isBold = false,
    this.upperCase = false,
    this.shadows,
    this.fontSize = 20,
    this.maxLines = 2,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _title = title;
    if (addColon) _title += ':';

    return Container(
      margin: margin ??
          const EdgeInsets.only(
            left: defaultPadding,
            right: defaultPadding,
            bottom: defaultPadding,
          ),
      child: CnText(
        _title,
        isBold: isBold,
        localize: localize,
        shadows: shadows,
        fontSize: fontSize,
        maxLines: maxLines,
        color: color,
        upperCase: upperCase,
      ),
    );
  }
}

// class TextWithIcon extends StatelessWidget {
//   final CnIconData icon;
//   final String text;

//   final double iconSize;
//   final Color color;

//   final int maxLines;

//   const TextWithIcon({
//     @required this.icon,
//     @required this.text,
//     this.iconSize,
//     this.color,
//     this.maxLines = 2,
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         CnIcon.image(
//           icon.icon,
//           size: iconSize,
//           color: color ?? defaultTextColor,
//         ),
//         SizedBox(width: 8),
//         Expanded(
//           child: Padding(
//             // to align the text and icon
//             // this font has empty header area
//             padding: const EdgeInsets.only(bottom: 3.0),
//             child: CnText(
//               text,
//               maxLines: maxLines,
//               color: color ?? defaultTextColor,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
