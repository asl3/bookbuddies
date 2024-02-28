import 'package:flutter/material.dart';
import '../book.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class InfoTab extends StatefulWidget {
  const InfoTab({super.key, required this.book});

  final Book book;

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  final TextEditingController readingStatusController = TextEditingController();

  @override
  void dispose() {
    readingStatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: SafeArea(
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  const Center(
                      child: Text(
                    'Author',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Text(
                        widget.book.author,
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Center(
                    child: Text(
                      'Genre',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Text(
                        widget.book.genre,
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Center(
                    child: Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: DropdownMenu(
                        initialSelection: widget.book.readingStatus,
                        controller: readingStatusController,
                        // label: const Text('Reading Status'),
                        onSelected: (String? readingStatus) {
                          widget.book.updateReadingStatus(
                              readingStatusController.text);
                        },
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'Unread', label: 'Unread'),
                          DropdownMenuEntry(value: 'Reading', label: 'Reading'),
                          DropdownMenuEntry(
                              value: 'Completed', label: 'Completed'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Center(
                    child: Text(
                      'Visibility',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: ToggleSwitch(
                        initialLabelIndex: widget.book.isPublic ? 0 : 1,
                        totalSwitches: 2,
                        activeBgColors: const [
                          [Colors.green],
                          [Colors.red]
                        ],
                        labels: const ['Public', 'Private'],
                        onToggle: (index) {
                          widget.book.toggleVisiblity(index == 0);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Center(
                    heightFactor: 2,
                    child: Text(
                      'Rating',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: RatingBar.builder(
                      initialRating: widget.book.rating.toDouble(),
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 30,
                      itemPadding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 8),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        widget.book.toggleRating(rating.toInt());
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
