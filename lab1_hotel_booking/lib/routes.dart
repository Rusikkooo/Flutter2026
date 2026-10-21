import 'package:flutter/material.dart';

import 'models/stay.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';

// R25: имена маршрутов — константы; '/' пишем только в этом файле
class Routes {
  static const shell = '/';
  static const detail = '/detail';
  static const form = '/form';

  // R25: детали и форма строятся из типизированных аргументов
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    if (settings.name == detail && args is DetailArgs) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (context) => DetailScreen(args: args),
      ); // MaterialPageRoute
    }

    if (settings.name == form && args is FormArgs) {
      return MaterialPageRoute<Stay>(
        settings: settings,
        builder: (context) => FormScreen(args: args),
      ); // MaterialPageRoute
    }

    return null; // всё остальное уйдёт в onUnknownRoute
  }

  // R25: страница «Not found»
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Not found'),
        ), 
        body: Center(
          child: Text('No page for ${settings.name}'),
        ), 
      ), 
    ); 
  }
}

// R26: что получает экран деталей (колбэки добавим на этапе 4)
class DetailArgs {
  const DetailArgs({required this.stay});
  final Stay stay;
}

// R26: что получает форма: Stay — правка, null — новое предложение
class FormArgs {
  const FormArgs({this.stay});
  final Stay? stay;
}