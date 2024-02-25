import 'package:flutter/foundation.dart';

import '../screens/camera/camera_view.dart';
import '../screens/map/map_view.dart';
import 'package:app/screens/profile/profileScreen.dart';
import '../bloc/landing_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../settings/global.dart';
import 'dart:async';

List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.camera_alt_outlined),
    label: 'Camera',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.favorite_outline),
    label: 'Favourite',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline),
    label: 'User',
  ),
];

List<Widget> bottomNavScreen = <Widget>[
  const MapView(),
  CameraScreen(cameras: cameras),
  Text('Index 3: User'),
  const ProfileScreen(),
];

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Timer _timer;
  bool _isNavVisible = true;

  @override
  void initState() {
    super.initState();
    // Start the timer when the widget is initialized
    _startTimer();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const Duration inactiveDuration = Duration(seconds: 3);
    _timer = Timer(inactiveDuration, () {
      // If the current screen is the home screen, hide the bottom navigation bar
        setState(() {
          _isNavVisible = false;
        });
    });
  }

  void _resetTimer() {
    // Reset the timer when user interacts with the screen
    if (kDebugMode) {
      print('Resetting timer');
    }
    _timer.cancel();
    _startTimer();
    setState(() {
      _isNavVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LandingPageBloc, LandingPageState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: GestureDetector(
            onTap: () => _resetTimer(),
            onDoubleTap: () => _resetTimer(),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(child: bottomNavScreen.elementAt(state.tabIndex)),
                ),
                if (_isNavVisible) // Only show the bottom navigation bar if it's visible
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.only(top: 0),
                      margin: const EdgeInsets.only(
                        bottom: 20.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(27.0)),
                        child: BottomNavigationBar(
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          items: bottomNavItems,
                          currentIndex: state.tabIndex,
                          selectedItemColor: Theme.of(context).colorScheme.primary,
                          unselectedItemColor: Colors.grey,
                          onTap: (index) {
                            BlocProvider.of<LandingPageBloc>(context)
                                .add(TabChange(tabIndex: index));
                            _resetTimer(); // Reset the timer on user interaction with the bottom navigation bar
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
