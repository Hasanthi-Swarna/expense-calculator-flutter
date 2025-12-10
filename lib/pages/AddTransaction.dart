import 'package:flutter/material.dart';

// Simple enum for type
enum TransactionType { received, sent }

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TransactionType _type = TransactionType.received;
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _saveAndReturn() {
    final text = _amountController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an amount')));
      return;
    }

    final amount = double.tryParse(text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    final result = {
      'type': _type == TransactionType.received ? 'income' : 'expense',
      'amount': amount,
    };

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Expense Calculator',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              print("Account details will be shown");
            },
          ),
        ],

        backgroundColor: Colors.teal.shade300,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Transaction', style: TextStyle(fontSize: 24)),

            const SizedBox(height: 20),

            // FIXED RADIO BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Radio<TransactionType>(
                      value: TransactionType.received,
                      groupValue: _type,
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                    ),
                    const Text('Received'),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Radio<TransactionType>(
                      value: TransactionType.sent,
                      groupValue: _type,
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                    ),
                    const Text('Sent'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Amount input
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
            ),

            const SizedBox(height: 30),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAndReturn,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.teal.shade300,
                ),
                child: const Text('Save', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
