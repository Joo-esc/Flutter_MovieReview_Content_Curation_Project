import 'package:movie_curation/utilities/index.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel(
    this._loadMovieTrailerKey,
    this._loadPopularContentListUseCase,
  );

  /* 전역변수 및 객체 */
  final Rxn<List<ContentModel>> _selectedContentList = Rxn();
  final Rxn<List<ContentModel>> _popularMovieList = Rxn();
  final Rxn<List<ContentModel>> _popularDramaList = Rxn();
  final Rxn<List<ContentModel>> _recommendedContentList = Rxn();
  RxString? _trailerKey;
  final db = FirebaseFirestore.instance;

  // State Variables;
  RxInt selectedCategoryIndex = 0.obs; // [인기, 최신, 추천] 카테고리 옵션
  RxInt selectedContentIndex = 0.obs; // 홈 화면에서 선택된 컨텐츠의 인덱스

  /* 컨트롤러 */
  // ItemScrollController & Listener - (Horizontal Post Slider )
  late final ItemScrollController _itemScrollController;
  late final ItemPositionsListener _itemPositionsListener;

  //Youtube Player Controller - (예고편)
  YoutubePlayerController get _trailerYoutubeController {
    return YoutubePlayerController(
      initialVideoId: _trailerKey?.value ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
    );
  }

  /* Usecase */
  final TmdbLoadMovieTrailerKeyUseCase _loadMovieTrailerKey;
  final LoadPopularContentListUseCase _loadPopularContentListUseCase;

  /* 메소드 */
  // 카테고리 그룹 버튼을 탭 되었을 때
  void onCategoryBtnTap(int index) {
    loading(true);
    selectedContentIndex.value = 0; // 컨텐츠 인덱스 초기화
    selectedCategoryIndex.value = index; // 카테고리 변경
    // 이미 카테고리 호출 되었다면 API CALL하지 않도록 함. (중복 API CALL 방지)
    switch (index) {
      // 현재 카테고리가 다시 클릭 되었을 때는 해당 메소드 종료 (불필요 API CALL 방지)
      case 0:
        _recommendedContentList.value == null
            ? loadPopularContentList()
            : _selectedContentList.value = _recommendedContentList.value;
        break;
      case 1:
        _popularMovieList.value == null
            ? loadPopularContentList()
            : _selectedContentList.value = _popularMovieList.value;
        break;
      case 2:
        _popularDramaList.value == null
            ? loadPopularContentList()
            : _selectedContentList.value = _popularDramaList.value;
        break;
    }
    loading(false);
  }

  // 콘텐츠가 선택 되었을 때
  void contentSelectHandler(int index) {
    selectedContentIndex.value = index;
  }

  // 예고편 다이어로 위젯 띄우기
  Future<void> showContentTrailer() async {
    final int contentId = selectedContent!.id.toInt();
    final trailerKey = await _loadMovieTrailerKey.call(contentId);
    _trailerKey = trailerKey?.obs;
    Get.dialog(MovieTrailerDialog(
        controller: _trailerYoutubeController,
        hasTrailerKey: trailerKey == null ? false : true));
  }

  // 포스트 슬라이더에서 포스트 아이템에 선택 되었을 때
  void onPosterItemTapped(index) {
    // Scroll to Index 인터렉션
    _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOutCubic);

    // selectedMovieIndex 설정
    contentSelectHandler(index);
  }

  /* 네트워킹 메소드 */
  // 인기 [컨텐츠] 데이터 호출. (현재 선택된 카테고리 인덱스를 기준으로 호출)
  Future<void> loadPopularContentList() async {
    loading(true);
    final responseResult =
        await _loadPopularContentListUseCase.call(selectedCategoryIndex.value);
    responseResult.fold(onSuccess: (data) {
      _selectedContentList.value = data;
      loading(false);
    }, onFailure: (error) {
      print(error);
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await loadPopularContentList();
    _itemScrollController = ItemScrollController();
    _itemPositionsListener = ItemPositionsListener.create();
  }

  /* 캡술화 - (Getter) */
  // static List<ContentModel>? get selectedContentListG =>
  //     Get.find<HomeViewModel>()._selectedContentList.value;
  List<ContentModel>? get selectedContentList => _selectedContentList.value;
  ContentModel? get selectedContent =>
      _selectedContentList.value?[selectedContentIndex.value];
  ItemScrollController get itemScrollController => _itemScrollController;
  ItemPositionsListener get itemPositionListener => _itemPositionsListener;
  static ContentModel? get selectedContentG =>
      Get.find<HomeViewModel>().selectedContent;
  static String? get trailerKey => Get.find<HomeViewModel>()._trailerKey?.value;
}
