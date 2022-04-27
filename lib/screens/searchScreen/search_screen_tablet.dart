import 'package:movie_curation/utilities/index.dart';

class SearchScreenT extends StatefulWidget {
  @override
  State<SearchScreenT> createState() => _SearchScreenTState();
}

final _searchVM = SearchVM(model: SearchCore());

class _SearchScreenTState extends State<SearchScreenT>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _searchVM.fetchAllContents();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // Gradient Background Container
        const RandomPosterBackground(),
        // Expanded Row Layout
        Row(
          children: [
            /* Left Side (SearchBar & Genre) */
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 40, left: 20),
                // color: Colors.purple.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /* Search Bar */
                    searchBar(screenWidth),
                    /* Genre Group List */
                    genreGroupButton()
                  ],
                ),
              ),
            ),
            /* Contents List Slider */
            Expanded(
              flex: 2,
              child: ContentThumbnailVerticalSlider(searchVM: _searchVM),
            ),
            /* Right Side (Movie Contents) */
          ],
        ),
      ],
    );
  }

  Expanded genreGroupButton() {
    return Expanded(
      child: GetBuilder<SearchVM>(
          init: _searchVM,
          builder: (context) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 60, right: 60),
              shrinkWrap: true,
              itemCount: genreKeyList.length,
              itemBuilder: (context, index) {
                final genreKey = genreKeyList[index];
                final genreItem = genreDefaults[genreKey];
                return TextButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: () {
                    _searchVM.tapGroupButton(genreKey);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: genreKey == _searchVM.selectedGenre
                          ? Border.all(color: kYellow, width: 1)
                          : null,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    margin: EdgeInsets.only(bottom: 4),
                    height: 54,
                    child: Text(
                      genreItem ?? "장르",
                      style: FontStyles().genreOption,
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  Widget searchBar(double screenWidth) {
    return SizedBox(
      width: screenWidth / 3 * 0.76,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        onSubmitted: (String inputs) {
          print(inputs);
        },
        cursorColor: kYellow,
        style: FontStyles(0, false).searchBarInputs,
        decoration: InputDecoration(
          hintText: "제목을 입력하세요",
          hintStyle: FontStyles(0, false).searchBarPlaceHolder,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: kCloudyLightGrey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: kCloudyLightGrey),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
