#!/usr/bin/env bash
# ==============================================================================
# Susadım - Flutter Feature Scaffold Üretici Betiği (generate_feature.sh)
# 
# Bu betik, project.md ve skill.md standartlarına uygun olarak yeni bir modülün
# controllers, models, view, widgets ve test iskeletini eksiksiz üretir.
#
# Kullanım:
#   ./generate_feature.sh <feature_name>
#   Örnek: ./generate_feature.sh workout_tracker
# ==============================================================================

set -euo pipefail

# Renkler (ANSI)
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Yardım Mesajı
show_help() {
  cat << EOF
Kullanım: $(basename "$0") [FEATURE_NAME]

Seçenekler:
  -h, --help    Bu yardım iletisini gösterir.

Örnekler:
  $(basename "$0") water_tracker
  $(basename "$0") calorie_counter
  $(basename "$0") profile
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  show_help
  exit 0
fi

# Girdi Doğrulama
RAW_NAME="${1:-}"
if [[ -z "$RAW_NAME" ]]; then
  echo -e "${YELLOW}Lütfen oluşturmak istediğiniz modülün adını giriniz (örn: water_tracker):${NC}"
  read -r RAW_NAME
fi

if [[ -z "$RAW_NAME" ]]; then
  echo -e "${RED}Hata: Modül adı boş bırakılamaz!${NC}"
  exit 1
fi

# snake_case dönüşümü (örn: WaterTracker -> water_tracker, water-tracker -> water_tracker)
SNAKE_NAME=$(echo "$RAW_NAME" | sed -E 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]' | tr '-' '_')

# PascalCase dönüşümü (örn: water_tracker -> WaterTracker)
PASCAL_NAME=$(echo "$SNAKE_NAME" | awk -F_ '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' OFS="")

# Başlık Formatı (örn: Water Tracker)
TITLE_NAME=$(echo "$SNAKE_NAME" | awk -F_ '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' OFS=" ")

# Proje Kök Dizinini Bulma
# Betiğin nerede çalıştırıldığına bakılmaksızın (proje kökü veya .agents/skills/script),
# lib/ klasörünün veya project.md'nin olduğu çalışma kökünü tespit eder.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_DIR="$(pwd)"

if [[ -d "$CURRENT_DIR/lib" || -f "$CURRENT_DIR/project.md" ]]; then
  PROJECT_ROOT="$CURRENT_DIR"
elif [[ -d "$SCRIPT_DIR/../../../lib" || -f "$SCRIPT_DIR/../../../project.md" ]]; then
  PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
else
  PROJECT_ROOT="$CURRENT_DIR"
fi

FEATURE_DIR="$PROJECT_ROOT/lib/features/$SNAKE_NAME"
TEST_DIR="$PROJECT_ROOT/test/features/$SNAKE_NAME"

echo -e "${CYAN}==> Susadım Feature İskeleti Üretiliyor: ${GREEN}${PASCAL_NAME}${NC} (${SNAKE_NAME})"
echo -e "${CYAN}==> Hedef Dizin: ${NC}$FEATURE_DIR"

# 1. Klasörleri Oluştur
mkdir -p "$FEATURE_DIR/controllers"
mkdir -p "$FEATURE_DIR/models"
mkdir -p "$FEATURE_DIR/view"
mkdir -p "$FEATURE_DIR/widgets"
mkdir -p "$TEST_DIR"

# 2. Model Dosyasını Oluştur (models/${SNAKE_NAME}_model.dart)
MODEL_FILE="$FEATURE_DIR/models/${SNAKE_NAME}_model.dart"
if [[ ! -f "$MODEL_FILE" ]]; then
  cat << EOF > "$MODEL_FILE"
/// ${TITLE_NAME} veri modeli.
/// Değişmez (immutable) yapıda tasarlanmıştır; copyWith, fromJson ve toJson metodlarını içerir.
class ${PASCAL_NAME}Model {
  final String id;
  final String title;
  final int value;
  final DateTime timestamp;

  const ${PASCAL_NAME}Model({
    required this.id,
    required this.title,
    required this.value,
    required this.timestamp,
  });

  ${PASCAL_NAME}Model copyWith({
    String? id,
    String? title,
    int? value,
    DateTime? timestamp,
  }) {
    return ${PASCAL_NAME}Model(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory ${PASCAL_NAME}Model.fromJson(Map<String, dynamic> json) {
    return ${PASCAL_NAME}Model(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      value: json['value'] as int? ?? 0,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
EOF
  echo -e "  [+] ${GREEN}Model:${NC} $MODEL_FILE"
else
  echo -e "  [!] ${YELLOW}Model mevcut, atlandı:${NC} $MODEL_FILE"
fi

# 3. Controller Dosyasını Oluştur (controllers/${SNAKE_NAME}_controller.dart)
CONTROLLER_FILE="$FEATURE_DIR/controllers/${SNAKE_NAME}_controller.dart"
if [[ ! -f "$CONTROLLER_FILE" ]]; then
  cat << EOF > "$CONTROLLER_FILE"
import 'package:flutter/foundation.dart';
import '../models/${SNAKE_NAME}_model.dart';

/// ${TITLE_NAME} durum ve iş mantığı yöneticisi.
/// Reaktif durumlar ValueNotifier ile yönetilir; harici ağır paketler kullanılmaz.
class ${PASCAL_NAME}Controller {
  final ValueNotifier<int> totalCount = ValueNotifier<int>(0);
  final ValueNotifier<List<${PASCAL_NAME}Model>> items =
      ValueNotifier<List<${PASCAL_NAME}Model>>(<${PASCAL_NAME}Model>[]);

  void addItem({required String title, required int value}) {
    if (value <= 0) return;
    
    totalCount.value += value;
    final newItem = ${PASCAL_NAME}Model(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      value: value,
      timestamp: DateTime.now(),
    );
    
    // Değişmezliği koruyarak yeni liste referansı oluşturulur
    items.value = List<${PASCAL_NAME}Model>.unmodifiable([...items.value, newItem]);
  }

  void reset() {
    totalCount.value = 0;
    items.value = const <${PASCAL_NAME}Model>[];
  }

  void dispose() {
    totalCount.dispose();
    items.dispose();
  }
}
EOF
  echo -e "  [+] ${GREEN}Controller:${NC} $CONTROLLER_FILE"
else
  echo -e "  [!] ${YELLOW}Controller mevcut, atlandı:${NC} $CONTROLLER_FILE"
fi

# 4. Widget Dosyasını Oluştur (widgets/${SNAKE_NAME}_card.dart)
WIDGET_FILE="$FEATURE_DIR/widgets/${SNAKE_NAME}_card.dart"
if [[ ! -f "$WIDGET_FILE" ]]; then
  cat << EOF > "$WIDGET_FILE"
import 'package:flutter/material.dart';
import '../models/${SNAKE_NAME}_model.dart';

/// ${TITLE_NAME} tekil öğe sunum kartı.
/// 40 satır kuralına uygun, yeniden kullanılabilir sunum bileşeni.
class ${PASCAL_NAME}Card extends StatelessWidget {
  final ${PASCAL_NAME}Model item;

  const ${PASCAL_NAME}Card({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        title: Text(item.title, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '\${item.timestamp.hour.toString().padLeft(2, '0')}:\${item.timestamp.minute.toString().padLeft(2, '0')}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Text(
          '+\${item.value}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
EOF
  echo -e "  [+] ${GREEN}Widget:${NC} $WIDGET_FILE"
else
  echo -e "  [!] ${YELLOW}Widget mevcut, atlandı:${NC} $WIDGET_FILE"
fi

# 5. View Dosyasını Oluştur (view/${SNAKE_NAME}_view.dart)
VIEW_FILE="$FEATURE_DIR/view/${SNAKE_NAME}_view.dart"
if [[ ! -f "$VIEW_FILE" ]]; then
  cat << EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import '../controllers/${SNAKE_NAME}_controller.dart';
import '../models/${SNAKE_NAME}_model.dart';
import '../widgets/${SNAKE_NAME}_card.dart';

/// ${TITLE_NAME} ana ekran görünümü.
/// Sayfa düzeyinde ağır setState kullanılmaz; ValueListenableBuilder ile reaktif dinleme yapılır.
class ${PASCAL_NAME}View extends StatelessWidget {
  final ${PASCAL_NAME}Controller controller;

  const ${PASCAL_NAME}View({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${TITLE_NAME}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildTotalSection(context),
            const SizedBox(height: 16),
            Expanded(child: _buildListSection()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.addItem(title: '${TITLE_NAME} Kaydı', value: 100),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller.totalCount,
      builder: (context, total, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Toplam Miktar:', style: TextStyle(fontSize: 16)),
                Text('\$total', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListSection() {
    return ValueListenableBuilder<List<${PASCAL_NAME}Model>>(
      valueListenable: controller.items,
      builder: (context, itemList, _) {
        if (itemList.isEmpty) {
          return const Center(child: Text('Henüz kayıt bulunmuyor.'));
        }
        return ListView.builder(
          itemCount: itemList.length,
          itemBuilder: (context, index) => ${PASCAL_NAME}Card(item: itemList[index]),
        );
      },
    );
  }
}
EOF
  echo -e "  [+] ${GREEN}View:${NC} $VIEW_FILE"
else
  echo -e "  [!] ${YELLOW}View mevcut, atlandı:${NC} $VIEW_FILE"
fi

# 6. Birim Test Dosyasını Oluştur (test/features/${SNAKE_NAME}/${SNAKE_NAME}_controller_test.dart)
TEST_FILE="$TEST_DIR/${SNAKE_NAME}_controller_test.dart"
if [[ ! -f "$TEST_FILE" ]]; then
  cat << EOF > "$TEST_FILE"
import 'package:flutter_test/flutter_test.dart';
import '../../lib/features/${SNAKE_NAME}/controllers/${SNAKE_NAME}_controller.dart';

void main() {
  group('${PASCAL_NAME}Controller Birim Testleri', () {
    late ${PASCAL_NAME}Controller controller;

    setUp(() {
      controller = ${PASCAL_NAME}Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç değerleri sıfır ve liste boş olmalıdır', () {
      expect(controller.totalCount.value, 0);
      expect(controller.items.value.isEmpty, isTrue);
    });

    test('addItem çağrıldığında toplam ve liste güncellenmelidir', () {
      controller.addItem(title: 'Test Kaydı', value: 150);
      expect(controller.totalCount.value, 150);
      expect(controller.items.value.length, 1);
      expect(controller.items.value.first.title, 'Test Kaydı');
    });

    test('reset çağrıldığında tüm durumlar sıfırlanmalıdır', () {
      controller.addItem(title: 'Öğe 1', value: 200);
      controller.reset();
      expect(controller.totalCount.value, 0);
      expect(controller.items.value.isEmpty, isTrue);
    });
  });
}
EOF
  echo -e "  [+] ${GREEN}Unit Test:${NC} $TEST_FILE"
else
  echo -e "  [!] ${YELLOW}Unit Test mevcut, atlandı:${NC} $TEST_FILE"
fi

echo -e "\n${GREEN}✓ ${PASCAL_NAME} modülü başarıyla oluşturuldu!${NC}"
echo -e "${CYAN}Doğrulama Adımları:${NC}"
echo -e "  1. Statik kod analizi:  ${YELLOW}flutter analyze${NC}"
echo -e "  2. Birim testleri:      ${YELLOW}flutter test${NC}"
