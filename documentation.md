# Password Validation Implementation Guide

This document explains the real-time password validation logic implemented in the `SignUpView`.

## 1. Defining the Strength Criteria

**The Question:** What actually makes a password "strong" enough for our application?
**The Answer:** We've defined four specific rules:
1.  At least 8 characters.
2.  Contains at least one uppercase letter.
3.  Contains at least one lowercase letter.
4.  Contains at least one number.

### Implementation: The Getters
To check these rules without cluttering the `build` method, we use computed getters that look directly at the `TextEditingController`:

```dart
bool get _hasMinLength =>
    context.read<RegisterProvider>().passwordController.text.length >= 8;

bool get _hasUppercase =>
    context.read<RegisterProvider>().passwordController.text.contains(RegExp(r'[A-Z]'));

bool get _hasLowercase =>
    context.read<RegisterProvider>().passwordController.text.contains(RegExp(r'[a-z]'));

bool get _hasNumber =>
    context.read<RegisterProvider>().passwordController.text.contains(RegExp(r'[0-9]'));

bool get _isPasswordValid =>
    _hasMinLength && _hasUppercase && _hasLowercase && _hasNumber;
```

---

## 2. Real-Time Feedback Logic

**The Question:** How do we ensure the UI updates *immediately* as the user types, rather than waiting for a "Submit" click?
**The Answer:** We attach a listener to the controller in `initState` and trigger a rebuild on every change.

### The Listener setup:
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final provider = context.read<RegisterProvider>();
    // This ensures _validate runs whenever the password text changes
    provider.passwordController.addListener(_validate);
    _validate();
  });
}
```

### The Validation Method:
**The Question:** If we only call `setState` when the *entire form* becomes valid, what happens to the individual rule indicators (like the "8 characters" checkmark)?
**The Answer:** They won't update! To provide "live" feedback for each individual rule, we must call `setState` on every keystroke.

```dart
void _validate() {
  if (!mounted) return;
  final provider = context.read<RegisterProvider>();
  
  // The overall form is only valid if the password meets ALL criteria
  final valid = provider.emailController.text.trim().contains('@') &&
      _isPasswordValid &&
      provider.phoneController.text.trim().length >= 6;

  // We call setState unconditionally here to refresh the rule indicators
  setState(() => _isFormValid = valid);
}
```

---

## 3. The Visual Feedback UI

**The Question:** How can we show the user exactly which rules they have satisfied without creating a messy, repetitive UI code?
**The Answer:** By creating a small, private reusable widget called `_PasswordRule`.

### The Reusable Component:
```dart
class _PasswordRule extends StatelessWidget {
  final String label;
  final bool passed;

  const _PasswordRule({required this.label, required this.passed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.circle_outlined,
          color: passed ? AppColors.sceTeal : AppColors.sceGreyA0,
          size: 16.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: passed ? AppColors.sceTeal : AppColors.sceGreyA0,
            fontSize: 12.sp,
            fontWeight: passed ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
```

---

## Summary of the "Socratic" Flow
1.  **Observe**: We need a strong password.
2.  **Identify**: What are the specific requirements? (Length, Case, Numbers).
3.  **Implement**: How do we check these? (Regex & Getters).
4.  **Listen**: How do we know when the user changes the text? (Add a listener).
5.  **React**: How do we update the UI? (Call `setState` on every change).
6.  **Display**: How do we make it clear to the user? (Visual checklist with color states).
