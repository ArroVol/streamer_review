import 'package:flutter/material.dart';
import 'package:streamer_review/helper/database_helper.dart';
import 'package:streamer_review/secondScreen.dart';
import 'package:streamer_review/widgets/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Streamer Review App',
        theme: ThemeData(
          primarySwatch: Colors.blue,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AaronsMain()
      // home: ColorCircle(title: 'Color Circle',),
    );
  }
}

class AaronsMain extends StatefulWidget {
  AaronsMain({Key key, this.title}) : super(key: key);

  final String title;
  // String email;
  // String password;

  String get email {
    return email;
  }
  void set email(String email){
    email = email;
  }
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AaronsMain> {

  String email;
  String password;

// String get email => email;
//
// String get password => password;

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Streamer Review'),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
            decoration: new InputDecoration.collapsed(hintText: "input email"),
              // onChanged: (String text) {
              // print("Text => $text");
              // },
              onSubmitted: (String email){
              email = email;
              print("Submitted:  $email");
              },
            ),
            new TextField(
              decoration: new InputDecoration.collapsed(hintText: "input password"),
              // onChanged: (String text) {
              // print("Text => $text");
              // },
              onSubmitted: (String password){
                print("Submitted:  $password");
              },
            ),
            FlatButton(
                onPressed: () async {
                  int i = await DatabaseHelper2.instance
                      .insert({DatabaseHelper2.columnEmail: 'sarah@spoopmail.net', DatabaseHelper2.columnPassword:'spoopy9r'});
                  print('the inserted id is $i');
                },
                child: Text('insert')),
            FlatButton(
                onPressed: () async {
                  List<Map<String, dynamic>> queryRows =
                  await DatabaseHelper2.instance.queryAll();
                  print(queryRows);
                },
                child: Text('query')),
            FlatButton(
                onPressed: () async {
                  int updatedId = await DatabaseHelper2.instance.update({
                    DatabaseHelper2.columnId: 12,
                    DatabaseHelper2.columnPassword: 'Mark'
                  });
                  //returns the number of rows affected
                  print("on update, this is the updated ID: ,  ");
                  print(updatedId);
                },
                child: Text('update')),
            FlatButton(onPressed: () async {
              int rowsAffected = await DatabaseHelper2.instance.delete(13);
              print(rowsAffected);
            }, child: Text('delete')),
            FlatButton(onPressed: () async {
              DatabaseHelper2.instance.resetDb();
            }, child: Text('Delete Database')),
            FlatButton(onPressed: () async {
              DatabaseHelper2.instance.createUserTable();
            }, child: Text('Recreate user table')),
            FlatButton(onPressed: () async {
              print(email);
              print(password);
              DatabaseHelper2.instance.insert({DatabaseHelper2.columnEmail: email, DatabaseHelper2.columnPassword: password});
            }, child: Text('Insert specified email and pass')),
          ],
        ),
      ),
    );
  }

// _openPopup(context) {
//   Alert(
//       context: context,
//       title: "LOGIN",
//       content: Column(
//         children: <Widget>[
//           TextField(
//             decoration: InputDecoration(
//               icon: Icon(Icons.account_circle),
//               labelText: 'Username',
//             ),
//           ),
//           TextField(
//             obscureText: true,
//             decoration: InputDecoration(
//               icon: Icon(Icons.lock),
//               labelText: 'Password',
//             ),
//           ),
//         ],
//       ),
//       buttons: [
//         DialogButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text(
//             "LOGIN",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         )
//       ]).show();
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Streamer Review'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             FlatButton(
//                 onPressed: () async {
//                   int i = await DatabaseHelper2.instance
//                       .insert({DatabaseHelper2.columnName: 'Saheb'});
//                   print('the inserted id is $i');
//                 },
//                 child: Text('insert')),
//             FlatButton(
//                 onPressed: () async {
//                   List<Map<String, dynamic>> queryRows =
//                   await DatabaseHelper2.instance.queryAll();
//                   print(queryRows);
//                 },
//                 child: Text('query')),
//             FlatButton(
//                 onPressed: () async {
//                   int updatedId = await DatabaseHelper2.instance.update({
//                     DatabaseHelper2.columnId: 12,
//                     DatabaseHelper2.columnName: 'Mark'
//                   });
//                   //returns the number of rows affected
//                   print(updatedId);
//                 },
//                 child: Text('update')),
//             FlatButton(onPressed: () async {
//               int rowsAffected = await DatabaseHelper2.instance.delete(13);
//               print(rowsAffected);
//                   }, child: Text('delete')),
//           ],
//         ),
//       ),
//     );
//   }
// }
}