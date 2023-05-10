import 'package:flutter/cupertino.dart';

class ImagePreview extends StatefulWidget {
  final String imageUrl;

  const ImagePreview({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isEmpty) {
      return Container();
    }
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.imageUrl),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
