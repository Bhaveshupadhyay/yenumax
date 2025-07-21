import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CommonTextField extends StatelessWidget {

  final String hintText;
  final Icon? prefixIcon;
  final String? prefixSvgIcon;
  final Icon? suffixIcon;
  final TextEditingController textEditingController;
  final bool? isObscureText;
  final VoidCallback? onIconTap;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final Border? border;
  final bool? isReadOnly;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final Function(String)? onTextChanged;
  final EdgeInsets? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;


  const CommonTextField({super.key, required this.hintText, this.suffixIcon,
    required this.textEditingController, this.isObscureText, this.onIconTap, required this.keyboardType,
    this.border, this.isReadOnly, this.onTap, this.inputFormatters, this.bgColor, this.prefixIcon, this.onTextChanged, this.borderRadius, this.contentPadding, this.prefixSvgIcon, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius??BorderRadius.circular(20.r),
        border: border,
        color: bgColor
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(prefixIcon!=null || prefixSvgIcon!=null)
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: prefixIcon?? SvgPicture.asset(
                prefixSvgIcon!,
                height: 20.h,
                width: 20.w,
              ),
            ),
          Expanded(
            child: TextFormField(
                onTap: onTap,
                focusNode: focusNode,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: textEditingController,
                readOnly: isReadOnly??false,
                obscureText: isObscureText ?? false,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 15.sp,
                    ),
                  contentPadding: contentPadding??EdgeInsets.symmetric(vertical:20.h,horizontal:20.w)
                ),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 15.sp,
                ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "$hintText is missing!";
                }
                return null;
              },
              onChanged: onTextChanged
            ),
          ),

          if(suffixIcon!=null)
            InkWell(
              onTap: onIconTap,
              child: suffixIcon,
            ),
          SizedBox(width: 10.w,),
        ],
      ),
    );
  }
}
