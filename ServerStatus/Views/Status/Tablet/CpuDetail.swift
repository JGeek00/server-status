import SwiftUI

struct CpuDetail: View {
    @EnvironmentObject var statusModel: StatusViewModel
    @EnvironmentObject var appConfig: AppConfigViewModel
    
    var body: some View {
        let data = statusModel.status?.last
        let cpuMaxTemp = data?.cpu?.temperatures?.map({ return $0.first ?? 0 }).max()
        List {
            Section("Information") {
                HStack {
                    Text("Model")
                    Spacer()
                    Text(data?.cpu?.model ?? "N/A")
                }
                HStack {
                    Text("Core count")
                    Spacer()
                    Text("\(data?.cpu?.cores != nil ? String(data!.cpu!.cores!) : "N/A") physical cores, \(data?.cpu?.count != nil ? String(data!.cpu!.count!) : "N/A") execution threads")
                }
                HStack {
                    Text("Cache")
                    Spacer()
                    Text("\(cacheValue(value: data?.cpu?.cache))")
                }
            }
            Section("General status") {
                HStack {
                    Text("Load")
                    Spacer()
                    Text(data?.cpu?.utilisation != nil ? "\(Int(data!.cpu!.utilisation!))%" : "N/A")
                } 
                HStack {
                    Text("Temperature")
                    Spacer()
                    Text(cpuMaxTemp != nil ? "\(cpuMaxTemp!)ºC" : "N/A")
                }
            }
            if data?.cpu?.frequencies != nil {
                ForEach(data!.cpu!.frequencies!.indices, id: \.self) { index in
                    CpuCharts(index: index)
                }
            }
        }
        .navigationTitle("CPU")
        .listStyle(InsetListStyle())
        .background(appConfig.getTheme() == ColorScheme.dark ? Color.black : Color.white)
    }
}

#Preview {
    CpuDetail()
}
