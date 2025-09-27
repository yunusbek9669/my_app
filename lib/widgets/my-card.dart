import 'package:flutter/material.dart';
import '../models/nature.dart';
import 'info-card.dart';

class MyCard extends StatelessWidget {
  final Nature nature; // 🔑 data kiritiladi

  const MyCard({super.key, required this.nature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.fromLTRB(6, 3, 6, 3),
      child: Stack(
        children: [
          // asosiy kontent
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
                                    tag: nature.imageUrl,
                                    child: Image.asset(
                                      nature.imageUrl,
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
                    tag: nature.imageUrl,
                    child: Image.asset(
                      nature.imageUrl,
                      height: 80,
                    ),
                  ),
                ),
              ),
              Expanded( // 👉 shu joyda qo‘shiladi
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // chapga tekislash
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 30, 0),
                      child: Text(
                        nature.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        overflow: TextOverflow.ellipsis, // ✅ sig‘masa ... qo‘yadi
                        style: const TextStyle(fontSize: 12, color: Colors.green),
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