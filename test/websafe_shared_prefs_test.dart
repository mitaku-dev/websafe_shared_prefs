import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:websafe_shared_prefs/websafe_shared_prefs.dart';

/*
Tests should be run with: flutter test --platform chrome
 */

void main() {
  test('SafePrefs get initialized with false', () {
    final sprefs = SafePreferences();
    expect(sprefs.allowed.value, false);
  });

  test('SafePrefs throws when not allowed', () {
    final sprefs = SafePreferences();
    expect(() => sprefs.getInstance(), throwsA(isInstanceOf<StorageNotAllowedException>()));
  });

  test('SafePrefs return prefs when allowed', () async {
    final sprefs = SafePreferences();
    sprefs.allow();
    final prefs = await sprefs.getInstance();
  });


}
