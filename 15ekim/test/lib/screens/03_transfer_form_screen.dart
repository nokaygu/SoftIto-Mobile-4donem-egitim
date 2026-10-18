import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransferFormScreen extends StatefulWidget {
  const TransferFormScreen({super.key});
  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  double _balance = 148950.00;
  final List<TransactionItem> _history = [
    const TransactionItem(
      id: "tx_init_1",
      title: 'Ahmet Yılmaz',
      category: 'Hızlı Transfer',
      date: 'bugün 11.30',
      amount: 1500.00,
      isExpense: true,
      icon: Icons.send_rounded,
    ),
    const TransactionItem(
      id: "tx_init_2",
      title: 'Merve Demir ',
      category: 'Hızlı Transfer',
      date: 'dün 15.45',
      amount: 2400.00,
      isExpense: true,
      icon: Icons.send_rounded,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Bakiye: ₺${_balance.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _openTransferModel,
            icon: const Icon(Icons.send_rounded),
            label: const Text('Transfer yap'),
          ),
        ],
      ),
    );
  }

  void _openTransferModel() {
    final formKey = GlobalKey<FormState>();
    String recipient = '';
    double amount = 0;
    bool submitted = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              24,
              8,
              24,
              MediaQuery.of(sheetContext).viewInsets.bottom + 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hızlı Transfer',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kullanılabilir bakiye: ₺${_balance.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 24),

                  // Alıcı
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Alıcı adı soyadı',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Alıcı adını girin';
                      }
                      return null;
                    },
                    onSaved: (value) => recipient = value!.trim(),
                  ),
                  const SizedBox(height: 16),

                  // Tutar
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Gönderilecek tutar',
                      suffixText: 'TL',
                      helperText: 'Örnek: 1500 veya 1500,50',
                      errorMaxLines: 2,
                      prefixIcon: Icon(Icons.payments_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final text = (value ?? '').trim();

                      // En fazla iki ondalık basamak.
                      if (!RegExp(
                        r'^[0-9]+(?:[.,][0-9]{1,2})?$',
                      ).hasMatch(text)) {
                        return 'Geçerli bir tutar girin (ör. 1500,50)';
                      }

                      final parsed = double.tryParse(
                        text.replaceAll(',', '.'),
                      );

                      if (parsed == null || !parsed.isFinite || parsed <= 0) {
                        return 'Tutar sıfırdan büyük olmalı';
                      }

                      if (parsed > _balance) {
                        return 'Yetersiz bakiye';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      amount = double.parse(
                        value!.trim().replaceAll(',', '.'),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Gönder
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Gönder'),
                      onPressed: () {
                        if (submitted || !mounted) return;

                        // Hatalı alan varsa işlemi durdur.
                        if (!formKey.currentState!.validate()) return;

                        // onSaved metotlarını çalıştır.
                        formKey.currentState!.save();
                        submitted = true;

                        final now = DateTime.now();
                        final hour = now.hour.toString().padLeft(2, '0');
                        final minute = now.minute.toString().padLeft(2, '0');

                        setState(() {
                          // Hesabı kuruş üzerinden yap.
                          _balance = ((_balance * 100).round() -
                                  (amount * 100).round()) /
                              100;

                          // Yeni işlemi geçmişin başına ekle.
                          _history.insert(
                            0,
                            TransactionItem(
                              id: 'tx_${now.microsecondsSinceEpoch}',
                              title: recipient,
                              category: 'Hızlı Transfer',
                              date: 'bugün $hour.$minute',
                              amount: amount,
                              isExpense: true,
                              icon: Icons.send_rounded,
                            ),
                          );
                        });

                        Navigator.of(sheetContext).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$recipient için '
                              '₺${amount.toStringAsFixed(2)} '
                              'transfer kaydı eklendi.',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
