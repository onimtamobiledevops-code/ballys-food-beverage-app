class Item {
  final double idNo;
  final String prodCode;
  final String loca;
  final String prodName;
  final String shortDescrip;
  final double qty;
  final double purchasePrice;
  final double sellingPrice;
  final double markedPrice;
  final String packSize;
  final String productLock;
  final String unit;
  final double disc;
  final bool discAllow;
  final String catCode;
  final String deptCode;
  final int imageId;
  final bool kotId;
  final bool botId;
  final String printer;
  final bool issId;
  final bool reqId;
  final int issSectorLevel;
  final bool guestReq;
  final int printLoca;

  const Item({
    required this.idNo,
    required this.prodCode,
    required this.loca,
    required this.prodName,
    required this.shortDescrip,
    required this.qty,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.markedPrice,
    required this.packSize,
    required this.productLock,
    required this.unit,
    required this.disc,
    required this.discAllow,
    required this.catCode,
    required this.deptCode,
    required this.imageId,
    required this.kotId,
    required this.botId,
    required this.printer,
    required this.issId,
    required this.reqId,
    required this.issSectorLevel,
    required this.guestReq,
    required this.printLoca,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      idNo: (json['Id_No'] as num?)?.toDouble() ?? 0.0,
      prodCode: json['Prod_Code']?.toString() ?? '',
      loca: json['Loca']?.toString() ?? '',
      prodName: json['Prod_Name']?.toString() ?? '',
      shortDescrip: json['Short_Descrip']?.toString() ?? '',
      qty: (json['Qty'] as num?)?.toDouble() ?? 0.0,
      purchasePrice: (json['Purchase_Price'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['Selling_Price'] as num?)?.toDouble() ?? 0.0,
      markedPrice: (json['Marked_Price'] as num?)?.toDouble() ?? 0.0,
      packSize: json['Pack_Size']?.toString() ?? '',
      productLock: json['Product_Lock']?.toString() ?? '',
      unit: json['Unit']?.toString() ?? '',
      disc: (json['Disc'] as num?)?.toDouble() ?? 0.0,
      discAllow: json['DiscAllow']?.toString() == 'T',
      catCode: json['Cat_Code']?.toString() ?? '',
      deptCode: json['Dept_Code']?.toString() ?? '',
      imageId: (json['ImageID'] as num?)?.toInt() ?? 0,
      kotId: json['KOT_ID'] == true,
      botId: json['BOT_ID'] == true,
      printer: json['Printer']?.toString() ?? '',
      issId: json['Iss_ID'] == true,
      reqId: json['REQ_ID'] == true,
      issSectorLevel: (json['IssSec_Level'] as num?)?.toInt() ?? 0,
      guestReq: json['GuestReq'] == true,
      printLoca: (json['PrintLoca'] as num?)?.toInt() ?? 0,
    );
  }

  /// Convenience getter — use this wherever the UI needs a display name
  String get itemName => prodName;

  /// Convenience getter — use this wherever the UI needs a product code
  String get itemCode => prodCode;
}