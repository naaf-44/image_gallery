import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery/controllers/gallery_controller.dart';
import 'package:image_gallery/screens/view_image.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  GalleryController galleryController = Get.put(GalleryController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return galleryController.backPressed(context);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Gallery")),
        body: Obx(
          () => galleryController.isGalleryLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              child: TextFormField(
                                controller: galleryController.searchController,
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.red)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                    hintText: "Search Image",
                                    prefixIcon: const Icon(Icons.search_outlined)),
                                onChanged: galleryController.onSearchChanged,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: GridView.builder(
                          controller: galleryController.scrollController,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: galleryController.getCrossAxisCount(context)),
                          itemCount: galleryController.galleryModel!.hits!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: galleryController.boxSize,
                                  width: galleryController.boxSize,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(
                                        ViewImage(imageUrl: galleryController.galleryModel!.hits![index].largeImageURL),
                                        transition: Transition.zoom,
                                        duration: const Duration(milliseconds: 500)
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: galleryController.galleryModel!.hits![index].previewURL!,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, data, obj) {
                                        return Icon(Icons.broken_image, size: galleryController.boxSize);
                                      },
                                      placeholder: (context, data) {
                                        return Icon(Icons.image, size: galleryController.boxSize);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: galleryController.boxSize,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.remove_red_eye_outlined),
                                          Text(galleryController.displayNumberInKMB(galleryController.galleryModel!.hits![index].views!))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.thumb_up_alt_outlined),
                                          Text(galleryController.displayNumberInKMB(galleryController.galleryModel!.hits![index].likes!))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            );
                          },
                        ),
                      ),
                      if (galleryController.isMoreGalleryLoading.value)
                        const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 5), child: CircularProgressIndicator()))
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
