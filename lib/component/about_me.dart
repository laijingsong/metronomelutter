import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  final String version;
  const AboutMe({
    required Key key,
    this.version = '0.0',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double? iconSize = iconTheme.size;

    return AboutDialog(
      applicationIcon: Image.asset(
        'assets/images/playstore-icon.png',
        width: iconSize,
        height: iconSize,
      ),
      applicationVersion: '$version',
      applicationName: '节拍器',
      applicationLegalese: 'Copyright© 2020-${DateTime.now().year} en20. All rights reserved.',
      children: <Widget>[
        // Container(
        //     margin: EdgeInsets.only(top: 20),
        //     width: 80,
        //     height: 80,
        //     child: Image.asset('assets/images/playstore-icon.png')),
        Container(
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              '基于 flutter 技术打造的极简全平台节拍器',
            )),
      ],
    );
  }
}
