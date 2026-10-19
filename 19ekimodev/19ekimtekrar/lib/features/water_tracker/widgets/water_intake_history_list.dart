import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../models/water_tracker_model.dart';

/// Su tüketim geçmişindeki kayıtları listeleyen ve silme imkanı sunan widget.
class WaterIntakeHistoryList extends StatelessWidget {
  const WaterIntakeHistoryList({
    super.key,
    required this.logs,
    required this.onRemoveLog,
  });

  final List<WaterIntakeLog> logs;
  final ValueChanged<String> onRemoveLog;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.info_outline,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Henüz su kaydı eklenmedi. Yukarıdaki butonlarla su ekleyebilirsin.',
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: logs
          .map(
            (WaterIntakeLog item) =>
                _WaterLogTile(log: item, onRemove: () => onRemoveLog(item.id)),
          )
          .toList(growable: false),
    );
  }
}

class _WaterLogTile extends StatelessWidget {
  const _WaterLogTile({required this.log, required this.onRemove});

  final WaterIntakeLog log;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.opacity, color: context.colorScheme.primary),
        title: Text(log.label, style: context.textTheme.titleMedium),
        subtitle: Text(
          '+${log.amountMl} ml',
          style: context.textTheme.bodyMedium,
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: context.colorScheme.error),
          tooltip: 'Kaydı Sil',
          onPressed: onRemove,
        ),
      ),
    );
  }
}
