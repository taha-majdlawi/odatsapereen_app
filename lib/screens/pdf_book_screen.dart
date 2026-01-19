import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfBookScreen extends StatefulWidget {
  final String title;
  final String assetPath; // مثال: assets/book/book.pdf
  final String bookId; // مفتاح فريد للحفظ (مثال: "odatsapereen_pdf")

  const PdfBookScreen({
    super.key,
    required this.title,
    required this.assetPath,
    required this.bookId,
  });

  @override
  State<PdfBookScreen> createState() => _PdfBookScreenState();
}

class _PdfBookScreenState extends State<PdfBookScreen> {
  final PdfViewerController _pdfController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfKey = GlobalKey();

  late PdfTextSearchResult _searchResult;

  int _pageNumber = 1;
  int _pageCount = 0;

  bool _readingMode = true;

  String get _prefsKey => 'pdf_last_page_${widget.bookId}';

  @override
  void initState() {
    super.initState();
    _searchResult = PdfTextSearchResult();
    _restoreLastPage();
  }

  Future<void> _restoreLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPage = prefs.getInt(_prefsKey) ?? 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pdfController.jumpToPage(lastPage);
    });
  }

  Future<void> _saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, page);
  }

  void _openGoToPageDialog() {
    final controller = TextEditingController(text: _pageNumber.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'الانتقال إلى صفحة',
            textDirection: TextDirection.rtl,
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              hintText: 'اكتب رقم الصفحة',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', textDirection: TextDirection.rtl),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(controller.text.trim());
                if (value == null) return;

                final target = value.clamp(
                  1,
                  _pageCount == 0 ? 999999 : _pageCount,
                );
                _pdfController.jumpToPage(target);
                Navigator.pop(context);
              },
              child: const Text('اذهب', textDirection: TextDirection.rtl),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgColor = theme.brightness == Brightness.dark
        ? const Color(0xFF121212)
        : const Color(0xFFF6F1E8); // أبيض سكري

    final cardColor = theme.cardColor;
    final onBg = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'اذهب لصفحة',
            icon: const Icon(Icons.pin_drop_outlined),
            onPressed: _openGoToPageDialog,
          ),
          IconButton(
            tooltip: 'وضع القراءة',
            icon: Icon(
              _readingMode ? Icons.chrome_reader_mode : Icons.grid_view,
            ),
            onPressed: () => setState(() => _readingMode = !_readingMode),
          ),

          if (_searchResult.totalInstanceCount > 0) ...[
            IconButton(
              tooltip: 'النتيجة السابقة',
              icon: const Icon(Icons.keyboard_arrow_up),
              onPressed: () {
                _searchResult.previousInstance();
                setState(() {});
              },
            ),
            IconButton(
              tooltip: 'النتيجة التالية',
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: () {
                _searchResult.nextInstance();
                setState(() {});
              },
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'الصفحة $_pageNumber من ${_pageCount == 0 ? '-' : _pageCount}',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: onBg, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  tooltip: 'السابق',
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _pageNumber > 1
                      ? () => _pdfController.previousPage()
                      : null,
                ),
                IconButton(
                  tooltip: 'التالي',
                  icon: const Icon(Icons.chevron_right),
                  onPressed: (_pageCount > 0 && _pageNumber < _pageCount)
                      ? () => _pdfController.nextPage()
                      : null,
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: bgColor,
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: cardColor,
                  child: SfPdfViewer.asset(
                    widget.assetPath,
                    key: _pdfKey,
                    controller: _pdfController,
                    pageLayoutMode: _readingMode
                        ? PdfPageLayoutMode.single
                        : PdfPageLayoutMode.continuous,
                    canShowScrollHead: true,
                    canShowScrollStatus: true,
                    enableDoubleTapZooming: true,
                    onDocumentLoaded: (details) async {
                      setState(() => _pageCount = details.document.pages.count);

                      final prefs = await SharedPreferences.getInstance();
                      final lastPage = prefs.getInt(_prefsKey) ?? 1;
                      final target = lastPage.clamp(1, _pageCount);
                      _pdfController.jumpToPage(target);
                    },
                    onPageChanged: (details) {
                      setState(() => _pageNumber = details.newPageNumber);
                      _saveLastPage(details.newPageNumber);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
