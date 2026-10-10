import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const DostYeriApp());
}

class DostYeriApp extends StatelessWidget {
  const DostYeriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DostYeri.Org IRC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF006689),
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showDostyeriConnectDialog(BuildContext context) {
    final TextEditingController nickController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(
            children: [
              Icon(Icons.chat, color: Color(0xFF006689)),
              SizedBox(width: 10),
              Text('DostYeri Sohbet'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Sohbete katılmak için rumuzunuzu giriniz.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 16),
                TextField(
                  controller: nickController,
                  decoration: const InputDecoration(
                    labelText: 'Rumuz (Nick)',
                    hintText: 'Örn: Dost_34',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Nick Şifresi (İsteğe Bağlı)',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006689),
                foregroundColor: Colors.white,
              ),
              child: const Text('Sohbete Bağlan'),
              onPressed: () {
                String nick = nickController.text.trim();
                if (nick.isEmpty) nick = "Dost_${DateTime.now().millisecond % 1000}";
                Navigator.of(context).pop();
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      serverName: 'irc.dostyeri.org',
                      port: 6667,
                      nick: nick,
                      password: passwordController.text.trim(),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddCustomServerDialog(BuildContext context) {
    final TextEditingController serverHostController = TextEditingController();
    final TextEditingController portController = TextEditingController(text: '6667');
    final TextEditingController nickController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Row(
            children: [
              Icon(Icons.dns, color: Color(0xFF006689)),
              SizedBox(width: 10),
              Text('Yeni Sunucu Ekle'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: serverHostController,
                  decoration: const InputDecoration(labelText: 'Sunucu Adresi (Host)', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: portController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Port', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nickController,
                  decoration: const InputDecoration(labelText: 'Varsayılan Rumuz', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('İptal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006689), foregroundColor: Colors.white),
              onPressed: () {
                String nick = nickController.text.trim();
                if (nick.isEmpty) nick = "Guest";
                int port = int.tryParse(portController.text.trim()) ?? 6667;
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      serverName: serverHostController.text.trim(),
                      port: port,
                      nick: nick,
                      password: '',
                    ),
                  ),
                );
              },
              child: const Text('Bağlan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DostYeri')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          children: [
            const Icon(Icons.forum_rounded, size: 80, color: Color(0xFF006689)),
            const SizedBox(height: 12),
            const Text('DostYeri', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('Mobil v1.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            const Text('www.dostyeri.org', style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.w500)),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.flash_on, color: Colors.green),
                title: const Text('DostYeri Sunucusuna Bağlan', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('irc.dostyeri.org'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showDostyeriConnectDialog(context),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              child: ListTile(
                leading: const Icon(Icons.add_to_photos, color: Colors.orange),
                title: const Text('Diğer Sunucu...'),
                subtitle: const Text('Yeni bir IRC adresi ve port ekleyin'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showAddCustomServerDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String serverName;
  final int port;
  final String nick;
  final String password;

  const ChatScreen({
    super.key,
    required this.serverName,
    this.port = 6667,
    required this.nick,
    required this.password,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();

  Socket? _socket;
  bool _isConnected = false;
  final Map<String, List<String>> _logs = {'Status': []};
  List<String> channels = ['Status'];

  late AudioPlayer _audioPlayer;
  bool _isRadioPlaying = false;
  bool _isRadioLoading = false;
  double _radioVolume = 0.8;
  final String _radioStreamUrl = "https://yayin.dostyeri.org:8000/stream";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: channels.length, vsync: this);
    _audioPlayer = AudioPlayer();
    _connectToIRC();
  }

  Future<void> _connectToIRC() async {
    _addLog('Status', '*** ${widget.serverName}:${widget.port} sunucusuna bağlanılıyor...');

    try {
      _socket = await Socket.connect(
        widget.serverName,
        widget.port,
        timeout: const Duration(seconds: 15),
      );

      setState(() => _isConnected = true);
      _addLog('Status', '*** Sunucuya fiziki bağlantı kuruldu. Kimlik gönderiliyor...');

      if (widget.password.isNotEmpty) {
        _sendRaw('PASS ${widget.password}');
      }

      _sendRaw('NICK ${widget.nick}');
      _sendRaw('USER ${widget.nick} 0 * :DostYeri Mobil User');

      _socket!.transform(utf8.decoder).transform(const LineSplitter()).listen(
        (String rawLine) {
          _handleIrcLine(rawLine);
        },
        onError: (err) {
          _addLog('Status', '*** Bağlantı Hatası: $err');
          setState(() => _isConnected = false);
        },
        onDone: () {
          _addLog('Status', '*** Sunucu ile bağlantı kesildi.');
          setState(() => _isConnected = false);
        },
      );
    } catch (e) {
      _addLog('Status', '*** Bağlantı Kurulamadı: $e');
      setState(() => _isConnected = false);
    }
  }

  void _handleIrcLine(String line) {
    if (line.isEmpty) return;

    if (line.startsWith('PING')) {
      String pingArg = line.substring(5);
      _sendRaw('PONG $pingArg');
      return;
    }

    if (line.contains(' 001 ') || line.contains(' 376 ')) {
      _sendRaw('JOIN #Sohbet');
    }

    if (line.contains(' JOIN ')) {
      List<String> parts = line.split(' ');
      if (parts.length >= 3) {
        String chan = parts[2].replaceFirst(':', '').trim();
        if (!channels.contains(chan)) {
          setState(() {
            channels.add(chan);
            _logs[chan] = [];
            _tabController = TabController(length: channels.length, vsync: this);
          });
        }
      }
    }

    _addLog('Status', line);
  }

  void _sendRaw(String data) {
    if (_socket != null && _isConnected) {
      _socket!.write('$data\r\n');
    }
  }

  void _sendMessage() {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    String currentTab = channels[_tabController.index];

    if (text.startsWith('/')) {
      _sendRaw(text.substring(1));
    } else if (currentTab != 'Status') {
      _sendRaw('PRIVMSG $currentTab :$text');
      _addLog(currentTab, '<${widget.nick}> $text');
    }

    _messageController.clear();
  }

  void _addLog(String tabName, String text) {
    setState(() {
      _logs.putIfAbsent(tabName, () => []);
      _logs[tabName]!.add(text);
    });
  }

  @override
  void dispose() {
    _socket?.destroy();
    _audioPlayer.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _toggleRadio() async {
    try {
      if (_isRadioPlaying) {
        await _audioPlayer.stop();
        setState(() => _isRadioPlaying = false);
      } else {
        setState(() => _isRadioLoading = true);
        await _audioPlayer.setUrl(_radioStreamUrl);
        await _audioPlayer.setVolume(_radioVolume);
        _audioPlayer.play();
        setState(() {
          _isRadioLoading = false;
          _isRadioPlaying = true;
        });
      }
    } catch (e) {
      setState(() {
        _isRadioLoading = false;
        _isRadioPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DostYeri (${_isConnected ? "Bağlı" : "Bağlantı Yok"})', style: const TextStyle(fontSize: 16)),
            Text('${widget.nick} | ${widget.serverName}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: channels.map((ch) => Tab(text: ch)).toList(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: const Color(0xFF004D66),
            child: Row(
              children: [
                _isRadioLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : IconButton(
                        icon: Icon(_isRadioPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.white, size: 28),
                        onPressed: _toggleRadio,
                      ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text("DostYeri Canlı Radyo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                SizedBox(
                  width: 80,
                  child: Slider(
                    value: _radioVolume,
                    activeColor: Colors.white,
                    onChanged: (v) {
                      setState(() {
                        _radioVolume = v;
                        _audioPlayer.setVolume(v);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: channels.map((ch) {
                List<String> list = _logs[ch] ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: list.length,
                  itemBuilder: (context, idx) => Text(list[idx], style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Mesaj yazın veya /komut girin...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF006689)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
