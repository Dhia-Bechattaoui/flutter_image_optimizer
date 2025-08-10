import 'package:flutter/material.dart';
import 'package:flutter_image_optimizer/flutter_image_optimizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Image Optimizer Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ImageOptimizerExample(),
    );
  }
}

class ImageOptimizerExample extends StatefulWidget {
  const ImageOptimizerExample({super.key});

  @override
  State<ImageOptimizerExample> createState() => _ImageOptimizerExampleState();
}

class _ImageOptimizerExampleState extends State<ImageOptimizerExample> {
  String? _selectedImagePath;
  OptimizationResult? _lastResult;
  bool _isProcessing = false;

  final _qualityController = TextEditingController(text: '85');
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  OutputFormat _selectedFormat = OutputFormat.auto;
  bool _maintainAspectRatio = true;

  @override
  void dispose() {
    _qualityController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // In a real app, you'd use image_picker or file_picker
    // For this example, we'll simulate picking an image
    setState(() {
      _selectedImagePath = '/path/to/sample/image.jpg';
    });
  }

  Future<void> _optimizeImage() async {
    if (_selectedImagePath == null) {
      _showSnackBar('Please select an image first');
      return;
    }

    setState(() {
      _isProcessing = true;
      _lastResult = null;
    });

    try {
      final options = OptimizationOptions(
        quality: int.tryParse(_qualityController.text) ?? 85,
        targetWidth: int.tryParse(_widthController.text),
        targetHeight: int.tryParse(_heightController.text),
        maintainAspectRatio: _maintainAspectRatio,
        outputFormat: _selectedFormat,
      );

      final result = await ImageOptimizer.optimizeFile(
        _selectedImagePath!,
        options: options,
      );

      setState(() {
        _lastResult = result;
        _isProcessing = false;
      });

      if (result.success) {
        _showSnackBar('Image optimized successfully!');
      } else {
        _showSnackBar('Optimization failed: ${result.errorMessage}');
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showSnackBar('Error: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Image Optimizer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Image Selection',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedImagePath ?? 'No image selected',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Pick Image'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Optimization Options',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _qualityController,
                            decoration: const InputDecoration(
                              labelText: 'Quality (0-100)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<OutputFormat>(
                            value: _selectedFormat,
                            decoration: const InputDecoration(
                              labelText: 'Output Format',
                              border: OutlineInputBorder(),
                            ),
                            items: OutputFormat.values.map((format) {
                              return DropdownMenuItem(
                                value: format,
                                child: Text(format.name.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedFormat = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _widthController,
                            decoration: const InputDecoration(
                              labelText: 'Target Width (optional)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _heightController,
                            decoration: const InputDecoration(
                              labelText: 'Target Height (optional)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('Maintain Aspect Ratio'),
                      value: _maintainAspectRatio,
                      onChanged: (value) {
                        setState(() {
                          _maintainAspectRatio = value ?? true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessing ? null : _optimizeImage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : const Text('Optimize Image'),
            ),
            if (_lastResult != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Optimization Result',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _buildResultInfo(_lastResult!),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultInfo(OptimizationResult result) {
    if (result.success) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Status', 'Success', Colors.green),
          _buildInfoRow('Output Path', result.outputPath ?? 'N/A'),
          _buildInfoRow('Original Size', '${result.originalSize} bytes'),
          _buildInfoRow('Optimized Size', '${result.optimizedSize} bytes'),
          _buildInfoRow('Size Reduction', '${result.sizeReduction} bytes'),
          _buildInfoRow('Reduction %',
              '${result.sizeReductionPercentage?.toStringAsFixed(1)}%'),
          _buildInfoRow('Compression Ratio',
              '${result.compressionRatio?.toStringAsFixed(2)}'),
          _buildInfoRow('Processing Time', '${result.processingTimeMs}ms'),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Status', 'Failed', Colors.red),
          _buildInfoRow('Error', result.errorMessage ?? 'Unknown error'),
          _buildInfoRow('Processing Time', '${result.processingTimeMs}ms'),
        ],
      );
    }
  }

  Widget _buildInfoRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}
