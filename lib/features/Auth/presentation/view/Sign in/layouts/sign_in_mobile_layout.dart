import 'package:depi_project/core/constant/app_color.dart';
import 'package:depi_project/core/constant/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constant/app_image.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../cubit/auth_cubit.dart';

class SignInMobileLayout extends StatefulWidget {
  const SignInMobileLayout({super.key});

  @override
  State<SignInMobileLayout> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInMobileLayout> {
  final formkey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool isNotVisible = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.user.emailVerified) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.homePage,
              (route) => false,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.verifyEmail,
              (route) => false,
            );
          }
        } else if (state is AuthError) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Authentication Error"),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: Appcolor.kWhite,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(AppImage.logoMap, height: 60, width: 60),
                    const SizedBox(height: 20),
                    Text(
                      AppString.kWelcome,
                      style: TextStyle(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Appcolor.kblack,
                      ),
                    ),
                    Text(
                      AppString.kSignin_to_continue,
                      style: TextStyle(
                        fontSize: width * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Appcolor.kgrey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(email, AppString.kEmail, false),
                    const SizedBox(height: 15),
                    _buildPasswordField(),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, Routes.forgetPass),
                      child:  Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          AppString.kForgetPassword,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Appcolor.kgrey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildSignInButton(isLoading),
                    const SizedBox(height: 20),
                    Text(
                      AppString.kOrSignInWith,
                      style: TextStyle(
                        color: Appcolor.kgrey,
                        fontSize: width * 0.035,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildGoogleButton(isLoading),
                    const Spacer(),
                    _buildSignUpRow(width),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    bool isPassword,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && isNotVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Appcolor.kgrey, width: 2),
        ),
      ),
      validator: (v) => v?.isEmpty ?? true ? "Required" : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: password,
      obscureText: isNotVisible,
      decoration: InputDecoration(
        labelText: AppString.kPassword,
        suffixIcon: IconButton(
          onPressed: () => setState(() => isNotVisible = !isNotVisible),
          icon: Icon(isNotVisible ? Icons.visibility : Icons.visibility_off),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(color: Appcolor.kgrey, width: 2),
        ),
      ),
      validator: (v) => (v?.length ?? 0) < 6 ? "Minimum 6 characters" : null,
    );
  }

  Widget _buildSignInButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                if (formkey.currentState!.validate()) {
                  context.read<AuthCubit>().signIn(
                    email.text.trim(),
                    password.text.trim(),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Appcolor.kblack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                AppString.kSignIN,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildGoogleButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: isLoading
            ? null
            : () => context.read<AuthCubit>().signInWithGoogle(),
        icon: Image.asset(AppImage.logoGoogle, width: 24),
        label: const Text(
          AppString.kSignInGoogle,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSignUpRow(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppString.kDon_tHaveAnAccount,
          style: TextStyle(color: Appcolor.kgrey, fontSize: width * 0.04),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, Routes.signUp),
          child: Text(
            AppString.kSign_up_now,
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Appcolor.kblack,
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
