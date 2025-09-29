import 'package:flutter/material.dart';
import '../models/nature.dart';
import '../utils.dart';

class InfoButton extends StatelessWidget {
  final Nature nature;

  const InfoButton({super.key, required this.nature});

  @override
  Widget build(BuildContext context) {
    final imageBytes = base64FromDataUri(nature.imageUrl);
    return Positioned(
      top: 0,
      right: 0,
      child: IconButton(
        icon: const Icon(Icons.info, color: Colors.blue),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.black87,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  // Orqaga qaytishda avval modal yopiladi
                  Navigator.pop(context);
                  return false;
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle (chiziqcha)
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      Text(
                        nature.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              imageBytes,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: 200,
                            ),
                          ),
                          // Gradient overlay
                          Container(
                            height: 100,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.black87,
                                ],
                                stops: [0.0, 0.0, 1.0],
                              ),
                            ),
                          ),
                          // Title yozuv
                          Positioned(
                            left: 12,
                            bottom: 12,
                            right: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '\$${nature.cost}',
                                    overflow: TextOverflow.ellipsis, // ✅ sig‘masa ... bo‘ladi
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(0, 1),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_sharp,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      nature.date,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(0, 1),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        nature.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
