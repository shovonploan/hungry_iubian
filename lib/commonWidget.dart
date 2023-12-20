import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/cubits/session.dart';

class CustomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomeAppBar({super.key, required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(
              Icons.account_circle,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          // User name text
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            style: const ButtonStyle(splashFactory: NoSplash.splashFactory),
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(14, 165, 233, 1),
              Color.fromRGBO(104, 107, 241, 1),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({
    Key? key,
    required this.username,
    required this.email,
  }) : super(key: key);

  final String username;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              username,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              email,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(124, 144, 231, 1),
                  Color.fromRGBO(206, 168, 238, 1),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Menu Card'),
            onTap: () {
              Navigator.pushNamed(context, '/customerMenu');
            },
          ),
          ListTile(
            leading: const Icon(Icons.percent),
            title: const Text('Discounts'),
            onTap: () {
              Navigator.pushNamed(context, '/discounts');
            },
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Balance'),
            onTap: () {
              Navigator.pushNamed(context, '/balance');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_pizza),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushNamed(context, '/customerOrder');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_4),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              context.read<SessionCubit>().logout();
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    Key? key,
    required this.username,
    required this.email,
  }) : super(key: key);

  final String username;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              username,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              email,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.blue,
              ),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(124, 144, 231, 1),
                  Color.fromRGBO(206, 168, 238, 1),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Menu Card'),
            onTap: () {
              Navigator.pushNamed(context, '/adminMenu');
            },
          ),
          ListTile(
            leading: const Icon(Icons.percent),
            title: const Text('Discounts'),
            onTap: () {
              Navigator.pushNamed(context, '/discounts');
            },
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on),
            title: const Text('Balance'),
            onTap: () {
              Navigator.pushNamed(context, "/adminBalance");
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_pizza),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pushNamed(context, '/allOrdes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.document_scanner),
            title: const Text('Generate Reports'),
            onTap: () {
              Navigator.pushNamed(context, '/report');

            },
          ),
          ListTile(
            leading: const Icon(Icons.person_4),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_4),
            title: const Text('All User'),
            onTap: () {
              Navigator.pushNamed(context, "/allUser");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              context.read<SessionCubit>().logout();
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
