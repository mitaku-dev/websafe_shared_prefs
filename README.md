# websafe_shared_prefs

Wraps the [shared_preferences](https://pub.dev/packages/shared_preferences) plugin to ask for
consent under web.


##Warning
I can't guarantee that this package is DSVGO conform, i just tried to simplify this workflow.
Please ensure yourself it's working for your app in your intended way.



## Usage

To use this package,add ``websafe_shared_prefs`` as a dependency in your pubspec.yaml file.

## Initialization

use ``SafePreferences().init()`` to read from storage if consent is already given.
with ``SafePreferences().init(onError: _onError)`` an additional error callback can be set

###Example

```
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websafe_shared_prefs/websafe_shared_prefs.dart';

void main() {
    SafePreferences().init();
  runApp(MaterialApp(
    home: Scaffold(
      body: Column(
        children: [
            Center(
                child: RaisedButton(
                onPressed: _incrementCounter,
                child: Text('Increment Counter'),
                ),
            ),
            RaisedButton(
                onPressed: SafePreferences().allow(),
                child: Text('Allow'),
            ),
         ]        
        ),
    ),
  ));
}

_incrementCounter() async {
  SharedPreferences prefs = await SafePreferences().getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  print('Pressed $counter times.');
  await prefs.setInt('counter', counter);
}
```


Use ```SafePreferences().getInstance()``` to get the SharedPreferencs instance instead.
This will make no changes to usage under mobile, but under web it will result in throwing a
``StorageNotAllowedException`` by default.

You can use ```SafePreferences().allow()``` to allow SafePreferences to return SharedPreferences.


A full example is provided under examples/lib. It's a variant of the SharedPreferences example.

## Listen to allow changes
``SafePreferences().allow`` is a ValueNotifier, so its Listenable
Also you can define an callback in as: ``SafePreferences().allow(callback: callback)``


## CookieBanner
The package provides a really simple banner to ask for consent ``CookieBanner``.
You can edit the text by providing the parameter ``text`` : ``CookieBanner(text: 'Hello World')``






