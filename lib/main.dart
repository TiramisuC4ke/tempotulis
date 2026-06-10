import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3B82F6),
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'TempoTulis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1a1a1a),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1a1a1a),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF2a2a2a),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey[800]!),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF3B82F6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1f1f1f),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[850]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[850]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
          ),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF2a2a2a),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF1f1f1f),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey[900],
          labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey[800]!),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected) ? const Color(0xFF3B82F6) : Colors.grey[400]),
          trackColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? const Color(0xFF3B82F6).withValues(alpha: 0.4)
                  : Colors.grey[800]),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Note> notes = [
    Note(
      title: 'Test',
      content: 'Test',
      date: '10 Juni 2026',
      topic: 'Sismul',
    ),
    Note(
      title: 'Test',
      content: 'Test',
      date: '10 Juni 2026',
      topic: 'Capstone',
    ),
  ];

  final List<String> topics = ['Sismul', 'Capstone', 'Cybersecurity'];
  int _selectedTopicIndex = 0;
  late ValueNotifier<int> _selectedTopicNotifier;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedTopicNotifier = ValueNotifier<int>(_selectedTopicIndex);
    _pages = [
      TimerPage(
        notes: notes,
        onNoteAdded: _addNote,
        topics: topics,
        selectedTopicNotifier: _selectedTopicNotifier,
        onTopicChanged: _changeTopicIndex,
        onTopicAdded: _addTopic,
        onTopicRemoved: _removeTopic,
      ),
      NotesPage(notes: notes, onNoteAdded: _addNote, onNoteUpdated: _updateNote, onNoteRemoved: _removeNote),
      const StatisticsPage(),
      const SettingsPage(),
    ];
  }

  void _updateNote(int index, Note updated) {
    setState(() {
      if (index >= 0 && index < notes.length) {
        notes[index] = updated;
      }
    });
  }

  void _removeNote(int index) {
    setState(() {
      if (index >= 0 && index < notes.length) {
        notes.removeAt(index);
      }
    });
  }

  void _addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  void _addTopic(String topic) {
    setState(() {
      topics.add(topic);
      // topics is a shared list reference; TimerPage reads this list directly.
    });
  }

  void _removeTopic(int index) {
    setState(() {
      if (topics.length > 1) {
        topics.removeAt(index);
        if (_selectedTopicIndex >= topics.length) {
          _selectedTopicIndex = topics.length - 1;
          _selectedTopicNotifier.value = _selectedTopicIndex;
        }
      }
    });
  }

  void _changeTopicIndex(int index) {
    setState(() {
      _selectedTopicIndex = index;
      _selectedTopicNotifier.value = _selectedTopicIndex;
    });
  }

  @override
  void dispose() {
    _selectedTopicNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF202020),
          border: Border(top: BorderSide(color: Colors.grey[850]!)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.timer_outlined, Icons.timer, 'Timer'),
                _buildNavItem(1, Icons.note_outlined, Icons.note, 'Catatan'),
                _buildNavItem(2, Icons.bar_chart_outlined, Icons.bar_chart, 'Statistik'),
                _buildNavItem(3, Icons.settings_outlined, Icons.settings, 'Pengaturan'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3B82F6).withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? filledIcon : outlineIcon,
                color: isSelected ? const Color(0xFF3B82F6) : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF3B82F6) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Timer Page
class TimerPage extends StatefulWidget {
  final List<Note> notes;
  final Function(Note) onNoteAdded;
  final List<String> topics;
  final ValueNotifier<int> selectedTopicNotifier;
  final Function(int) onTopicChanged;
  final Function(String) onTopicAdded;
  final Function(int) onTopicRemoved;

  const TimerPage({
    super.key,
    required this.notes,
    required this.onNoteAdded,
    required this.topics,
    required this.selectedTopicNotifier,
    required this.onTopicChanged,
    required this.onTopicAdded,
    required this.onTopicRemoved,
  });

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  int _timerMinutes = 25;
  int _timerSeconds = 0;
  late int _remainingSeconds;
  bool _isRunning = false;
  final int _sessionsToday = 3;
  final int _totalMinutesToday = 82;
  late VoidCallback _topicListener;

  int get _durationSeconds => _timerMinutes * 60 + _timerSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = _durationSeconds;
    _topicListener = () {
      if (mounted) setState(() {});
    };
    widget.selectedTopicNotifier.addListener(_topicListener);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _showStopDialog();
      }
    });
  }

  void _toggleTimer() {
    setState(() {
      if (_isRunning) {
        _isRunning = false;
        _timer?.cancel();
      } else {
        if (_remainingSeconds == 0) {
          _remainingSeconds = _durationSeconds;
        }
        _isRunning = true;
        _startTimer();
      }
    });
  }

  void _resetTimer() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    setState(() {
      _remainingSeconds = _durationSeconds;
      _isRunning = false;
    });
  }

  void _showStopDialog() {
    if (!mounted) return;
    setState(() {
      _isRunning = false;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildFinishDialog(),
    );
  }

  Widget _buildFinishDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String selectedTopic = widget.topics.isNotEmpty
      ? widget.topics[widget.selectedTopicNotifier.value]
      : 'Umum';

    return StatefulBuilder(
      builder: (context, setState) => Dialog(
        backgroundColor: const Color(0xFF2a2a2a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF3B82F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Sesi Pembelajaran Selesai!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Catat apa yang telah kamu pelajari',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Topik',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[700]!),
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF1a1a1a),
                  ),
                  child: DropdownButton<String>(
                    value: selectedTopic,
                    isExpanded: true,
                    underline: const SizedBox(),
                    dropdownColor: const Color(0xFF2a2a2a),
                    style: const TextStyle(color: Colors.white),
                    items: widget.topics
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) {
                      setState(() => selectedTopic = v ?? selectedTopic);
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Judul Catatan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    hintText: 'Masukkan judul catatan',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1a1a1a),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Isi Catatan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: contentCtrl,
                  decoration: InputDecoration(
                    hintText:
                        'Tuliskan poin-poin penting yang telah kamu pelajari...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1a1a1a),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Lewati',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (titleCtrl.text.isNotEmpty &&
                              contentCtrl.text.isNotEmpty) {
                            widget.onNoteAdded(
                              Note(
                                title: titleCtrl.text,
                                content: contentCtrl.text,
                                date: _getCurrentDate(),
                                topic: selectedTopic,
                              ),
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Catatan berhasil disimpan!'),
                                backgroundColor: Color(0xFF3B82F6),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Harap isi judul dan isi catatan'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildDurationChip(int minutes, StateSetter sheetSetState) {
    final isSelected = _timerMinutes == minutes && _timerSeconds == 0;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        setState(() {
          _timerMinutes = minutes;
          _timerSeconds = 0;
          _remainingSeconds = _durationSeconds;
        });
        sheetSetState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF1a1a1a),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[800]!),
        ),
        child: Text(
          '$minutes m',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey[300],
          ),
        ),
      ),
    );
  }

  void _showDurationPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, sheetSetState) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Atur Durasi Timer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final preset in const [5, 15, 25, 30, 45, 60])
                      _buildDurationChip(preset, sheetSetState),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a1a),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Durasi kustom',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_timerMinutes > 0) {
                                setState(() {
                                  _timerMinutes--;
                                  _remainingSeconds = _durationSeconds;
                                });
                                sheetSetState(() {});
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF3B82F6)),
                          ),
                          SizedBox(
                            width: 48,
                            child: Text(
                              '${_timerMinutes}m',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _timerMinutes++;
                                _remainingSeconds = _durationSeconds;
                              });
                              sheetSetState(() {});
                            },
                            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF3B82F6)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Selesai'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({required IconData icon, required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF3B82F6), size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showAddTopicDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF2a2a2a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tambah Topik Baru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Nama topik',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1a1a1a),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                    ),
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        widget.onTopicAdded(controller.text);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Topik "${controller.text}" ditambahkan!',
                            ),
                            backgroundColor: const Color(0xFF3B82F6),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: const Text('Tambah'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTopicMenu(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2a2a2a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.topics[index],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
              title: const Text('Pilih Topik Ini'),
              onTap: () {
                widget.onTopicChanged(index);
                Navigator.pop(context);
              },
            ),
            if (widget.topics.length > 1)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Hapus Topik',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onTopicRemoved(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Topik "${widget.topics[index]}" dihapus'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.selectedTopicNotifier.removeListener(_topicListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Tempo',
                            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          TextSpan(
                            text: 'Tulis',
                            style: TextStyle(color: Color(0xFF3B82F6)),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tetap fokus dan produktif',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🔥', style: TextStyle(fontSize: 14)),
                      SizedBox(width: 4),
                      Text(
                        '5 hari',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Active Topic - Large Display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF3B82F6),
                    const Color(0xFF3B82F6).withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SEDANG BELAJAR',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.topics[widget.selectedTopicNotifier.value],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Other Topics
            if (widget.topics.length > 1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Topik Lainnya',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...List.generate(widget.topics.length, (index) {
                        if (index == widget.selectedTopicNotifier.value) {
                          return const SizedBox.shrink();
                        }
                        return GestureDetector(
                          onTap: () => widget.onTopicChanged(index),
                          onLongPress: () => _showTopicMenu(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[700]!),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[900],
                            ),
                            child: Text(
                              widget.topics[index],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        );
                      }),
                      GestureDetector(
                        onTap: _showAddTopicDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, size: 16, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Tambah',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            else
              GestureDetector(
                onTap: _showAddTopicDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Tambah Topik',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 240,
                          height: 240,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 240,
                          height: 240,
                          child: CircularProgressIndicator(
                            value: _durationSeconds > 0
                                ? _remainingSeconds / _durationSeconds
                                : 0,
                            strokeWidth: 12,
                            strokeCap: StrokeCap.round,
                            backgroundColor: Colors.grey[900],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatTime(_remainingSeconds),
                              style: TextStyle(
                                fontSize: _remainingSeconds >= 3600 ? 40 : 54,
                                fontWeight: FontWeight.w800,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _isRunning ? 'Sedang berjalan' : (_remainingSeconds == 0 ? 'Selesai' : 'Berhenti'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                          ),
                          onPressed: _isRunning ? null : _showDurationPicker,
                          child: Icon(
                            Icons.tune_rounded,
                            size: 22,
                            color: _isRunning ? Colors.grey[600] : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                            elevation: 6,
                            shadowColor: const Color(0xFF3B82F6).withValues(alpha: 0.5),
                          ),
                          onPressed: _toggleTimer,
                          child: Icon(_isRunning ? Icons.pause : Icons.play_arrow, size: 32),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                          ),
                          onPressed: _resetTimer,
                          child: const Icon(Icons.refresh, size: 24, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.local_fire_department_rounded,
                    value: '$_sessionsToday',
                    label: 'Sesi hari ini',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.access_time_filled_rounded,
                    value: '${_totalMinutesToday ~/ 60}j ${_totalMinutesToday % 60}m',
                    label: 'Total belajar',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Notes Page
class NotesPage extends StatefulWidget {
  final List<Note> notes;
  final Function(Note) onNoteAdded;
  final Function(int, Note) onNoteUpdated;
  final Function(int) onNoteRemoved;

  const NotesPage({
    super.key,
    required this.notes,
    required this.onNoteAdded,
    required this.onNoteUpdated,
    required this.onNoteRemoved,
  });

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
    final filteredNotes = widget.notes.where((note) {
      final query = _searchQuery.toLowerCase();
      return query.isEmpty ||
          note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query) ||
          note.topic.toLowerCase().contains(query);
    }).toList();

    final noNotes = widget.notes.isEmpty;
    final noResults = widget.notes.isNotEmpty && filteredNotes.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3B82F6),
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daftar Catatan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.notes.length} catatan tersimpan',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: _showAddNoteDialog,
                  icon: const Icon(Icons.add, color: Color(0xFF3B82F6)),
                  label: const Text(
                    'Tambah Catatan',
                    style: TextStyle(color: Color(0xFF3B82F6)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey[800]!),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  icon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Cari judul, isi, atau topik...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: noNotes
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.note_alt_outlined, size: 72, color: Colors.grey[600]),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada catatan',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _showAddNoteDialog,
                            child: const Text('Buat catatan pertama'),
                          ),
                        ],
                      ),
                    )
                  : noResults
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search_off, size: 72, color: Colors.grey[600]),
                              const SizedBox(height: 16),
                              const Text(
                                'Tidak ada catatan yang cocok',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Silakan ubah kata kunci pencarian atau hapus filter.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                },
                                child: const Text('Bersihkan pencarian'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                      itemCount: filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = filteredNotes[index];
                        final originalIndex = widget.notes.indexOf(note);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(18),
                            onTap: () => _showNoteDetailDialog(context, note, originalIndex),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2a2a2a),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.grey[800]!),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Color(0x40000000),
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          note.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF3B82F6),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          note.topic,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    note.content,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[300],
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        note.date,
                                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                      ),
                                      const Icon(Icons.chevron_right, color: Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNoteDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final topicCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF2a2a2a),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah Catatan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  hintText: 'Judul catatan',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: const Color(0xFF1a1a1a),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Isi catatan',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: const Color(0xFF1a1a1a),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: topicCtrl,
                decoration: InputDecoration(
                  hintText: 'Topik (opsional)',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: const Color(0xFF1a1a1a),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                        widget.onNoteAdded(
                          Note(
                            title: titleCtrl.text,
                            content: contentCtrl.text,
                            date: _getCurrentDate(),
                            topic: topicCtrl.text.isNotEmpty ? topicCtrl.text : 'Umum',
                          ),
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Catatan ditambahkan'),
                          backgroundColor: Color(0xFF3B82F6),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  void _showNoteDetailDialog(BuildContext context, Note note, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF171717),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditNoteDialog(context, note, index);
                    },
                    icon: const Icon(Icons.edit, color: Color(0xFF3B82F6)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    note.topic,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                note.content,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    note.date,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          title: const Text('Hapus catatan'),
                          content: const Text('Yakin ingin menghapus catatan ini?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(c), child: const Text('Batal')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () {
                                Navigator.pop(c);
                                widget.onNoteRemoved(index);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Catatan dihapus'),
                                  backgroundColor: Colors.red,
                                ));
                              },
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showEditNoteDialog(BuildContext context, Note note, int index) {
    final titleCtrl = TextEditingController(text: note.title);
    final contentCtrl = TextEditingController(text: note.content);
    final topicCtrl = TextEditingController(text: note.topic);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF171717),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Edit Catatan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  hintText: 'Judul',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1a1a1a),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Isi',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1a1a1a),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: topicCtrl,
                decoration: InputDecoration(
                  hintText: 'Topik',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color(0xFF1a1a1a),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                        final updated = Note(
                          title: titleCtrl.text,
                          content: contentCtrl.text,
                          date: note.date,
                          topic: topicCtrl.text.isNotEmpty ? topicCtrl.text : note.topic,
                        );
                        widget.onNoteUpdated(index, updated);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Catatan diperbarui'),
                          backgroundColor: Color(0xFF3B82F6),
                        ));
                      }
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class Note {
  final String title;
  final String content;
  final String date;
  final String topic;

  Note({
    required this.title,
    required this.content,
    required this.date,
    required this.topic,
  });
}

// Statistics Page
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  static const _weekData = [
    {'day': 'Senin', 'label': 'S', 'minutes': 150},
    {'day': 'Selasa', 'label': 'S', 'minutes': 105},
    {'day': 'Rabu', 'label': 'R', 'minutes': 190},
    {'day': 'Kamis', 'label': 'K', 'minutes': 140},
    {'day': 'Jumat', 'label': 'J', 'minutes': 110},
    {'day': 'Sabtu', 'label': 'S', 'minutes': 165},
    {'day': 'Minggu', 'label': 'M', 'minutes': 0},
  ];

  @override
  Widget build(BuildContext context) {
    final maxMinutes = _weekData.map((d) => d['minutes'] as int).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistik Mingguan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Waktu belajar per hari minggu ini',
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _weekData.map((d) {
                    final minutes = d['minutes'] as int;
                    final isToday = d['day'] == 'Selasa';
                    final heightFactor = maxMinutes > 0 ? minutes / maxMinutes : 0.0;
                    return _buildBar(
                      label: d['label'] as String,
                      heightFactor: heightFactor,
                      minutes: minutes,
                      highlighted: isToday,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ringkasan Belajar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.access_time_filled_rounded,
                    label: 'Total Waktu',
                    value: '18h 20m',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.local_fire_department_rounded,
                    label: 'Total Sesi',
                    value: '45',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.timelapse_rounded,
                    label: 'Rata-rata Sesi',
                    value: '24 menit',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.calendar_today_rounded,
                    label: 'Hari Aktif',
                    value: '6 hari',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar({
    required String label,
    required double heightFactor,
    required int minutes,
    required bool highlighted,
  }) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    final timeLabel = minutes == 0 ? '-' : (hours > 0 ? '${hours}h${mins > 0 ? ' ${mins}m' : ''}' : '${mins}m');

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          timeLabel,
          style: TextStyle(
            fontSize: 10,
            color: highlighted ? const Color(0xFF3B82F6) : Colors.grey[500],
            fontWeight: highlighted ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 22,
          height: 100 * heightFactor.clamp(0.04, 1.0),
          decoration: BoxDecoration(
            color: highlighted ? const Color(0xFF3B82F6) : const Color(0xFF3B82F6).withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: highlighted ? FontWeight.bold : FontWeight.normal,
            color: highlighted ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({required IconData icon, required String label, required String value}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _timerNotif = true;
  bool _noteNotif = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF2a2a2a),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengguna TempoTulis',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tetap konsisten setiap hari',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Notifikasi',
            [
              _buildSwitchTile(
                'Notifikasi Timer Selesai',
                'Dapatkan pengingat saat sesi selesai',
                Icons.notifications_active_outlined,
                _timerNotif,
                (v) => setState(() => _timerNotif = v),
              ),
              _buildSwitchTile(
                'Notifikasi Catatan',
                'Pengingat untuk menulis catatan',
                Icons.note_outlined,
                _noteNotif,
                (v) => setState(() => _noteNotif = v),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Tampilan',
            [
              _buildSwitchTile(
                'Mode Gelap',
                'Gunakan tema gelap di seluruh aplikasi',
                Icons.brightness_4_outlined,
                _darkMode,
                (v) => setState(() => _darkMode = v),
              ),
              _buildTile('Ukuran Font', 'Normal', Icons.text_fields),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Akun',
            [
              _buildTile('Profil', 'Lihat profil', Icons.person_outline),
              _buildTile('Sinkronisasi', 'Sinkronkan sekarang', Icons.sync),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.15),
                foregroundColor: Colors.red,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3B82F6),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Material(
              color: const Color(0xFF2a2a2a),
              child: Column(
                children: [
                  for (var i = 0; i < tiles.length; i++) ...[
                    tiles[i],
                    if (i != tiles.length - 1)
                      Divider(height: 1, indent: 56, color: Colors.grey[850]),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTile(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF3B82F6)),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: const Color(0xFF3B82F6)),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      value: value,
      onChanged: onChanged,
    );
  }
}
