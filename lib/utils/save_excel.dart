import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;
import 'package:permission_handler/permission_handler.dart';

// To save the file in the device
class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory('/storage/emulated/0/Documents/');
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeFile(List<int> bytes, String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file = File('$path/$name');

    print("Save file");

    // Write the data in the file you have created
    return file.writeAsBytes(bytes, flush: true);
  }

  static Future<void> generateExcel(
      List<OrderResponse> orders, List<DateTime> interval, double total) async {
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = false;

    sheet.enableSheetCalculations();

    sheet.getRangeByName('A1').columnWidth = 4.82;
    sheet.getRangeByName('L1').columnWidth = 4.82;
    sheet.getRangeByName('B1:C1').columnWidth = 13.82;
    sheet.getRangeByName('D1').columnWidth = 13.20;
    sheet.getRangeByName('E1').columnWidth = 7.50;
    sheet.getRangeByName('F1').columnWidth = 9.73;
    sheet.getRangeByName('G1').columnWidth = 8.82;
    sheet.getRangeByName('H1').columnWidth = 4.46;

    sheet.getRangeByName('A1:H1').cellStyle.backColor = '#333F4F';
    sheet.getRangeByName('A1:H1').merge();
    sheet.getRangeByName('B4:H6').merge();

    sheet.getRangeByName('B4').setText('Relatório de pedidos snacks');
    sheet.getRangeByName('B4').cellStyle.fontSize = 32;

    sheet.getRangeByName('B8').setText('De:');
    sheet.getRangeByName('B8').cellStyle.fontSize = 9;
    sheet.getRangeByName('B8').cellStyle.bold = true;

    sheet
        .getRangeByName('B9')
        .setText(DateFormat('dd/MM/yy').format(interval.first));
    sheet.getRangeByName('B9').cellStyle.fontSize = 12;

    sheet.getRangeByName('B10').setText('Até:');
    sheet.getRangeByName('B10').cellStyle.fontSize = 9;
    sheet.getRangeByName('B10').cellStyle.bold = true;
    sheet
        .getRangeByName('B11')
        .setText(DateFormat('dd/MM/yy').format(interval.last));
    sheet.getRangeByName('B11').cellStyle.fontSize = 12;

    // sheet.getRangeByIndex(13, 3).setText('Data e hora');
    // sheet.getRangeByIndex(13, 2).setText('Codigo');
    // sheet.getRangeByIndex(13, 4).setText('Restaurante');
    // sheet.getRangeByIndex(13, 5).setText('Quantidade');
    // sheet.getRangeByIndex(13, 6).setText('Item');
    // sheet.getRangeByIndex(13, 7).setText('Extras');
    // sheet.getRangeByIndex(13, 8).setText('Extras valor');
    // sheet.getRangeByIndex(13, 9).setText('Pagamento');
    // sheet.getRangeByIndex(13, 10).setText('Delivery');
    // sheet.getRangeByIndex(13, 11).setText('Total');

    // for (var order in orders) {
    //   for (var item in order.items) {
    //     print(item.extras);
    //     var extras = item.extras != null && item.extras!.isNotEmpty
    //         ? item.extras!
    //             .map((e) => double.tryParse(e["value"]) ?? 0)
    //             .reduce((v, e) => v + e)
    //         : 0;
    //     var data = [
    //       order.created_at,
    //       order.code,
    //       order.restaurantName,
    //       item.amount,
    //       item.optionSelected.title,
    //       item.extras?.map((e) => e["title"]).join(","),
    //       extras,
    //       order.paymentMethod,
    //       order.deliveryValue,
    //       item.optionSelected.value,
    //     ];
    //     lineOrder.addAll(data);
    //   }
    // }
    // sheet.importList(lineOrder.toList(), firstRow, firstColumn, isVertical);

// Create Data Rows for importing.
    int startLine = 13;
    final List<ExcelDataRow> dataRows = _buildReportDataRows(orders);

// Import the Data Rows in to Worksheet.
    sheet.importData(dataRows, startLine, 2);
    final Range rangeHead = sheet.getRangeByName('B13:K13');
    final Range extras = sheet.getRangeByName('G13:G14');
    rangeHead.cellStyle.bold = true;
    rangeHead.columnWidth = 14;
    extras.columnWidth = 14;
    extras.columnWidth = 14;
    // rangeHead;
    rangeHead.autoFit();
    rangeHead.autoFitRows();

    final List<int> bytes = workbook.saveSync();
    //Dispose the document.

    workbook.dispose();

    var time = DateTime.now().millisecond.toString() +
        DateTime.now().microsecond.toString();
    var datetime = DateFormat('ddMMyy').format(DateTime.now());
    await writeFile(bytes, 'Snacks_Relatorio_${time}_$datetime.xlsx');
  }

  static List<ExcelDataRow> _buildReportDataRows(List<OrderResponse> orders) {
    List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

    excelDataRows = [];

    for (var order in orders) {
      for (var item in order.items) {
        var extras = item.extras != null && item.extras!.isNotEmpty
            ? item.extras!
                .map((e) => double.tryParse(e["value"]) ?? 0)
                .reduce((v, e) => v + e)
            : 0;

        print(item.extras);
        excelDataRows.add(ExcelDataRow(cells: <ExcelDataCell>[
          ExcelDataCell(
            columnHeader: 'Data e hora',
            value: order.created_at,
          ),
          ExcelDataCell(columnHeader: 'Codigo', value: order.code),
          ExcelDataCell(
              columnHeader: 'Restaurante', value: order.restaurantName),
          ExcelDataCell(columnHeader: 'Quantidade', value: item.amount),
          ExcelDataCell(columnHeader: 'Item', value: item.optionSelected.title),
          ExcelDataCell(
            columnHeader: 'Extras',
            value: item.extras?.map((e) => e["title"]).join(","),
          ),
          ExcelDataCell(columnHeader: 'Extras valor', value: extras),
          ExcelDataCell(columnHeader: 'Pagamento', value: order.paymentMethod),
          ExcelDataCell(columnHeader: 'Delivery', value: order.deliveryValue),
          ExcelDataCell(columnHeader: 'Total', value: order.value),
        ]));
      }
    }
    return excelDataRows;
  }
}
