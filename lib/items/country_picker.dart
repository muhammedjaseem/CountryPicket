import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../items/atoz_sort.dart';
import '../items/az_common.dart';
import '../items/az_listview.dart';
import '../items/country_list_item.dart';
import '../items/index_bar.dart';

import '../models/country_model.dart';

class CountryPicker extends StatefulWidget {
  final String title;
  final String code_country;
  final Widget? titleWidget;
  final double? borderRadius;
   final bool isEnglish;
  final Widget closeButton;
  final Color mainColor;
  const CountryPicker({Key? key, required this.title, this.code_country = '',  this.titleWidget,this.borderRadius, required this.isEnglish, required this.closeButton, required this.mainColor}) : super(key: key);

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  bool isLoading = true;
  List<CountryCodeList> _countries = [];
  List<CountryCodeList> _topCountries = [];
  List<CountryCodeList> search_countries = [];
  TextEditingController? nation;
  var isSearch = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    nation = TextEditingController();
    loadData(widget.isEnglish);
  }

  void loadData(bool isEnglish) async {
    try {
      await rootBundle.loadString(
        'packages/country_picker_cax/asset/top__countries.json',
      ).then((value) {
        Map countyMap = json.decode(value);
        List list = countyMap['countrylist'];
        list.forEach((v) {
          _topCountries.add(CountryCodeList.fromJson(v));
        });
      });

      await rootBundle.loadString(
        'packages/country_picker_cax/asset/country.json',
      ).then((value) {
        Map countyMap = json.decode(value);
        List list = countyMap['countrylist'];
        list.forEach((v) {
          _countries.add(CountryCodeList.fromJson(v));
        });
        _handleList(_countries, isEnglish);
      });

      isLoading = false;
    }catch(e,s){
      print("error on Load $e,$s");
    }
  }

  void _handleList(List<CountryCodeList> list,bool isEnglish) {
    if (list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String sort = AtoZSort.getSortAtoZ(
          "${!(isEnglish) ? list[i].countryNameArabic : list[i].countryName}");
      String tag = sort.substring(0, 1).toUpperCase();
      list[i].namePinyin = sort;
      if (!(isEnglish)) {
        if (RegExp("[ا-ي]").hasMatch(tag)) {
          list[i].tagIndex = tag;
        } else {
          list[i].tagIndex = "#";
        }
      } else {
        if (RegExp("[A-Z]").hasMatch(tag)) {
          list[i].tagIndex = tag;
        } else {
          list[i].tagIndex = "#";
        }
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(list);
    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(list);
    // add topList.
    //_countries.insertAll(0, _topCountries);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;

    return Container(
        width: double.infinity,
        padding: widget.titleWidget ==null?null:EdgeInsets.symmetric(horizontal: 14),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:  BorderRadius.only(
                topRight: Radius.circular(widget.borderRadius??30), topLeft: Radius.circular(widget.borderRadius??30))),
        margin: EdgeInsets.only(top:widget.titleWidget ==null? 10.0:0),
        child: SafeArea(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              isLoading
                  ? Expanded(
                    child: Center(child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.black),
                          Text("Loading...")
                        ],
                      ),
                    )),
                  )
                  : Expanded(
                  child: Column(children: [
                    widget.titleWidget ==null?(Column(children:[  Row(children: [Spacer(),InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: widget.closeButton)],),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 18.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black
                                  ),),
                            ]),
                      ),])):widget.titleWidget!,

                    Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        height: 40,
                        width: double.infinity,
                        child: TextFormField(
                            controller: nation,
                            enableSuggestions: false,
                            enableIMEPersonalizedLearning: false,
                            autofillHints: [],
                            autocorrect: false,
                            onChanged: (s) async {
                              setState(() {
                                search_countries = _countries.where((element) {
                                  return element.iSDCode!.toLowerCase().contains(s.toLowerCase()) ||
                                      element.countryCode!.toLowerCase().contains(s.toLowerCase()) ||
                                      element.countryName!.toLowerCase().contains(s.toLowerCase()) ||
                                      element.countryNameArabic!.toLowerCase().contains(s.toLowerCase()) ||
                                      element.countryName!.toLowerCase().contains(s.toLowerCase());
                                }).toList();
                                isSearch = true;
                                _handleList(search_countries,widget.isEnglish);
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                hintText: 'search',
                                hintStyle:
                                TextStyle(fontSize: 13, fontFamily: 'Poppins-Regular', color:  Colors.black),
                                fillColor: isDarkMode? Colors.black : Colors.white,
                                filled: true,
                                contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey)),
                                suffixIcon: nation!.text.isNotEmpty
                                    ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            nation!.clear();
                                            search_countries.clear();
                                            isSearch = false;
                                          });
                                        },
                                        child: const CircleAvatar(
                                            backgroundColor: Colors.black,
                                            radius: 10,
                                            child: Icon(Icons.clear, color: Colors.white, size: 18))))
                                    : const Icon(Icons.search, color: Colors.black)))),
                    Expanded(
                        child: AzListView(
                            searchResult: isSearch,
                            extraWidget: !isSearch
                                ? Column(children: [
                              Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8), color:  Colors.grey),
                                  alignment: !(widget.isEnglish)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Text('top',style: TextStyle(
                                      fontSize: 12, color:  Colors.black, fontWeight: FontWeight.w900
                                  ),)),
                              const SizedBox(height: 10),
                              Column(
                                  children: _topCountries.map((model) {
                                    return CountryListItem.getWeChatListItem(context, model,isEnglish: widget.isEnglish);
                                  }).toList()),
                              Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color:  Colors.grey,
                                  ),
                                  alignment: !(widget.isEnglish)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Text('A',))
                            ])
                                : null,
                            data: search_countries.isNotEmpty ? search_countries : _countries,
                            itemCount: search_countries.isNotEmpty ? search_countries.length : _countries.length,
                            itemBuilder: (BuildContext context, int index) {
                              CountryCodeList model =
                              search_countries.isNotEmpty ? search_countries[index] : _countries[index];
                              return CountryListItem.getWeChatListItem(context, model,isEnglish: widget.isEnglish);
                            },
                            physics: const BouncingScrollPhysics(),
                            susItemBuilder: (BuildContext context, int index) {
                              CountryCodeList model =
                              search_countries.isNotEmpty ? search_countries[index] : _countries[index];
                              return CountryListItem.getSusItem(context, model.getSuspensionTag(), mainColor: widget.mainColor,isEnglish: widget.isEnglish);
                            },
                            indexBarData: !(widget.isEnglish)
                                ? [...kArabicIndexBarData]
                                : [...kIndexBarData],
                            indexBarAlignment:
                            !(widget.isEnglish) ? Alignment.centerLeft : Alignment.centerRight,
                            indexBarOptions: IndexBarOptions(
                                needRebuild: true,
                                ignoreDragCancel: true,
                                downTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
                                downItemDecoration:
                                const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF7FAFF1)),
                                indexHintWidth: 120 / 2,
                                indexHintHeight: 100 / 2,
                                textStyle: TextStyle(color:  Colors.black,fontSize: 13),
                                indexHintAlignment: !(widget.isEnglish)
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                indexHintChildAlignment: !(widget.isEnglish??false)
                                    ? const Alignment(0.0, -0.25)
                                    : const Alignment(-0.25, 0.0),
                                indexHintOffset: !(widget.isEnglish??false)
                                    ? const Offset(0, -20)
                                    : const Offset(-20, 0))))
                  ]))
            ])));
  }
}
