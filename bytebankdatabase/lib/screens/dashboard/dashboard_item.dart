import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function? onClick;
  // ignore: prefer_const_constructors_in_immutables
  FeatureItem(
    this.name,
    this.icon, {
    @required this.onClick,
  }) : assert(onClick != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Material(
        color: Theme.of(context).colorScheme.primary,
        child: InkWell(
          onTap: () {
            onClick!();
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            height: 80,
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
