import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter city", text: $viewModel.city, onCommit: {
                viewModel.fetchWeather()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)

            Image(systemName: viewModel.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.blue)

            Text(viewModel.temperature)
                .font(.system(size: 48, weight: .bold))

            Text(viewModel.description)
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .padding()
        .onAppear {
            viewModel.fetchWeather()
        }
    }
}
