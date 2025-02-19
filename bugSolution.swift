func fetchData(completion: @escaping (Result<[Data], Error>) -> Void) {
    let group = DispatchGroup()
    var results: [Result<Data, Error>] = []
    let semaphore = DispatchSemaphore(value: 0)
    for i in 0..<10 {
        group.enter()
        DispatchQueue.global().async {
            // Simulate network request
            let delay = Double.random(in: 0...1)
            sleep(UInt32(delay))
            if i % 2 == 0 {
                let data = Data([UInt8(i)])
                results.append(.success(data))
            } else {
                results.append(.failure(NSError(domain: "Network Error", code: i, userInfo: nil)))
            }
            group.leave()
        }
    }
    group.notify(queue: .main) {
        let finalResult: Result<[Data], Error> = results.reduce(.success([])) { result, nextResult in
            switch (result, nextResult) {
            case let (.success(data), .success(newData)):
                return .success(data + [newData])
            case let (.failure(error), _):
                return .failure(error)
            case let (_, .failure(error)):
                return .failure(error)
            }
        }
        completion(finalResult)
    }
}