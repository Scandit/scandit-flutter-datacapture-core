import 'package:material_ui/material_ui.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureCore.initialize();
  var context = DataCaptureContext.forLicenseKey('');
  var frameSource = Camera.defaultCamera;
  if (frameSource != null) {
    await context.setFrameSource(frameSource);
  }
  var app = MyApp(context);
  runApp(app);
  await frameSource?.switchToDesiredState(FrameSourceState.on);
}

class MyApp extends StatefulWidget {
  final DataCaptureContext _context;

  const MyApp(this._context, {super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Center(
            child: DataCaptureView.forContext(widget._context),
          )),
    );
  }
}
