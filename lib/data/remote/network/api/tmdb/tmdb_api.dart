import 'package:dio/dio.dart';
import 'package:movie_curation/utilities/index.dart';
import 'package:retrofit/retrofit.dart';
part 'tmdb_api.g.dart';

// 인기 드라마 컨텐츠
// "https://api.themoviedb.org/3/tv/popular?api_key=b40235ce96defc556ca26d48159f5f13&language=ko-KR&page=1";

// 인기 영화 컨텐츠
// "https://api.themoviedb.org/3/movie/popular?api_key=b40235ce96defc556ca26d48159f5f13&language=ko-KR&page=1"

@RestApi(baseUrl: "https://api.themoviedb.org/3")
abstract class TmdbApi {
  factory TmdbApi(Dio dio, {String baseUrl}) = _TmdbApi;

  //인기 영화 호출
  @GET(
      "/movie/popular?api_key=b40235ce96defc556ca26d48159f5f13&language=ko-KR&page=1")
  Future<TmdbPopularMovieResponse> loadPopularMovie();

  // 인기 드라마 호출
  @GET(
      "/tv/popular?api_key=b40235ce96defc556ca26d48159f5f13&language=ko-KR&page=1")
  Future<TmdbPopularDramaResponse> loadPopularDrama();
  // https://api.themoviedb.org/3/movie/453395/videos?api_key=b40235ce96defc556ca26d48159f5f13&language=ko-KR&page=1

  // 영화 비디오 정보 호출 (예고판 키값 등등)
  @GET(
      "/movie/{movieId}/videos?api_key=b40235ce96defc556ca26d48159f5f13&language=ko-KR&page=1")
  Future<TmdbMovieVideoInfoResponse> loadTmdbMovieVideoInfo(
      @Path("movieId") int movieId);

  // https://api.themoviedb.org/3/movie/${453395}/credits?api_key=b40235ce96defc556ca26d48159f5f13&language=ko-KR&page=1
  // 영화 크래딧 정보 호출 (출연진 정보 등등)
  @GET(
      "/movie/{movieId}/credits?api_key=b40235ce96defc556ca26d48159f5f13&language=ko-KR&page=1")
  Future<TmdbMovieCreditResponse> loadMovieCreditInfo(
      @Path("movieId") int movieId);

  // 드라마 크래딧 정보 호출 (출연진 정보 등등)
  @GET(
      "/tv/{dramaId}/credits?api_key=b40235ce96defc556ca26d48159f5f13&language=ko-KR&page=1")
  Future<TmdbDramaCreditResponse> loadDramaCreditInfo(
      @Path("dramaId") int dramaId);
}
