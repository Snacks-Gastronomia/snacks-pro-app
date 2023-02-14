import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/corner_border.dart';
import 'package:snacks_pro_app/utils/md5.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/utils/toast.dart';
import 'package:snacks_pro_app/views/home/widgets/modals/content_payment_failed.dart';

class ScanCardScreen extends StatefulWidget {
  const ScanCardScreen({Key? key}) : super(key: key);

  @override
  State<ScanCardScreen> createState() => _ScanCardScreenState();
}

class _ScanCardScreenState extends State<ScanCardScreen> {
  late MobileScannerController controller;
  final modal = AppModal();
  final toast = AppToast();
  final md5 = AppMD5();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    // TODO: implement initState
    toast.init(context: context);
    controller = MobileScannerController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(41, 41)),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.black,
                            size: 19,
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    Text(
                      'Leia o qr code presente no cartão',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.semiBold(25,
                          color: Colors.white.withOpacity(0.5)),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 40),
                      // height: MediaQuery.of(context).size.height * 0.70,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.68,
                        maxWidth: MediaQuery.of(context).size.width * 0.88,
                      ),
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              offset: Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            )
                          ],
                          color: Colors.black,
                          // color: Colors.white.withOpacity(.15),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/snacks_logo.svg",
                            width: 90,
                            color: Colors.white,
                          ),
                          Center(
                              child: QRCodeBuilder(
                                  controller: controller,
                                  key: qrKey,
                                  onDetect: (barcode) async {
                                    if (barcode.barcodes.isEmpty) {
                                      toast.showToast(
                                          context: context,
                                          content:
                                              "Não foi possível identificar o cartão snacks",
                                          type: ToastType.error);

                                      Future.delayed(const Duration(seconds: 2),
                                          (() => Navigator.pop(context)));
                                      modal.showModalBottomSheet(
                                          context: context,
                                          content: const PaymentFailedContent(
                                            readError: true,
                                            value: "",
                                          ));
                                    } else {
                                      final String card_code =
                                          barcode.barcodes[0].rawValue ?? "";
                                      Navigator.pop(context, card_code);
                                    }
                                  }
                                  // (barcode) async {
                                  //   if (barcode.rawValue == null) {
                                  //     debugPrint('Failed to scan Barcode');
                                  //     toast.showToast(
                                  //         context: context,
                                  //         content:
                                  //             "Não foi possível identificar o cartão snacks",
                                  //         type: ToastType.error);

                                  //     Future.delayed(const Duration(seconds: 2),
                                  //         (() => Navigator.pop(context)));
                                  //   } else {
                                  //     final String card_code =
                                  //         barcode.rawValue!;
                                  //     // print(card_code);
                                  //     // if (card_code) {
                                  //     Navigator.pop(context, card_code);
                                  //     // } else {
                                  //     //   Navigator.pop(context, null);
                                  //     // }
                                  //   }
                                  // }
                                  ))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QRCodeBuilder extends StatelessWidget {
  const QRCodeBuilder({
    Key? key,
    required this.controller,
    required this.onDetect,
  }) : super(key: key);
  final MobileScannerController controller;
  // final modal = AppModal();
  final dynamic Function(BarcodeCapture) onDetect;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 300,
          width: 300,
          child: Center(
            child: SizedBox(
                height: 250,
                width: 250,
                child:
                    MobileScanner(controller: controller, onDetect: onDetect)),
          ),
        ),
        SizedBox(
          height: 285,
          width: 300,
          child: CustomPaint(
            painter: MyCustomPainter(
                padding: 15, frameSFactor: .1, color: Colors.white, stroke: 6),
            // child: Container(),
          ),
        ),
      ],
    );
  }
}
