echo "Updating $1 environment..."
dart run flutter_launcher_icons -f flavors_$1.yaml
dart run flutter_native_splash:create --path=flavors_$1.yaml