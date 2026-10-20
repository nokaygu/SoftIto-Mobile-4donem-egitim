import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kurucu/core/state/auth_role_controller.dart';
import 'package:kurucu/features/admin_portal/views/admin_portal_view.dart';
import 'package:kurucu/features/auth/views/role_selection_view.dart';
import 'package:kurucu/features/investor_portal/views/investor_portal_view.dart';
import 'package:kurucu/features/onboarding/views/onboarding_view.dart';
import 'package:kurucu/features/onboarding/widgets/no_plan_form.dart';
import 'package:kurucu/features/shell/views/shell_view.dart';
import 'package:kurucu/main.dart';

void main() {
  testWidgets('KurucuApp launches with RoleSelectionView and navigates between roles', (WidgetTester tester) async {
    AuthRoleController.instance.logout();
    await tester.pumpWidget(const KurucuApp());
    await tester.pump();

    // Verify RoleSelectionView is rendered with 3 portals
    expect(find.byType(RoleSelectionView), findsOneWidget);
    expect(find.text('Yatırım Alan Portalı'), findsOneWidget);
    expect(find.text('Yatırımcı Portalı (Deal Flow)'), findsOneWidget);
    expect(find.text('Admin Kontrol & Denetim Masası'), findsOneWidget);

    // Switch to Entrepreneur role
    AuthRoleController.instance.setRole(UserRole.entrepreneur);
    await tester.pumpAndSettle();
    expect(find.byType(ShellView), findsOneWidget);
    expect(find.text('Hukuk & Finans'), findsOneWidget);
    expect(find.text('Yatırımcılar'), findsOneWidget);

    // Switch to Investor role
    AuthRoleController.instance.setRole(UserRole.investor);
    await tester.pumpAndSettle();
    expect(find.byType(InvestorPortalView), findsOneWidget);
    expect(find.text('Deal Flow'), findsOneWidget);
    expect(find.text('Gelenler'), findsOneWidget);

    // Switch to Admin role
    AuthRoleController.instance.setRole(UserRole.admin);
    await tester.pumpAndSettle();
    expect(find.byType(AdminPortalView), findsOneWidget);
    expect(find.text('Başvurular'), findsOneWidget);
    expect(find.text('Merkezi Denetim & Onay Konsolu'), findsOneWidget);
  });

  testWidgets('OnboardingView switches to NoPlanForm without dropdown assertion error', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingView()));
    await tester.pump();

    // Find and tap "İş Planım Yok / Fikir Aşamasındayım"
    final noPlanChoice = find.text('İş Planım Yok / Fikir Aşamasındayım');
    expect(noPlanChoice, findsOneWidget);
    await tester.tap(noPlanChoice);
    await tester.pumpAndSettle();

    // Verify NoPlanForm is rendered with no assertion errors
    expect(find.byType(NoPlanForm), findsOneWidget);
    expect(find.text('1 - 3 Ay İçinde Şirketleşme'), findsOneWidget);
  });
}
