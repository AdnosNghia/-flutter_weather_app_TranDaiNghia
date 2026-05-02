import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';

// man hinh tim kiem thanh pho
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _searchHistory = [];
  List<String> _favoriteCities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    // tu dong focus vao o tim kiem
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  // tai lich su va thanh pho yeu thich
  Future<void> _loadData() async {
    final provider = context.read<WeatherProvider>();
    final history = await provider.getSearchHistory();
    final favorites = await provider.getFavoriteCities();
    setState(() {
      _searchHistory = history;
      _favoriteCities = favorites;
    });
  }

  // thuc hien tim kiem
  void _search(String city) {
    if (city.trim().isEmpty) return;
    Navigator.pop(context, city.trim());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVi = context.watch<SettingsProvider>().isVietnamese;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isVi ? 'Tìm kiếm thành phố' : 'Search City',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // thanh tim kiem
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: isVi ? 'Nhập tên thành phố...' : 'Enter city name...',
                hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withAlpha(20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              onChanged: (_) => setState(() {}),
            ),
          ),

          // noi dung
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // thanh pho yeu thich
                  if (_favoriteCities.isNotEmpty) ...[
                    _buildSectionTitle(
                      isVi ? 'Thành phố yêu thích' : 'Favorite Cities',
                      Icons.favorite_rounded,
                    ),
                    ..._favoriteCities.map((city) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      title: Text(city, style: const TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.redAccent, size: 20),
                        onPressed: () async {
                          await context.read<WeatherProvider>().removeFavoriteCity(city);
                          _loadData();
                        },
                      ),
                      onTap: () => _search(city),
                    )),
                    const SizedBox(height: 16),
                  ],

                  // lich su tim kiem
                  if (_searchHistory.isNotEmpty) ...[
                    _buildSectionTitle(
                      isVi ? 'Tìm kiếm gần đây' : 'Recent Searches',
                      Icons.history_rounded,
                    ),
                    ..._searchHistory.map((city) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      title: Text(city, style: const TextStyle(color: Colors.white)),
                      trailing: IconButton(
                        icon: Icon(
                          _favoriteCities.contains(city) ? Icons.favorite : Icons.favorite_border,
                          color: _favoriteCities.contains(city) ? Colors.redAccent : Colors.white38,
                          size: 20,
                        ),
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          if (_favoriteCities.contains(city)) {
                            await context.read<WeatherProvider>().removeFavoriteCity(city);
                          } else {
                            final added = await context.read<WeatherProvider>().addFavoriteCity(city);
                            if (!added) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(isVi ? 'Tối đa 5 thành phố yêu thích' : 'Max 5 favorite cities'),
                                ),
                              );
                            }
                          }
                          _loadData();
                        },
                      ),
                      onTap: () => _search(city),
                    )),
                  ],

                  // khong co du lieu
                  if (_favoriteCities.isEmpty && _searchHistory.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          children: [
                            Icon(Icons.search_rounded, size: 64, color: Colors.white.withAlpha(60)),
                            const SizedBox(height: 16),
                            Text(
                              isVi ? 'Tìm kiếm thành phố để xem thời tiết' : 'Search a city to view weather',
                              style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // tieu de phan
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white54),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
