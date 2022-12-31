import 'package:flutter/material.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/utils/image_full_screen.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static showCustomDialog(BuildContext context,
      {@required String title,
      String details,
      String okBtnText = "Ok",
      String cancelBtnText = "Cancel",
      @required Function okBtnFunction}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Text(details),
            actions: <Widget>[
              Visibility(
                visible: false,
                child: ElevatedButton(
                  child: Text(okBtnText),
                  onPressed: okBtnFunction,
                ),
              ),
              ElevatedButton(
                  child: Text(cancelBtnText),
                  onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }

  static imageDialog(text, path, context, bool isImageExist) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$text',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
          Container(
            width: 220,
            height: 200,
            padding: EdgeInsets.all(10),
            child: ImageFullScreenWrapperWidget(
              child: Image.network(
                '$path',
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace stackTrace) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImageFullScreenWrapperWidget(
                          child: Image.network(NO_ImageNetWorkURL)),
                      /*SizedBox(height: 10),
                      Text("No Image Uploaded")*/
                    ],
                  );
                },
              ),
            ),
          ),
          isImageExist == false ? Text("No Image Uploaded") : Container(),
        ],
      ),
    );
  }
}
