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

// ============================================================================
// 1. ANA AÇILIŞ VE SUNUCU SEÇİM EKRANI
// ============================================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // DostYeri Bağlantı Penceresi
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
                if (nick.isEmpty) nick = "Misafir_${DateTime.now().millisecond}";
                Navigator.of(context).pop();
                
                // Chat Ekranına Geçiş
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(serverName: 'irc.dostyeri.org', nick: nick),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Diğer Sunucu Ekleme Penceresi
  void _showAddCustomServerDialog(BuildContext context) {
    final TextEditingController serverNameController = TextEditingController();
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
                  controller: serverNameController,
                  decoration: const InputDecoration(labelText: 'Sunucu İsmi', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
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
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(serverName: serverHostController.text, nick: nick),
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
      appBar: AppBar(
        title: const Text('DostYeri'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
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
            const Text('Biliyor muydunuz?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text(
              'DostYeri uygulaması ile kesintisiz sohbet edebilir, üst kısımdaki canlı radyo ile sohbetinizi müzikle taçlandırabilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Bağlantı Seçenekleri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
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

// ============================================================================
// 2. SOHBET VE CANLI RADYO EKRANI (CHAT UI)
// ============================================================================
class ChatScreen extends StatefulWidget {
  final String serverName;
  final String nick;

  const ChatScreen({super.key, required this.serverName, required this.nick});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _messageController = TextEditingController();

  // Audio Player
  late AudioPlayer _audioPlayer;
  bool _isRadioPlaying = false;
  bool _isRadioLoading = false;
  double _radioVolume = 0.8;
  final String _radioStreamUrl = "https://yayin.dostyeri.org:8000/stream";

  // Tab Tamamlama Değişkenleri
  String _searchPrefix = '';
  int _matchingIndex = -1;
  List<String> _matchingNicks = [];

  List<String> channels = ['Status', '#Sohbet', '#Radyo', '#Kelime', '#OperHELP'];

  final List<Map<String, String>> userList = [
    {'nick': '~Ela', 'role': 'owner'},
    {'nick': '&G-Bot', 'role': 'admin'},
    {'nick': '@aDa', 'role': 'op'},
    {'nick': '%Seth', 'role': 'hop'},
    {'nick': '+Serdengecti', 'role': 'voice'},
    {'nick': '+alperen', 'role': 'voice'},
    {'nick': 'Seda', 'role': 'user'},
    {'nick': 'RuYa', 'role': 'user'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: channels.length, vsync: this);
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Radyo Başlat/Durdur
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

  // Büyüteç / Tab Tamamlama Mantığı
  void _handleTabCompletion() {
    String currentText = _messageController.text;
    if (currentText.isEmpty) return;

    if (_matchingNicks.isEmpty) {
      List<String> words = currentText.trim().split(' ');
      _searchPrefix = words.last.toLowerCase();

      _matchingNicks = userList.map((u) => u['nick']!).where((nick) {
        String cleanNick = nick.replaceAll(RegExp(r'^[~&@%+]'), '');
        return cleanNick.toLowerCase().startsWith(_searchPrefix);
      }).toList();

      _matchingNicks.sort((a, b) => a.compareTo(b));
      _matchingIndex = 0;
    } else {
      _matchingIndex = (_matchingIndex + 1) % _matchingNicks.length;
    }

    if (_matchingNicks.isNotEmpty) {
      String selectedNick = _matchingNicks[_matchingIndex].replaceAll(RegExp(r'^[~&@%+]'), '');
      List<String> words = currentText.trim().split(' ');
      words.removeLast();

      String newText = words.isEmpty ? '$selectedNick: ' : '${words.join(' ')} $selectedNick ';
      _messageController.text = newText;
      _messageController.selection = TextSelection.fromPosition(TextPosition(offset: _messageController.text.length));
    }
  }

  // Sekmeye Uzun Basarak Çıkma
  void _showCloseChannelDialog(String channelName, int index) {
    if (channelName == 'Status') return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$channelName Kanalından Çık'),
        content: Text('$channelName sekmesini kapatmak istiyor musunuz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                channels.removeAt(index);
                _tabController = TabController(length: channels.length, vsync: this);
              });
            },
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  // Nick Action Menu
  void _showUserActionMenu(String targetNick) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Kullanıcı: $targetNick', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
              const Divider(),
              ListTile(leading: const Icon(Icons.chat), title: const Text('Özel Mesaj (Query)'), onTap: () => Navigator.pop(context)),
              ListTile(leading: const Icon(Icons.info), title: const Text('Whois Bilgisi'), onTap: () => Navigator.pop(context)),
              Row(
                children: [
                  Expanded(child: TextButton.icon(icon: const Icon(Icons.add, color: Colors.green), label: const Text('+v Voice'), onPressed: () => Navigator.pop(context))),
                  Expanded(child: TextButton.icon(icon: const Icon(Icons.star, color: Colors.amber), label: const Text('+o Op'), onPressed: () => Navigator.pop(context))),
                  Expanded(child: TextButton.icon(icon: const Icon(Icons.shield, color: Colors.purple), label: const Text('+a Sop'), onPressed: () => Navigator.pop(context))),
                ],
              ),
              Row(
                children: [
                  Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), onPressed: () => Navigator.pop(context), child: const Text('Kick'))),
                  const SizedBox(width: 8),
                  Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(context), child: const Text('Kick + Ban'))),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('DostYeri.Org', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Nick: ${widget.nick} | ${widget.serverName}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.arrow_drop_down_circle_outlined), onPressed: () => _scaffoldKey.currentState?.openEndDrawer()),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'settings') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('Ayarlar')),
              const PopupMenuItem(value: 'quit', child: Text('Bağlantıyı Kes', style: TextStyle(color: Colors.red))),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: channels.map((ch) {
            int idx = channels.indexOf(ch);
            return GestureDetector(
              onLongPress: () => _showCloseChannelDialog(ch, idx),
              child: Tab(text: ch),
            );
          }).toList(),
        ),
      ),

      // SAĞ AÇILIR NİCK LİSTESİ
      endDrawer: Drawer(
        width: 220,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 10, left: 16),
              color: const Color(0xFF006689),
              width: double.infinity,
              child: Text('Kullanıcılar (${userList.length})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return ListTile(
                    dense: true,
                    title: Text(user['nick']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () {
                      Navigator.pop(context);
                      _showUserActionMenu(user['nick']!);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // CANLI RADYO OYNATICI BAR
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("DostYeri Canlı Radyo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(_isRadioPlaying ? "Yayında" : "Radyoyu Başlat", style: const TextStyle(color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Slider(
                    value: _radioVolume,
                    activeColor: Colors.white,
                    onChanged: (v) {
                      setState(() {
                        _radioVolume = v;
                        _audioPlayer.setVolume(_radioVolume);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // SOHBET AKIŞI
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: channels.map((ch) {
                return ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    Text('[09:30] ** $ch kanalına katıldınız.', style: const TextStyle(color: Colors.grey)),
                    const Text('[09:31] (<~Ela>) Selam hoş geldiniz!', style: const TextStyle(color: Colors.purple)),
                    const Text('[09:33] (%Seth) Hoş bulduk, canlı radyo harika çalıyor.', style: const TextStyle(color: Colors.blue)),
                  ],
                );
              }).toList(),
            ),
          ),

          // ALT MESAJ GİRİŞ KUTUSU VE BÜYÜTEÇ (TAB)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF006689)),
                  tooltip: 'Nick Tamamla (Tab)',
                  onPressed: _handleTabCompletion,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Bir mesaj yazın...', border: InputBorder.none),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF006689)),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _messageController.clear();
                      setState(() => _matchingNicks = []);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 3. AYARLAR VE OPER/ADMIN GİRİŞ SAYFASI
// ============================================================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoOper = false;

  void _showOperSettingsDialog(BuildContext context) {
    final TextEditingController userCtrl = TextEditingController();
    final TextEditingController passCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oper / Admin Girişi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: userCtrl, decoration: const InputDecoration(labelText: 'Oper Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Oper Şifresi', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006689), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Oper bilgileri kaydedildi.')));
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar'), backgroundColor: const Color(0xFF006689)),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Yönetici / Operatör Ayarları', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006689))),
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: Colors.redAccent),
            title: const Text('Oper / Admin Girişi'),
            subtitle: const Text('/OPER kullanıcı adı ve şifresini tanımlayın'),
            onTap: () => _showOperSettingsDialog(context),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.autorenew, color: Colors.orange),
            title: const Text('Otomatik Oper Ol'),
            subtitle: const Text('Bağlantı kurulduğunda otomatik /OPER gönder'),
            value: _autoOper,
            onChanged: (val) => setState(() => _autoOper = val),
          ),
        ],
      ),
    );
  }
}
