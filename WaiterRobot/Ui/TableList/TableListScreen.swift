import SwiftUI
import shared
import UIPilot

struct TableListScreen: View {
  @EnvironmentObject var navigator: UIPilot<Screen>
  
  @StateObject private var strongVM = ObservableViewModel(vm: koin.tableListVM())
  
  private let layout = [
    GridItem(.adaptive(minimum: 100))
  ]
  
  var body: some View {
    unowned let vm = strongVM
    
    ScreenContainer(vm.state) {
      VStack {
        HStack {
          ScrollView(.horizontal) {
            HStack {
              ForEach(Array(vm.state.selectedTableGroups), id: \.id) { group in
                Button {
                  vm.actual.toggleFilter(tableGroup: group)
                } label: {
                  Text(group.name)
                }
                .buttonStyle(.bordered)
                .tint(.blue)
              }
              
              ForEach(Array(vm.state.unselectedTableGroups), id: \.id) { group in
                Button {
                  vm.actual.toggleFilter(tableGroup: group)
                } label: {
                  Text(group.name)
                }
                .buttonStyle(.bordered)
              }
            }.padding(.horizontal)
          }
          Button {
            vm.actual.clearFilter()
          } label: {
            Image(systemName: "xmark")
          }.padding()
        }
        ScrollView {
          if vm.state.filteredTableGroups.isEmpty {
            Text(S.tableList.noTableFound())
              .multilineTextAlignment(.center)
              .frame(maxWidth: .infinity)
              .padding()
          } else {
            LazyVGrid(columns: layout, spacing: 10) {
              ForEach(vm.state.filteredTableGroups, id: \.group.id) { groupWithTables in
                Section(groupWithTables.group.name) {
                  ForEach(groupWithTables.tables, id: \.id) { table in
                    Table(
                      text: table.number.description,
                      onClick: {
                        vm.actual.onTableClick(table: table)
                      }
                    )
                    .padding(10)
                  }
                }
              }
            }
            .padding()
          }
        }
      }
    }
    .navigationTitle(CommonApp.shared.settings.eventName)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          vm.actual.openSettings()
        } label: {
          Image(systemName: "gear")
        }
      }
    }
    .refreshable {
      vm.actual.loadTables(forceUpdate: true)
    }
    .handleSideEffects(of: vm, navigator)
  }
}
