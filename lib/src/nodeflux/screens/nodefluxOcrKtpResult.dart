import 'package:flutter/material.dart';
import '../models/nodeflux_result2_model.dart';

class NodefluxOcrKtpResult extends StatefulWidget {
  //final FetchIdCardModel model;
  final NodefluxResult2Model model;

  NodefluxOcrKtpResult(this.model);

  @override
  _NodefluxOcrKtpResultState createState() => _NodefluxOcrKtpResultState();
}

class _NodefluxOcrKtpResultState extends State<NodefluxOcrKtpResult> {
  final _key = new GlobalKey<FormState>();

  TextEditingController txtNama, txtNik, txtTempatTglLahir, txtJenisKelamin, txtAlamat, txtRtrw, txtKecamatan, txtAgama, txtStatusPerkawinan,
      txtPekerjaan, txtProvinsi, txtBerlakuHingga, txtGolonganDarah, txtKabupatenKota, txtKelurahanDesa, txtKewarganegaraan;

  setup(){
    txtNik = TextEditingController(text: widget.model.nik);
    txtNama = TextEditingController(text: widget.model.nama);
    txtAgama = TextEditingController(text: widget.model.agama);
    txtRtrw = TextEditingController(text: widget.model.rt_rw);
    txtAlamat = TextEditingController(text: widget.model.alamat);
    txtProvinsi = TextEditingController(text: widget.model.provinsi);
    txtKecamatan = TextEditingController(text: widget.model.kecamatan);
    txtPekerjaan = TextEditingController(text: widget.model.pekerjaan);
    txtTempatTglLahir = TextEditingController(text: widget.model.tempat_lahir + "/" + widget.model.tanggal_lahir);
    txtJenisKelamin = TextEditingController(text: widget.model.jenis_kelamin);
    txtBerlakuHingga= TextEditingController(text: widget.model.berlaku_hingga);

    txtKelurahanDesa = TextEditingController(text: widget.model.kelurahan_desa);


    txtStatusPerkawinan = TextEditingController(text: widget.model.status_perkawinan);



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR KTP Result'),
        leading: IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              moveToLastScreen();
            }
        ),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              enabled: false,
              controller: txtNik,
              decoration: InputDecoration(
                  labelText: "NIK"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtNama,
              decoration: InputDecoration(
                  labelText: "Nama"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtTempatTglLahir,
              decoration: InputDecoration(
                  labelText: "Tempat / Tgl Lahir"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtJenisKelamin,
              decoration: InputDecoration(
                  labelText: "Jenis Kelamin"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtGolonganDarah,
              decoration: InputDecoration(
                  labelText: "Golongan Darah"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtAlamat,
              decoration: InputDecoration(
                  labelText: "Alamat"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtRtrw,
              decoration: InputDecoration(
                  labelText: "RT / RW"
              ),
            ),

            TextFormField(
              enabled: false,
              controller: txtKelurahanDesa,
              decoration: InputDecoration(
                  labelText: "Kelurahan / Desa"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtKecamatan,
              decoration: InputDecoration(
                  labelText: "Kecamatan"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtKabupatenKota,
              decoration: InputDecoration(
                  labelText: "Kabupaten/ Kota"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtAgama,
              decoration: InputDecoration(
                  labelText: "Agama"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtStatusPerkawinan,
              decoration: InputDecoration(
                  labelText: "Status"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtPekerjaan,
              decoration: InputDecoration(
                  labelText: "Pekerjaan"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtKewarganegaraan,
              decoration: InputDecoration(
                  labelText: "Kewarganegaraan"
              ),
            ),
            TextFormField(
              enabled: false,
              controller: txtBerlakuHingga,
              decoration: InputDecoration(
                  labelText: "Berlaku Hingga"
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
