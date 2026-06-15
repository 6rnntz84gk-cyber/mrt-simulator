import SwiftUI

struct StationDetailView: View {
    @ObservedObject var viewModel: SimulationViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Details Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Station Details")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                if let station = viewModel.selectedStation {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(station.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Text(station.code)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                } else {
                    Text("Select a station from the map")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                        .italic()
                }
            }
            .padding(12)
            .background(Color(UIColor.darkGray))
            .border(Color.gray.opacity(0.3), width: 1)
            
            // Station List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.getStationsForSelectedLine()) { station in
                        StationRowView(
                            station: station,
                            isSelected: viewModel.selectedStation?.code == station.code,
                            demandColor: viewModel.getDemandColor(for: station.demandProfile.level),
                            action: { viewModel.selectStation(station) }
                        )
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .background(Color.black)
        .border(Color.gray.opacity(0.3), width: 1)
    }
}

struct StationRowView: View {
    let station: Station
    let isSelected: Bool
    let demandColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(spacing: 2) {
                    Text(station.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(station.code)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(spacing: 4) {
                    Circle()
                        .fill(demandColor)
                        .frame(width: 12, height: 12)
                    
                    Text(String(station.demandProfile.avgPassengersPerHour / 100))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(10)
            .background(isSelected ? Color.blue.opacity(0.3) : Color(UIColor.darkGray))
            .border(isSelected ? Color.blue : Color.gray.opacity(0.3), width: 1)
        }
    }
}

#Preview {
    StationDetailView(viewModel: SimulationViewModel())
}
