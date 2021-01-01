import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metronomelutter/config/config.dart';
import 'package:metronomelutter/global_data.dart';
import 'package:metronomelutter/store/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

import './component/indactor.dart';
import './component/slider.dart';
import 'pages/setting.dart';
import 'utils/shared_preferences.dart';

void main() async {
  // 确保初始化,否则访问 SharedPreferences 会报错
  WidgetsFlutterBinding.ensureInitialized();

  GlobalData.sp = await SpUtil.getInstance();
  initSoundType();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '节拍器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '节拍器'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _bpm = 70;
  int _nowStep = -1;
  bool _isRunning = false;
  Timer timer;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  AnimationController _animationController;

  void _setBpmHanlder(int val) {
    setState(() {
      _bpm = val;
    });
  }

  void _toggleIsRunning() {
    if (_isRunning) {
      timer.cancel();
      _animationController.reverse();
    } else {
      runTimer();
      _animationController.forward();
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _setNowStep() {
    setState(() {
      _nowStep++;
    });
  }

  Future<void> _playAudio() {
    int nextStep = _nowStep + 1;
    int soundType = appStore.soundType;
    if (nextStep % 4 == 0) {
      return assetsAudioPlayer.open(Audio('assets/metronome$soundType-1.mp3'));
    } else {
      // todo 不这样 ios 只播放一次
      return assetsAudioPlayer.open(Audio('assets/metronome$soundType-2.mp3'));
    }
  }

  void runTimer() {
    timer = Timer(Duration(milliseconds: (60 / _bpm * 1000).toInt()), () {
      _playAudio().then((value) => _setNowStep());
      runTimer();
    });
  }

  Future setBpm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int bpm = prefs.getInt('bpm');
    if (bpm != null) {
      print('get bpm $bpm');
      // 超过范围,重置回默认
      if (bpm < Config.BPM_MIN || bpm > Config.BPM_MAX) {
        bpm = Config.BPM_DEFAULT;
      }
      _setBpmHanlder(bpm);
    }
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      Wakelock.enable();
    }
    setBpm();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.settings),
                    color: Theme.of(context).textTheme.headline3.color,
                    onPressed: () async {
                      final result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Setting()));
                      print('setting result: $result');
                    },
                  )
                ],
              )),
          // Text(
          //   '节拍器',
          //   style: Theme.of(context).textTheme.headline3,
          // ),
          SliderRow(_bpm, _setBpmHanlder, _isRunning, _toggleIsRunning,
              _animationController),

          IndactorRow(_nowStep),
        ],
      ),
    ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

initSoundType() {
  int soundType = GlobalData.sp.getInt('soundType');
  if (soundType != null) {
    print('get sound type $soundType');
    appStore.setSoundType(soundType);
  }
}
