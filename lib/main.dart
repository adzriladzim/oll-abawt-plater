import 'package:flutter/material.dart';
import 'movie_catalog_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 202, 228, 236),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: const ProfessionalProfilePage(),
    );
  }
}

class ProfessionalProfilePage extends StatelessWidget {
  const ProfessionalProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // KOMBINASI 1: Scrolling + Layout (Slivers)
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.movie, color: Colors.white),
                tooltip: 'Movie Catalog',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MovieCatalogPage(),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                // KOMBINASI 2: Layout + Basics (Stacking elements)
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 99, 139, 204),
                    ),
                  ),
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 30),
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.person,
                            size: 55,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Adzril Adzim H.",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KOMBINASI 3: Text + Layout (RichText Executive Bio Fokus QA)
                  const Text(
                    "Biodata Diri",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color.fromARGB(255, 45, 84, 146),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(220, 30, 30, 30),
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: "Saya adalah seorang "),
                        TextSpan(
                          text: "Informatika Explorer ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 218, 142, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "berlatar belakang Ilmu Komputer yang fokus mendalami rekayasa kualitas perangkat lunak (Software Quality Assurance) dan SDET. Terampil dalam merancang skenario pengujian fungsional otomatis, analisis API, serta memastikan reliabilitas sistem sebelum dilepas ke lingkungan produksi.",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // KOMBINASI 4: Layout + Scrolling (Daftar Kompetensi QA & Frontend yang Diperluas)
                  const Text(
                    "Core Competencies",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          [
                                "API Automation Testing",
                                "UI Automation",
                                "Postman Tool",
                                "React.js & Next.js",
                                "JavaScript",
                                "CI/CD Pipeline",
                                "Git & GitHub",
                                "HTML & CSS",
                              ]
                              .map(
                                (skill) => Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.blueAccent.withValues(
                                        alpha: 0.25,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    skill,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // KOMBINASI 5: Layout + Basics (Fokus Eksplorasi Ditambahkan)
                  const Text(
                    "Fokus Eksplorasi",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      ActionChip(
                        avatar: Icon(Icons.bug_report, size: 16),
                        label: Text("Software QA / SDET"),
                      ),
                      ActionChip(
                        avatar: Icon(Icons.api, size: 16),
                        label: Text("API Testing Automation"),
                      ),
                      ActionChip(
                        avatar: Icon(Icons.speed, size: 16),
                        label: Text("Performance Testing"),
                      ),
                      ActionChip(
                        avatar: Icon(Icons.web, size: 16),
                        label: Text("Frontend Dev Integration"),
                      ),
                      ActionChip(
                        avatar: Icon(Icons.checklist_rtl, size: 16),
                        label: Text("Manual & Functional Testing"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // 💼 PROFESSIONAL EXPERIENCE (Disusun Akurat Terkini -> Terlama)
                  const Text(
                    "Professional Experience",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 1. TERBARU (Masa Sekarang - 2026): PT Chronaxis Labs - Fokus QA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified_user,
                          color: Color.fromARGB(255, 99, 139, 204),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Software Quality Assurance (QA) Engineer",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                "PT Chronaxis Labs • Present",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Bertanggung jawab penuh menetapkan standar kualitas pengujian, merancang skenario uji manual dan otomatisasi untuk endpoints API berskala masif, serta mengevaluasi fungsionalitas sistem sebelum siklus rilis.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 2. Cakrawala University (Freelance Pendukung Pembelajaran)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.co_present,
                          color: Color.fromARGB(255, 99, 139, 204),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Class Facilitator",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                "Cakrawala University • Freelance",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Mengelola manajemen infrastruktur teknis ruang pertemuan hybrid kelas, bertindak selaku moderator koordinasi, serta mengontrol kestabilan sistem pembelajaran digital.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 3. PT Prima Avza Solusindo (Freelance)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.developer_mode,
                          color: Color.fromARGB(255, 99, 139, 204),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Frontend Developer",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                "PT Prima Avza Solusindo • Freelance",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Membangun antarmuka modul frontend PKSS HR Management System (Anak Perusahaan BRI), landing page utama korporat, serta mengelola efisiensi sistem arsip file internal perusahaan.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 3. PT Itho Indostock
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.code,
                          color: Color.fromARGB(255, 99, 139, 204),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Frontend Developer",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                "PT Itho Indostock • Full-time",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Mengembangkan arsitektur frontend sistem KantinGo, IASPEM Voting, merancang modul internal Rapor Kurikulum Merdeka, serta menyusun dokumentasi teknis pemetaan komponen web.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // FOOTER HALAMAN
                  const SizedBox(height: 35),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "© 2026 Adzril Adzim H. • Built with Flutter Layout Engine",
                      style: TextStyle(
                        color: Color.fromARGB(97, 20, 19, 19),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
