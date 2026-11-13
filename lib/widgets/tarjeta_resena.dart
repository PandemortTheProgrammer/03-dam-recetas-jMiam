import 'package:flutter/material.dart';

import '../models/resena.dart';

class TarjetaResena extends StatelessWidget {
  final Resena resena;

  const TarjetaResena({super.key, required this.resena});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Usuario ${resena.usuarioId}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < resena.valoracion
                          ? Icons.star
                          : Icons.star_border,
                      size: 18,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(resena.resena),
          ],
        ),
      ),
    );
  }
}
