import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/entry.dart';
import '../../data/providers/entry_provider.dart';

class JournalEditPage extends ConsumerStatefulWidget {
  final Entry? entry;
  
  const JournalEditPage({super.key, this.entry});
  
  @override
  ConsumerState<JournalEditPage> createState() => _JournalEditPageState();
}

class _JournalEditPageState extends ConsumerState<JournalEditPage> {
  late final TextEditingController _textController;
  int? _moodScore;
  final List<String> _tags = [];
  
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.entry?.text ?? '');
    _moodScore = widget.entry?.moodScore;
  }
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  Future<void> _saveEntry() async {
    final now = DateTime.now();
    final entry = Entry(
      id: widget.entry?.id ?? 0,
      date: widget.entry?.date ?? now.millisecondsSinceEpoch,
      text: _textController.text.trim(),
      moodScore: _moodScore,
      tags: _tags,
      createdAt: widget.entry?.createdAt ?? now.millisecondsSinceEpoch,
      updatedAt: now.millisecondsSinceEpoch,
    );
    
    final notifier = ref.read(entryNotifierProvider.notifier);
    if (widget.entry == null) {
      await notifier.addEntry(entry);
    } else {
      await notifier.updateEntry(entry);
    }
    
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? '新建记录' : '编辑记录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveEntry,
            tooltip: '保存',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: '今天想记录些什么？',
                border: InputBorder.none,
              ),
              autofocus: widget.entry == null,
            ),
            const SizedBox(height: 24),
            const Text(
              '心情评分',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final score = index + 1;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _moodScore = score;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _moodScore == score
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[300],
                    ),
                    child: Center(
                      child: Text(
                        score.toString(),
                        style: TextStyle(
                          color: _moodScore == score ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

