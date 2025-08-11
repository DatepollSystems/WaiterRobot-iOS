import shared
import SwiftUI
import WRCore

struct Event: View {
    let event: shared.Event

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(event.name)

                if event.isDemo {
                    Spacer()

                    Text(localize.switchEvent_demoEvent())
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 2)
                        .background {
                            Capsule()
                                .fill(.darkRed)
                        }
                }
            }

            HStack {
                Text(event.city)
                    .font(.caption)
                    .foregroundColor(Color.gray)

                Spacer()

                if let date = event.startDate {
                    Text(date.description())
                        .font(.caption)
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}

#Preview {
    Event(
        event: shared.Event(
            id: 1,
            name: "My Event",
            startDate: nil,
            endDate: nil,
            city: "Graz",
            organisationId: 1,
            stripeSettings: shared.Event.StripeSettingsDisabled(),
            isDemo: true
        )
    )
}
