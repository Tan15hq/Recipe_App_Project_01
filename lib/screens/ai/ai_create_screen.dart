import 'package:flutter/material.dart';

class AICreateScreen extends StatefulWidget {
  const AICreateScreen({Key? key}) : super(key: key);

  @override
  State<AICreateScreen> createState() => _AICreateScreenState();
}

class _AICreateScreenState extends State<AICreateScreen> {
  final _controller = TextEditingController();
  String _generatedRecipe = '';
  bool _loading = false;

  Future<void> _generateRecipe() async {
    if (_controller.text.trim().isEmpty) return;
    setState(() => _loading = true);

    await Future.delayed(const Duration(seconds: 2)); // Simulate AI API
    setState(() {
      _generatedRecipe = '''
🍽 **AI-Generated Recipe**
Based on: ${_controller.text}

**Title:** Magical ${_controller.text.split(' ').first} Delight  
**Ingredients:** ${_controller.text}, salt, olive oil  
**Steps:**
1. Mix all ingredients in a bowl.
2. Heat a pan for 10 minutes.
3. Serve hot and enjoy! 😋
      ''';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Create with AI 🤖",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter ingredients (e.g. chicken, rice, garlic)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _generateRecipe,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_generatedRecipe.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.orange[50],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _generatedRecipe,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
