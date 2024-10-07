import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'fcm_test_mocks.dart';

void main() {
  setupFirebaseMessagingMocks();
  FirebaseMessaging? messaging;

   group('$FirebaseMessaging', () {

     setUpAll(() async {
      await Firebase.initializeApp();
      FirebaseMessagingPlatform.instance = kMockMessagingPlatform;
      messaging = FirebaseMessaging.instance;
    });
    group('subscribeToTopic', () {
      setUp(() {
        when(kMockMessagingPlatform.subscribeToTopic(''))
            .thenAnswer((_) => Future<void>.value());
      });

      test('throws AssertionError if topic is invalid', () async {
        const invalidTopic = 'test invalid = topic';

        expect(() => messaging!.subscribeToTopic(invalidTopic),
            throwsAssertionError);
      });

      test('verify delegate method is called with correct args', () async {
        when(kMockMessagingPlatform.subscribeToTopic(any))
            .thenAnswer((_) => Future<void>.value());

        const topic = 'test-topic';

        await messaging!.subscribeToTopic(topic);
        verify(kMockMessagingPlatform.subscribeToTopic(topic));
      });
    });
    group('unsubscribeFromTopic', () {
      when(kMockMessagingPlatform.unsubscribeFromTopic(any))
          .thenAnswer((_) => Future<void>.value());
      test('verify delegate method is called with correct args', () async {
        const topic = 'test-topic';

        await messaging!.unsubscribeFromTopic(topic);
        verify(kMockMessagingPlatform.unsubscribeFromTopic(topic));
      });
    });

  });
}