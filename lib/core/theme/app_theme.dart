import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemeSwitcherApp();
  }
}

class ThemeSwitcherApp extends StatefulWidget {
  const ThemeSwitcherApp({super.key});

  @override
  State<ThemeSwitcherApp> createState() => _ThemeSwitcherAppState();
}

class _ThemeSwitcherAppState extends State<ThemeSwitcherApp> {
  final ValueNotifier<ThemeMode> _themeModeNotifier =
      ValueNotifier(ThemeMode.light);

  bool get _isDark => _themeModeNotifier.value == ThemeMode.dark;

  void _toggleTheme() {
    _themeModeNotifier.value =
        _isDark ? ThemeMode.light : ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: HomePage(
            isDark: _isDark,
            onToggle: _toggleTheme,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    super.dispose();
  }
}

class HomePage extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const HomePage({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Toggle Demo'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: IconButton(
                key: ValueKey<bool>(isDark),
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: isDark ? Colors.amber : null,
                ),
                tooltip: isDark ? 'Switch to Light' : 'Switch to Dark',
                onPressed: onToggle,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current theme: ${isDark ? "Dark 🌙" : "Light ☀️"}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),

            // Button yenye text + icon inayobadilika
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: ElevatedButton.icon(
                key: ValueKey<bool>(isDark),
                onPressed: onToggle,
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  size: 24,
                ),
                label: Text(
                  isDark ? 'White Theme' : 'Dark Theme',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Chaguo la switch flanked na icons (alternative style)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.light_mode_outlined,
                  color: isDark ? Colors.grey : Colors.amber,
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isDark,
                  onChanged: (_) => onToggle(),
                  activeColor: Colors.amber,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.dark_mode_outlined,
                  color: isDark ? Colors.blueGrey[300] : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}