import 'package:flutter/material.dart';
import 'package:dart_iztro/utils/solar_time_util.dart';
import 'package:dart_iztro/solar_time_calculator.dart';
import 'package:dart_iztro/services/geo_lookup_service.dart';
import 'package:intl/intl.dart';

class SolarTimeUtilExample extends StatefulWidget {
  const SolarTimeUtilExample({Key? key}) : super(key: key);

  @override
  State<SolarTimeUtilExample> createState() => _SolarTimeUtilExampleState();
}

class _SolarTimeUtilExampleState extends State<SolarTimeUtilExample> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController(
    text: '116.4074',
  );
  final TextEditingController _latitudeController = TextEditingController(
    text: '39.9042',
  );
  final TextEditingController _addressController = TextEditingController();

  final _hourController = TextEditingController(text: '12');
  final _minuteController = TextEditingController(text: '00');
  final _geoLookupService = GeoLookupService();

  bool _useNewMethod = true; // 默认使用新方法
  bool _isLoading = false;
  String _errorMessage = '';
  String _displayAddress = '';
  String _selectedMeridiem = 'AM';

  // 计算结果
  String _meanSolarTime = '';
  String _realSolarTime = '';
  String _oldMethodResult = '';

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // 设置默认时间为当前时间
    final now = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(now);
    _timeController.text = DateFormat('HH:mm:ss').format(now);

    // 同步两个日期控制器
    _selectedDate = now;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    _addressController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  Future<void> _searchAddress() async {
    if (_addressController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = '请输入地址';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      // 清空之前的结果
      _longitudeController.text = '';
      _latitudeController.text = '';
      _displayAddress = '';
      _meanSolarTime = '';
      _realSolarTime = '';
      _oldMethodResult = '';
    });

    try {
      final address = _addressController.text.trim();
      print('开始查询地址: $address');
      final location = await _geoLookupService.lookupAddress(address);

      print('获取到地址查询结果: $location');

      if (location != null) {
        print(
          '地址查询成功: 经度=${location.longitude}, 纬度=${location.latitude}, 地址=${location.displayName}',
        );
        // 检查经纬度是否为0
        if (location.longitude == 0 && location.latitude == 0) {
          print('警告: 经纬度为0，可能数据有误');
          setState(() {
            _errorMessage = '获取的经纬度为0，请尝试更精确的地址';
            _isLoading = false;
          });
          return;
        }

        setState(() {
          _longitudeController.text = location.longitude.toString();
          _latitudeController.text = location.latitude.toString();
          _displayAddress = location.displayName;
          _isLoading = false;
          print('状态已更新: 经度=${location.longitude}, 纬度=${location.latitude}');
        });
      } else {
        print('未找到地址信息');
        setState(() {
          _errorMessage = '无法找到该地址，请尝试更精确的地址';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('地址查询过程中发生异常: $e');
      setState(() {
        _errorMessage = '查询失败: $e';
        _isLoading = false;
      });
    }
  }

  void _onDateSelected(DateTime dateTime) {
    setState(() {
      _selectedDate = dateTime;
      _dateController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    });
  }

  void _calculateSolarTime() {
    try {
      setState(() {
        _errorMessage = '';
        _meanSolarTime = '';
        _realSolarTime = '';
        _oldMethodResult = '';
      });

      // 验证输入
      if (_longitudeController.text.isEmpty ||
          _latitudeController.text.isEmpty) {
        setState(() {
          _errorMessage = '请输入有效的经纬度';
        });
        return;
      }

      // 解析经纬度
      final longitude = double.parse(_longitudeController.text);
      final latitude = double.parse(_latitudeController.text);

      if (_useNewMethod) {
        // 新方法：使用SolarTimeUtil计算
        // 解析输入的日期时间
        final dateStr = _dateController.text;
        final timeStr = _timeController.text;
        final dateTimeStr = '$dateStr $timeStr';
        final dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeStr);

        // 创建SolarTime对象
        final solarTime = SolarTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second.toDouble(),
        );

        // 创建太阳时计算工具实例
        final solarTimeUtil = SolarTimeUtil(
          longitude: longitude,
          latitude: latitude,
        );

        // 计算平太阳时
        final meanSolarTime = solarTimeUtil.getMeanSolarTime(solarTime);

        // 计算真太阳时
        final realSolarTime = solarTimeUtil.getRealSolarTime(solarTime);

        setState(() {
          _meanSolarTime = '平太阳时: ${meanSolarTime.toString()}';
          _realSolarTime = '真太阳时: ${realSolarTime.toString()}';
        });
      } else {
        // 旧方法：使用SolarTimeCalculator计算
        // 验证输入
        if (_hourController.text.isEmpty || _minuteController.text.isEmpty) {
          setState(() {
            _errorMessage = '请输入出生时间';
          });
          return;
        }

        // 解析出生时间
        int hour = int.tryParse(_hourController.text) ?? 0;
        int minute = int.tryParse(_minuteController.text) ?? 0;

        // 简单验证
        if (hour < 0 || hour > 12) {
          setState(() {
            _errorMessage = '小时必须在0-12之间';
          });
          return;
        }

        if (minute < 0 || minute > 59) {
          setState(() {
            _errorMessage = '分钟必须在0-59之间';
          });
          return;
        }

        // 12小时制转24小时制
        if (_selectedMeridiem == 'PM' && hour < 12) {
          hour += 12;
        } else if (_selectedMeridiem == 'AM' && hour == 12) {
          hour = 0;
        }

        // 创建出生时间的DateTime对象
        final birthDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          hour,
          minute,
        );

        print('计算真太阳时: 日期时间=$birthDateTime, 经度=$longitude, 纬度=$latitude');

        // 使用SolarTimeCalculator计算真太阳时
        final trueSolarTime = SolarTimeCalculator.calculateTrueSolarTime(
          birthDateTime,
          longitude,
          8.0, // 中国时区UTC+8
        );

        // 计算本地平时（未考虑夏令时的标准时间）
        final localMeanTime = birthDateTime.add(
          Duration(minutes: (4 * (longitude - 120)).round()), // 120是东八区的中央经线
        );

        setState(() {
          _oldMethodResult =
              '旧算法结果:\n真太阳时: ${DateFormat('HH:mm:ss').format(trueSolarTime)}\n'
              '地方平时: ${DateFormat('HH:mm:ss').format(localMeanTime)}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '计算出错: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('太阳时计算示例')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 选择计算方法
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '选择计算方法',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('新方法 (天文算法)'),
                              value: true,
                              groupValue: _useNewMethod,
                              onChanged: (value) {
                                setState(() {
                                  _useNewMethod = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('旧方法 (简易计算)'),
                              value: false,
                              groupValue: _useNewMethod,
                              onChanged: (value) {
                                setState(() {
                                  _useNewMethod = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 地址搜索
              const Text(
                '通过地址搜索:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: '输入地址',
                        hintText: '例如: 北京市海淀区',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _searchAddress,
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('搜索'),
                  ),
                ],
              ),

              if (_displayAddress.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '找到地址: $_displayAddress',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.green,
                  ),
                ),
              ],

              const SizedBox(height: 16),
              const Divider(),

              if (_useNewMethod) ...[
                // 新方法的输入表单
                const Text(
                  '输入日期和时间:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: '日期 (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      _onDateSelected(picked);
                    }
                  },
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: '时间 (HH:MM:SS)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ] else ...[
                // 旧方法的输入表单
                const Text(
                  '输入日期和时间:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // 日期选择器
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        _onDateSelected(picked);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(_selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 时间输入
                Row(
                  children: [
                    // 小时
                    Expanded(
                      child: TextField(
                        controller: _hourController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '小时 (1-12)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 分钟
                    Expanded(
                      child: TextField(
                        controller: _minuteController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: '分钟 (0-59)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // AM/PM选择
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedMeridiem,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'AM', child: Text('AM')),
                          DropdownMenuItem(value: 'PM', child: Text('PM')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedMeridiem = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 16),

              const Text(
                '输入位置:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _longitudeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: '经度 (-180 到 180)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _latitudeController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: '纬度 (-90 到 90)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              if (_errorMessage.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateSolarTime,
                  child: const Text('计算太阳时'),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                '计算结果:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_useNewMethod) ...[
                        Text(_meanSolarTime),
                        const SizedBox(height: 8),
                        Text(_realSolarTime),
                      ] else ...[
                        Text(_oldMethodResult),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const ExpansionTile(
                title: Text('说明'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '两种计算方法：\n\n'
                      '新方法（天文算法）：综合考虑地球公转轨道椭圆形状、地轴倾斜等因素，使用复杂天文计算得出更精确的结果。\n\n'
                      '旧方法（简易计算）：使用简化计算，主要基于经度差异计算地方时，未充分考虑季节变化等因素。\n\n'
                      '平太阳时：以地球公转轨道平均速度计算的太阳时。\n\n'
                      '真太阳时：根据实际太阳位置计算的太阳时，包含了地球公转轨道椭圆形状和地轴倾斜的修正。\n\n'
                      '经度：东经为正值，西经为负值，范围是-180到180度。\n\n'
                      '纬度：北纬为正值，南纬为负值，范围是-90到90度。',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
