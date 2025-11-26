import 'dart:convert';

import '../items/az_common.dart';
class CountryCodeList extends ISuspensionBean {
  String? countryId;
  String? tagIndex;
  String? countryCode;
  String? countryName;
  String? countryNameArabic;
  String? mobileCode;
  String? namePinyin;
  String? mobileCodeArabc;
  String? iSDCode;
  String? currencyCode;
  String? culture;
  String? countryFormat;
  String? countryCodeFormat;
  String? countrynameFormatted;
  String? countryCodeFormatted;

  CountryCodeList(
      {this.countryId,
        this.countryCode,
        this.namePinyin,
        this.tagIndex,
        this.countryName,
        this.countryNameArabic,
        this.mobileCode,
        this.mobileCodeArabc,
        this.iSDCode,
        this.currencyCode,
        this.culture,
        this.countryFormat,
        this.countryCodeFormat,
        this.countrynameFormatted,
        this.countryCodeFormatted});

  CountryCodeList.fromJson(Map<String, dynamic> json) {
    countryId = json['CountryId'];
    countryCode = json['CountryCode'];
    countryName = json['CountryName'];
    countryNameArabic = json['CountryNameArabic'];
    mobileCode = json['MobileCode'];
    mobileCodeArabc = json['MobileCodeArabc'];
    iSDCode = json['ISDCode'];
    currencyCode = json['CurrencyCode'];
    culture = json['culture'];
    countryFormat = json['CountryFormat'];
    countryCodeFormat = json['CountryCodeFormat'];
    countrynameFormatted = json['CountrynameFormatted'];
    countryCodeFormatted = json['CountryCodeFormatted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['CountryId'] = countryId;
    data['CountryCode'] = countryCode;
    data['CountryName'] = countryName;
    data['CountryNameArabic'] = countryNameArabic;
    data['MobileCode'] = mobileCode;
    data['MobileCodeArabc'] = mobileCodeArabc;
    data['ISDCode'] = iSDCode;
    data['CurrencyCode'] = currencyCode;
    data['culture'] = culture;
    data['CountryFormat'] = countryFormat;
    data['CountryCodeFormat'] = countryCodeFormat;
    data['CountrynameFormatted'] = countrynameFormatted;
    data['CountryCodeFormatted'] = countryCodeFormatted;
    return data;
  }

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => json.encode(this);
}
