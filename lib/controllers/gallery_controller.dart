import 'package:get/get.dart';
import 'package:image_gallery/api_requests/gallery_api_request.dart';
import 'package:image_gallery/model_class/gallery_model.dart';

class GalleryController extends GetxController {
  var isGalleryLoading = false.obs;
  var isMoreGalleryLoading = false.obs;
  int page = 1;
  GalleryModel? galleryModel;

  @override
  void onInit() {
    super.onInit();
    loadGallery("");
  }

  loadGallery(String searchQuery) async {
    try {
      isGalleryLoading(true);
      galleryModel = await GalleryApiRequest.getGalleryImage(searchQuery: searchQuery);
      return galleryModel;
    } catch (error) {
      isGalleryLoading(false);
    } finally {
      isGalleryLoading(false);
    }
  }

  loadMoreGallery(String searchQuery) async {
    try {
      page++;
      isMoreGalleryLoading(true);
      GalleryModel tempGalleryModel = await GalleryApiRequest.getGalleryImage(searchQuery: searchQuery, page: page);
      if (tempGalleryModel != null) {
        for (int i = 0; i < tempGalleryModel.hits!.length; i++) {
          galleryModel!.hits!.add(tempGalleryModel.hits![i]);
        }
      }
      return galleryModel;
    } catch (error) {
      isMoreGalleryLoading(false);
    } finally {
      isMoreGalleryLoading(false);
    }
  }
}
