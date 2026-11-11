import 'package:flutter/material.dart';
import 'package:recetas_app/models/receta.dart';
import 'package:recetas_app/screens/detalle_receta_screen.dart';
import 'package:recetas_app/services/recipe_service.dart';
import 'package:recetas_app/widgets/receta_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  late Future<List<Receta>> _futureRecetas;

  @override
  void initState() {
    super.initState();
    _futureRecetas = _recipeService.obtenerRecetas();
  }

  void _cargarRecetas() {
    setState(() {
      _futureRecetas = _recipeService.obtenerRecetas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RecetasApp, Joshua Fernando Miam Santos LIITID41',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 80, 23, 3),
      ),
      body: FutureBuilder<List<Receta>>(
        future: _futureRecetas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _cargarRecetas,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final recetas = snapshot.data ?? [];
          if (recetas.isEmpty) {
            return const Center(child: Text('No hay recetas disponibles.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: recetas.length,
            itemBuilder: (context, index) {
              return RecetaCard(
                receta: recetas[index],
                onTap: () async {
                  final bool? esFavorita = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetalleRecetaScreen(receta: recetas[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
