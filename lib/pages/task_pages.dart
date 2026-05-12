import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/task_model.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> tasks = [];
  String npm = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Fungsi untuk mengambil data Tugas dan NPM
  void loadData() async {
    setState(() => isLoading = true);
    try {
      // 1. Ambil list tugas dari API
      var taskData = await AuthService.getTasks();

      // 2. Ambil NPM dari SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String savedNpm = prefs.getString("npm") ?? "";

      setState(() {
        tasks = taskData;
        npm = savedNpm;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
    }
  }

  // Fungsi untuk menghapus tugas
  void deleteTask(int id) async {
    await AuthService.deleteTask(id);
    loadData(); // Refresh list setelah hapus
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Tugas berhasil dihapus")));
  }

  // Dialog untuk tambah tugas baru
  void showAddDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tambah Tugas Baru"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Judul Tugas",
                hintText: "Contoh: Belajar CRUD",
              ),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: "Deskripsi",
                hintText: "Keterangan tugas...",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("BATAL"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                await AuthService.addTask(
                  titleController.text,
                  descController.text,
                );
                Navigator.pop(context);
                loadData(); // Refresh list setelah tambah
              }
            },
            child: Text("SIMPAN"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tugas Mahasiswa ($npm)"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "Belum ada tugas terdaftar.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async => loadData(),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        tasks[index].title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(tasks[index].description ?? "-"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => deleteTask(tasks[index].id),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
    );
  }
}
