import 'package:flutter/material.dart';
import '../models/asset_model.dart';
import '../models/transaction_model.dart';

class MarketsGridListScreen extends StatelessWidget {
  const MarketsGridListScreen({super.key});

  static const List<Asset> assets = [
    Asset(
        symbol: 'BTC',
        name: 'Bitcoin',
        price: 67420.00,
        change24h: 4.20,
        balance: 0.4),
    Asset(
        symbol: 'ETH',
        name: 'Ethereum',
        price: 3500,
        change24h: -1.80,
        balance: 4.20),
    Asset(
        symbol: 'Sol',
        name: 'Solana',
        price: 200.00,
        change24h: 0.5,
        balance: 85.00),
  ];

  static const List<TransactionItem> transactions = [
    TransactionItem(
        id: 'tx_1',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14.20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
    TransactionItem(
        id: 'tx_2',
        title: 'Beratusta Danışmanlık Hakediş',
        category: 'Kurumsal Gelir',
        date: 'Dün 09.00',
        amount: 125000.00,
        isExpense: true,
        icon: Icons.account_balance),
    TransactionItem(
        id: 'tx_3',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
    TransactionItem(
        id: 'tx_4',
        title: 'Apple Store',
        category: 'Teknoloji',
        date: 'bugün 14:20',
        amount: 64500,
        isExpense: true,
        icon: Icons.laptop_mac),
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Piyasalar',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Varlık kartları
          GridView.builder(
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: assets.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 260,
              mainAxisExtent: 190,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final asset = assets[index];
              final isPositive = asset.change24h >= 0;
              final changeColor = isPositive ? Colors.green : Colors.red;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.symbol.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      asset.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '\$${asset.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${isPositive ? '+' : ''}'
                      '${asset.change24h.toStringAsFixed(2)}% (24s)',
                      style: TextStyle(
                        color: changeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bakiye: ${asset.balance}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 28),
          const Text(
            'Son İşlemler',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // İşlem listesi
          ListView.separated(
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final amountColor =
                  transaction.isExpense ? Colors.red : Colors.green;

              return Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: ListTile(
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: transaction.isExpense
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                    child: Icon(transaction.icon, color: amountColor),
                  ),
                  title: Text(
                    transaction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${transaction.category}\n${transaction.date}',
                  ),
                  trailing: SizedBox(
                    width: 110,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${transaction.isExpense ? '-' : '+'}'
                        '₺${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: amountColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
