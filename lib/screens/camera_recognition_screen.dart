import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/food_recognition_service.dart';
import '../models/food_recognition_result.dart';

class CameraRecognitionScreen extends StatefulWidget {
  final Function(List<FoodRecognitionResult> results, Map<String, int> servingsMap, String? imagePath)
      onFoodConfirmed;

  const CameraRecognitionScreen({
    super.key,
    required this.onFoodConfirmed,
  });

  @override
  State<CameraRecognitionScreen> createState() =>
      _CameraRecognitionScreenState();
}

class _CameraRecognitionScreenState extends State<CameraRecognitionScreen> {
  final ImagePicker _picker = ImagePicker();
  final FoodRecognitionService _recognitionService = FoodRecognitionService();

  XFile? _selectedImage;
  FoodRecognitionResponse? _recognitionResult;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, int> _servingsMap = {};
  List<FoodRecognitionResult> _selectedFoods = [];
  bool _isManualSelectionMode = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isManualSelectionMode ? '选择食物' : '拍照识别食物'),
        centerTitle: true,
        actions: [
          if (!_isManualSelectionMode)
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: _pickFromGallery,
              tooltip: '从相册选择',
            ),
          IconButton(
            icon: Icon(_isManualSelectionMode ? Icons.camera_alt : Icons.list),
            onPressed: () {
              setState(() {
                _isManualSelectionMode = !_isManualSelectionMode;
                if (_isManualSelectionMode) {
                  _recognitionResult = null;
                  _selectedFoods = [];
                  _servingsMap = {};
                }
              });
            },
            tooltip: _isManualSelectionMode ? '使用拍照' : '手动选择',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isManualSelectionMode)
              _buildManualSelectionSection()
            else
              _buildImageSection(),
            const SizedBox(height: 20),
            if (_isLoading) _buildLoadingSection(),
            if (_errorMessage != null && !_isManualSelectionMode) _buildErrorSection(),
            if (_recognitionResult != null && !_isLoading && !_isManualSelectionMode)
              _buildRecognitionResultsSection(),
            if (_selectedFoods.isNotEmpty) _buildConfirmButton(),
          ],
        ),
      ),
      floatingActionButton: _isManualSelectionMode
          ? null
          : FloatingActionButton.extended(
              onPressed: _isLoading ? null : _takePicture,
              icon: const Icon(Icons.camera_alt),
              label: const Text('拍照'),
              backgroundColor: _isLoading ? Colors.grey : Colors.orange,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImageSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: kIsWeb
                    ? FutureBuilder<Uint8List>(
                        future: _selectedImage!.readAsBytes(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      )
                    : Image.network(
                        _selectedImage!.path,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.broken_image, size: 64));
                        },
                      ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '点击下方按钮拍照',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildManualSelectionSection() {
    final foodDatabase = FoodRecognitionService.getFoodDatabase();
    final filteredFoods = _searchQuery.isEmpty
        ? foodDatabase
        : FoodRecognitionService.searchFood(_searchQuery);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '搜索食物...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '已选择 ${_selectedFoods.length} 种食物',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filteredFoods.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final food = filteredFoods[index];
                final foodResult = FoodRecognitionResult(
                  name: food['name'] as String,
                  calorie: food['calorie'] as double,
                  probability: 1.0,
                  hasCalorie: true,
                );
                final isSelected = _selectedFoods.any((f) => f.name == foodResult.name);
                final servings = _servingsMap[foodResult.name] ?? 1;

                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          if (!_selectedFoods.any((f) => f.name == foodResult.name)) {
                            _selectedFoods.add(foodResult);
                            _servingsMap[foodResult.name] = 1;
                          }
                        } else {
                          _selectedFoods.removeWhere((f) => f.name == foodResult.name);
                          _servingsMap.remove(foodResult.name);
                        }
                      });
                    },
                    activeColor: Colors.orange,
                  ),
                  title: Text(
                    food['name'] as String,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text('${food['calorie']} kcal/100g · ${food['category']}'),
                  trailing: isSelected
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (servings > 1) {
                                  setState(() {
                                    _servingsMap[foodResult.name] = servings - 1;
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove, size: 20),
                              color: Colors.orange,
                            ),
                            Text(
                              servings.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (servings < 10) {
                                  setState(() {
                                    _servingsMap[foodResult.name] = servings + 1;
                                  });
                                }
                              },
                              icon: const Icon(Icons.add, size: 20),
                              color: Colors.orange,
                            ),
                          ],
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedFoods.removeWhere((f) => f.name == foodResult.name);
                        _servingsMap.remove(foodResult.name);
                      } else {
                        if (!_selectedFoods.any((f) => f.name == foodResult.name)) {
                          _selectedFoods.add(foodResult);
                          _servingsMap[foodResult.name] = 1;
                        }
                      }
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            CircularProgressIndicator(color: Colors.orange),
            SizedBox(height: 16),
            Text(
              '正在识别食物...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '请稍候',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return Card(
      elevation: 4,
      color: Colors.red[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: _takePicture,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重新拍照'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isManualSelectionMode = true;
                      _recognitionResult = null;
                      _selectedFoods = [];
                      _servingsMap = {};
                    });
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('手动选择'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecognitionResultsSection() {
    if (_recognitionResult == null || !_recognitionResult!.hasResults) {
      return Card(
        elevation: 4,
        color: Colors.orange[50],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.search_off, color: Colors.orange, size: 48),
              const SizedBox(height: 12),
              const Text(
                '未能识别出食物',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '可以尝试重新拍照或手动选择',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _takePicture,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('重新拍照'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isManualSelectionMode = true;
                        _recognitionResult = null;
                        _selectedFoods = [];
                        _servingsMap = {};
                      });
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('手动选择'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.restaurant_menu, color: Colors.orange),
                const SizedBox(width: 8),
                const Text(
                  '识别到以下食物',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '已选 ${_selectedFoods.length} 项',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const Divider(),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recognitionResult!.results.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final food = _recognitionResult!.results[index];
                final isSelected = _selectedFoods.contains(food);
                final servings = _servingsMap[food.name] ?? 1;
                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedFoods.add(food);
                          if (!_servingsMap.containsKey(food.name)) {
                            _servingsMap[food.name] = 1;
                          }
                        } else {
                          _selectedFoods.remove(food);
                        }
                      });
                    },
                    activeColor: Colors.orange,
                  ),
                  title: Text(
                    food.name,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    food.hasCalorie
                        ? '${food.calorie.toStringAsFixed(0)} kcal/100g'
                        : '暂无热量数据',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${food.confidencePercentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: food.isHighConfidence
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {
                            if (servings > 1) {
                              setState(() {
                                _servingsMap[food.name] = servings - 1;
                              });
                            }
                          },
                          icon: const Icon(Icons.remove, size: 20),
                          color: Colors.orange,
                        ),
                        Text(
                          servings.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (servings < 10) {
                              setState(() {
                                _servingsMap[food.name] = servings + 1;
                              });
                            }
                          },
                          icon: const Icon(Icons.add, size: 20),
                          color: Colors.orange,
                        ),
                      ],
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedFoods.remove(food);
                      } else {
                        _selectedFoods.add(food);
                        if (!_servingsMap.containsKey(food.name)) {
                          _servingsMap[food.name] = 1;
                        }
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    int totalCalories = 0;
    for (var food in _selectedFoods) {
      if (food.hasCalorie) {
        totalCalories += (food.calorie * (_servingsMap[food.name] ?? 1)).toInt();
      }
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '已选择 ${_selectedFoods.length} 种食物',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '总计: $totalCalories kcal',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedFoods.isNotEmpty ? _confirmSelection : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(width: 8),
                  Text(
                    '保存记录',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (image != null) {
        await _processImage(image);
      }
    } catch (e) {
      setState(() {
        _errorMessage = '拍照失败: $e';
      });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (image != null) {
        await _processImage(image);
      }
    } catch (e) {
      setState(() {
        _errorMessage = '选择图片失败: $e';
      });
    }
  }

  Future<void> _processImage(XFile image) async {
    setState(() {
      _selectedImage = image;
      _isLoading = true;
      _errorMessage = null;
      _recognitionResult = null;
      _selectedFoods = [];
      _servingsMap = {};
    });

    try {
      final imageBytes = await image.readAsBytes();
      final result = await _recognitionService.recognizeFoodFromBytes(imageBytes);

      setState(() {
        _isLoading = false;
        _recognitionResult = result;

        if (!result.isSuccess) {
          _errorMessage = result.errorMsg ??
              FoodRecognitionService.getErrorMessage(result.errorCode);
        } else if (!result.hasResults) {
          _errorMessage = '未能识别出食物，请尝试重新拍照或手动选择';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '处理失败: $e';
      });
    }
  }

  Future<void> _confirmSelection() async {
    if (_selectedFoods.isEmpty) return;

    widget.onFoodConfirmed(_selectedFoods, _servingsMap, _selectedImage?.path);
    Navigator.pop(context);
  }
}
