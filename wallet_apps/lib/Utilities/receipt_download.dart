import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DownloadReceipt {
  static Future<void> generatePdf({
    required String merchantName,
    required String amount,
    required String refID,
    required String date,
  }) async {
    try {
      final pdf = pw.Document();

      // 1. CRITICAL: Load fonts BEFORE building the page
      // Using Font.ttf(data) is safer for Web than dynamic loading inside the build
      final font = await PdfGoogleFonts.robotoRegular();
      final boldFont = await PdfGoogleFonts.robotoBold();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(35),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("PAYMENT RECEIPT", 
                      style: pw.TextStyle(font: boldFont, fontSize: 24)),
                  pw.SizedBox(height: 10),
                  pw.Divider(color: PdfColors.grey300),
                  pw.SizedBox(height: 30),

                  _row("Recipient", merchantName, font, boldFont),
                  _row("Reference ID", refID, font, boldFont),
                  _row("Date/Time", date, font, boldFont),
                  _row("Amount", "RM $amount", font, boldFont),
                  _row("Status", "SUCCESSFUL", font, boldFont),

                  pw.Spacer(),
                  pw.Center(
                    child: pw.Text("Generated via WalletApp", 
                        style: pw.TextStyle(font: font, color: PdfColors.grey500, fontSize: 10)),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // 2. Await the save and use the bytes
      final Uint8List bytes = await pdf.save();

      // 3. Open the layout (This opens the print tab in Chrome)
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => bytes,
        name: 'Receipt_$refID.pdf',
      );
      
    } catch (e) {
      print("PDF Error: $e");
    }
  }

  static pw.Widget _row(String label, String value, pw.Font font, pw.Font bold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(font: font, fontSize: 13, color: PdfColors.grey700)),
          pw.Text(value, style: pw.TextStyle(font: bold, fontSize: 13)),
        ],
      ),
    );
  }
}