import 'package:flutter/material.dart';
import 'package:recetas_app/data/resenas_db.dart';
import 'package:recetas_app/models/receta.dart';
import 'package:recetas_app/models/resena.dart';
import 'package:recetas_app/widgets/formulario_resena.dart';
import 'package:recetas_app/widgets/tarjeta_resena.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;
  const DetalleRecetaScreen({super.key, required this.receta});

  @override
  State<DetalleRecetaScreen> createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  List<Resena> _resenas = [];
  bool _cargandoResenas = true;
  String? _errorResenas;

  @override
  void initState() {
    super.initState();
    _cargarResenas();
  }

  Future<void> _cargarResenas() async {
    try {
      final resenas = await ResenasDb.instancia.obtenerPorReceta(
        widget.receta.id,
      );
      if (!mounted) return;
      setState(() {
        _resenas = resenas;
        _errorResenas = null;
        _cargandoResenas = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorResenas = 'No se pudieron cargar las reseñas: $error';
        _cargandoResenas = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final receta = widget.receta;
    return Scaffold(
      appBar: AppBar(title: Text("Detalle de la receta")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(14),
            child: Image.network(
              receta.imagenUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Image.asset(
                "assets/images/plato-placeholder.png",
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            children: [
              Chip(label: Text('${receta.tiempoTotal} min')),
              Chip(label: Text('${receta.porciones} porciones')),
              Chip(label: Text('${receta.calorias} kcal')),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Ingredientes: ",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.ingredientes.map(
            (ingrediente) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ingrediente)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Preparación ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.instrucciones.asMap().entries.map(
            (entrada) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      "${entrada.key + 1}",
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(entrada.value)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Reseñas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FormularioResena(
            recetaId: receta.id,
            onResenaEnviada: _cargarResenas,
          ),
          const SizedBox(height: 8),
          if (_cargandoResenas)
            const Center(child: CircularProgressIndicator())
          else if (_errorResenas != null)
            Text(_errorResenas!)
          else if (_resenas.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Aún no hay reseñas. ¡Sé la primera persona!'),
            )
          else
            ..._resenas.map((resena) => TarjetaResena(resena: resena)),
        ],
      ),
    );
  }
}
