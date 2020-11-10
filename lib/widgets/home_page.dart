import 'package:flutter/material.dart';

import '../gooby.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streamer Review Hub'),
      ),
      body: new Center(
        child: new ButtonBar(
          mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
          children: <Widget>[
            ElevatedButton(
            child: Text('Go To Next Page'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondRoute()),
              );
            },
          ),
            ElevatedButton(
              child: new Text('Hi, i dont work right now but thats okay :)'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Gooby()),
                );
              },
            ),
            Text(
              'Yeah, yeah, yeah',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
            Text(
              'Testing the children widgets',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class Child1 extends StatelessWidget {
    @override
    Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: Text('Streamer Review Hub'),
        ),
        body: Container(
          child: Center(

            child: ElevatedButton(
              child: Text('Go To Next Page'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                );
              },
            ),
          ),
        ),
      );
    }
  }


class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Return to Home Page"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
// class ColorCircle extends StatelessWidget {
//
//   final String title;
//
//   const ColorCircle({Key key, this.title}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       appBar: AppBar(
//         title: Text('First Route'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Open route'),
//           onPressed: () {
//             // Navigate to second route when tapped.
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class SecondRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Second Route"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Navigate back to first route when tapped.
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Streamer Review Hub'),
//       ),
//       body: Container(
//         child: Center(
//
//           child: ElevatedButton(
//             child: Text('Go To Next Page'),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SecondRoute()),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column( // or Row or Wrap
//             children: [
//               Child1(),
//               // Child2(),
//             ]
//         )
//     );
//   }
// }

// class Child2 extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     // throw UnimplementedError();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Streamer Review Hub'),
//       ),
//       body: Container(
//         child: Center(
//
//           child: ElevatedButton(
//             child: Text('Go To Next Page'),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SecondRoute()),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
