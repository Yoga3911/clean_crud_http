import 'dart:developer';

import 'package:clean_crud/controller/services.dart';
import 'package:clean_crud/model/warga.dart';
import 'package:clean_crud/util/debouncer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  final String title = "Data Warga";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Warga>? _warga;
  // Filter warga
  List<Warga>? _filterWarga;
  TextEditingController? _nama;
  TextEditingController? _umur;
  Warga? _isSelected;
  bool? _isUpdating;
  String? _titleProgress;
  final _debouncer = Debouncer(millisecond: 500);

  @override
  void initState() {
    super.initState();
    _warga = [];
    _filterWarga = [];
    _nama = TextEditingController();
    _umur = TextEditingController();
    _isUpdating = false;
    _titleProgress = widget.title;
    _getWarga();
  }

  _showProgrees(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackbar(context, String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  _createTable() {
    _showProgrees("Create Table");
    Services.createTable().then((value) {
      if (value == "success") {
        _showSnackbar(context, value);
        _showProgrees(widget.title);
      } else {
        _showSnackbar(context, "Gagal!");
      }
    });
  }

  _getWarga() {
    _showProgrees("Get Warga");
    Services.getWarga().then((value) {
      _showProgrees(widget.title);
      setState(() {
        _warga = value;
        _filterWarga = value;
      });
      inspect(value);
    });
  }

  _addWarga() {
    _showProgrees("Add Warga");
    if (_nama!.text.isEmpty || _umur!.text.isEmpty) {
      _showSnackbar(context, 'Empety');
      return;
    } else {
      Services.addData(_nama!.text, _umur!.text).then((value) {
        if (value == "success") {
          _getWarga();
          _showSnackbar(context, 'Berhasil ditambahkan');
          _clearValue();
        }
        inspect(value);
      });
    }
  }

  _updateWarga(Warga warga) {
    _showProgrees("Update Warga");
    _isUpdating = true;
    Services.updateData(warga.id, _nama!.text, _umur!.text).then((value) {
      if (value == "success") {
        _getWarga();
        _showSnackbar(context, "Berhasil diupdate");
        _clearValue();
        setState(() {
          _isUpdating = false;
        });
      }
    });
  }

  _deleteWarga(Warga warga) {
    _showProgrees("Delete Warga");
    Services.deleteData(warga.id).then((value) {
      if (value == "success") {
        _getWarga();
        _showSnackbar(context, "Hapus data berhasil");
      }
    });
  }

  _clearValue() {
    _nama!.text = '';
    _umur!.text = '';
  }

  _showValues(Warga warga) {
    _nama!.text = warga.nama;
    _umur!.text = warga.umur;
  }

  @override
  void dispose() {
    super.dispose();
    _nama!.dispose();
    _umur!.dispose();
  }

  void alert(context, Warga warga) {
    final dial = AlertDialog(
      title: const Text('Apakah anda yakin?'),
      actions: [
        ElevatedButton(
            onPressed: () {
              _deleteWarga(warga);
              Navigator.pop(context);
            },
            child: const Text('Hapus')),
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal')),
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return dial;
        });
  }

  SingleChildScrollView dataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('NAMA')),
              DataColumn(label: Text('UMUR')),
              DataColumn(label: Text('HAPUS')),
            ],
            rows: _filterWarga!
                .map((e) => DataRow(cells: [
                      DataCell(Text(e.id.toString()), onTap: () {
                        _showValues(e);
                        _isSelected = e;
                        setState(() {
                          _isUpdating = true;
                        });
                      }),
                      DataCell(Text(e.nama.toString()), onTap: () {
                        _showValues(e);
                        _isSelected = e;
                        setState(() {
                          _isUpdating = true;
                        });
                      }),
                      DataCell(Text(e.umur.toString()), onTap: () {
                        _showValues(e);
                        _isSelected = e;
                        setState(() {
                          _isUpdating = true;
                        });
                      }),
                      DataCell(IconButton(
                          onPressed: () => alert(context, e),
                          icon: const Icon(Icons.delete)))
                    ]))
                .toList()),
      ),
    );
  }

  searchField() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextField(
        decoration: const InputDecoration(
            hintText: "Cari berdasar nama", contentPadding: EdgeInsets.all(5)),
        onChanged: (string) {
          _debouncer.run(() {
            setState(() {
              _filterWarga = _warga!
                  .where((element) =>
                      element.nama.toLowerCase().contains(string.toLowerCase()))
                  .toList();
            });
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleProgress as String),
        leading: const Icon(Icons.air_sharp),
        actions: [
          IconButton(
            icon: const Icon(Icons.table_chart),
            onPressed: () => _createTable(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _getWarga(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _addWarga(), child: const Icon(Icons.add)),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _nama,
                autofocus: false,
                decoration: const InputDecoration.collapsed(hintText: 'Nama'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _umur,
                autofocus: false,
                decoration: const InputDecoration.collapsed(hintText: 'Umur'),
              ),
            ),
            _isUpdating!
                ? Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateWarga(_isSelected as Warga),
                        child: const Text('Update'),
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {
                          _isUpdating = false;
                          _clearValue();
                        }),
                        child: const Text('Cancel'),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      ),
                    ],
                  )
                : const SizedBox(),
            searchField(),
            Expanded(child: dataTable())
          ],
        ),
      ),
    );
  }
}
