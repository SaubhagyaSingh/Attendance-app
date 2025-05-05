import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:attendance_app/main.dart';

// Create a mock class for CameraDescription
class MockCameraDescription extends Mock implements CameraDescription {
  @override
  String get name => 'mock_camera';

  @override
  CameraLensDirection get lensDirection => CameraLensDirection.back;

  @override
  int get sensorOrientation => 90;
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create a mock CameraDescription
    final mockCamera = MockCameraDescription();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(camera: mockCamera));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}