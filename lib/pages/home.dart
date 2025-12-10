import 'package:flutter/material.dart';
import 'package:expensecalculator/pages/AddTransaction.dart';
import 'package:expensecalculator/pages/loginpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double totalIncome = 0;
  double totalExpense = 0;
  double balance = 0;

  final List<String> transactions = [];

  Future<void> _openAddTransaction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTransaction()),
    );

    if (result == null) return;

    final type = result['type'] as String?;
    final amount = result['amount'] as double?;

    if (type == null || amount == null) return;

    setState(() {
      if (type == 'income') {
        totalIncome += amount;
        transactions.insert(0, "Received + ₹${amount.toStringAsFixed(2)}");
      } else {
        totalExpense += amount;
        transactions.insert(0, "Sent - ₹${amount.toStringAsFixed(2)}");
      }
      balance = totalIncome - totalExpense;
      // transactions.insert(0, "Balance: ₹${balance.toStringAsFixed(2)}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final savedMoney = balance > 0;
    final initialCondition = balance == 0;

    return Scaffold(
      appBar: AppBar(
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
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
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
          children: [
            Text(
              // savedMoney
              //     ? "Hurray, you saved money today!"
              //     : "You overspent today, try to save more!",
              initialCondition
                  ? "Welcome! Start adding your transactions."
                  : (savedMoney
                        ? "Hurray, you saved money today!"
                        : "You overspent today, try to save more!"),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: initialCondition
                    ? Colors.teal
                    : (savedMoney ? Colors.green : Colors.red),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text(
                      "Income",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${totalIncome.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Expense",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${totalExpense.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Balance",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${balance.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: transactions.isEmpty
                  ? const Center(child: Text('No transactions yet'))
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.receipt),
                            title: Text(transactions[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransaction,
        backgroundColor: Colors.teal.shade300,
        child: const Icon(Icons.add),
      ),
    );
  }
}
