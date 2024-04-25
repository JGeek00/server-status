import Foundation

func mockData() -> StatusModel? {
    if let jsonData = statusMockData.data(using: .utf8) {
        do {
            let data = try JSONDecoder().decode([StatusModel].self, from: Data(jsonData))
            return data[0]
        } catch {
            return nil
        }
    } else {
        return nil
    }
}
