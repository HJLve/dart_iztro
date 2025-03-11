/// 用于处理索引，将索引锁定在 0~max 范围内
///
/// @param index 当前索引
/// @param max 最大循环数，默认为12【因为12用得最多，宫位数量以及十二地支数量都为12，所以将12作为默认值】
/// @returns {number} 处理后的索引
int fixIndex(int index, {int max = 12}) {
  if (index < 0) {
    return fixIndex(index + max, max: max);
  }

  if (index > max - 1) {
    return fixIndex(index - max, max: max);
  }

  var res = (index != 0) ? index : 0;
  return res;
}
