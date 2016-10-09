
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char *argv[]) {
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QCoreApplication::setApplicationName("SenseTrace");
  QCoreApplication::setOrganizationName("Q");
  QQuickStyle::setStyle("Material");
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

#if defined(QT_QML_DEBUG) && defined(Q_OS_ANDROID)
  engine.load(QUrl(QLatin1String(
	  "file:/sdcard/Documents/QML Projects/Projects/SenseTrace/app.qml")));
#else
  engine.load(QUrl(QLatin1String("qrc:/qml/app.qml")));
#endif

  return app.exec();
}
