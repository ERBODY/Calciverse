import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/translations.dart';
import '../utils/conversion_mapping.dart';
import '../widgets/unified_page_design.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FileConverterPage extends StatefulWidget {
  final String currentLanguage;

  const FileConverterPage({super.key, required this.currentLanguage});

  @override
  State<FileConverterPage> createState() => FileConverterPageState();
}

class FileConverterPageState extends State<FileConverterPage> {
  File? _selectedFile;
  String? _selectedFileName;
  String? _selectedFileExtension;
  String _targetFormat = '';
  String? _sourceFormat; // The selected source format (e.g., 'PDF')
  bool _isConverting = false;
  double _conversionProgress = 0.0;
  String? _downloadUrl;
  int _dailyConversionCredits = 10; // Daily conversion credits
  DateTime? _lastResetDate; // Track last reset date

  // CloudConvert API key
  static const String _cloudConvertToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiM2ZiODVkMTBhMTdjMzhkMTQ2MTRkODZmNjkwYzRmNjFiMThlZDA1NTFmNzk3ZWUwMTYxNDRjY2ViNmU4MDZkYTQ1MzU4NzQyOTA0MTdkYWMiLCJpYXQiOjE3NTE2NDMzMTEuNTY2NzczLCJuYmYiOjE3NTE2NDMzMTEuNTY2Nzc1LCJleHAiOjQ5MDczMTY5MTEuNTYyMjYsInN1YiI6IjcyMTQzMzQyIiwic2NvcGVzIjpbInVzZXIucmVhZCIsInVzZXIud3JpdGUiLCJ0YXNrLnJlYWQiLCJ0YXNrLndyaXRlIiwid2ViaG9vay5yZWFkIiwid2ViaG9vay53cml0ZSIsInByZXNldC5yZWFkIiwicHJlc2V0LndyaXRlIl19.opQfxX8w9sTDR7BtZyMsLw6QhfIEnHOvfD4xSsGc1gJ2ZVwJ625wXeM4LzV5guNz5lhiqjMIh6dCxizrXy63zbfSKuOwV6N3ehSVKFpyIViBNS-xlDpsL-ODlYPpc4UghxanvSCld4bAchwbSUgk9Ab4dwZpQsFUgsPVKbgUYXOQl4JPc56vpTb6FoUFsRpF4Sbd6hFcIbDtrhQzRhPeCpuqFoFAG2NOEti8kDZdnQmqs-JMFPLuoRF-uQsIcJR-uNpTakkcQmOUmroIw5yZi79sXUV_eyxDvFlYWqQehTmodl8mj8MsagGM3ezo37i164M_StoPD7mSkoVlHOJVKB4lGizAFdqUi1iG3PlDLEq-5aP0j0QgF9QD4WCOxGoqagGIsWXTtPyAo4HvXMQmS85R_n0mIw-F3hT8ajgUo4X3NuEClSCvwoI1SaXToIEeK2SWD7wnoLLGXB3mFrDfoo3vQhwxySPNkb9W7dqDMXCI9aEpS8aNTih-RG49x_cNqghZhZIAUlO1cxJClCWR8w99dQQs-pmUjkStrTktoOG3s3vR0iSK9Rtq35yMF0LCb58ZffTYC_6v4eCwg6SzNzNXK_1Pe638nBpzir4EMk0YW9ymeLg4w19kxgHPahe2Ncquy0V3S3xos1Y78hGytBS6cmpOr4FOJOgrg-KWf0E';

  // Configuration
  final int _maxFileSizeMB = 100;
  final int _timeoutMinutes = 10;

  @override
  void initState() {
    super.initState();
    _loadAndCheckCredits();
  }

  Future<void> _loadAndCheckCredits() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCredits = prefs.getInt('daily_conversion_credits') ?? 10;
    final savedResetDateStr = prefs.getString('last_reset_date');

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime? savedResetDate;

    if (savedResetDateStr != null) {
      savedResetDate = DateTime.parse(savedResetDateStr);
    }

    // Check if we need to reset credits (new day)
    if (savedResetDate == null ||
        DateTime(savedResetDate.year, savedResetDate.month, savedResetDate.day)
            .isBefore(today)) {
      // New day, reset credits
      setState(() {
        _dailyConversionCredits = 10;
        _lastResetDate = now;
      });
      await _saveCredits(10, now);
    } else {
      // Same day, restore saved credits
      setState(() {
        _dailyConversionCredits = savedCredits;
        _lastResetDate = savedResetDate;
      });
    }
  }

  Future<void> _saveCredits(int credits, DateTime resetDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_conversion_credits', credits);
    await prefs.setString('last_reset_date', resetDate.toIso8601String());
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path;
        if (filePath != null) {
          setState(() {
            _selectedFile = File(filePath);
            _selectedFileName = result.files.single.name;
            _selectedFileExtension =
                result.files.single.extension?.toUpperCase();
            _sourceFormat = _selectedFileExtension;
            _targetFormat = '';
            _downloadUrl = null;
          });
        } else {
          _showErrorDialog(
            Translations.getTranslation(
                widget.currentLanguage, 'file_path_null'),
          );
        }
      }
    } catch (e) {
      _showErrorDialog(
        '${Translations.getTranslation(widget.currentLanguage, 'error_picking_file')}: $e',
      );
    }
  }

  // Validate file size before conversion
  bool _isFileSizeValid(File file) {
    final fileSizeMB = file.lengthSync() / (1024 * 1024);
    return fileSizeMB <= _maxFileSizeMB;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(Translations.getTranslation(widget.currentLanguage, 'error')),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text(Translations.getTranslation(widget.currentLanguage, 'ok')),
          ),
        ],
      ),
    );
  }

  Future<void> _convertFile() async {
    // Validation: Check file & format selection
    if (_selectedFile == null || _targetFormat.isEmpty) {
      _showErrorDialog(
        Translations.getTranslation(
            widget.currentLanguage, 'select_file_and_format'),
      );
      return;
    }
    if (_sourceFormat == null ||
        !isValidConversion(_sourceFormat!, _targetFormat)) {
      _showErrorDialog(
        Translations.getTranslation(
            widget.currentLanguage, 'invalid_or_unsupported_conversion'),
      );
      return;
    }

    // Validation: Check file size
    if (!_isFileSizeValid(_selectedFile!)) {
      _showErrorDialog(
        '${Translations.getTranslation(widget.currentLanguage, 'file_size_exceeds_limit')} '
        '$_maxFileSizeMB MB. '
        '${Translations.getTranslation(widget.currentLanguage, 'current_size')} '
        '${Translations.formatNumber(widget.currentLanguage, (_selectedFile!.lengthSync() / (1024 * 1024)), decimalDigits: 2)} MB',
      );
      return;
    }

    setState(() {
      _isConverting = true;
      _conversionProgress = 0.0;
      _downloadUrl = null;
    });

    try {
      // Step 1: Create Job
      final jobRes = await http.post(
        Uri.parse("https://api.cloudconvert.com/v2/jobs"),
        headers: {
          'Authorization': 'Bearer $_cloudConvertToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "tasks": {
            "import-my-file": {"operation": "import/upload"},
            "convert-my-file": {
              "operation": "convert",
              "input": "import-my-file",
              "input_format": _sourceFormat!.toLowerCase(),
              "output_format": _targetFormat.toLowerCase()
            },
            "export-my-file": {
              "operation": "export/url",
              "input": "convert-my-file"
            }
          }
        }),
      );

      if (jobRes.statusCode != 201) {
        throw Exception(
          Translations.getTranslation(
              widget.currentLanguage, 'failed_to_create_job'),
        );
      }

      final jobData = jsonDecode(jobRes.body);
      final jobId = jobData['data']['id'];
      final uploadTask = jobData['data']['tasks']
          .firstWhere((t) => t['name'] == 'import-my-file');
      final uploadUrl = uploadTask['result']['form']['url'];
      final uploadParams = uploadTask['result']['form']['parameters'];

      // Step 2: Upload File to S3
      final uploadRequest = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add all form parameters
      (uploadParams as Map<String, dynamic>).forEach((key, value) {
        uploadRequest.fields[key] = value.toString();
      });

      // Add file to upload
      uploadRequest.files
          .add(await http.MultipartFile.fromPath('file', _selectedFile!.path));

      // Upload file
      final uploadResponse = await uploadRequest.send();

      if (!mounted) return;

      setState(() {
        _conversionProgress = 0.5;
      });

      if (uploadResponse.statusCode != 201 &&
          uploadResponse.statusCode != 204) {
        throw Exception(
          Translations.getTranslation(
              widget.currentLanguage, 'file_upload_failed'),
        );
      }

      // Step 3: Wait for job completion
      bool jobDone = false;
      while (!jobDone && _isConverting) {
        await Future.delayed(const Duration(seconds: 2));
        final checkRes = await http.get(
          Uri.parse("https://api.cloudconvert.com/v2/jobs/$jobId"),
          headers: {'Authorization': 'Bearer $_cloudConvertToken'},
        ).timeout(Duration(minutes: _timeoutMinutes));

        if (checkRes.statusCode != 200) {
          throw Exception('Failed to check job status');
        }

        final checkData = jsonDecode(checkRes.body);
        final status = checkData['data']['status'];

        if (status == 'finished') {
          jobDone = true;
          final exportTask = checkData['data']['tasks']
              .firstWhere((t) => t['name'] == 'export-my-file');
          final fileUrl = exportTask['result']['files'][0]['url'];
          setState(() {
            _downloadUrl = fileUrl;
            _isConverting = false;
            _conversionProgress = 1.0;
            // Reduce daily conversion credits
            if (_dailyConversionCredits > 0) {
              _dailyConversionCredits--;
            }
          });
          // Save updated credits
          await _saveCredits(
              _dailyConversionCredits, _lastResetDate ?? DateTime.now());
        } else if (status == 'error') {
          // Extract error details from failed tasks
          final tasks = checkData['data']['tasks'] as List;
          String errorDetails = Translations.getTranslation(
            widget.currentLanguage,
            'conversion_failed',
          );
          for (var task in tasks) {
            if (task['status'] == 'error') {
              errorDetails = task['message'] ?? 'Unknown error';
              break;
            }
          }
          throw Exception(errorDetails);
        } else if (status == 'processing') {
          setState(() {
            _conversionProgress = 0.5 + (_conversionProgress * 0.5);
          });
        }
      }
    } catch (e) {
      setState(() {
        _isConverting = false;
        _conversionProgress = 0.0;
      });

      // Enhanced error handling with specific error types
      String errorMessage =
          '${Translations.getTranslation(widget.currentLanguage, 'conversion_error')}: $e';
      if (e is SocketException ||
          e.toString().contains('Network is unreachable')) {
        errorMessage = Translations.getTranslation(
          widget.currentLanguage,
          'network_error',
        );
      } else if (e is TimeoutException) {
        errorMessage = Translations.getTranslation(
          widget.currentLanguage,
          'timeout_error',
        );
      } else if (e.toString().contains('401') || e.toString().contains('403')) {
        errorMessage = Translations.getTranslation(
          widget.currentLanguage,
          'auth_error',
        );
      } else if (e.toString().contains('429')) {
        errorMessage = Translations.getTranslation(
          widget.currentLanguage,
          'too_many_requests',
        );
      } else if (e.toString().contains('500') || e.toString().contains('503')) {
        errorMessage = Translations.getTranslation(
          widget.currentLanguage,
          'service_unavailable',
        );
      }

      _showErrorDialog(errorMessage);
    }
  }

  void _clearAll() {
    setState(() {
      _selectedFile = null;
      _selectedFileName = null;
      _selectedFileExtension = null;
      _targetFormat = '';
      _isConverting = false;
      _conversionProgress = 0.0;
      _downloadUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(widget.currentLanguage, 'file_converter'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearAll,
            tooltip:
                Translations.getTranslation(widget.currentLanguage, 'Reset'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Daily Conversion Credits Card
            UnifiedResultCard(
              title: Translations.getTranslation(
                  widget.currentLanguage, 'Daily Conversions'),
              value: Translations.formatNumber(
                  widget.currentLanguage, _dailyConversionCredits,
                  decimalDigits: 0),
              icon: Icons.card_giftcard,
            ),
            const SizedBox(height: 16),
            _buildFileSelectionSection(),
            if (_selectedFile != null) ...[
              const SizedBox(height: 16),
              _buildFormatSelectionSection(),
              const SizedBox(height: 16),
              _buildFileSummarySection(),
              const SizedBox(height: 16),
              _buildConversionSection(),
            ],
            if (_downloadUrl != null) ...[
              const SizedBox(height: 16),
              _buildDownloadSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFileSelectionSection() {
    return UnifiedInputSection(
      title: Translations.getTranslation(widget.currentLanguage, 'Select File'),
      icon: Icons.cloud_upload,
      children: [
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: UnifiedPageDesign.primaryColor.withOpacity(0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _selectedFile == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 48,
                        color: UnifiedPageDesign.primaryColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Translations.getTranslation(
                            widget.currentLanguage, 'Tap to select file'),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description,
                        size: 48,
                        color: UnifiedPageDesign.primaryColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedFileName ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${Translations.formatNumber(widget.currentLanguage, (_selectedFile!.lengthSync() / 1024), decimalDigits: 2)} KB',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      if (!_isFileSizeValid(_selectedFile!)) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning,
                                  color: Colors.red, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'File size exceeds $_maxFileSizeMB MB limit',
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormatSelectionSection() {
    if (_sourceFormat != null &&
        getValidTargetFormats(_sourceFormat!).isNotEmpty) {
      return UnifiedInputSection(
        title: Translations.getTranslation(
            widget.currentLanguage, 'Target Format'),
        icon: Icons.file_present,
        children: [
          DropdownButtonFormField<String>(
            value: _targetFormat.isNotEmpty &&
                    getValidTargetFormats(_sourceFormat!)
                        .contains(_targetFormat)
                ? _targetFormat
                : null,
            decoration: InputDecoration(
              labelText: Translations.getTranslation(
                  widget.currentLanguage, 'Select target format'),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.file_present),
            ),
            items: getValidTargetFormats(_sourceFormat!)
                .map<DropdownMenuItem<String>>((format) {
              return DropdownMenuItem<String>(
                value: format,
                child: Text(format),
              );
            }).toList(),
            onChanged: (_selectedFile != null &&
                    _sourceFormat != null &&
                    getValidTargetFormats(_sourceFormat!).isNotEmpty)
                ? (val) {
                    setState(() {
                      _targetFormat = val ?? '';
                    });
                  }
                : null,
            isExpanded: true,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildFileSummarySection() {
    if (_selectedFile != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: UnifiedPageDesign.primaryColor.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: UnifiedPageDesign.primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  Translations.getTranslation(
                      widget.currentLanguage, 'File Summary'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${Translations.getTranslation(widget.currentLanguage, 'Name')}: ${_selectedFileName ?? ''}',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              '${Translations.getTranslation(widget.currentLanguage, 'Size')}: '
              '${Translations.formatNumber(widget.currentLanguage, (_selectedFile!.lengthSync() / 1024), decimalDigits: 2)} KB',
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              '${Translations.getTranslation(widget.currentLanguage, 'Type')}: ${_selectedFileExtension ?? ''}',
              style: const TextStyle(fontSize: 13),
            ),
            if (_targetFormat.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${Translations.getTranslation(widget.currentLanguage, 'Convert to')}: $_targetFormat',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: UnifiedPageDesign.accentColor,
                ),
              ),
            ],
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildConversionSection() {
    return Column(
      children: [
        UnifiedPrimaryButton(
          text: _isConverting
              ? 'Converting... '
                  '${Translations.formatNumber(widget.currentLanguage, (100 * _conversionProgress), decimalDigits: 0)}%'
              : Translations.getTranslation(
                  widget.currentLanguage, 'Calculate'),
          icon: Icons.transform,
          isLoading: _isConverting,
          onPressed: (_selectedFile != null &&
                  _targetFormat.isNotEmpty &&
                  !_isConverting &&
                  _isFileSizeValid(_selectedFile!))
              ? _convertFile
              : null,
        ),
        if (_isConverting) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: UnifiedPageDesign.primaryColor.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.sync, color: UnifiedPageDesign.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      Translations.getTranslation(
                          widget.currentLanguage, 'Conversion Progress'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: _conversionProgress,
                  backgroundColor:
                      UnifiedPageDesign.primaryColor.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    UnifiedPageDesign.accentColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${Translations.formatNumber(widget.currentLanguage, (100 * _conversionProgress), decimalDigits: 0)}% '
                  '${Translations.getTranslation(widget.currentLanguage, 'complete')}',
                  style: const TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDownloadSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 8),
              Text(
                Translations.getTranslation(
                    widget.currentLanguage, 'Conversion Complete'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${Translations.getTranslation(widget.currentLanguage, 'Original')}: ${_selectedFileName ?? ''}',
            style: const TextStyle(fontSize: 13),
          ),
          Text(
            '${Translations.getTranslation(widget.currentLanguage, 'Converted to')}: $_targetFormat',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          UnifiedPrimaryButton(
            text: Translations.getTranslation(
                widget.currentLanguage, 'Download Now'),
            icon: Icons.download,
            onPressed: () async {
              try {
                final url = Uri.parse(_downloadUrl!);
                await launchUrl(
                  url,
                  mode: LaunchMode.externalApplication,
                );
              } catch (e) {
                _showErrorDialog(
                  '${Translations.getTranslation(widget.currentLanguage, 'error')}: $e',
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
