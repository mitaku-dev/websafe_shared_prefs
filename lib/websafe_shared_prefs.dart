library websafe_shared_prefs;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageNotAllowedException implements Exception {}


class SafePreferences {

 // bool _allowed = false;
  Function? onError;

 // bool get isAllowed => _allowed;


  final allowed = ValueNotifier<bool>(false);

  SafePreferences._internal(){
    allowed.value = false;
    //check if sharedPreferences is set

  }
  static final SafePreferences _instance = SafePreferences._internal();
  factory SafePreferences() => _instance;


  init({Function? onError}) async {
    this.onError = onError;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    allowed.value = prefs.getBool('storage_allowed') ?? false;

  }


  Future<SharedPreferences> getInstance() {
    if(kIsWeb && !allowed.value) {
      if(onError == null) throw StorageNotAllowedException();
      onError!();
      return Future.error('StorageNotAllowed');
    }
      return SharedPreferences.getInstance();
  }


  allow() async{
    allowed.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('storage_allowed', true);
  }


}


class CookieBanner extends StatefulWidget {

  CookieBanner({Function? callback, String? text}): _callback=callback, _text=text;
  Function? _callback;
  String? _text;

  @override
  _CookieBannerState createState() => _CookieBannerState();
}

class _CookieBannerState extends State<CookieBanner> {

  bool hidden = false;


  @override
  void initState() {
    hidden = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  kIsWeb && !SafePreferences().allowed.value && !hidden ?
    Container(
      width: 700,
      child: MaterialBanner(
            content: Text(widget._text ?? 'We need to use Local Storage for some functions on this website.'
                'Please allow us to save Data to enhance your user experience.'
                'If you dont consent, we cant ensure all functionalities are avaible for you'),
          padding: const EdgeInsets.all(20),
          contentTextStyle: TextStyle(color: Colors.black),
          backgroundColor: Colors.grey.shade500.withOpacity(0.2),
            actions: [
              ElevatedButton(
                  onPressed: _allow,
                  child: const Text("Allow"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)
                  )
              ),
              FlatButton(onPressed: _closeBanner, child: const Text("Decline"))
            ]
      ),
    ) : Container();
  }

  _allow(){
    setState(() {
      SafePreferences().allow();
      widget._callback!();
    });
  }

  _closeBanner() {
    setState(() {
      hidden = !hidden;
    });
  }
}
