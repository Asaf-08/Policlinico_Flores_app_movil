import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:policlinico_flores/models/fichas_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class FichasPDF {
  final date = DateTime.now();
  Future<Uint8List> fichaclinica(FichaModel ficha) async {
    String dateformat = "${date.day}/${date.month}/${date.year}";
    final pdf = pw.Document();

    final logo =
        (await rootBundle.load("assets/images/logo.png")).buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: ((pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: <pw.Widget>[
                pw.Container(
                  alignment: pw.Alignment.topLeft,
                  child: pw.Column(children: <pw.Widget>[
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: <pw.Widget>[
                          pw.Text(
                            "Fecha: $dateformat",
                            style: const pw.TextStyle(
                                color: PdfColors.grey, fontSize: 10),
                          ),
                          pw.Text(
                            "RUC: 20600579178",
                            style: const pw.TextStyle(
                                color: PdfColors.grey, fontSize: 10),
                          ),
                        ]),
                    pw.Row(children: <pw.Widget>[
                      pw.Text(
                        "Código de ficha: ${ficha.codigoficha}",
                        style: const pw.TextStyle(
                            color: PdfColors.grey, fontSize: 10),
                      ),
                    ]),
                  ]),
                ),
                pw.Container(
                  alignment: pw.Alignment.topCenter,
                  child: pw.Image(pw.MemoryImage(logo),
                      width: 90, height: 90, fit: pw.BoxFit.cover),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  "Policlínico Flores S.R.L.",
                  style: pw.TextStyle(
                      color: PdfColors.blue,
                      fontSize: 25,
                      fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "Mz O Lt 2 Urb. Santa Ana, Los Olivos",
                  style: const pw.TextStyle(color: PdfColors.grey),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "Teléfono: +(51) 901196994",
                  style: const pw.TextStyle(color: PdfColors.grey),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "Email: Policlinicofc328@hotmail.com",
                  style: const pw.TextStyle(color: PdfColors.grey),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 20),
                  width: double.infinity,
                  decoration: const pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.only(
                          topLeft: pw.Radius.circular(10),
                          topRight: pw.Radius.circular(10)),
                      color: PdfColors.blue),
                  child: pw.Text(
                    "Datos del paciente",
                    style: const pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 18,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 5),
                  padding:
                      const pw.EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  decoration: const pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: pw.BorderRadius.only(
                          bottomLeft: pw.Radius.circular(10),
                          bottomRight: pw.Radius.circular(10))),
                  child: pw.Column(
                    children: <pw.Widget>[
                      pw.SizedBox(height: 10),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Container(
                            width: 170,
                            child: pw.Text(
                              "Id del paciente: ",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          pw.Text(
                            ficha.idpaciente.toString(),
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Container(
                            width: 170,
                            child: pw.Text(
                              "Apellidos: ",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          pw.Text(
                            ficha.apellidos!,
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Container(
                            width: 170,
                            child: pw.Text(
                              "Nombres: ",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          pw.Text(
                            ficha.nombres!,
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Container(
                            width: 170,
                            child: pw.Text(
                              "DNI: ",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          pw.Text(
                            ficha.dni!,
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      ficha.edad != null
                          ? pw.SizedBox(height: 5)
                          : pw.SizedBox.shrink(),
                      ficha.edad != null
                          ? pw.Row(
                              children: <pw.Widget>[
                                pw.Container(
                                  width: 170,
                                  child: pw.Text(
                                    "Edad: ",
                                    style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                pw.Text(
                                  ficha.edad.toString(),
                                  style: const pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            )
                          : pw.SizedBox.shrink(),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Container(
                            width: 170,
                            child: pw.Text(
                              "Género: ",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          pw.Text(
                            ficha.genero!,
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Container(
                            width: 170,
                            child: pw.Text(
                              "Teléfono: ",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          pw.Text(
                            ficha.telefono!,
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 20),
                  width: double.infinity,
                  decoration: const pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.only(
                          topLeft: pw.Radius.circular(10),
                          topRight: pw.Radius.circular(10)),
                      color: PdfColors.blue),
                  child: pw.Text(
                    "Datos de la consulta",
                    style: const pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 18,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 5),
                  padding:
                      const pw.EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  decoration: const pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: pw.BorderRadius.only(
                          bottomLeft: pw.Radius.circular(10),
                          bottomRight: pw.Radius.circular(10))),
                  child: pw.Column(
                    children: <pw.Widget>[
                      pw.SizedBox(height: 10),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Container(
                            width: 170,
                            child: pw.Text(
                              "Id de consulta: ",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          pw.Text(
                            ficha.idconsulta.toString(),
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Container(
                            width: 170,
                            child: pw.Text(
                              "Área de atención: ",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          pw.Text(
                            ficha.area!,
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Container(
                            width: 170,
                            child: pw.Text(
                              "Motivo de consulta: ",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          pw.Text(
                            ficha.motivo!,
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      pw.SizedBox(height: 5),
                      pw.Row(
                        children: <pw.Widget>[
                          pw.Container(
                            width: 170,
                            child: pw.Text(
                              "Fecha de consulta: ",
                              style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                          pw.Text(
                            ficha.fechaconsulta!,
                            style: const pw.TextStyle(
                              color: PdfColors.black,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 10),
                  padding: const pw.EdgeInsets.symmetric(horizontal: 15),
                  child: pw.Row(
                    children: <pw.Widget>[
                      pw.Container(
                        width: 170,
                        child: pw.Text(
                          "Especialista a cargo: ",
                          style: pw.TextStyle(
                              color: PdfColors.black,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      pw.Text(
                        ficha.especialista!,
                        style: const pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 70),
                  child: pw.Center(
                      child: pw.Text(
                    "¡Gracias por su visita, vuelva pronto!",
                    style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        fontStyle: pw.FontStyle.italic),
                  )),
                ),
              ],
            ),
          );
        }),
      ),
    );
    return pdf.save();
  }

  Future<void> savePDF(String filename, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$filename.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenFile.open(filePath);
  }
}
