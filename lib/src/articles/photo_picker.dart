import 'package:flutter/material.dart';
import 'package:models_weebi/base.dart';
import 'package:models_weebi/common.dart';
import 'package:views_weebi/src/articles/photo.dart';
import 'package:views_weebi/src/styles/colors.dart';
import 'package:filebridge/filebridge.dart';

class PhotoChangedNotif extends Notification {
  final String path;
  final PhotoSource photoSource;
  const PhotoChangedNotif(this.path, this.photoSource);
}

class PhotoStateless extends StatelessWidget {
  final String path;
  final PhotoSource source;
  const PhotoStateless(
      {this.path = '', this.source = PhotoSource.unknown, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAlreadyPhoto = path.isNotEmpty && source != PhotoSource.unknown;

    return AspectRatio(
      aspectRatio: 2.3,
      child: Container(
        margin: EdgeInsets.all(5),
        child: SizedBox(
            height: 300,
            child: Stack(
              children: [
                if (isAlreadyPhoto) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                        child: Icon(Icons.image, color: Colors.grey),
                      ),
                      PhotoWidget(PhotoObject(path: path, source: source)),
                    ],
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          PhotoChangedNotif('', PhotoSource.unknown)
                              .dispatch(context);
                        },
                        mini: true,
                        child: const Icon(Icons.delete, color: Colors.grey),
                      ),
                    ),
                  ),
                ] else
                  Center(
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            WeebiColors.orange),
                      ),
                      icon: const Icon(Icons.folder_open),
                      label: Text(isAlreadyPhoto == false
                          ? 'Choisir la photo'
                          : 'Choisir une autre photo'),
                      onPressed: () async {
                        final file =
                            await FileLoaderMonolith.loadPhotoFromUserPick();
                        if (file.path.isEmpty) {
                          return;
                        }
                        PhotoChangedNotif(
                          file.path,
                          PhotoSource.file,
                        ).dispatch(context);
                      },
                    ),
                  ),
              ],
            )),
      ),
    );
  }
}

class PhotoPickerWidget extends StatefulWidget {
  final String path;
  final PhotoSource source;
  const PhotoPickerWidget(
      {this.path = '', this.source = PhotoSource.unknown, Key? key})
      : super(key: key);

  @override
  State<PhotoPickerWidget> createState() => _PhotoPickerWidgetState();
}

class _PhotoPickerWidgetState extends State<PhotoPickerWidget> {
  String _path = '';
  PhotoSource _source = PhotoSource.unknown;

  @override
  void initState() {
    super.initState();
    _path = widget.path;
    _source = widget.source;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<PhotoChangedNotif>(
      onNotification: (n) {
        setState(() {
          _path = n.path;
          _source = n.photoSource;
        });
        return true;
      },
      child: PhotoStateless(
        path: _path,
        source: _source,
      ),
    );
  }
}
