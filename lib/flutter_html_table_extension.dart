library flutter_html_table_extension;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlTableExtension extends HtmlExtension {
  final TextStyle? headerStyle;
  final TextStyle? cellStyle;
  final TableBorder? tableBorder;

  const HtmlTableExtension({
    this.headerStyle,
    this.cellStyle,
    this.tableBorder,
  });

  @override
  Set<String> get supportedTags => {"table"};

  WidgetSpan builder(ExtensionContext extensionContext) {
    final list = extensionContext.node.children
        .map(
          (e) => e.children
              .map((f) => f.children
                  .map(
                    (g) => g.text,
                  )
                  .toList())
              .toList(),
        )
        .toList();

    for (var list in list) {
      list.removeWhere((element) => element.isEmpty || (element is String && (element as String).trim().isEmpty));
    }

    list.removeWhere((element) => element.isEmpty);

    final flatList = list.expand((i) => i).toList();
    final columns = flatList[0];
    flatList.removeAt(0);
    final rows = flatList;

    return WidgetSpan(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  key: const Key("DataTable"),
                  border: tableBorder ?? TableBorder.all(width: 1),
                  columns: List.generate(
                      columns.length,
                      (i) => DataColumn(
                              label: Text(
                            columns[i].trim(),
                            style: headerStyle,
                          ))),
                  rows: List.generate(
                    rows.length,
                    (i) => DataRow(
                        cells: List.generate(
                            rows[i].length,
                            (j) => DataCell(Text(
                                  rows[i][j].trim(),
                                  style: cellStyle,
                                )))),
                  ),
                ))));
  }

  @override
  InlineSpan build(ExtensionContext context) {
    return builder(context);
  }
}
