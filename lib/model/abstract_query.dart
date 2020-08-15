// 分页查询抽象对象
abstract class Query<T> {
  // 当前页数
  int page = 1;

  // 返回的行数
  int rows = 10;

  // 总数
  int total = 0;

  // 结果集
  List<T> result = List<T>();
}
