import 'package:flutter/material.dart';

void main() {
  runApp(const CardCounterApp());
}

class CardCounterApp extends StatelessWidget {
  const CardCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador de Cartas Blackjack',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF0E4A2F),
        useMaterial3: true,
      ),
      home: const DeckSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DeckSelectionScreen extends StatelessWidget {
  const DeckSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contador de Cartas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[800],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.casino,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                '¿Con cuántos mazos quieres empezar?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Selecciona el número de mazos que se usan en tu mesa de blackjack',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [1, 2, 4, 6, 8]
                      .map((decks) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CardCounterScreen(
                                          numberOfDecks: decks),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[700],
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  '$decks ${decks == 1 ? "Mazo" : "Mazos"} (${decks * 52} cartas)',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardValue {
  final String name;
  final int value;
  int remaining;
  final int initialCount;

  CardValue({
    required this.name,
    required this.value,
    required this.remaining,
    required this.initialCount,
  });

  double getProbability(int totalCardsLeft) {
    if (totalCardsLeft == 0) return 0.0;
    return (remaining / totalCardsLeft) * 100;
  }
}

class CardCounterScreen extends StatefulWidget {
  final int numberOfDecks;

  const CardCounterScreen({super.key, required this.numberOfDecks});

  @override
  State<CardCounterScreen> createState() => _CardCounterScreenState();
}

class _CardCounterScreenState extends State<CardCounterScreen> {
  late List<CardValue> cardValues;
  late int totalCardsRemaining;
  late int initialTotalCards;

  @override
  void initState() {
    super.initState();
    _initializeCards();
  }

  void _initializeCards() {
    initialTotalCards = widget.numberOfDecks * 52;
    totalCardsRemaining = initialTotalCards;

    cardValues = [
      CardValue(
          name: 'A',
          value: 11,
          remaining: widget.numberOfDecks * 4,
          initialCount: widget.numberOfDecks * 4),
      CardValue(
          name: '2',
          value: 2,
          remaining: widget.numberOfDecks * 4,
          initialCount: widget.numberOfDecks * 4),
      CardValue(
          name: '3',
          value: 3,
          remaining: widget.numberOfDecks * 4,
          initialCount: widget.numberOfDecks * 4),
      CardValue(
          name: '4',
          value: 4,
          remaining: widget.numberOfDecks * 4,
          initialCount: widget.numberOfDecks * 4),
      CardValue(
          name: '5',
          value: 5,
          remaining: widget.numberOfDecks * 4,
          initialCount: widget.numberOfDecks * 4),
      CardValue(
          name: '6',
          value: 6,
          remaining: widget.numberOfDecks * 4,
          initialCount: widget.numberOfDecks * 4),
      CardValue(
          name: '7',
          value: 7,
          remaining: widget.numberOfDecks * 4,
          initialCount: widget.numberOfDecks * 4),
      CardValue(
          name: '8',
          value: 8,
          remaining: widget.numberOfDecks * 4,
          initialCount: widget.numberOfDecks * 4),
      CardValue(
          name: '9',
          value: 9,
          remaining: widget.numberOfDecks * 4,
          initialCount: widget.numberOfDecks * 4),
      CardValue(
          name: '10',
          value: 10,
          remaining: widget.numberOfDecks * 16,
          initialCount: widget.numberOfDecks * 16), // 10, J, Q, K
    ];
  }

  void _removeCard(int index) {
    setState(() {
      if (cardValues[index].remaining > 0) {
        cardValues[index].remaining--;
        totalCardsRemaining--;
      }
    });
  }

  void _addCard(int index) {
    setState(() {
      if (cardValues[index].remaining < cardValues[index].initialCount) {
        cardValues[index].remaining++;
        totalCardsRemaining++;
      }
    });
  }

  void _resetCount() {
    setState(() {
      _initializeCards();
    });
  }

  Color _getCardColor(double probability) {
    if (probability >= 8.0) return const Color(0xFFE53E3E); // Rojo brillante
    if (probability >= 6.0) return const Color(0xFFFF8C00); // Naranja brillante
    if (probability >= 4.0) return const Color(0xFFFFD700); // Amarillo dorado
    return const Color(0xFF38A169); // Verde normal
  }

  String _getProbabilityStatus(double probability) {
    if (probability >= 8.0) return "🔴 ALTA";
    if (probability >= 6.0) return "🟠 MEDIA";
    if (probability >= 4.0) return "🟡 BAJA";
    return "🟢 MUY BAJA";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contador ${widget.numberOfDecks} ${widget.numberOfDecks == 1 ? "Mazo" : "Mazos"}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetCount,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Cartas Restantes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalCardsRemaining / $initialTotalCards',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${((totalCardsRemaining / initialTotalCards) * 100).toStringAsFixed(1)}% del mazo',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[800]?.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[300]!, width: 1),
                ),
                child: Column(
                  children: [
                    const Text(
                      '📱 Instrucciones',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Presiona "-" cuando salga una carta\n• Presiona "+" para corregir errores',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Colores de Probabilidad:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildColorIndicator(Color(0xFFE53E3E), '≥8% ALTA'),
                        _buildColorIndicator(Color(0xFFFF8C00), '6-8% MEDIA'),
                        _buildColorIndicator(Color(0xFFFFD700), '4-6% BAJA'),
                        _buildColorIndicator(Color(0xFF38A169), '<4% MUY BAJA'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: cardValues.length,
                itemBuilder: (context, index) {
                  final card = cardValues[index];
                  final probability = card.getProbability(totalCardsRemaining);
                  final cardColor = _getCardColor(probability);
                  final probabilityStatus = _getProbabilityStatus(probability);

                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            card.name == '10' ? '10/J/Q/K' : card.name,
                            style: TextStyle(
                              color: probability >= 4.0 && probability < 6.0
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: probability >= 4.0 && probability < 6.0
                                  ? []
                                  : [
                                      const Shadow(
                                        blurRadius: 2,
                                        color: Colors.black,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                'Quedan: ${card.remaining}',
                                style: TextStyle(
                                  color: probability >= 4.0 && probability < 6.0
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                probabilityStatus,
                                style: TextStyle(
                                  color: probability >= 4.0 && probability < 6.0
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${probability.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: probability >= 4.0 && probability < 6.0
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () => _addCard(index),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _removeCard(index),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.red[800],
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _resetCount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reiniciar Conteo Completo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[800]?.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Tips para Conteo:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '• >8%: Muchas cartas quedan\n• 4-8%: Cantidad normal\n• <4%: Pocas cartas quedan\n• 10/J/Q/K se cuentan juntas',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorIndicator(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: Colors.white, width: 0.5),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }
}
