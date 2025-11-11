import 'package:flutter/material.dart';
import 'package:flutter_image_optimizer/flutter_image_optimizer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Image Optimizer Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ImageOptimizerDemo(),
    );
  }
}

class ImageOptimizerDemo extends StatefulWidget {
  const ImageOptimizerDemo({super.key});

  @override
  State<ImageOptimizerDemo> createState() => _ImageOptimizerDemoState();
}

class _ImageOptimizerDemoState extends State<ImageOptimizerDemo> {
  String? _selectedImagePath;
  OptimizationResult? _lastResult;
  bool _isProcessing = false;
  
  // Image dimensions
  int? _originalWidth;
  int? _originalHeight;
  int? _optimizedWidth;
  int? _optimizedHeight;

  // Feature 1: Quality Control (0-100)
  double _quality = 85.0;

  // Feature 2: Multiple Formats (JPEG, PNG, WebP, Auto)
  OutputFormat _selectedFormat = OutputFormat.auto;

  // Feature 3: Smart Resizing with Aspect Ratio Preservation
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  bool _maintainAspectRatio = true;

  // Feature 4: Max File Size Enforcement
  final _maxFileSizeController = TextEditingController();

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    _maxFileSizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      
      // Show dialog to choose between gallery and camera
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final XFile? image = await picker.pickImage(source: source);

      if (image != null && image.path.isNotEmpty) {
        // Get image dimensions
        final imageFile = File(image.path);
        final imageBytes = await imageFile.readAsBytes();
        final decodedImage = img.decodeImage(imageBytes);
        
        setState(() {
          _selectedImagePath = image.path;
          _lastResult = null;
          _originalWidth = decodedImage?.width;
          _originalHeight = decodedImage?.height;
          _optimizedWidth = null;
          _optimizedHeight = null;
        });
        _showSnackBar('✅ Image selected: ${image.name}', isError: false);
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e\n\nMake sure camera/storage permissions are granted.', isError: true);
    }
  }

  Future<void> _optimizeImage() async {
    if (_selectedImagePath == null) {
      _showSnackBar('Please select an image first');
      return;
    }

    if (!File(_selectedImagePath!).existsSync()) {
      _showSnackBar('Selected file does not exist');
      return;
    }

    setState(() {
      _isProcessing = true;
      _lastResult = null;
    });

    try {
      final options = OptimizationOptions(
        // Feature 1: Quality Control
        quality: _quality.round(),
        
        // Feature 2: Multiple Formats
        outputFormat: _selectedFormat,
        
        // Feature 3: Smart Resizing
        targetWidth: int.tryParse(_widthController.text),
        targetHeight: int.tryParse(_heightController.text),
        maintainAspectRatio: _maintainAspectRatio,
        
        // Feature 4: Max File Size Enforcement
        maxFileSize: int.tryParse(_maxFileSizeController.text),
      );

      final result = await ImageOptimizer.optimizeFile(
        _selectedImagePath!,
        options: options,
      );

      // Get optimized image dimensions
      int? optimizedWidth;
      int? optimizedHeight;
      if (result.success && result.outputPath != null) {
        try {
          final optimizedFile = File(result.outputPath!);
          final optimizedBytes = await optimizedFile.readAsBytes();
          final decodedOptimized = img.decodeImage(optimizedBytes);
          optimizedWidth = decodedOptimized?.width;
          optimizedHeight = decodedOptimized?.height;
        } catch (e) {
          // Ignore errors reading dimensions
        }
      }

      setState(() {
        _lastResult = result;
        _isProcessing = false;
        _optimizedWidth = optimizedWidth;
        _optimizedHeight = optimizedHeight;
      });

      // Feature 7: Error Handling
      if (result.success) {
        _showSnackBar('✅ Image optimized successfully!', isError: false);
      } else {
        _showSnackBar('❌ Optimization failed: ${result.errorMessage}', isError: true);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showSnackBar('Error: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Image Optimizer Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Selection Section
            _buildSection(
              title: '📁 Image Selection',
              child: Column(
                children: [
                  if (_selectedImagePath != null) ...[
                    // Image Preview
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_selectedImagePath!),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Image Info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.image, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedImagePath!.split('/').last,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (_originalWidth != null && _originalHeight != null)
                                  Text(
                                    'Size: ${_formatBytes(File(_selectedImagePath!).lengthSync())} • Dimensions: $_originalWidth × $_originalHeight px',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                  else
                    const Text('No image selected'),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Select Image'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Feature 1: Quality Control
            _buildSection(
              title: '⚡ Quality Control',
              subtitle: 'Adjustable quality settings for lossy formats (0-100)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quality: ${_quality.round()}'),
                  Slider(
                    value: _quality,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: _quality.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _quality = value;
                      });
                    },
                  ),
                  const Text(
                    'Lower values = smaller file size, lower quality\nHigher values = larger file size, better quality',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Feature 2: Multiple Formats
            _buildSection(
              title: '🖼️ Multiple Formats',
              subtitle: 'Support for JPEG, PNG, WebP with automatic format detection',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<OutputFormat>(
                    initialValue: _selectedFormat,
                    decoration: const InputDecoration(
                      labelText: 'Output Format',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.image),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: OutputFormat.auto,
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome, size: 20),
                            const SizedBox(width: 8),
                            const Text('Auto (Intelligent Detection)'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: OutputFormat.jpeg,
                        child: Row(
                          children: [
                            const Icon(Icons.image, size: 20),
                            const SizedBox(width: 8),
                            const Text('JPEG (Lossy, Photos)'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: OutputFormat.png,
                        child: Row(
                          children: [
                            const Icon(Icons.image_outlined, size: 20),
                            const SizedBox(width: 8),
                            const Text('PNG (Lossless, Graphics)'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: OutputFormat.webp,
                        child: Row(
                          children: [
                            const Icon(Icons.high_quality, size: 20),
                            const SizedBox(width: 8),
                            const Text('WebP (Modern, Efficient)'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedFormat = value;
                        });
                      }
                    },
                  ),
                  if (_selectedFormat == OutputFormat.auto)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '🔍 Auto-detection: Automatically chooses PNG for images with transparency, JPEG otherwise',
                        style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Feature 3: Smart Resizing
            _buildSection(
              title: '📏 Smart Resizing',
              subtitle: 'Resize images with optional aspect ratio preservation',
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _widthController,
                          decoration: const InputDecoration(
                            labelText: 'Target Width (px)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.width_wide),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _heightController,
                          decoration: const InputDecoration(
                            labelText: 'Target Height (px)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.height),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('Maintain Aspect Ratio'),
                    subtitle: const Text('Preserve original image proportions'),
                    value: _maintainAspectRatio,
                    onChanged: (value) {
                      setState(() {
                        _maintainAspectRatio = value ?? true;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Feature 4: Max File Size
            _buildSection(
              title: '📊 Max File Size Enforcement',
              subtitle: 'Automatically reduce quality/resize to meet size limit',
              child: TextField(
                controller: _maxFileSizeController,
                decoration: InputDecoration(
                  labelText: 'Max File Size (bytes)',
                  hintText: 'e.g., 500000 for 500KB',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.storage),
                  helperText: 'Leave empty for no limit',
                ),
                keyboardType: TextInputType.number,
              ),
            ),

            const SizedBox(height: 24),

            // Optimize Button
            ElevatedButton.icon(
              onPressed: (_isProcessing || _selectedImagePath == null)
                  ? null
                  : _optimizeImage,
              icon: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_fix_high),
              label: Text(_isProcessing ? 'Processing...' : 'Optimize Image'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),

            // Feature 6: Detailed Metrics
            if (_lastResult != null) ...[
              const SizedBox(height: 24),
              _buildSection(
                title: '📊 Detailed Metrics',
                subtitle: 'Comprehensive optimization statistics and timing',
                child: _buildMetricsCard(_lastResult!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsCard(OptimizationResult result) {
    if (result.success) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success Status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Optimization Successful',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Before/After Image Comparison
          if (result.outputPath != null && _selectedImagePath != null) ...[
            Row(
              children: [
                // Original Image
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Original',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedImagePath!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_originalWidth != null && _originalHeight != null)
                        Text(
                          '$_originalWidth × $_originalHeight px',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      Text(
                        _formatBytes(result.originalSize),
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward, color: Colors.blue),
                const SizedBox(width: 16),
                // Optimized Image
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Optimized',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(result.outputPath!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_optimizedWidth != null && _optimizedHeight != null)
                        Text(
                          '$_optimizedWidth × $_optimizedHeight px',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      Text(
                        _formatBytes(result.optimizedSize ?? 0),
                        style: TextStyle(fontSize: 12, color: Colors.green[700], fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
          ],

          // File Path
          _buildMetricRow(
            'Output Path',
            result.outputPath ?? 'N/A',
            icon: Icons.folder,
          ),

          // Dimensions
          if (_originalWidth != null && _originalHeight != null)
            _buildMetricRow(
              'Original Dimensions',
              '$_originalWidth × $_originalHeight px',
              icon: Icons.aspect_ratio,
            ),
          if (_optimizedWidth != null && _optimizedHeight != null)
            _buildMetricRow(
              'Optimized Dimensions',
              '$_optimizedWidth × $_optimizedHeight px',
              icon: Icons.aspect_ratio,
            ),

          // File Sizes
          _buildMetricRow(
            'Original Size',
            _formatBytes(result.originalSize),
            icon: Icons.insert_drive_file,
          ),
          _buildMetricRow(
            'Optimized Size',
            _formatBytes(result.optimizedSize ?? 0),
            icon: Icons.compress,
          ),

          // Size Reduction
          if (result.sizeReduction != null)
            _buildMetricRow(
              'Size Reduction',
              '${_formatBytes(result.sizeReduction!)} (${result.sizeReductionPercentage?.toStringAsFixed(1)}%)',
              icon: Icons.trending_down,
              valueColor: Colors.green,
            ),

          // Compression Ratio
          if (result.compressionRatio != null)
            _buildMetricRow(
              'Compression Ratio',
              result.compressionRatio!.toStringAsFixed(2),
              icon: Icons.percent,
            ),

          // Feature 1: High Performance - Processing Time
          _buildMetricRow(
            'Processing Time',
            '${result.processingTimeMs}ms',
            icon: Icons.speed,
            valueColor: Colors.blue,
          ),
        ],
      );
    } else {
      // Feature 7: Error Handling
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  'Optimization Failed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildMetricRow(
              'Error Message',
              result.errorMessage ?? 'Unknown error',
              icon: Icons.info,
            ),
            _buildMetricRow(
              'Processing Time',
              '${result.processingTimeMs}ms',
              icon: Icons.speed,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildMetricRow(
    String label,
    String value, {
    IconData? icon,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: valueColor != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}
