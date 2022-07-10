import 'package:movie_curation/domain/base/base_use_case.dart';
import 'package:movie_curation/domain/models/content/content_cast_model.dart';
import 'package:movie_curation/utilities/index.dart';

class TmdbLoadDramaCastsUseCase extends BaseUseCase<int, Result<List<ContentCastModel>>> {
  TmdbLoadDramaCastsUseCase(this._repository);

  final TmdbRepository _repository;

  @override
  Future<Result<List<ContentCastModel>>> call(int request) {
    return _repository.loadDramaCastInfo(request);
  }
}