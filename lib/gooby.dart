import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() =>
    runApp(Gooby());


class Gooby extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ITS P GOOBY TIME'),
      ),
    );
    
  }
}

// Container(
// Row(
// children: [
// IconButton(
// icon: Icon(Icons.menu),
// tooltip: 'Navigation menu',
// ),
// Expanded(
// child: title,
// ),
// IconButton(
// icon: Icon(Icons.search),
// tooltip: 'Search',
// ),
// ],
// ),
// height: 56.0,
// padding: const EdgeInsets.symmetric(horizontal: 8.0),
// decoration: BoxDecoration(color: Colors.blue[500]),
// );
