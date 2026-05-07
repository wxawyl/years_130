// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Vivir hasta 130';

  @override
  String get todayHealthScore => 'Puntuación de salud de hoy';

  @override
  String get loadingFailed => 'Error de carga, por favor intente de nuevo';

  @override
  String get fourDimensions => 'Cuatro dimensiones';

  @override
  String get sleep => 'Sueño';

  @override
  String get diet => 'Dieta';

  @override
  String get exercise => 'Ejercicio';

  @override
  String get mood => 'Estado de ánimo';

  @override
  String get quickRecord => 'Registro rápido';

  @override
  String get home => 'Inicio';

  @override
  String get veryGood => '🎉 ¡Excelente! ¡Mantén un estilo de vida saludable!';

  @override
  String get good => '👍 ¡Bien! Hay margen de mejora';

  @override
  String get needsWork => '💪 ¡Vamos! Necesitas esforzarte más';

  @override
  String get takeCare => '😅 Cuídate bien hoy también';

  @override
  String get todayIntake => 'Ingesta de hoy';

  @override
  String get calories => 'Calorías';

  @override
  String get protein => 'Proteína(g)';

  @override
  String get carbs => 'Carbohidratos(g)';

  @override
  String get fat => 'Grasa(g)';

  @override
  String get photoRecognize => 'Tomar foto para reconocer alimentos';

  @override
  String get aiRecognition =>
      'Reconocimiento inteligente con IA · Cálculo automático de calorías';

  @override
  String get quickAddFood => 'Agregar alimento rápidamente';

  @override
  String get recordDiet => 'Registrar dieta';

  @override
  String get mealType => 'Tipo de comida';

  @override
  String get breakfast => 'Desayuno';

  @override
  String get lunch => 'Almuerzo';

  @override
  String get dinner => 'Cena';

  @override
  String get snack => 'Merienda';

  @override
  String get foodName => 'Nombre del alimento';

  @override
  String get servings => 'Porciones';

  @override
  String get saveRecord => 'Guardar registro';

  @override
  String get todayRecords => 'Registros de hoy';

  @override
  String get noRecordsToday => 'No hay registros de dieta para hoy';

  @override
  String get dietEducation => 'Educación nutricional';

  @override
  String get source => 'Fuente';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get confirmDelete => 'Confirmar eliminación';

  @override
  String confirmDeleteMessage(String foodName) {
    return '¿Está seguro de que desea eliminar el registro de \"$foodName\"?';
  }

  @override
  String get recordSaved => '¡Registro de dieta guardado exitosamente!';

  @override
  String get recordUpdated => '¡Registro actualizado exitosamente!';

  @override
  String get recordDeleted => 'Registro eliminado';

  @override
  String foodsRecognized(int count, int calories) {
    return '$count tipos de alimentos reconocidos, total $calories kcal';
  }

  @override
  String get editDietRecord => 'Editar registro de dieta';

  @override
  String get sleepManagement => 'Gestión del sueño';

  @override
  String get sleepDuration => 'Duración del sueño';

  @override
  String get sleepQuality => 'Calidad del sueño';

  @override
  String get bedtime => 'Hora de acostarse';

  @override
  String get wakeTime => 'Hora de levantarse';

  @override
  String get hours => 'horas';

  @override
  String get recordSleep => 'Registrar sueño';

  @override
  String get sleepRecordSaved => '¡Registro de sueño guardado exitosamente!';

  @override
  String get noSleepRecords => 'No hay registros de sueño para hoy';

  @override
  String get sleepEducation => 'Educación sobre el sueño';

  @override
  String get exerciseManagement => 'Gestión del ejercicio';

  @override
  String get exerciseType => 'Tipo de ejercicio';

  @override
  String get duration => 'Duración';

  @override
  String get minutes => 'minutos';

  @override
  String get caloriesBurned => 'Calorías quemadas';

  @override
  String get recordExercise => 'Registrar ejercicio';

  @override
  String get exerciseRecordSaved =>
      '¡Registro de ejercicio guardado exitosamente!';

  @override
  String get noExerciseRecords => 'No hay registros de ejercicio para hoy';

  @override
  String get exerciseEducation => 'Educación sobre ejercicio';

  @override
  String get walking => 'Caminar';

  @override
  String get running => 'Correr';

  @override
  String get cycling => 'Ciclismo';

  @override
  String get swimming => 'Natación';

  @override
  String get yoga => 'Yoga';

  @override
  String get gym => 'Gimnasio';

  @override
  String get moodManagement => 'Gestión del estado de ánimo';

  @override
  String get moodLevel => 'Índice de estado de ánimo';

  @override
  String get note => 'Nota';

  @override
  String get recordMood => 'Registrar estado de ánimo';

  @override
  String get moodRecordSaved =>
      '¡Registro de estado de ánimo guardado exitosamente!';

  @override
  String get noMoodRecords => 'No hay registros de estado de ánimo para hoy';

  @override
  String get moodEducation => 'Educación sobre el estado de ánimo';

  @override
  String get veryHappy => 'Muy feliz';

  @override
  String get happy => 'Feliz';

  @override
  String get normal => 'Normal';

  @override
  String get sad => 'Triste';

  @override
  String get verySad => 'Muy triste';

  @override
  String get meditationMusic => 'Música de meditación';

  @override
  String get presetMusic => 'Música predefinida';

  @override
  String get startMeditation => 'Iniciar meditación';

  @override
  String get stopMeditation => 'Detener meditación';

  @override
  String get nowPlaying => 'Reproduciendo';

  @override
  String get playFailed => 'Error de reproducción, por favor intente de nuevo';

  @override
  String get language => 'Idioma';

  @override
  String get chinese => '简体中文';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '한국어';

  @override
  String get spanish => 'Español';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get settings => 'Configuración';
}
