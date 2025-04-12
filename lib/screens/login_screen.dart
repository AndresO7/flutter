import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/biometric_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  
  bool _isLoading = false;
  bool _isLocalDataAvailable = false;
  bool _isBiometricLoading = false;
  bool _rememberMe = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
    
    // Simular verificación de datos locales
    _verifyLocalData();
  }

  Future<void> _verifyLocalData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLocalDataAvailable = true;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  void _authenticateWithBiometrics() {
    setState(() {
      _isBiometricLoading = true;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isBiometricLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Autenticación biométrica exitosa"),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Inicio de sesión exitoso"),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar contraseña'),
        content: const Text('Se enviará un enlace de recuperación a tu correo electrónico.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Enlace de recuperación enviado"),
                  backgroundColor: AppTheme.successColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Stack(
              children: [
                // Wave en la parte superior
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: Size(size.width, 80),
                    painter: WavePainter(),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: size.height * 0.02),
                          _buildHeader(),
                          SizedBox(height: size.height * 0.03),
                          _buildLoginForm(),
                          SizedBox(height: size.height * 0.01),
                          _buildRememberMe(),
                          SizedBox(height: size.height * 0.03),
                          _buildLoginButton(),
                          if (_isLocalDataAvailable) ...[
                            SizedBox(height: size.height * 0.01),
                            _buildBiometricOption(),
                          ],
                          SizedBox(height: size.height * 0.02),
                          _buildSocialLogin(),
                          SizedBox(height: size.height * 0.02),
                          _buildRegisterOption(),
                          SizedBox(height: size.height * 0.01),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.subtleShadow,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/logo.jpeg',
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: const Text(
                    'HV',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            // Primera capa (desplazada a la izquierda y arriba)
            Positioned(
              left: -0.4,
              top: -0.4,
              child: Text(
                'HOSPITAL',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                  letterSpacing: 0.8,
                ),
              ),
            ),
            // Segunda capa (desplazada a la derecha y arriba)
            Positioned(
              left: 0.4,
              top: -0.4,
              child: Text(
                'HOSPITAL',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                  letterSpacing: 0.8,
                ),
              ),
            ),
            // Texto principal
            const Text(
              'HOSPITAL',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        Stack(
          children: [
            // Capa 1 (desplazada a la izquierda y arriba)
            Positioned(
              left: -0.8,
              top: -0.8,
              child: Text(
                'VOZANDES QUITO',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333333),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Capa 2 (desplazada a la derecha y arriba)
            Positioned(
              left: 0.8,
              top: -0.8,
              child: Text(
                'VOZANDES QUITO',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333333),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Capa 3 (desplazada a la izquierda y abajo)
            Positioned(
              left: -0.8,
              top: 0.8,
              child: Text(
                'VOZANDES QUITO',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333333),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Capa 4 (desplazada a la derecha y abajo)
            Positioned(
              left: 0.8,
              top: 0.8,
              child: Text(
                'VOZANDES QUITO',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333333),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Capa 5 (desplazada a la izquierda)
            Positioned(
              left: -0.8,
              child: Text(
                'VOZANDES QUITO',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333333),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Capa 6 (desplazada a la derecha)
            Positioned(
              left: 0.8,
              child: Text(
                'VOZANDES QUITO',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333333),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Capa 7 (desplazada arriba)
            Positioned(
              top: -0.8,
              child: Text(
                'VOZANDES QUITO',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333333),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Capa 8 (desplazada abajo)
            Positioned(
              top: 0.8,
              child: Text(
                'VOZANDES QUITO',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF333333),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            // Texto principal
            Text(
              'VOZANDES QUITO',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xFF333333),
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Bienvenido',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Inicia sesión para continuar',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textColor.withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: 'Correo electrónico',
            hintText: 'nombre@ejemplo.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            focusNode: _emailFocusNode,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
            prefixIcon: const Icon(Icons.email_outlined, color: AppTheme.darkGreyColor),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu correo';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Ingresa un correo válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Contraseña',
            hintText: '••••••••',
            controller: _passwordController,
            isPassword: true,
            focusNode: _passwordFocusNode,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _login(),
            prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.darkGreyColor),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingresa tu contraseña';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _forgotPassword,
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (value) {
            setState(() {
              _rememberMe = value ?? false;
            });
          },
        ),
        const Text(
          'Recordarme',
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return CustomButton(
      text: 'Iniciar sesión',
      onPressed: _login,
      isLoading: _isLoading,
      leadingIcon: Icons.login_rounded,
    );
  }

  Widget _buildBiometricOption() {
    return Center(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'o iniciar sesión con',
              style: TextStyle(
                color: AppTheme.darkGreyColor,
                fontSize: 14,
              ),
            ),
          ),
          BiometricButton(
            onPressed: _authenticateWithBiometrics,
            isLoading: _isBiometricLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        if (!_isLocalDataAvailable)
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text(
              'o iniciar sesión con',
              style: TextStyle(
                color: AppTheme.darkGreyColor,
                fontSize: 14,
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(icon: Icons.g_mobiledata, color: Colors.red),
            const SizedBox(width: 16),
            _buildSocialButton(icon: Icons.facebook, color: AppTheme.accentBlueColor),
            const SizedBox(width: 16),
            _buildSocialButton(icon: Icons.apple, color: Colors.black),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({required IconData icon, required Color color}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.subtleShadow,
        ),
        child: Icon(
          icon,
          color: color,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildRegisterOption() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '¿No tienes una cuenta?',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
              );
            },
            child: const Text(
              'Regístrate',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF84133F)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    
    // Comenzar en la esquina superior izquierda
    path.moveTo(0, 0);
    
    // Dibujar la parte superior
    path.lineTo(size.width, 0);
    
    // Dibujar el lado derecho hasta donde empieza la curva
    path.lineTo(size.width, size.height * 0.5);
    
    // Dibujar la curva
    path.quadraticBezierTo(
      size.width * 0.75, 
      size.height * 0.9, 
      size.width * 0.5, 
      size.height * 0.6
    );
    
    path.quadraticBezierTo(
      size.width * 0.25, 
      size.height * 0.3, 
      0, 
      size.height * 0.7
    );
    
    // Volver a la esquina superior izquierda
    path.lineTo(0, 0);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
} 