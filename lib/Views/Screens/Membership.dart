import 'package:flutter/material.dart';

class MembershipsScreen extends StatefulWidget {
  const MembershipsScreen({super.key});

  @override
  State<MembershipsScreen> createState() => _MembershipsScreenState();
}

class _MembershipsScreenState extends State<MembershipsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  String search = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  final List<Map<String, dynamic>> members = [
    {
      "name": "Rahul Sharma",
      "email": "rahul@example.com",
      "role": "Member",
      "club": "Mumbai Photography Club",
      "status": "Active"
    },
    {
      "name": "Deepa Menon",
      "email": "deepa@example.com",
      "role": "Member",
      "club": "Bangalore Clicks",
      "status": "Pending"
    },
  ];

  final List<Map<String, dynamic>> clubs = [
    {
      "name": "Mumbai Photography Club",
      "members": 145,
      "federation": "Maharashtra Federation",
      "status": "Active"
    },
  ];

  final List<Map<String, dynamic>> federations = [
    {
      "name": "Maharashtra Federation",
      "clubs": 12,
      "members": 456,
      "president": "Dr. Anil Patil"
    },
  ];

  Color statusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = members
        .where((m) =>
            m["name"].toLowerCase().contains(search.toLowerCase()))
        .toList();

    final pendingMembers =
        members.where((m) => m["status"] == "Pending").toList();

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),
      appBar: AppBar(
        title: const Text("Memberships"),
        backgroundColor: Colors.indigo,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            const Tab(text: "All Members"),
            Tab(text: "Pending (${pendingMembers.length})"),
            const Tab(text: "Clubs"),
            const Tab(text: "Federations"),
          ],
        ),
      ),
      body: Column(
        children: [
          // 🔎 Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search members...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildMemberTable(filteredMembers),
                buildMemberTable(pendingMembers),
                buildClubsGrid(),
                buildFederationsGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= MEMBERS TABLE =================

  Widget buildMemberTable(List<Map<String, dynamic>> list) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text("Member")),
          DataColumn(label: Text("Role")),
          DataColumn(label: Text("Club")),
          DataColumn(label: Text("Status")),
        ],
        rows: list.map((m) {
          return DataRow(cells: [
            DataCell(Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.indigo,
                  child: Text(
                    m["name"]
                        .split(" ")
                        .map((e) => e[0])
                        .join(),
                    style: const TextStyle(
                        fontSize: 12, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(m["name"],
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    Text(
                      m["email"],
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ],
            )),
            DataCell(Text(m["role"])),
            DataCell(Text(m["club"])),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor(m["status"])
                    .withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                m["status"],
                style: TextStyle(
                    color: statusColor(m["status"]),
                    fontWeight: FontWeight.w600),
              ),
            )),
          ]);
        }).toList(),
      ),
    );
  }

  // ================= CLUBS GRID =================

  Widget buildClubsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clubs.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final c = clubs[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c["name"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold)),
              Text(c["federation"],
                  style:
                      const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text("${c["members"]} members"),
                  const SizedBox(width: 20),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor(c["status"])
                          .withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                      c["status"],
                      style: TextStyle(
                          color:
                              statusColor(c["status"])),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // ================= FEDERATIONS GRID =================

  Widget buildFederationsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: federations.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        final f = federations[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(f["name"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold)),
              Text("President: ${f["president"]}",
                  style:
                      const TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text("${f["clubs"]} clubs"),
                  const SizedBox(width: 20),
                  Text("${f["members"]} members"),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}