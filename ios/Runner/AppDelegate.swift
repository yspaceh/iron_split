import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 1. 取得 Flutter ViewController 與建立通訊通道
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let brightnessChannel = FlutterMethodChannel(name: "com.ironsplit/brightness", binaryMessenger: controller.binaryMessenger)

    // 2. 監聽來自 Flutter 的指令
    brightnessChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        
      // 確保呼叫的方法名稱正確
      if call.method == "setBrightness" {
        // 取得參數
        if let args = call.arguments as? [String: Any],
           let brightness = args["brightness"] as? Double {
            
            // iOS 原生的亮度控制，範圍是 0.0 到 1.0
            UIScreen.main.brightness = CGFloat(brightness)
            result(nil) // 回傳成功
            
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Brightness value is missing", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    brightnessChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        
      if call.method == "setBrightness" {
        if let args = call.arguments as? [String: Any],
           let brightness = args["brightness"] as? Double {
            UIScreen.main.brightness = CGFloat(brightness)
            result(nil)
        } else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Brightness value is missing", details: nil))
        }
      } 
      // ✨ 補上這一段：讓 Flutter 可以取得當前亮度
      else if call.method == "getBrightness" {
          result(Double(UIScreen.main.brightness))
      } 
      else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
