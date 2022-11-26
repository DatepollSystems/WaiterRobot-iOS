import SwiftUI
import shared

struct TableListScreen: View {
  
  @StateObject private var strongVM = ObservableViewModel(vm: koin.tableListVM())
  
  private var idiom: UIUserInterfaceIdiom {
    UIDevice.current.userInterfaceIdiom
  }
  
  private var columnSize: CGFloat {
    if idiom == .pad || idiom == .mac {
      return UIScreen.main.bounds.size.width / 6
    }
    
    return UIScreen.main.bounds.size.width / 4
  }
  
  private let layout = [
    GridItem(.adaptive(minimum: UIScreen.main.bounds.size.width / 4))
  ]
  
  var body: some View {
    unowned let vm = strongVM
    
    ScreenContainer(vm.state) {
      if vm.state.tables.isEmpty {
        Text(S.tableList.noTableFound())
      } else {
        ScrollView {
          LazyVGrid(columns: layout, spacing: 30) {
            ForEach(vm.state.tables, id: \.id) { table in
              Table(text: table.number.description, size: columnSize, onClick: {
                /* TODO */
              })
            }
          }
          .padding()
        }
      }
    }
  }
}
