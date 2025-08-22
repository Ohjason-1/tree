import Foundation
import Combine
import FirebaseAuth

@MainActor
class ViewModelManager: ObservableObject {
    @Published var profileViewModel: ProfileViewModel
    @Published var subletsViewModel: SubletsViewModel
    @Published var storesViewModel: StoresViewModel
    @Published var messagesViewModel: MessagesViewModel
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = ViewModelManager()
    private var cancellables = Set<AnyCancellable>()
    private var currentUserId: String?
    
    
    private init() {
        // Create initial view models
        let profile = ProfileViewModel()
        self.profileViewModel = profile
        self.subletsViewModel = SubletsViewModel(profile: profile)
        self.storesViewModel = StoresViewModel(profile: profile)
        self.messagesViewModel = MessagesViewModel()
        
        // Listen for user session changes and recreate view models
        setupUserChangeObserver()
    }
    
    private func setupUserChangeObserver() {
        AuthService.shared.$userSession
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userSession in
                if let userSession = userSession {
                    self?.userSession = userSession
                    UserInfo.currentUserId = userSession.uid
                }
                self?.recreateAllViewModels()
                
            }
            .store(in: &cancellables)
    }
    
    func locationDidChange(state: String, city: String) {
            // Clear existing data and refresh for new location
        subletsViewModel.refreshForNewLocation(state: state, city: city)
        storesViewModel.refreshForNewLocation(state: state, city: city)
    }
    
    private func recreateAllViewModels() {
        // Create completely fresh view model instances
        self.subletsViewModel.sublets.removeAll()
        self.storesViewModel.stores.removeAll()
        self.profileViewModel.treeFeed.removeAll()
        
        let newProfile = ProfileViewModel()
        let newSublets = SubletsViewModel(profile: newProfile)
        let newStores = StoresViewModel(profile: newProfile)
        let newMessages = MessagesViewModel()
        
        // Update published properties (this will trigger UI updates)
        self.profileViewModel = newProfile
        self.subletsViewModel = newSublets
        self.storesViewModel = newStores
        self.messagesViewModel = newMessages
        
        print("DEBUG: All view models recreated with fresh instances")
    }
}

