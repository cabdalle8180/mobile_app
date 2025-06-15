import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class DocumentsScreen extends StatefulWidget {
  final String userId;

  const DocumentsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _selectedDocumentType;
  File? _selectedFile;
  String? _uploadError;

  final List<Map<String, dynamic>> _documents = [
    {
      'type': 'Medical Certificate',
      'status': 'Valid',
      'uploadDate': '2024-03-01',
      'expiryDate': '2025-03-01',
      'fileSize': '2.5 MB',
      'fileType': 'PDF',
    },
    {
      'type': 'Proof of Address',
      'status': 'Valid',
      'uploadDate': '2024-02-15',
      'expiryDate': '2025-02-15',
      'fileSize': '1.8 MB',
      'fileType': 'PDF',
    },
  ];

  final List<String> _allowedFileTypes = ['pdf', 'jpg', 'jpeg', 'png'];
  final int _maxFileSize = 5 * 1024 * 1024; // 5MB

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showUploadDialog,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _documents.length,
        itemBuilder: (context, index) {
          final doc = _documents[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        doc['type'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          doc['status'],
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Upload Date', doc['uploadDate']),
                  _buildInfoRow('Expiry Date', doc['expiryDate']),
                  _buildInfoRow('File Size', doc['fileSize']),
                  _buildInfoRow('File Type', doc['fileType']),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _viewDocument(doc),
                        icon: const Icon(Icons.visibility),
                        label: const Text('View'),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () => _downloadDocument(doc),
                        icon: const Icon(Icons.download),
                        label: const Text('Download'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Upload Document'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Document Type',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedDocumentType,
                  items: const [
                    DropdownMenuItem(
                      value: 'Medical Certificate',
                      child: Text('Medical Certificate'),
                    ),
                    DropdownMenuItem(
                      value: 'Proof of Address',
                      child: Text('Proof of Address'),
                    ),
                    DropdownMenuItem(
                      value: 'ID Card',
                      child: Text('ID Card'),
                    ),
                    DropdownMenuItem(
                      value: 'Passport',
                      child: Text('Passport'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedDocumentType = value;
                      _uploadError = null;
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (_selectedFile != null) ...[
                  ListTile(
                    leading: const Icon(Icons.file_present),
                    title: Text(
                      path.basename(_selectedFile!.path),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${(_selectedFile!.lengthSync() / 1024 / 1024).toStringAsFixed(2)} MB',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _selectedFile = null;
                          _uploadError = null;
                        });
                      },
                    ),
                  ),
                ] else
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Select File'),
                  ),
                if (_uploadError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _uploadError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (_isUploading) ...[
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _uploadProgress,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Uploading: ${(_uploadProgress * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isUploading
                  ? null
                  : () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedDocumentType = null;
                        _selectedFile = null;
                        _uploadError = null;
                        _uploadProgress = 0.0;
                      });
                    },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isUploading
                  ? null
                  : () {
                      if (_validateUpload()) {
                        _uploadDocument();
                      }
                    },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedFileTypes,
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        if (file.lengthSync() > _maxFileSize) {
          setState(() {
            _uploadError = 'File size exceeds 5MB limit';
          });
          return;
        }

        setState(() {
          _selectedFile = file;
          _uploadError = null;
        });
      }
    } catch (e) {
      setState(() {
        _uploadError = 'Error selecting file: $e';
      });
    }
  }

  bool _validateUpload() {
    if (_selectedDocumentType == null) {
      setState(() {
        _uploadError = 'Please select a document type';
      });
      return false;
    }

    if (_selectedFile == null) {
      setState(() {
        _uploadError = 'Please select a file to upload';
      });
      return false;
    }

    return true;
  }

  Future<void> _uploadDocument() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _uploadError = null;
    });

    try {
      // Simulate upload progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {
          _uploadProgress = i / 100;
        });
      }

      // TODO: Implement actual file upload to backend
      // final response = await uploadFile(_selectedFile!, _selectedDocumentType!);

      // Add the new document to the list
      setState(() {
        _documents.add({
          'type': _selectedDocumentType,
          'status': 'Valid',
          'uploadDate': DateTime.now().toString().split(' ')[0],
          'expiryDate': DateTime.now()
              .add(const Duration(days: 365))
              .toString()
              .split(' ')[0],
          'fileSize':
              '${(_selectedFile!.lengthSync() / 1024 / 1024).toStringAsFixed(1)} MB',
          'fileType':
              path.extension(_selectedFile!.path).toUpperCase().substring(1),
        });
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Document uploaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _uploadError = 'Upload failed: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  Future<void> _viewDocument(Map<String, dynamic> doc) async {
    // TODO: Implement document viewing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document viewing not implemented yet'),
      ),
    );
  }

  Future<void> _downloadDocument(Map<String, dynamic> doc) async {
    // TODO: Implement document download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document download not implemented yet'),
      ),
    );
  }
}
