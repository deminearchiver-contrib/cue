import 'package:cue/cue.dart';
import 'package:example/examples/bottom_bar.dart';
import 'package:example/examples/delete_confirmation.dart';
import 'package:example/examples/horizinally_expanding_cards.dart';
import 'package:example/examples/image_grid_modal.dart';
import 'package:example/examples/indicator_to_button.dart';
import 'package:example/examples/ios_context_menu.dart';
import 'package:example/examples/on_scroll_parallax.dart';
import 'package:example/examples/options_button.dart';
import 'package:example/examples/slack_style_fab.dart';
import 'package:example/examples/smooth_switch.dart';
import 'package:example/examples/three_dots_action.dart';
import 'package:example/examples/wallet_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cue",
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const Demo1View(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        if (kDebugMode) {
          return CueDebugTools(child: child!);
        }
        return child!;
      },
    );
  }
}

class Demo1View extends StatefulWidget {
  const Demo1View({super.key});

  @override
  State<Demo1View> createState() => _Demo1ViewState();
}

class _Demo1ViewState extends State<Demo1View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HorizontallyExpandingCards(),
      // floatingActionButton: ThreeDotsAction(),
      floatingActionButton: SlackStyleFab(),
    );
  }
}
