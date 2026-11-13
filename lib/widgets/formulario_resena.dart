import 'package:flutter/material.dart';

import '../data/resenas_db.dart';
import '../models/resena.dart';

class FormularioResena extends StatefulWidget {
  final int recetaId;
  final VoidCallback onResenaEnviada;

  const FormularioResena({
    super.key,
    required this.recetaId,
    required this.onResenaEnviada,
  });

  @override
  State<FormularioResena> createState() => _FormularioResenaState();
}

class _FormularioResenaState extends State<FormularioResena> {
  final _formKey = GlobalKey<FormState>();
  final _resenaController = TextEditingController();
  int _valoracion = 0;
  bool _guardando = false;

  @override
  void dispose() {
    _resenaController.dispose();
    super.dispose();
  }

  Future<void> _enviarResena() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    try {
      await ResenasDb.instancia.insertar(
        Resena(
          recetaId: widget.recetaId,
          valoracion: _valoracion,
          resena: _resenaController.text.trim(),
        ),
      );

      if (!mounted) return;
      _resenaController.clear();
      setState(() => _valoracion = 5);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Reseña guardada.')));
      widget.onResenaEnviada();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar la reseña: $error')),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Deja tu reseña',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Tu valoración'),
              Row(
                children: List.generate(
                  5,
                  (index) => IconButton(
                    tooltip: '${index + 1} estrellas',
                    onPressed: _guardando
                        ? null
                        : () => setState(() => _valoracion = index + 1),
                    icon: Icon(
                      index < _valoracion ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: _resenaController,
                enabled: !_guardando,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Comentario',
                  hintText: '¿Qué te pareció esta receta?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Escribe un comentario.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _guardando ? null : _enviarResena,
                  icon: _guardando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(_guardando ? 'Guardando...' : 'Publicar reseña'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
