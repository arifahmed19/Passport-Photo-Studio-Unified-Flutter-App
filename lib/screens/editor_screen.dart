import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../providers/passport_provider.dart';
import '../providers/auth_provider.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PassportProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => provider.applyStandard(),
          ),
        ],
      ),
      body: provider.isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Processing Image...', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            )
          : provider.processedImageBytes == null
              ? const Center(child: Text('No image selected'))
              : Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            _buildPreview(context, provider),
                            const SizedBox(height: 24),
                            _buildMagicEraseTool(context, provider),
                            const SizedBox(height: 24),
                            _buildStandardInfo(context, provider),
                            const SizedBox(height: 48),
                            _buildExportButtons(context, provider, authProvider),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildPreview(BuildContext context, PassportProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.memory(
          provider.processedImageBytes!,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildMagicEraseTool(BuildContext context, PassportProvider provider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_fix_high_rounded, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Auto Background', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('Convert to white background', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
              if (provider.isProcessing)
                const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
              else
                TextButton(
                  onPressed: () async {
                    final error = await provider.removeBackground();
                    if (error != null && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Background removed successfully!')));
                    }
                  },
                  child: const Text('ERASE'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStandardInfo(BuildContext context, PassportProvider provider) {
    final std = provider.selectedStandard!;
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Format', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
                    Text(std.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                const Divider(height: 32, color: Colors.white10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dimensions', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
                    Text('${std.widthMm} x ${std.heightMm} mm', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 15,
                        color: Theme.of(context).primaryColor,
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

  Widget _buildExportButtons(BuildContext context, PassportProvider provider, AuthProvider authProvider) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 120,
          child: Row(
            children: [
              Expanded(
                child: _ActionTile(
                  title: 'Save to Cloud',
                  icon: Icons.cloud_upload_outlined,
                  color: Theme.of(context).primaryColor,
                  onTap: () async {
                    if (provider.processedImageBytes != null) {
                      final url = await authProvider.uploadPhoto(
                        provider.processedImageBytes!,
                        'passport_${DateTime.now().millisecondsSinceEpoch}.jpg',
                      );
                      
                      if (url != null) {
                        await provider.addToHistory(url, provider.selectedStandard!.name);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Successfully uploaded and saved to history!')),
                          );
                        }
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _ActionTile(
                  title: 'Print Preview',
                  icon: Icons.print_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                  onTap: () => _generatePdf(context, provider),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _generatePdf(BuildContext context, PassportProvider provider) async {
    final pdf = pw.Document();
    
    // Load a Unicode-supported font for the PDF
    final font = await PdfGoogleFonts.outfitRegular();
    
    final image = pw.MemoryImage(provider.processedImageBytes!);
    final std = provider.selectedStandard!;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Passport Photo Sheet - ${std.name}', style: const pw.TextStyle(fontSize: 20)),
              pw.SizedBox(height: 10),
              pw.Text('Size: ${std.widthMm}x${std.heightMm}mm'),
              pw.SizedBox(height: 30),
              pw.Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  8,
                  (index) => pw.Container(
                    width: std.widthMm * PdfPageFormat.mm,
                    height: std.heightMm * PdfPageFormat.mm,
                    child: pw.Image(image),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 12),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
