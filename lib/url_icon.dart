import 'package:flutter/material.dart';

class ScreenLifecyle extends StatefulWidget {
  ScreenLifecyleState? state;

  ScreenLifecyle({Key? key}) : super(key: key);

  //createState(): When the Framework is instructed to build a StatefulWidget, it immediately calls createState()
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ScreenLifecyleState();
  }
}

class ScreenLifecyleState extends State<ScreenLifecyle>
    with WidgetsBindingObserver {
  /*
    mounted is true: When createState creates your state class, a buildContext is assigned to that state.
    BuildContext is, overly simplified, the place in the widget tree in which this widget is placed.
    Here's a longer explanation. All widgets have a bool this.mounted property.
    It is turned true when the buildContext is assigned. It is an error to call setState when a widget is unmounted.
    mounted is false: The state object can never remount, and an error is thrown is setState is called.
    */

  /*
    This is the first method called when the widget is created (after the class constructor, of course.)
    initState is called once and only once. It must called super.initState().
    */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState");
  }

  /*
    This method is called immediately after initState on the first time the widget is built.
    */
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  /*
    build(): This method is called often. It is required, and it must return a Widget.
    */
  @override
  Widget build(BuildContext context) {
    print("build");

    // TODO: implement build
    return Container();
  }

  /*
    If the parent widget changes and has to rebuild this widget (because it needs to give it different data),
    but it's being rebuilt with the same runtimeType, then this method is called.
    This is because Flutter is re-using the state, which is long lived.
    In this case, you may want to initialize some data again, as you would in initState.
    */
  @override
  void didUpdateWidget(ScreenLifecyle oldWidget) {
    print("didUpdateWidget");

    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void setState(fn) {
    print("setState");

    // TODO: implement setState
    super.setState(fn);
  }

  /*
    Deactivate is called when State is removed from the tree,
    but it might be reinserted before the current frame change is finished.
    This method exists basically because State objects can be moved from one point in a tree to another.
    */
  @override
  void deactivate() {
    // TODO: implement deactivate
    print("deactivate");
    super.deactivate();
  }

  /*
    Dispose is called when the State object is removed, which is permanent.
    This method is where you should unsubscribe and cancel all animations, streams, etc.
    */
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // super.screenLifecycleState(state);
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      // case AppLifecycleState.suspending:
      //   print('appLifeCycleState suspending');
      //   break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }
}
