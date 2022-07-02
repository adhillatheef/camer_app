import 'dart:io';
import 'package:camera_app/full_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

ValueNotifier<List> imageList = ValueNotifier([]);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Snap Shot',
          style: TextStyle(color: Colors.yellow, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                pickImage();
              },
              icon: const Icon(
                Icons.camera,
                color: Colors.yellow,
              ))
        ],
      ),
      body: Container(
        color: Colors.black,
        child: ValueListenableBuilder(
            valueListenable: imageList,
            builder: ((BuildContext context, List data, Widget? child) {
              return GridView.builder(
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
                  itemBuilder: (BuildContext context, index) {
                    final String curntPath = data[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FullScreen(path: curntPath)));
                      },
                      child: Hero(
                          tag: index,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(File(data[index])))),
                          )),
                    );
                  });
            })),
      ),
    );
  }
}

pickImage() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (image == null) {
    return;
  } else {
    var dir = await getExternalStorageDirectory();
    File imagePath = File(image.path);
    final newImage = await imagePath.copy('${dir!.path}/${DateTime.now()}.jpg');
    imageList.value.add(newImage.path);
    imageList.notifyListeners();
  }
}

createList() async {
  final dir = await getExternalStorageDirectory();
  if (dir != null) {
    var listDir = await dir.list().toList();
    for (var i = 0; i < listDir.length; i++) {
      if (listDir[i].path.endsWith('.jpg')) {
        imageList.value.add(listDir[i].path);
      }
    }
  }
  imageList.notifyListeners();
}
