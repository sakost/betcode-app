import Flutter
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene,
          let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

    let controller = FlutterViewController(project: nil, nibName: nil, bundle: nil)

    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = controller
    window.makeKeyAndVisible()
    self.window = window

    // Sync with FlutterAppDelegate so plugins can locate the engine.
    appDelegate.window = window
    GeneratedPluginRegistrant.register(with: appDelegate)
  }
}
