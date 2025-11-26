import 'dart:collection';

import 'dict_data.dart';

enum FormatText { WITHOUT_TONE, WITH_TONE_MARK, WITH_TONE_NUMBER }

class AtoZSort {
  static const String chineseRegex = "[\\u4e00-\\u9fa5]";
  static final RegExp chineseRegexp = RegExp(chineseRegex);

  static bool isChinese(String c) {
    return '〇' == c || chineseRegexp.hasMatch(c);
  }

  static Map<String, String> getPinyinResource() {
    return getResource(pinyinDict);
  }

  static Map<String, String> pinyinMap = getPinyinResource();

  static List<String> convertToPinyinArray(String c, FormatText format) {
    String? pinyin = pinyinMap[c];
    return pinyin == null ? [] : formatPinyin(pinyin, format);
  }

  static String getSortAtoZ(
    String str, {
    String separator = ' ',
    String defPinyin = ' ',
    FormatText format = FormatText.WITHOUT_TONE,
  }) {
    if (str.isEmpty) return '';
    StringBuffer sb = StringBuffer();
    str = convertToSimplifiedChinese(str);
    int strLen = str.length;
    int i = 0;
    while (i < strLen) {
      String subStr = str.substring(i);
      Multi? node = convertToMultiPinyin(subStr, separator, format);
      if (node == null) {
        String _char = str[i];
        if (isChinese(_char)) {
          List<String> pinyinArray = convertToPinyinArray(_char, format);
          if (pinyinArray.isNotEmpty) {
            sb.write(pinyinArray[0]);
          } else {
            sb.write(defPinyin);
            print(
                "### Can't convert to pinyin: $_char , defPinyin: $defPinyin");
          }
        } else {
          sb.write(_char);
        }
        if (i < strLen) {
          sb.write(separator);
        }
        i++;
      } else {
        sb.write(node.pinyin);
        i += node.word!.length;
      }
    }
    String res = sb.toString();
    return ((res.endsWith(separator) && separator != '')
        ? res.substring(0, res.length - 1)
        : res);
  }

  static String convertToSimplifiedChinese(String str) {
    StringBuffer sb = StringBuffer();
    for (int i = 0, len = str.length; i < len; i++) {
      sb.write(convertCharToSimplifiedChinese(str[i]));
    }
    return sb.toString();
  }

  static String convertCharToSimplifiedChinese(String c) {
    String? simplifiedChinese = chineseMap[c];
    return simplifiedChinese ?? c;
  }

  static final Map<String, String> chineseMap = getChineseResource();

  static Map<String, String> getChineseResource() {
    return getResource(chineseDict);
  }

  static Map<String, String> getResource(List<String> list) {
    Map<String, String> map = HashMap();
    List<MapEntry<String, String>> mapEntryList = [];
    for (int i = 0, length = list.length; i < length; i++) {
      List<String> tokens = list[i].trim().split('=');
      MapEntry<String, String> mapEntry = MapEntry(tokens[0], tokens[1]);
      mapEntryList.add(mapEntry);
    }
    map.addEntries(mapEntryList);
    return map;
  }

  static int maxMultiLength = 0;
  static int minMultiLength = 2;
  static const String pinyinSeparator = ',';
  static const String allMarkedVowel = 'āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜ';
  static const String allUnmarkedVowel = 'aeiouv';

  static Map<String, String> multiPinyinMap = getMultiPinyinResource();

  static Map<String, String> getMultiPinyinResource() {
    return getResource(multiPinyinDict);
  }

  static List<String> formatPinyin(String pinyinStr, FormatText format) {
    if (format == FormatText.WITH_TONE_MARK) {
      return pinyinStr.split(pinyinSeparator);
    } else if (format == FormatText.WITH_TONE_NUMBER) {
      return convertWithToneNumber(pinyinStr);
    } else if (format == FormatText.WITHOUT_TONE) {
      return convertWithoutTone(pinyinStr);
    }
    return [];
  }

  static List<String> convertWithoutTone(String pinyinArrayStr) {
    List<String> pinyinArray;
    for (int i = allMarkedVowel.length - 1; i >= 0; i--) {
      int originalChar = allMarkedVowel.codeUnitAt(i);
      double index = (i - i % 4) / 4;
      int replaceChar = allUnmarkedVowel.codeUnitAt(index.toInt());
      pinyinArrayStr = pinyinArrayStr.replaceAll(
          String.fromCharCode(originalChar), String.fromCharCode(replaceChar));
    }
    // 将拼音中的ü替换为v
    pinyinArray = pinyinArrayStr.replaceAll("ü", "v").split(pinyinSeparator);
    // 去掉声调后的拼音可能存在重复，做去重处理
    LinkedHashSet<String> pinyinSet = LinkedHashSet<String>();
    pinyinArray.forEach((value) {
      pinyinSet.add(value);
    });
    return pinyinSet.toList();
  }

  static List<String> convertWithToneNumber(String pinyinArrayStr) {
    List<String> pinyinArray = pinyinArrayStr.split(pinyinSeparator);
    for (int i = pinyinArray.length - 1; i >= 0; i--) {
      bool hasMarkedChar = false;
      String originalPinyin = pinyinArray[i].replaceAll('ü', 'v'); // 将拼音中的ü替换为v
      for (int j = originalPinyin.length - 1; j >= 0; j--) {
        int originalChar = originalPinyin.codeUnitAt(j);
        if (originalChar < 'a'.codeUnitAt(0) ||
            originalChar > 'z'.codeUnitAt(0)) {
          int indexInAllMarked =
              allMarkedVowel.indexOf(String.fromCharCode(originalChar));
          int toneNumber = indexInAllMarked % 4 + 1; // 声调数
          double index = (indexInAllMarked - indexInAllMarked % 4) / 4;
          int replaceChar = allUnmarkedVowel.codeUnitAt(index.toInt());
          pinyinArray[i] = originalPinyin.replaceAll(
                  String.fromCharCode(originalChar),
                  String.fromCharCode(replaceChar)) +
              toneNumber.toString();
          hasMarkedChar = true;
          break;
        }
      }
      if (!hasMarkedChar) {
        // 找不到带声调的拼音字母说明是轻声，用数字5表示
        pinyinArray[i] = originalPinyin + '5';
      }
    }

    return pinyinArray;
  }

  static Multi? convertToMultiPinyin(
      String str, String separator, FormatText format) {
    if (str.length < minMultiLength) return null;
    if (maxMultiLength == 0) {
      List<String> keys = multiPinyinMap.keys.toList();
      for (int i = 0, length = keys.length; i < length; i++) {
        if (keys[i].length > maxMultiLength) {
          maxMultiLength = keys[i].length;
        }
      }
    }
    for (int end = minMultiLength, length = str.length;
        (end <= length && end <= maxMultiLength);
        end++) {
      String subStr = str.substring(0, end);
      String? multi = multiPinyinMap[subStr];
      if (multi != null && multi.isNotEmpty) {
        List<String> str = multi.split(pinyinSeparator);
        StringBuffer sb = StringBuffer();
        str.forEach((value) {
          List<String> pinyin = formatPinyin(value, format);
          sb.write(pinyin[0]);
          sb.write(separator);
        });
        return Multi(word: subStr, pinyin: sb.toString());
      }
    }
    return null;
  }
}

class Multi {
  String? word;
  String? pinyin;

  Multi({this.word, this.pinyin});

  @override
  String toString() {
    StringBuffer sb = StringBuffer('{');
    sb.write("\"word\":\"$word\"");
    sb.write(",\"pinyin\":\"$pinyin\"");
    sb.write('}');
    return sb.toString();
  }
}
