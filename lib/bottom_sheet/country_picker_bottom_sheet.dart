import 'package:flutter/material.dart';
import '../screen/country_picker.dart';
import '../models/country_model.dart';


class SelectCountryCax {
  static Future<CountryCodeList?> show(
      {required BuildContext context,required Color mainColor, required bool isEnglish,required Widget closeButton,required String title,String? code,Widget? titleWidget,double?   borderRadius}) async {
    return await showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        elevation: 0,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height -(kToolbarHeight*2),
          //  minHeight: MediaQuery.of(context).size.height -(kToolbarHeight*2),
        ),
        builder: (context) => DraggableScrollableSheet(
          expand: true,
          initialChildSize: 1,
          builder:
              (BuildContext context, ScrollController scrollController) {
            return  CountryPicker(
              mainColor: mainColor,
              title: title,
              titleWidget: titleWidget,
              borderRadius :16,
              code_country: code??"", isEnglish: isEnglish, closeButton: closeButton,
            );
          },
        ));
  }
}