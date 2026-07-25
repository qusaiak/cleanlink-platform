import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../core/utils/functions/validator.dart';

class CustomPinPut extends StatelessWidget {
  const CustomPinPut(
    this._pinCodeController,
    this._pinCodeFocusNode, {
    super.key,
  });

  final TextEditingController _pinCodeController;

  final FocusNode _pinCodeFocusNode;

  @override
  Widget build(BuildContext context) {
    return Pinput(
      onCompleted: (val) {
        _pinCodeFocusNode.unfocus();
      },
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      length: 4,
      validator: (value) => AppValidators.validateCode(value!, context),
      focusNode: _pinCodeFocusNode,
      showCursor: true,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      controller: _pinCodeController,
      closeKeyboardWhenCompleted: true,
      defaultPinTheme: AppDecoration.defaultPinTheme,
      focusedPinTheme: AppDecoration.focusedPinTheme,
      submittedPinTheme: AppDecoration.submittedPinTheme,
    );
  }
}

// ignore: strict_top_level_inference
AppBar appbarWithBackButton(context, theme) {
  return AppBar(
    elevation: 0,
    shadowColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  );
}

// ignore: strict_top_level_inference
// Widget radioListTitle(theme, context, value, selectedValue, title) {
//   return Row(
//     children: [
//       Radio(
//         value: value,
//         groupValue: selectedValue,
//         onChanged: (val) {
//           BlocProvider.of<AuthBloc>(context).add(SelectGender(value));
//         },
//         activeColor: theme.primary,
//         fillColor: WidgetStateProperty.resolveWith(
//               (states) {
//             if (states.contains(WidgetState.selected)) {
//               return theme.primary;
//             }
//             return Colors.grey;
//           },
//         ),

//       ),
//       Text(
//         title,
//         style: Styles.textStyle14.copyWith(color: theme.onSurface),
//       ),
//     ],
//   );
// }
