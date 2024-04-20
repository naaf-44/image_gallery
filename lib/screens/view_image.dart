import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  final String? imageUrl;

  const ViewImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text("View Image",style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl!,
          errorWidget: (context, data, obj) {
            return const Icon(Icons.broken_image);
          },
          placeholder: (context, data) {
            return const Center(child: CircularProgressIndicator());
          },
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
