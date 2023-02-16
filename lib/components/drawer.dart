
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(
          title: const Text('Read Right'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.mode),
          title: const Text('Mode'),
          onTap: () {
           
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('Favorite'),
          onTap: () {
            
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Info'),
          onTap: () {},
        ),
      ]),
    );
  }
}
