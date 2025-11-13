import 'package:dictionarydox/src/core/providers/initialization_provider.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/home_page.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/profile_page.dart';
import 'package:dictionarydox/src/presentation/pages/units_page/units_page.dart';
import 'package:flutter/material.dart';

/// Bottom navigation shell with persistent navigation using IndexedStack
class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Wait for initialization before building screens
    return FutureBuilder(
      future: InitializationProvider.of(context).initialization,
      builder: (context, snapshot) {
        // Show loading while initializing
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Loading DictionaryDox...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Show error if initialization failed
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to initialize app',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        // Initialization complete - build normal navigation
        return _buildNavigation();
      },
    );
  }

  Widget _buildNavigation() {
    // Pre-build screens to maintain their state
    const List<Widget> screens = [
      HomePage(),
      UnitsPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        elevation: 8,
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Colors.blue.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder, color: Colors.blue),
            label: 'Units',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Colors.blue),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
