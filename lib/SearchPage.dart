import 'package:flutter/material.dart';
import 'AcademicYears.dart';

class SearchPage extends StatelessWidget {
  final List<String> branches;

  SearchPage({required this.branches});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Branches"),
      ),
      body: CustomSearchDelegate(branches: branches),
    );
  }
}

class CustomSearchDelegate extends StatefulWidget {
  final List<String> branches;

  CustomSearchDelegate({required this.branches});

  @override
  _CustomSearchDelegateState createState() => _CustomSearchDelegateState();
}

class _CustomSearchDelegateState extends State<CustomSearchDelegate> {
  late List<String> searchResults;

  @override
  void initState() {
    super.initState();
    searchResults = widget.branches;
  }

  void filterResults(String query) {
    setState(() {
      searchResults = widget.branches
          .where((branch) => branch.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: filterResults,
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(searchResults[index]),
                onTap: () {
                  // Redirect to the respective academic years
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AcademicYears(branch: searchResults[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
