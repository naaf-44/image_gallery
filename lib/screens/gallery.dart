import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery/controllers/gallery_controller.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  GalleryController galleryController = Get.put(GalleryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gallery")),
      body: Obx(
        () => galleryController.isGalleryLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: galleryController.galleryModel!.hits!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: galleryController.galleryModel!.hits![index].previewURL!,
                          fit: BoxFit.fill,
                          height: 100,
                          width: 100,
                        ),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
