import 'package:flutter/material.dart';
import '../models/nature.dart';
import '../utils.dart';
import 'info-card.dart';

class MyCard extends StatelessWidget {
  final Nature nature;

  const MyCard({super.key, required this.nature});

  @override
  Widget build(BuildContext context) {
    final imageBytes = base64FromDataUri(nature.imageUrl ?? "");

    return Card(
      elevation: 3,
      margin: const EdgeInsets.fromLTRB(6, 3, 6, 3),
      color: Colors.white,
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                margin: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: '',
                      barrierColor: Colors.black.withOpacity(0.9),
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (context, anim1, anim2) {
                        return Scaffold(
                          backgroundColor: Colors.transparent,
                          body: Center(
                            child: Stack(
                              children: [
                                Center(
                                  child: Hero(
                                    tag: "nature-${nature.id}",
                                    child: Image.memory(
                                      imageBytes,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  right: 20,
                                  child: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.white, size: 30),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Hero(
                    tag: "nature-${nature.id}",
                    child: Image.memory(
                      imageBytes,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 30, 0),
                      child: Text(
                        nature.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 20, 0),
                      child: Text(
                        '\$${nature.cost}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 20, 10),
                      child: Text(
                        nature.description,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                        const TextStyle(fontSize: 12, color: Colors.green),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          InfoButton(nature: nature)
        ],
      ),
    );
  }
}
