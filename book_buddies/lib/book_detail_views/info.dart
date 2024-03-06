import 'package:flutter/material.dart';
import '../models.dart';
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
        padding: const EdgeInsets.all(30),
        child: SafeArea(child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: Table(
              columnWidths: const {
              0: FixedColumnWidth(100),
              1: FlexColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    const Text(
                      'Author',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        widget.book.author,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Genre',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        widget.book.genre,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Visibility',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    MediaQuery.of(context).orientation == Orientation.portrait 
                    ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: SizedBox(
                                    width: 50.0,
                                    height: 40.0,
                                    child: ToggleSwitch(
                                      initialLabelIndex:
                                          widget.book.isPublic ? 0 : 1,
                                      minWidth: 87,
                                      totalSwitches: 2,
                                      activeBgColors: const [
                                        [Colors.green],
                                        [Colors.red]
                                      ],
                                      labels: const ['Public', 'Private'],
                                      onToggle: (index) {
                                        widget.book.toggleVisiblity(index == 0);
                                      },
                                    )))
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 202),
                                    child: SizedBox(
                                        width: 50.0,
                                        height: 40.0,
                                        child: ToggleSwitch(
                                          initialLabelIndex:
                                              widget.book.isPublic ? 0 : 1,
                                          minWidth: 87,
                                          totalSwitches: 2,
                                          activeBgColors: const [
                                            [Colors.green],
                                            [Colors.red]
                                          ],
                                          labels: const ['Public', 'Private'],
                                          onToggle: (index) {
                                            widget.book
                                                .toggleVisiblity(index == 0);
                                          },
                                        ))),
                              ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Rating',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    RatingBar.builder(
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
                  ],
                ),
              ],
            ),
          );
        })));
  }
}
