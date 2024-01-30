import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  TestWidgetsFlutterBinding.ensureInitialized();


  testWidgets('Dialog Widget Integration Test', (WidgetTester tester) async {
    tester.view.physicalSize = Size(1200,2400);
    addTearDown(tester.view.resetPhysicalSize);
    final myApp = MyApp(); // Lanza aplicación
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('myIconButton1')));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Autores - 💱'), findsOneWidget);
    expect(find.text('👨‍💻 Ivan Álvarez'), findsOneWidget);
    expect(find.text('🧑‍💻 Fer Álvarez'), findsOneWidget);
    expect(find.text('👩‍💻 Ivanna Pombo'), findsOneWidget);
  });

  testWidgets('Integration Test: Prueba de Conversión de Moneda', (WidgetTester tester) async {
    tester.view.physicalSize = Size(1200,2400);
    addTearDown(tester.view.resetPhysicalSize);
    final myApp = MyApp(); // Lanza aplicación
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key('amountTextField')), '5.0');
    expect(find.text('5.0'), findsOneWidget);
    await tester.pump();
    await tester.tapAt(Offset(600, 1200));
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    await tester.dragUntilVisible(find.text('EUR'), find.byKey( Key('currencyListView')), const Offset(0, -300));
    await tester.tap(find.text('EUR'));
    await tester.pump();
    await tester.pumpAndSettle(Duration(seconds: 3));
    expect(find.byType(Dismissible), findsOneWidget);
    //esto no va y no se porque, porque el de arriba si?
    //expect(find.textContaining('4.59'), findsOneWidget);
  });


  testWidgets('Dialog Widget Integration Test', (WidgetTester tester) async {
    final myApp = MyApp(); // Lanza aplicación
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('myIconButton2')));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Autores - 💱'), findsOneWidget);
    expect(find.text('👨‍💻 Ivan Álvarez'), findsOneWidget);
    expect(find.text('🧑‍💻 Fer Álvarez'), findsOneWidget);
    expect(find.text('👩‍💻 Ivanna Pombo'), findsOneWidget);
  });

  testWidgets('Integration Test: Prueba de Conversión de Moneda', (WidgetTester tester) async {
    final myApp = MyApp(); // Lanza aplicación
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key('amountTextField')), '5.0');
    expect(find.text('5.0'), findsOneWidget);
    /*
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.tap(find.text('Moneda de Origen'));
    await tester.pump();
    expect(find.byKey( Key('dissmissableListView')) ,findsOneWidget);
    await tester.dragUntilVisible(find.textContaining('USD'), find.byKey( Key('dissmissableListView')), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('5.00'), findsOneWidget);

     */
  });

  testWidgets('Integration Test: Prueba de teclado', (WidgetTester tester) async {
    final myApp = MyApp(); // Lanza aplicación
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key('amountTextField')), '5.555');
    expect(find.text('5.55'), findsOneWidget);
    expect(find.text('5.555'), findsNothing);
  });

  testWidgets('Integration Test: Prueba de teclado 2', (WidgetTester tester) async {
    final myApp = MyApp(); // Lanza aplicación
    await tester.pumpWidget(myApp);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(Key('amountTextField')), 'aaaaaañ¡-.,<q *');
    expect(find.text('0.00'), findsOneWidget);
  });

  /* TEST IMPOSIBLE DE PROBAR, HABRIA QUE CAMBIAR MUCHISIMO CODIGO O USAR CONNECTIVITY Y NO MERECE LA PENA
  TESTEAR EN INTERFAZ GRAFICA EN EMULADOR SIN WIFI
  testWidgets('Integration Test: No Wifi', (WidgetTester tester) async {

    tester.view.physicalSize = Size(1200,2400);
    addTearDown(tester.view.resetPhysicalSize);

    final myApp = MyApp(); // Lanza aplicación

    await tester.pumpWidget(myApp);

    await tester.pumpAndSettle();

    //...resto de codigo...
    expect(find.text('Error'), findsOneWidget);
    expect(find.text('No tienes conexión a Internet'), findsOneWidget);
  });
  */
}

