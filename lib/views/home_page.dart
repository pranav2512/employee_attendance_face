import 'dart:io';

import 'package:camera/camera.dart';
import 'package:employee_attendance_app/model/sql_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String code;
  late String name = "";
  String? status;
  String? path1;

  List<CameraDescription>? cameras;
  late CameraController cameraController;

  loadCamera() async {
    cameras = await availableCameras();
    CameraDescription selectedCamera = cameras!.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.front);
    if (cameras != null) {
      cameraController = CameraController(selectedCamera, ResolutionPreset.max);
      cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  Future<void> getName() async {
    name = await SQLHelper.getName(int.parse(code));
    setState(() {});
  }

  Future<void> checkStatus(String code) async {
    status = await SQLHelper.checkStatus(int.parse(code));
    setState(() {});
  }

  Future<void> createEntry(String status, String path) async {
    await SQLHelper.createEntry(int.parse(code), path, status);
    path1 = null;
    checkStatus(code);
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    code = ModalRoute.of(context)!.settings.arguments as String;
    getName();
    checkStatus(code);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    loadCamera();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "history",arguments: code);
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (status == "" || status == null || status == "Punch-Out")
              Column(
                children: [
                  (!cameraController.value.isInitialized)
                      ? Container(
                          alignment: Alignment.center,
                          height: 300,
                          width: 250,
                          child: const CircularProgressIndicator(),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(300),
                            color: Colors.green,
                            border: Border.all(width: 4, color: Colors.green),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: SizedBox(
                                height: 300,
                                width: 300,
                                child: CameraPreview(cameraController)),
                          ),
                        ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      final image = await cameraController.takePicture();
                      path1 = image.path;

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Are you sure to Punch-In?"),
                          content: CircleAvatar(
                            radius: 150,
                            backgroundImage: FileImage(
                              File(path1!),
                            ),
                          ),
                          actions: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            FilledButton(
                              onPressed: () async {
                                await createEntry("Punch-In", path1 ?? "");
                                List<Map<String, dynamic>> entries =
                                    await SQLHelper.getEntries(int.parse(code));
                                print(entries);
                                print(status);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text("Punch-In Successfully"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("Punch-In"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text("Punch-In"),
                  ),
                ],
              )
            else if (status == "Punch-In" || status == "Break-Out")
              Column(
                children: [
                  (!cameraController.value.isInitialized)
                      ? Container(
                          alignment: Alignment.center,
                          height: 300,
                          width: 250,
                          child: const CircularProgressIndicator(),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(300),
                            color: Colors.green,
                            border: Border.all(width: 4, color: Colors.green),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: SizedBox(
                                height: 300,
                                width: 300,
                                child: CameraPreview(cameraController)),
                          ),
                        ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final image = await cameraController.takePicture();
                          path1 = image.path;

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Are you sure to Break-In?"),
                              content: CircleAvatar(
                                radius: 150,
                                backgroundImage: FileImage(
                                  File(path1!),
                                ),
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                FilledButton(
                                  onPressed: () async {
                                    await createEntry("Break-In", path1 ?? "");
                                    List<Map<String, dynamic>> entries =
                                        await SQLHelper.getEntries(
                                            int.parse(code));
                                    print(entries);
                                    print(status);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text("Break-In Successfully"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Break-In"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text("Break-In"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final image = await cameraController.takePicture();
                          path1 = image.path;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Are you sure to Punch-Out?"),
                              content: CircleAvatar(
                                radius: 150,
                                backgroundImage: FileImage(
                                  File(path1!),
                                ),
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                FilledButton(
                                  onPressed: () async {
                                    await createEntry("Punch-Out", path1 ?? "");
                                    List<Map<String, dynamic>> entries =
                                        await SQLHelper.getEntries(
                                            int.parse(code));
                                    print(entries);
                                    print(status);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text("Punch-Out Successfully"),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Punch-Out"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text("Punch-Out"),
                      ),
                    ],
                  ),
                ],
              )
            else if (status == "Break-In")
              Column(
                children: [
                  (!cameraController.value.isInitialized)
                      ? Container(
                          alignment: Alignment.center,
                          height: 300,
                          width: 250,
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(300),
                            color: Colors.green,
                            border: Border.all(width: 4, color: Colors.green),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(300),
                            child: SizedBox(
                                height: 300,
                                width: 300,
                                child: CameraPreview(cameraController)),
                          ),
                        ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      final image = await cameraController.takePicture();
                      path1 = image.path;

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Are you sure to Break-Out?"),
                          content: CircleAvatar(
                            radius: 150,
                            backgroundImage: FileImage(
                              File(path1!),
                            ),
                          ),
                          actions: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            FilledButton(
                              onPressed: () async {
                                await createEntry("Break-Out", path1 ?? "");
                                List<Map<String, dynamic>> entries =
                                    await SQLHelper.getEntries(int.parse(code));
                                print(entries);
                                print(status);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text("Break-Out Successfully"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("Break-Out"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text("Break-Out"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
