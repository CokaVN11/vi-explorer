import '../screens/camera/camera_view.dart';
import '../screens/map/map_view.dart';
import '../bloc/landing_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../settings/global.dart';

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
  Text('Index 2: Favourite'),
  Text('Index 3: User'),
];

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LandingPageBloc, LandingPageState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          // body: Center(child: bottomNavScreen.elementAt(state.tabIndex)),
          // bottomNavigationBar: Container(
          //   padding: const EdgeInsets.only(top: 0),
          //   margin: const EdgeInsets.only(
          //     bottom: 20.0,
          //     left: 20.0,
          //     right: 20.0,
          //   ),
          //   decoration: BoxDecoration(
          //     // transparent color
          //     color: Color.fromARGB(255, 255, 255, 255),
          //     borderRadius: BorderRadius.circular(25.0), // Adjust the border radius as needed
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withOpacity(0.2), // Shadow color
          //         spreadRadius: 1, // Spread radius
          //         blurRadius: 10, // Blur radius
          //         offset: Offset(0, 3), // Shadow offset
          //       ),
          //     ],
          //   ),
          //   child: ClipRRect(
          //     borderRadius: const BorderRadius.all(Radius.circular(27.0)),
          //     child: BottomNavigationBar(
          //       showSelectedLabels: false,
          //       showUnselectedLabels: false,
          //       items: bottomNavItems,
          //       currentIndex: state.tabIndex,
          //       selectedItemColor: Theme.of(context).colorScheme.primary,
          //       unselectedItemColor: Colors.grey,
          //       onTap: (index) {
          //         BlocProvider.of<LandingPageBloc>(context)
          //             .add(TabChange(tabIndex: index));
          //       },
          //     ),
          //   ),
          // ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Center(child: bottomNavScreen.elementAt(state.tabIndex)),
                ),
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
                      // transparent color
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(30.0), // Adjust the border radius as needed
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 10, // Blur radius
                          offset: Offset(0, 3), // Shadow offset
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
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
        );
      },
    );
  }
}
