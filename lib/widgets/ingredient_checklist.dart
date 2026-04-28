import 'package:flutter/material.dart';

class IngredientChecklist extends StatelessWidget {
  final List<String> ingredients;
  final List<String> selectedIngredients;
  final Function(List<String>) onChanged;

  const IngredientChecklist({
    super.key,
    required this.ingredients,
    required this.selectedIngredients,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ingredients.map((ingredient) {
        return CheckboxListTile(
          title: Text(
            ingredient,
            style: const TextStyle(fontSize: 16),
          ),
          value: selectedIngredients.contains(ingredient),
          onChanged: (bool? value) {
            if (value == true) {
              onChanged([...selectedIngredients, ingredient]);
            } else {
              onChanged(
                  selectedIngredients.where((i) => i != ingredient).toList());
            }
          },
          activeColor: Colors.green,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        );
      }).toList(),
    );
  }
}
