import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Gerador de Frase',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  Random random = new Random();
  var list = [
    "Salada de frango grelhado com vegetais frescos.",
    "Espaguete à bolonhesa.",
    "Filé de peixe assado com batatas e legumes.",
    "Strogonoff de carne com arroz e batata palha.",
    "Risoto de cogumelos.",
    "Lasanha de carne ou vegetariana.",
    "Tacos de carne ou frango com guacamole.",
    "Sopa de legumes com pão integral.",
    "Sanduíche natural de atum com salada.",
    "Omelete de queijo e presunto com salada verde.",
    "Wrap de frango com alface, tomate e molho de iogurte.",
    "Frango ao curry com arroz basmati.",
    "Quiche de espinafre e ricota.",
    "Hamburguer caseiro com batata doce frita.",
    "Filé mignon ao molho de mostarda com purê de batatas.",
    "Cuscuz marroquino com legumes.",
    "Salmão grelhado com quinoa e brócolis.",
    "Panqueca de carne moída com molho de tomate.",
    "Tabule com frango desfiado.",
    "Yakisoba de legumes e carne.",
    "Peito de frango recheado com queijo e espinafre.",
    "Bife acebolado com arroz, feijão e salada.",
    "Torta de frango com massa folhada.",
    "Suflê de queijo com salada verde.",
    "Filé de frango à parmegiana com purê de batatas.",
    "Espetinhos de carne e vegetais grelhados.",
    "Macarrão ao alho e óleo com camarões.",
    "Arroz de polvo com ervas.",
    "Abobrinha recheada com carne moída e queijo.",
    "Poke bowl de salmão com arroz e vegetais."
  ];
  var current = "Salada de frango grelhado com vegetais frescos.";

  void getNext() {
    current = list[random.nextInt(30)];
    notifyListeners();
  }

  var favorites = <String>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return const Center(
        child: Text('Não a favoritos no momento.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('Você tem '
              '${appState.favorites.length} ${appState.favorites.length > 1 ? 'frases favoritas:' : 'frase favorita'}'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair),
          ),
      ],
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 168, 137, 253),
          title: Text("Gerador de Comidas"),
        ),
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600, // ← Here.
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favoritos'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Favoritar'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Proximo'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final String pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair,
          style: style,
        ),
      ),
    );
  }
}
