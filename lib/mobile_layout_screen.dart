import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/utils/utils.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/chat/widgets/contact_list.dart';
import 'features/select_contacts/screen/select_contact_screen.dart';
import 'features/status/screen/confirm_status_screen.dart';
import 'features/status/screen/status_contact_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({super.key});

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ContactsList(),
    const StatusContactsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.hidden:
      // Handle hidden state if necessary
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1C1C1E),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Material(
                  elevation: 4.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150'), // Replace with the actual profile image URL
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Material(
              elevation: 4.0,
              shape: const CircleBorder(),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  onPressed: () {
                    if (_selectedIndex == 0) {
                      Navigator.pushNamed(context, SelectContactsScreen.routeName);
                    } else {
                      pickImageFromGallery(context).then((pickedImage) {
                        if (pickedImage != null) {
                          Navigator.pushNamed(
                            context,
                            ConfirmStatusScreen.routeName,
                            arguments: pickedImage,
                          );
                        }
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            child: Material(
              elevation: 8.0,
              borderRadius: BorderRadius.circular(40),
              child: TextField(
                style: const TextStyle(color: Colors.black54),
                decoration: InputDecoration(
                  hintText: 'search',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: const Color(0xFF2C2C2E),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            items: <BottomNavigationBarItem>[
              _buildBottomNavigationBarItem(
                icon: Icons.chat,
                isSelected: _selectedIndex == 0,
              ),
              _buildBottomNavigationBarItem(
                icon: Icons.circle,
                isSelected: _selectedIndex == 1,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      {required IconData icon, required bool isSelected}) {
    return BottomNavigationBarItem(
      icon: Material(
        elevation: isSelected ? 20.0 : 5.0,
        shape: const CircleBorder(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: const Color(0xFF2C2C2E), width: 0.1),
            color: const Color(0xFF1C1C1E),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: isSelected ? Colors.red : Colors.white),
        ),
      ),
      label: '',
    );
  }
}
