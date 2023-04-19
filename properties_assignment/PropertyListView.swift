import SwiftUI

@MainActor class PropertyListViewModel: ObservableObject {
    enum PropertyListViewModelError: Error {
        case generalError
        case invalidUrl
        
        var desc: String {
            switch self {
            case .generalError: return "An error occured"
            case .invalidUrl:  return "Invalid Url"
            }
        }
    }
    
    @Published var isLoading = false
    @Published var error: PropertyListViewModelError? = nil
    @Published var properties = [Property]()
    
    func fetchProperties() async {
            isLoading = true
            
            do {
                guard let url = URL(string: "https://pastebin.com/raw/nH5NinBi") else { throw PropertyListViewModelError.invalidUrl }
                let (data, _) = try await URLSession.shared.data(from: url)
                let container = try JSONDecoder().decode(PropertiesContainer.self, from: data)
                properties = container.items
            } catch let e {
                if type(of: e) == PropertyListViewModelError.self {
                    error = e as? PropertyListViewModelError
                } else {
                    error = .generalError
                }
            }
            
            isLoading = false
        }
}

struct PropertyListView: View {
    @StateObject var viewModel = PropertyListViewModel()
        
    var body: some View {
        ZStack{
            if viewModel.isLoading {
                ProgressView()
            } else if let e = viewModel.error {
                Text(e.desc)
            } else {
                ScrollView {
                    VStack {
                        ForEach(viewModel.properties) { property in
                            Text(property.streetAddress ?? "gata")
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchProperties()
        }
        
    }
}

struct PropertyListView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyListView()
    }
}
