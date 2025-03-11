import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:dart_iztro/dart_iztro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _dartIztroPlugin = DartIztro();
  String _platformVersion = 'Unknown';
  Map<String, dynamic>? _baziResult;
  Map<String, dynamic>? _chartResult;
  bool _isLoading = false;

  // 日期时间控制器
  final _yearController = TextEditingController(text: '1990');
  final _monthController = TextEditingController(text: '1');
  final _dayController = TextEditingController(text: '1');
  final _hourController = TextEditingController(text: '12');
  final _minuteController = TextEditingController(text: '0');

  // 性别和日期类型
  String _gender = 'male';
  bool _isLunar = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _dartIztroPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // 计算八字
  Future<void> _calculateBaZi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _dartIztroPlugin.calculateBaZi(
        year: int.parse(_yearController.text),
        month: int.parse(_monthController.text),
        day: int.parse(_dayController.text),
        hour: int.parse(_hourController.text),
        minute: int.parse(_minuteController.text),
        isLunar: _isLunar,
        gender: _gender,
      );

      setState(() {
        _baziResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('计算出错: ${e.toString()}')));
    }
  }

  // 计算紫微星盘
  Future<void> _calculateChart() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _dartIztroPlugin.calculateChart(
        year: int.parse(_yearController.text),
        month: int.parse(_monthController.text),
        day: int.parse(_dayController.text),
        hour: int.parse(_hourController.text),
        minute: int.parse(_minuteController.text),
        isLunar: _isLunar,
        gender: _gender,
      );

      setState(() {
        _chartResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('计算出错: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('紫微斗数演示')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('运行平台: $_platformVersion'),
              const SizedBox(height: 20),

              // 输入表单
              const Text(
                '出生信息',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _yearController,
                      decoration: const InputDecoration(labelText: '年'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _monthController,
                      decoration: const InputDecoration(labelText: '月'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _dayController,
                      decoration: const InputDecoration(labelText: '日'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hourController,
                      decoration: const InputDecoration(labelText: '时'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _minuteController,
                      decoration: const InputDecoration(labelText: '分'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: const InputDecoration(labelText: '性别'),
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(value: 'male', child: Text('男')),
                        DropdownMenuItem(value: 'female', child: Text('女')),
                      ],
                    ),
                  ),
                ],
              ),

              // 日期类型
              Row(
                children: [
                  const Text('日期类型:'),
                  Radio<bool>(
                    value: false,
                    groupValue: _isLunar,
                    onChanged: (value) {
                      setState(() {
                        _isLunar = value!;
                      });
                    },
                  ),
                  const Text('阳历'),
                  Radio<bool>(
                    value: true,
                    groupValue: _isLunar,
                    onChanged: (value) {
                      setState(() {
                        _isLunar = value!;
                      });
                    },
                  ),
                  const Text('农历'),
                ],
              ),

              const SizedBox(height: 20),

              // 计算按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _calculateBaZi,
                    child: const Text('计算八字'),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _calculateChart,
                    child: const Text('计算紫微星盘'),
                  ),
                ],
              ),

              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                ),

              // 八字结果
              if (_baziResult != null) ...[
                const SizedBox(height: 20),
                const Text(
                  '八字结果',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      const JsonEncoder.withIndent('  ').convert(_baziResult),
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ],

              // 紫微星盘结果
              if (_chartResult != null) ...[
                const SizedBox(height: 20),
                const Text(
                  '紫微星盘结果',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '宫位数量: ${(_chartResult!['palaces'] as List).length}',
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '详细信息:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          const JsonEncoder.withIndent(
                            '  ',
                          ).convert(_chartResult!['info']),
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
