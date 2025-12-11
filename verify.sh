#!/bin/bash
# Project Verification Script
# Run this to verify all files are in place

echo "🔍 CashApp Free - Project Verification"
echo "======================================"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

files_ok=0
files_missing=0

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((files_ok++))
    else
        echo -e "${RED}✗${NC} $1"
        ((files_missing++))
    fi
}

echo "📂 Core Files:"
check_file "pubspec.yaml"
check_file "lib/main.dart"
check_file "lib/theme.dart"

echo ""
echo "📱 Models:"
check_file "lib/models/product.dart"
check_file "lib/models/transaction.dart"
check_file "lib/models/index.dart"

echo ""
echo "🧠 Providers:"
check_file "lib/providers/product_provider.dart"
check_file "lib/providers/transaction_provider.dart"
check_file "lib/providers/settings_provider.dart"
check_file "lib/providers/index.dart"

echo ""
echo "📱 Screens:"
check_file "lib/screens/home_screen.dart"
check_file "lib/screens/products_screen.dart"
check_file "lib/screens/pos_screen.dart"
check_file "lib/screens/history_screen.dart"
check_file "lib/screens/settings_screen.dart"
check_file "lib/screens/index.dart"

echo ""
echo "🔧 Services:"
check_file "lib/services/database_helper.dart"
check_file "lib/services/csv_helper.dart"
check_file "lib/services/admob_helper.dart"
check_file "lib/services/index.dart"

echo ""
echo "🎨 Widgets & Utils:"
check_file "lib/widgets/custom_widgets.dart"
check_file "lib/widgets/index.dart"
check_file "lib/utils/currency_formatter.dart"
check_file "lib/utils/index.dart"

echo ""
echo "🌐 Localization:"
check_file "assets/lang/en.json"
check_file "assets/lang/id.json"

echo ""
echo "📚 Documentation:"
check_file "README.md"
check_file "QUICKSTART.md"
check_file "SETUP.md"
check_file "UI_UX_EXPLANATION.md"
check_file "PROJECT_INDEX.md"
check_file "CODE_PATTERNS.md"
check_file "COMPLETE_SUMMARY.md"

echo ""
echo "======================================"
echo -e "${GREEN}✓ Files OK: $files_ok${NC}"
if [ $files_missing -gt 0 ]; then
    echo -e "${RED}✗ Missing: $files_missing${NC}"
else
    echo -e "${GREEN}✓ All files present!${NC}"
fi

echo ""
echo "📊 Statistics:"
echo "- Dart files: $(find lib -name "*.dart" | wc -l)"
echo "- Total lines: $(find lib -name "*.dart" -exec wc -l {} + | tail -1 | awk '{print $1}')"
echo "- Documentation files: 7"
echo ""

if [ $files_missing -eq 0 ]; then
    echo -e "${GREEN}✅ PROJECT READY!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. flutter pub get"
    echo "2. flutter run"
    echo "3. Start using the app!"
    exit 0
else
    echo -e "${RED}❌ Some files are missing${NC}"
    exit 1
fi
