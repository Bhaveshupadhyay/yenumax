import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shawn/core/theme/app_color.dart';

class AppTheme{

  static ThemeData dark()=>
      ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.black,
        textTheme: TextTheme(
            titleSmall: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.white
            ),
            titleMedium: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white
            ),
          titleLarge: GoogleFonts.poppins(
                fontSize: 45.sp,
                fontWeight: FontWeight.w500,
              color: AppColors.white
            ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white
          ),
          bodySmall: GoogleFonts.poppins(
              fontSize: 15.sp,
              color: AppColors.white
          ),
          bodyMedium: GoogleFonts.poppins(
              fontSize: 18.sp,
              color: AppColors.white
          ),

        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor: AppColors.white,
          selectedItemColor: AppColors.primaryColor,
          showUnselectedLabels: false,
          showSelectedLabels: false
        ),
        iconTheme: IconThemeData(
          color: AppColors.primaryColor
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.grey.shade900,

        )
      );

  static ThemeData light()=>
      ThemeData.light().copyWith(
        textTheme: TextTheme(
            titleSmall: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              color: AppColors.black
            ),
            titleMedium: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.black
            ),
          titleLarge: GoogleFonts.poppins(
                fontSize: 45.sp,
                fontWeight: FontWeight.bold,
              color: AppColors.black
            ),
          headlineSmall: GoogleFonts.poppins(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.black
          ),
          bodySmall: GoogleFonts.poppins(
              fontSize: 15.sp,
              color: AppColors.black
          ),
          bodyMedium: GoogleFonts.poppins(
              fontSize: 18.sp,
              color: AppColors.black
          ),
        ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              unselectedItemColor: AppColors.black,
              selectedItemColor: AppColors.primaryColor,
              showUnselectedLabels: false,
              showSelectedLabels: false
          ),
          iconTheme: IconThemeData(
              color: AppColors.primaryColor
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: AppColors.white,

          ),
      );

  static LinearGradient shimmerGradient(BuildContext context)=>
      Theme.of(context).brightness==Brightness.light? AppTheme.lightGradient:  AppTheme.darkGradient;

  static final lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[
      Colors.white,
      Colors.white,
      Colors.grey[300]!,
      Colors.white,
      Colors.white,
    ],
    stops: const <double>[
      0.0,
      0.35,
      0.5,
      0.65,
      1.0,
    ],
  );

  static final darkGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Colors.grey[900]!,
        Colors.grey[900]!,
        Colors.grey[800]!,
        Colors.grey[900]!,
        Colors.grey[900]!
      ],
      stops: const <double>[
        0.0,
        0.35,
        0.5,
        0.65,
        1.0
      ]);
}