import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/admin_content_model.dart';

class ContentFormDialog extends StatefulWidget {
  final AdminContent? content;
  final Function(AdminContent) onSave;

  const ContentFormDialog({
    super.key,
    this.content,
    required this.onSave,
  });

  @override
  State<ContentFormDialog> createState() => _ContentFormDialogState();
}

class _ContentFormDialogState extends State<ContentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _videoIdController;
  late TextEditingController _categoryIdController;
  late TextEditingController _imageUrlController;
  late TextEditingController _thumbnailUrlController;
  late TextEditingController _contentUrlController;
  late TextEditingController _priorityController;

  String _selectedType = 'video';
  bool _isActive = true;
  bool _isFeatured = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with existing content or empty values
    _titleController = TextEditingController(text: widget.content?.title ?? '');
    _descriptionController = TextEditingController(text: widget.content?.description ?? '');
    _videoIdController = TextEditingController(text: widget.content?.videoId ?? '');
    _categoryIdController = TextEditingController(text: widget.content?.categoryId ?? '');
    _imageUrlController = TextEditingController(text: widget.content?.imageUrl ?? '');
    _thumbnailUrlController = TextEditingController(text: widget.content?.thumbnailUrl ?? '');
    _contentUrlController = TextEditingController(text: widget.content?.contentUrl ?? '');
    _priorityController = TextEditingController(text: widget.content?.priority.toString() ?? '0');

    _selectedType = widget.content?.type ?? 'video';
    _isActive = widget.content?.isActive ?? true;
    _isFeatured = widget.content?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoIdController.dispose();
    _categoryIdController.dispose();
    _imageUrlController.dispose();
    _thumbnailUrlController.dispose();
    _contentUrlController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Text(
                  widget.content == null ? 'Add New Content' : 'Edit Content',
                  style: AppTheme.headingMedium.copyWith(
                    color: AppTheme.textDark,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(),
            
            // Form
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingL),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description *',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingL),

                      // Type and Priority Row
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedType,
                              decoration: const InputDecoration(
                                labelText: 'Content Type *',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'video', child: Text('Video')),
                                DropdownMenuItem(value: 'category', child: Text('Category')),
                                DropdownMenuItem(value: 'featured', child: Text('Featured')),
                                DropdownMenuItem(value: 'banner', child: Text('Banner')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value ?? 'video';
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingL),
                          Expanded(
                            child: TextFormField(
                              controller: _priorityController,
                              decoration: const InputDecoration(
                                labelText: 'Priority',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final priority = int.tryParse(value);
                                  if (priority == null) {
                                    return 'Please enter a valid number';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingL),

                      // Video ID and Category ID Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _videoIdController,
                              decoration: const InputDecoration(
                                labelText: 'Video ID',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingL),
                          Expanded(
                            child: TextFormField(
                              controller: _categoryIdController,
                              decoration: const InputDecoration(
                                labelText: 'Category ID',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingL),

                      // Image URLs Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _imageUrlController,
                              decoration: const InputDecoration(
                                labelText: 'Image URL',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingL),
                          Expanded(
                            child: TextFormField(
                              controller: _thumbnailUrlController,
                              decoration: const InputDecoration(
                                labelText: 'Thumbnail URL',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingL),

                      // Content URL
                      TextFormField(
                        controller: _contentUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Content URL',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingL),

                      // Status Checkboxes
                      Row(
                        children: [
                          Checkbox(
                            value: _isActive,
                            onChanged: (value) {
                              setState(() {
                                _isActive = value ?? true;
                              });
                            },
                            activeColor: AppTheme.primaryPurple,
                          ),
                          const Text('Active'),
                          const SizedBox(width: AppTheme.spacingXL),
                          Checkbox(
                            value: _isFeatured,
                            onChanged: (value) {
                              setState(() {
                                _isFeatured = value ?? false;
                              });
                            },
                            activeColor: AppTheme.primaryPurple,
                          ),
                          const Text('Featured'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Actions
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: AppTheme.spacingM),
                ElevatedButton(
                  onPressed: _saveContent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(widget.content == null ? 'Create' : 'Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveContent() {
    if (_formKey.currentState!.validate()) {
      final content = AdminContent(
        id: widget.content?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        videoId: _videoIdController.text.trim().isNotEmpty ? _videoIdController.text.trim() : null,
        categoryId: _categoryIdController.text.trim().isNotEmpty ? _categoryIdController.text.trim() : null,
        imageUrl: _imageUrlController.text.trim().isNotEmpty ? _imageUrlController.text.trim() : null,
        thumbnailUrl: _thumbnailUrlController.text.trim().isNotEmpty ? _thumbnailUrlController.text.trim() : null,
        contentUrl: _contentUrlController.text.trim().isNotEmpty ? _contentUrlController.text.trim() : null,
        isActive: _isActive,
        isFeatured: _isFeatured,
        priority: int.tryParse(_priorityController.text) ?? 0,
        createdAt: widget.content?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: widget.content?.createdBy ?? 'admin',
        updatedBy: 'admin',
        metadata: widget.content?.metadata,
      );

      widget.onSave(content);
      Navigator.of(context).pop();
    }
  }
}
