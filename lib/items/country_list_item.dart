import 'package:flutter/material.dart';
import '../models/country_model.dart';
import 'circle_flag.dart';
import 'get_country_flag.dart';
class CountryListItem {
  static String getImgPath(String name, {String format = 'png'}) {
    return 'asset/images/$name.$format';
  }

  static Widget getSusItem(BuildContext context, String tag,
      {double susHeight = 40,required Color mainColor,required bool isEnglish}) {
    bool isDarkMode = false;
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:  mainColor,
      ),
      alignment: !isEnglish
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Text(tag, style: TextStyle(fontSize: 12, color:Colors.white),),
    );
  }

  static Widget getWeChatListItem(
    BuildContext context,
    CountryCodeList model, {
    double susHeight = 40,
    Color? defHeaderBgColor,
        required bool isEnglish
  }) {
    return getWeChatItem(context, model, defHeaderBgColor: defHeaderBgColor, isEnglish:isEnglish);
  }

  static Widget getWeChatItem(
    BuildContext context,
    CountryCodeList model, {
    Color? defHeaderBgColor,

        required bool isEnglish
  }) {
    bool isDarkMode = false;

    DecorationImage? image;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, model);
            },
            child: Row(
              children: [
                CircledFlag(
                    flag: GetCountryFlag.show(model.countryCode),
                    radius: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(text: '', children: [
                      TextSpan(
                          text: !isEnglish
                              ? model.countryNameArabic
                              : model.countryName,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          )),
                      const WidgetSpan(
                          child: SizedBox(
                        width: 5,
                      )),
                      TextSpan(
                        text: !isEnglish?'${model.countryCodeFormatted?.replaceAll('+', '')}+':model.countryCodeFormatted,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          indent: 15,
          endIndent: 20,
        )
      ],
    );
  }
}
