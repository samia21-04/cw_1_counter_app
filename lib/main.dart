import 'package:flutter/material.dart';

void main() {
  runApp(const CounterImageToggleApp());
}

class CounterImageToggleApp extends StatefulWidget {
  const CounterImageToggleApp({super.key});

  @override
  State<CounterImageToggleApp> createState() => _CounterImageToggleAppState();
}

class _CounterImageToggleAppState extends State<CounterImageToggleApp> {
  bool _isDark = false;

  void _toggleTheme() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CW1 Counter & Toggle',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(onToggleTheme: _toggleTheme, isDark: _isDark),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onToggleTheme, required this.isDark});

  final VoidCallback onToggleTheme;
  final bool isDark;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;

  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // ✅ Start animation so the first image is visible
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playFade() {
    _controller.reset();
    _controller.forward();
  }

  void _incrementCounter() {
    setState(() => _counter++);
    _playFade();
  }

  void _decrementCounter() {
    if (_counter == 0) return;
    setState(() => _counter--);
    _playFade();
  }

  void _resetCounter() {
    setState(() => _counter = 0);
    _playFade();
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _counter > 0
        ? 'assets/charged_battery.png'
        : 'assets/uncharged_battery.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('CW1 Counter & Toggle'),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Counter: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Increment'),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _counter == 0 ? null : _decrementCounter,
              child: const Text('Decrement'),
            ),
            const SizedBox(height: 24),

            FadeTransition(
              opacity: _fade,
              child: Image.asset(
                imagePath,
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _resetCounter,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
