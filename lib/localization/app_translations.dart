import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': _en,
    'es_ES': _es,
  };

  static const Map<String, String> _en = {
    // Nav
    'nav_home': 'Home',
    'nav_retainers': 'Retainers',
    'nav_referrals': 'Referrals',
    'nav_settings': 'Settings',
    'hi_user': 'Hi, @name',
    'keep_healthy_smile': 'Keep a Healthy Smile',

    // Language
    'language': 'Language',
    'language_english': 'English',
    'language_spanish': 'Spanish',
    'select_preferred_language': 'Select your preferred language',
    'save_changes': 'Save Changes',

    // Settings sections
    'section_appointment': 'Appointment',
    'section_chat': 'Chat',
    'section_reminder': 'Reminder',
    'section_language_preference': 'Language Preference',
    'section_faq': 'FAQ',
    'section_chat_support': 'Chat Support',
    'section_change_password': 'Change Password',
    'section_delete_account': 'Delete Account',
    'section_agreements': 'Agreements',
    'section_about_app': 'About App',
    'settings_chat_title': 'Chat',
    'settings_chat_subtitle': 'Start chat with your orthodontist',
    'settings_scheduled_appointments_title': 'Scheduled Appointments',
    'settings_scheduled_appointments_subtitle':
        'Get details of your appointments',
    'settings_your_reminder_title': 'Your Reminder',
    'settings_your_reminder_subtitle': '10:00 PM (Night)',
    'settings_faq_title': 'Frequently Asked Questions',
    'settings_faq_subtitle': 'Get answers to your questions',
    'settings_chat_support_subtitle': 'Get help from our support team',
    'settings_change_password_subtitle': 'Change your password',
    'settings_delete_account_subtitle': 'Delete your account',
    'settings_agreements_subtitle': 'View our agreements',
    'settings_about_app_subtitle': 'View information about the app',

    // Auth
    'login': 'Login',
    'enter_credentials': 'Enter your Credentials',
    'enter_email_address': 'Enter Email Address',
    'enter_password': 'Enter Password',
    'remember_me': 'Remember me',
    'forgot_password': 'Forgot Password?',
    'dont_have_account': "Don't have an account? ",
    'sign_up': 'Sign Up',
    'or': 'Or',
    'with_apple': 'With Apple',
    'with_google': 'With Google',
    'by_signing_up_agree': 'By signing up you agree to our ',
    'terms_and_conditions': 'Terms & Conditions',
    'privacy_policy': 'Privacy Policy',
    'terms_privacy_separator': ' | ',
    'sign_up_title': 'Sign Up',
    'email_address': 'Email Address',
    'password': 'Password',
    'confirm_password': 'Confirm Password',
    'agree_with_terms_prefix': 'I agree with the ',
    'sign_up_button': 'Sign up',
    'already_have_account': 'Already have an account? ',

    // Home
    'retainer_months_sample': '05 Months',
    'retainer_replacement_soon':
        'Your retainer may need\nreplacement soon',
    'order_now': 'Order Now',
    'mark_as_worn': 'Mark as Worn',
    'home_quote':
        'Your smile reflects your care protect it daily with simple habits that make a lasting difference.',
    'educational_tips': 'Educational Tips',
    'see_all': 'See All',

    // Notifications
    'notifications': 'Notifications',
    'remind_later': 'Remind Later',
    'already_wear': 'Already Wear',
    'notification_reminder_title': 'Time to wear your retainer',
    'notification_reminder_body':
        'Reminder - Lorem ipsum dolor sit amet consectetur. Sit scelerisque nibh ullamcorper.',
    'notification_habit_title': 'Great habits build great smiles',
    'notification_habit_body':
        "You're doing great—stay consistent this week",
    'notification_feature_title':
        "New features available. Check out what's new in your Freedom Smile",
    'notification_feature_body':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
    'notification_reward_title': "Congratulations! You've earned a reward.",
    'notification_reward_body':
        "You've unlocked your reward check it out now!",
    'notification_referral_title': 'Your referral has been approved.',
    'notification_referral_body':
        'Nice! Your referral is now counted toward your rewards.',
    'timestamp_today': 'Today',
    'timestamp_yesterday': 'Yesterday',
    'timestamp_mon': 'Mon',
    'timestamp_sun': 'Sun',

    // Appointments
    'appointments': 'Appointments',
    'pending': 'Pending',
    'completed': 'Completed',
    'rating_reviews': '@rating (@count)',
    'appointment_orthodontist_title': 'Lorem Ipsum Orthodontist',

    // Chat
    'chat': 'Chat',
    'search': 'Search',
    'write_your_message': 'Write your message..',
    'chat_doctor_jennifer': 'Dr Jennifer Vargas',
    'chat_doctor_anderson': 'Dr Anderson Smith',
    'chat_doctor_william': 'Dr William Roy',
    'chat_clinic_support': 'Clinic Support',
    'chat_last_message_lorem':
        'Lorem ipsum dolor sit amet consectetur.',
    'chat_last_message_confirmed':
        'Your next appointment is confirmed.',
    'chat_last_message_wear_tonight':
        'Please wear your retainer tonight.',
    'chat_last_message_help': 'How can we help you today?',
    'chat_message_lorem':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'chat_time_3pm': '3:00 pm',

    // FAQ
    'faqs_title': "FAQ's",
    'frequently_asked_questions_heading':
        'Frequently Asked Questions:',
    'faq_question_1': 'Lorem ipsum dolor sit amet consectetur ?',
    'faq_answer_1':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'faq_question_2': 'How do I care for my retainers daily?',
    'faq_answer_2':
        'Rinse your retainers with lukewarm water after each use and brush gently with a soft toothbrush.',
    'faq_question_3': 'What should I do if my retainer feels tight?',
    'faq_answer_3':
        'Mild tightness can be normal if you have not worn your retainer for a while. Wear it as directed and contact your orthodontist if discomfort persists.',
    'faq_question_4': 'Can I eat while wearing my retainers?',
    'faq_answer_4':
        'No. Remove your retainers before eating or drinking anything other than water.',
    'faq_question_5': 'How often should I replace my retainer?',
    'faq_answer_5':
        'Replacement timing depends on wear and fit. Your orthodontist can advise when a new retainer is needed.',

    // About
    'about_app': 'About App',
    'about_section_heading': 'Lorem ipsum dolor sit amet consectetur.',
    'about_section_body':
        'Arcu risus, lacus, et felis, vel vitae pulvinar. Nec viverra sit mattis morbi sagittis, eget dictum urna. Et viverra sed gravida id. Proin ut facilisis viverra nisi pulvinar at sed. Neque turpis tempor venenatis neque pellentesque lectus et morbi. Lacinia nunc ac, nullam malesuada dictum turpis accumsan, venenatis.',
    'app_name': 'Freedom Smile',
    'version_label': 'Version @version',

    // Agreements
    'agreements': 'Agreements',
    'terms_content':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    'privacy_content':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',

    // Profile
    'profile': 'Profile',
    'edit_personal_information': 'Edit Personal Information',
    'full_name': 'Full Name',
    'address': 'Address',
    'city': 'City',
    'state': 'State',
    'gender': 'Gender',
    'email': 'Email',
    'phone_number': 'Phone Number',
    'edit_profile': 'Edit Profile',
    'first_name': 'First Name',
    'last_name': 'Last Name',
    'next': 'Next',
    'gender_male': 'Male',
    'gender_female': 'Female',
    'gender_other': 'Other',
    'profile_updated': 'Profile Updated',
    'profile_updated_message':
        'You have successfully updated your profile.',
    'continue': 'Continue',

    // Reminders
    'set_reminder': 'Set Reminder',
    'reminder': 'Reminder',
    'your_reminder': 'Your Reminder',
    'reminder_time_night_sample': '10:00 PM (Night)',
    'edit': 'Edit',
    'new_reminder': 'New Reminder',
    'step_4_of_5': 'Step 4/5',
    'what_time_remind_you': 'What time should we remind you?',
    'reminder_change_later_hint':
        "Don't worry, you can change it in App",
    'night_time': 'Night Time',
    'morning': 'Morning',
    'custom_time': 'Custom Time',
    'recommend': 'Recommend',
    'daily_reminder_is_set': 'Daily Reminder Is Set',
    'daily_reminder_update': 'Daily Reminder Update',
    'reminder_success_message':
        "You're all set! We'll remind you every day to keep your smile healthy and on track.",
    'edit_reminder': 'Edit Reminder',
    'set_clock': 'Set Clock',
    'daily_reminder': 'Daily Reminder',
    'am': 'AM',
    'pm': 'PM',
    'save': 'Save',

    // Account
    'change_password': 'Change Password',
    'existing_password': 'Existing Password',
    'new_password': 'New Password',
    'create_new_password': 'Create New Password',
    'password_min_8_chars': 'Must be at least 8 characters',
    'reset_password': 'Reset Password',
    'password_must_contain': 'Password must contain:',
    'password_req_8_chars': 'At least 8 characters',
    'password_req_letters_numbers': 'Mix of letters and numbers',
    'password_req_special_char': 'At least one special character',
    'password_changed_success':
        'Your password has been changed successfully. You can now login with your new password.',
    'go_back': 'Go Back',
    'delete_account': 'Delete Account',
    'delete_your_account': 'Delete your Account',
    'delete_account_warning':
        'Deleting your account is permanent. All your data, messages, history, and preferences will be erased and cannot be restored.',
    'reason_selection_optional':
        'Reason Selection (Optional, for analytics)',
    'delete_reason_privacy': 'Privacy Concerns',
    'delete_reason_switching': 'Switching to another service',
    'delete_reason_notifications': 'Too many notifications',
    'delete_reason_technical': "I'm facing technical issues",
    'other': 'Other',
    'type_your_reason': 'Type your reason here..',
    'security_confirmation': 'Security Confirmation',
    'enter_password_to_delete':
        'For security, please enter your password to delete your account.',
    'enter_your_password': 'Enter your Password',
    'incorrect_password': 'Incorrect password. Please try again',
    'confirm': 'Confirm',
    'account_deleted_success':
        'Your account has been deleted successfully!',
    'login_account': 'Login Account',

    // Chat support
    'chat_support': 'Chat Support',
    'faqs_short': "FAQ's",
    'support_user_message_sample':
        "It's been feeling a bit sore on one side. Is that normal?",
    'support_reply_sample':
        'Of course! It sounds like you might be experiencing some initial discomfort. This is common when adjusting to a new retainer.',

    // Retainers
    'usage_insights': 'Usage Insights',
    'timestamp_this_week': 'Your Timestamp of this Week',
    'chart_worn': 'Worn',
    'chart_remaining': 'Remaining',
    'good_job': 'Good Job',
    'hours_progress_sample': '19:00:51 Hour Out of 21:00:00 Hours',
    'past_orders_history': 'Past Orders / History',
    'order_title_sample': 'Lorem Ipsum',
    'order_description_sample':
        'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit.',
    'delivered': 'Delivered',
    'retainers_quote':
        'Clean your retainer daily to avoid bacteria',

    // Referrals
    'refer_and_earn': 'Refer & Earn Rewards',
    'refer_hero_description':
        'Invite friends and earn exciting rewards as\nthey join and complete their first order.',
    'rewards_progress': 'Rewards Progress',
    'milestone_1': '1 Referral -> \$100 Gift Card',
    'milestone_2':
        '2 Referrals -> Miami Heat tickets (regular season)',
    'milestone_3': '3 Referrals -> Free Retainer',
    'completed_fraction': '2/3 Completed',
    'invite_friends': 'Invite Friends',
    'share_code_with_friends': 'Share this code with your friends',
    'referral_code_copied': 'Referral code copied',
    'referral_status_tracker': 'Referral Status Tracker',
    'status_registered': 'Registered',
    'status_approved': 'Approved',
    'earned_reward': 'Earned Reward',
    'next_reward_free_retainer': 'Next Reward: Free Retainer',
    'reward_amazon_gift_card': '\$100 Amazon Gift Card',
    'reward_miami_heat_tickets': 'Miami Heat Tickets',
    'reward_free_retainer': 'Free Retainer',
    'status_earned': 'Earned',
    'status_waiting': 'Waiting',

    // Onboarding
    'onboarding': 'Onboarding',
    'skip': 'Skip',
    'onboarding_title_1': 'Keep Your Smile in Shape',
    'onboarding_desc_1':
        'Never miss a day of wearing your retainer with smart daily reminders.',
    'onboarding_title_2': 'Manage & Replace with Ease',
    'onboarding_desc_2':
        "Track your retainer usage and get notified when it's time for a replacement.",
    'onboarding_title_3': 'Stay Connected with Your Orthodontist',
    'onboarding_desc_3':
        'Easily book appointments and stay in touch with your clinic anytime.',
  };

  static const Map<String, String> _es = {
    // Nav
    'nav_home': 'Inicio',
    'nav_retainers': 'Retenedores',
    'nav_referrals': 'Referidos',
    'nav_settings': 'Ajustes',
    'hi_user': 'Hola, @name',
    'keep_healthy_smile': 'Mantén una sonrisa saludable',

    // Language
    'language': 'Idioma',
    'language_english': 'Inglés',
    'language_spanish': 'Español',
    'select_preferred_language': 'Selecciona tu idioma preferido',
    'save_changes': 'Guardar cambios',

    // Settings sections
    'section_appointment': 'Cita',
    'section_chat': 'Chat',
    'section_reminder': 'Recordatorio',
    'section_language_preference': 'Preferencia de idioma',
    'section_faq': 'Preguntas frecuentes',
    'section_chat_support': 'Soporte por chat',
    'section_change_password': 'Cambiar contraseña',
    'section_delete_account': 'Eliminar cuenta',
    'section_agreements': 'Acuerdos',
    'section_about_app': 'Acerca de la app',
    'settings_chat_title': 'Chat',
    'settings_chat_subtitle': 'Inicia un chat con tu ortodoncista',
    'settings_scheduled_appointments_title': 'Citas programadas',
    'settings_scheduled_appointments_subtitle':
        'Consulta los detalles de tus citas',
    'settings_your_reminder_title': 'Tu recordatorio',
    'settings_your_reminder_subtitle': '10:00 PM (Noche)',
    'settings_faq_title': 'Preguntas frecuentes',
    'settings_faq_subtitle': 'Obtén respuestas a tus preguntas',
    'settings_chat_support_subtitle':
        'Obtén ayuda de nuestro equipo de soporte',
    'settings_change_password_subtitle': 'Cambia tu contraseña',
    'settings_delete_account_subtitle': 'Elimina tu cuenta',
    'settings_agreements_subtitle': 'Ver nuestros acuerdos',
    'settings_about_app_subtitle':
        'Ver información sobre la aplicación',

    // Auth
    'login': 'Iniciar sesión',
    'enter_credentials': 'Ingresa tus credenciales',
    'enter_email_address': 'Ingresa tu correo electrónico',
    'enter_password': 'Ingresa tu contraseña',
    'remember_me': 'Recordarme',
    'forgot_password': '¿Olvidaste tu contraseña?',
    'dont_have_account': '¿No tienes una cuenta? ',
    'sign_up': 'Registrarse',
    'or': 'O',
    'with_apple': 'Con Apple',
    'with_google': 'Con Google',
    'by_signing_up_agree': 'Al registrarte aceptas nuestros ',
    'terms_and_conditions': 'Términos y condiciones',
    'privacy_policy': 'Política de privacidad',
    'terms_privacy_separator': ' | ',
    'sign_up_title': 'Registrarse',
    'email_address': 'Correo electrónico',
    'password': 'Contraseña',
    'confirm_password': 'Confirmar contraseña',
    'agree_with_terms_prefix': 'Acepto los ',
    'sign_up_button': 'Registrarse',
    'already_have_account': '¿Ya tienes una cuenta? ',

    // Home
    'retainer_months_sample': '05 Meses',
    'retainer_replacement_soon':
        'Tu retenedor puede necesitar\nreemplazo pronto',
    'order_now': 'Pedir ahora',
    'mark_as_worn': 'Marcar como usado',
    'home_quote':
        'Tu sonrisa refleja tu cuidado; protégela a diario con hábitos simples que marcan la diferencia.',
    'educational_tips': 'Consejos educativos',
    'see_all': 'Ver todo',

    // Notifications
    'notifications': 'Notificaciones',
    'remind_later': 'Recordar después',
    'already_wear': 'Ya lo usé',
    'notification_reminder_title': 'Hora de usar tu retenedor',
    'notification_reminder_body':
        'Recordatorio - Lorem ipsum dolor sit amet consectetur. Sit scelerisque nibh ullamcorper.',
    'notification_habit_title':
        'Los buenos hábitos construyen grandes sonrisas',
    'notification_habit_body':
        '¡Lo estás haciendo genial! Mantén la constancia esta semana',
    'notification_feature_title':
        'Nuevas funciones disponibles. Descubre las novedades en Freedom Smile',
    'notification_feature_body':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
    'notification_reward_title': '¡Felicidades! Has ganado una recompensa.',
    'notification_reward_body':
        '¡Has desbloqueado tu recompensa, échale un vistazo!',
    'notification_referral_title': 'Tu referido ha sido aprobado.',
    'notification_referral_body':
        '¡Genial! Tu referido ya cuenta para tus recompensas.',
    'timestamp_today': 'Hoy',
    'timestamp_yesterday': 'Ayer',
    'timestamp_mon': 'Lun',
    'timestamp_sun': 'Dom',

    // Appointments
    'appointments': 'Citas',
    'pending': 'Pendiente',
    'completed': 'Completada',
    'rating_reviews': '@rating (@count)',
    'appointment_orthodontist_title': 'Ortodoncista Lorem Ipsum',

    // Chat
    'chat': 'Chat',
    'search': 'Buscar',
    'write_your_message': 'Escribe tu mensaje..',
    'chat_doctor_jennifer': 'Dra. Jennifer Vargas',
    'chat_doctor_anderson': 'Dr. Anderson Smith',
    'chat_doctor_william': 'Dr. William Roy',
    'chat_clinic_support': 'Soporte de la clínica',
    'chat_last_message_lorem':
        'Lorem ipsum dolor sit amet consectetur.',
    'chat_last_message_confirmed': 'Tu próxima cita está confirmada.',
    'chat_last_message_wear_tonight':
        'Por favor usa tu retenedor esta noche.',
    'chat_last_message_help': '¿Cómo podemos ayudarte hoy?',
    'chat_message_lorem':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'chat_time_3pm': '3:00 pm',

    // FAQ
    'faqs_title': 'Preguntas frecuentes',
    'frequently_asked_questions_heading':
        'Preguntas frecuentes:',
    'faq_question_1': '¿Lorem ipsum dolor sit amet consectetur?',
    'faq_answer_1':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'faq_question_2': '¿Cómo cuido mis retenedores a diario?',
    'faq_answer_2':
        'Enjuaga tus retenedores con agua tibia después de cada uso y cepíllalos suavemente con un cepillo de dientes suave.',
    'faq_question_3':
        '¿Qué debo hacer si mi retenedor se siente apretado?',
    'faq_answer_3':
        'Una leve tensión puede ser normal si no has usado tu retenedor por un tiempo. Úsalo según las indicaciones y contacta a tu ortodoncista si la molestia persiste.',
    'faq_question_4': '¿Puedo comer con los retenedores puestos?',
    'faq_answer_4':
        'No. Quítate los retenedores antes de comer o beber algo que no sea agua.',
    'faq_question_5': '¿Con qué frecuencia debo reemplazar mi retenedor?',
    'faq_answer_5':
        'El momento del reemplazo depende del desgaste y el ajuste. Tu ortodoncista puede indicarte cuándo necesitas uno nuevo.',

    // About
    'about_app': 'Acerca de la app',
    'about_section_heading': 'Lorem ipsum dolor sit amet consectetur.',
    'about_section_body':
        'Arcu risus, lacus, et felis, vel vitae pulvinar. Nec viverra sit mattis morbi sagittis, eget dictum urna. Et viverra sed gravida id. Proin ut facilisis viverra nisi pulvinar at sed. Neque turpis tempor venenatis neque pellentesque lectus et morbi. Lacinia nunc ac, nullam malesuada dictum turpis accumsan, venenatis.',
    'app_name': 'Freedom Smile',
    'version_label': 'Versión @version',

    // Agreements
    'agreements': 'Acuerdos',
    'terms_content':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    'privacy_content':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',

    // Profile
    'profile': 'Perfil',
    'edit_personal_information': 'Editar información personal',
    'full_name': 'Nombre completo',
    'address': 'Dirección',
    'city': 'Ciudad',
    'state': 'Estado',
    'gender': 'Género',
    'email': 'Correo electrónico',
    'phone_number': 'Número de teléfono',
    'edit_profile': 'Editar perfil',
    'first_name': 'Nombre',
    'last_name': 'Apellido',
    'next': 'Siguiente',
    'gender_male': 'Masculino',
    'gender_female': 'Femenino',
    'gender_other': 'Otro',
    'profile_updated': 'Perfil actualizado',
    'profile_updated_message':
        'Has actualizado tu perfil correctamente.',
    'continue': 'Continuar',

    // Reminders
    'set_reminder': 'Configurar recordatorio',
    'reminder': 'Recordatorio',
    'your_reminder': 'Tu recordatorio',
    'reminder_time_night_sample': '10:00 PM (Noche)',
    'edit': 'Editar',
    'new_reminder': 'Nuevo recordatorio',
    'step_4_of_5': 'Paso 4/5',
    'what_time_remind_you': '¿A qué hora debemos recordarte?',
    'reminder_change_later_hint':
        'No te preocupes, puedes cambiarlo en la app',
    'night_time': 'Noche',
    'morning': 'Mañana',
    'custom_time': 'Hora personalizada',
    'recommend': 'Recomendado',
    'daily_reminder_is_set': 'Recordatorio diario configurado',
    'daily_reminder_update': 'Recordatorio diario actualizado',
    'reminder_success_message':
        '¡Todo listo! Te recordaremos cada día para mantener tu sonrisa saludable.',
    'edit_reminder': 'Editar recordatorio',
    'set_clock': 'Configurar hora',
    'daily_reminder': 'Recordatorio diario',
    'am': 'AM',
    'pm': 'PM',
    'save': 'Guardar',

    // Account
    'change_password': 'Cambiar contraseña',
    'existing_password': 'Contraseña actual',
    'new_password': 'Nueva contraseña',
    'create_new_password': 'Crear nueva contraseña',
    'password_min_8_chars': 'Debe tener al menos 8 caracteres',
    'reset_password': 'Restablecer contraseña',
    'password_must_contain': 'La contraseña debe contener:',
    'password_req_8_chars': 'Al menos 8 caracteres',
    'password_req_letters_numbers': 'Mezcla de letras y números',
    'password_req_special_char': 'Al menos un carácter especial',
    'password_changed_success':
        'Tu contraseña se ha cambiado correctamente. Ya puedes iniciar sesión con tu nueva contraseña.',
    'go_back': 'Volver',
    'delete_account': 'Eliminar cuenta',
    'delete_your_account': 'Eliminar tu cuenta',
    'delete_account_warning':
        'Eliminar tu cuenta es permanente. Todos tus datos, mensajes, historial y preferencias se borrarán y no se podrán recuperar.',
    'reason_selection_optional':
        'Motivo (opcional, para análisis)',
    'delete_reason_privacy': 'Preocupaciones de privacidad',
    'delete_reason_switching': 'Cambio a otro servicio',
    'delete_reason_notifications': 'Demasiadas notificaciones',
    'delete_reason_technical': 'Tengo problemas técnicos',
    'other': 'Otro',
    'type_your_reason': 'Escribe tu motivo aquí..',
    'security_confirmation': 'Confirmación de seguridad',
    'enter_password_to_delete':
        'Por seguridad, ingresa tu contraseña para eliminar tu cuenta.',
    'enter_your_password': 'Ingresa tu contraseña',
    'incorrect_password':
        'Contraseña incorrecta. Inténtalo de nuevo',
    'confirm': 'Confirmar',
    'account_deleted_success':
        '¡Tu cuenta se ha eliminado correctamente!',
    'login_account': 'Iniciar sesión',

    // Chat support
    'chat_support': 'Soporte por chat',
    'faqs_short': 'Preguntas frecuentes',
    'support_user_message_sample':
        'Me ha estado doliendo un poco de un lado. ¿Es normal?',
    'support_reply_sample':
        '¡Por supuesto! Parece que podrías estar experimentando algo de molestia inicial. Es común al adaptarse a un retenedor nuevo.',

    // Retainers
    'usage_insights': 'Estadísticas de uso',
    'timestamp_this_week': 'Tu registro de esta semana',
    'chart_worn': 'Usado',
    'chart_remaining': 'Restante',
    'good_job': 'Buen trabajo',
    'hours_progress_sample':
        '19:00:51 horas de 21:00:00 horas',
    'past_orders_history': 'Pedidos anteriores / Historial',
    'order_title_sample': 'Lorem Ipsum',
    'order_description_sample':
        'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit.',
    'delivered': 'Entregado',
    'retainers_quote':
        'Limpia tu retenedor a diario para evitar bacterias',

    // Referrals
    'refer_and_earn': 'Recomienda y gana recompensas',
    'refer_hero_description':
        'Invita a amigos y gana recompensas cuando\nse unan y completen su primer pedido.',
    'rewards_progress': 'Progreso de recompensas',
    'milestone_1': '1 referido -> Tarjeta regalo de \$100',
    'milestone_2':
        '2 referidos -> Entradas Miami Heat (temporada regular)',
    'milestone_3': '3 referidos -> Retenedor gratis',
    'completed_fraction': '2/3 Completado',
    'invite_friends': 'Invitar amigos',
    'share_code_with_friends': 'Comparte este código con tus amigos',
    'referral_code_copied': 'Código de referido copiado',
    'referral_status_tracker': 'Seguimiento de referidos',
    'status_registered': 'Registrado',
    'status_approved': 'Aprobado',
    'earned_reward': 'Recompensa ganada',
    'next_reward_free_retainer': 'Próxima recompensa: Retenedor gratis',
    'reward_amazon_gift_card': 'Tarjeta regalo Amazon \$100',
    'reward_miami_heat_tickets': 'Entradas Miami Heat',
    'reward_free_retainer': 'Retenedor gratis',
    'status_earned': 'Ganada',
    'status_waiting': 'En espera',

    // Onboarding
    'onboarding': 'Introducción',
    'skip': 'Omitir',
    'onboarding_title_1': 'Mantén tu sonrisa en forma',
    'onboarding_desc_1':
        'No te pierdas ni un día de usar tu retenedor con recordatorios inteligentes.',
    'onboarding_title_2': 'Gestiona y reemplaza con facilidad',
    'onboarding_desc_2':
        'Controla el uso de tu retenedor y recibe avisos cuando sea hora de reemplazarlo.',
    'onboarding_title_3': 'Mantente conectado con tu ortodoncista',
    'onboarding_desc_3':
        'Reserva citas fácilmente y mantente en contacto con tu clínica en cualquier momento.',
  };
}
