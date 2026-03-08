echo "Updating $1 environment..."
dart run flutter_launcher_icons -f flutter_launcher_icons-$1.yaml
dart run flutter_native_splash:create --path=flutter_launcher_icons-$1.yaml