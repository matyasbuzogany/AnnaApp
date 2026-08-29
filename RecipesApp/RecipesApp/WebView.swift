import SwiftUI
import WebKit

// MARK: - Custom URL scheme handler for bundled web assets
// Serves files from the WebApp bundle folder under the scheme "app://"
// This lets WKWebView treat the page as a real origin, enabling localStorage.
final class BundleSchemeHandler: NSObject, WKURLSchemeHandler {

    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else {
            urlSchemeTask.didFailWithError(URLError(.badURL))
            return
        }

        // Map "app://localhost/foo/bar.js" → WebApp/foo/bar.js in the bundle
        var relativePath = url.path
        if relativePath.hasPrefix("/") { relativePath = String(relativePath.dropFirst()) }
        if relativePath.isEmpty { relativePath = "index.html" }

        guard
            let resourceURL = Bundle.main.url(forResource: nil, withExtension: nil, subdirectory: "WebApp/\(relativePath)") ??
                              Bundle.main.url(forResource: relativePath, withExtension: nil, subdirectory: "WebApp"),
            let data = try? Data(contentsOf: resourceURL)
        else {
            // Try a direct path approach
            let base = Bundle.main.bundleURL.appendingPathComponent("WebApp")
            let fileURL = base.appendingPathComponent(relativePath)
            guard let data = try? Data(contentsOf: fileURL) else {
                urlSchemeTask.didFailWithError(URLError(.fileDoesNotExist))
                return
            }
            let mime = mimeType(for: relativePath)
            let response = URLResponse(url: url, mimeType: mime, expectedContentLength: data.count, textEncodingName: "utf-8")
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
            return
        }

        let mime = mimeType(for: relativePath)
        let response = URLResponse(url: url, mimeType: mime, expectedContentLength: data.count, textEncodingName: "utf-8")
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(data)
        urlSchemeTask.didFinish()
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {}

    private func mimeType(for path: String) -> String {
        switch (path as NSString).pathExtension.lowercased() {
        case "html":  return "text/html"
        case "js":    return "application/javascript"
        case "css":   return "text/css"
        case "json":  return "application/json"
        case "png":   return "image/png"
        case "jpg", "jpeg": return "image/jpeg"
        case "svg":   return "image/svg+xml"
        default:      return "application/octet-stream"
        }
    }
}

// MARK: - WKWebView wrapper (works on iOS, iPadOS, macOS via Mac Catalyst)
struct WebView: UIViewRepresentable {

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()

        // Register the custom scheme — this gives the page a stable origin
        // so localStorage persists correctly across launches.
        config.setURLSchemeHandler(BundleSchemeHandler(), forURLScheme: "app")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.contentInsetAdjustmentBehavior = .automatic
        webView.isOpaque = false
        webView.backgroundColor = .clear

        // Load index.html via the custom scheme
        if let url = URL(string: "app://localhost/index.html") {
            webView.load(URLRequest(url: url))
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
