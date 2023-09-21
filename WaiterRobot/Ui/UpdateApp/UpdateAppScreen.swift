import shared
import SwiftUI

struct UpdateAppScreen: View {
    var body: some View {
        VStack {
            Text(localize.app.forceUpdate.message())
                .multilineTextAlignment(.center)

            Button {
                guard let storeUrl = VersionChecker.shared.storeUrl,
                      let url = URL(string: storeUrl)
                else {
                    return
                }

                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } label: {
                Text(localize.app.forceUpdate.openStore(value0: "App Store"))
            }.padding()
        }
        .padding()
        .navigationTitle(localize.app.forceUpdate.title())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UpdateAppScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateAppScreen()
        }
    }
}
