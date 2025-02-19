func fetchData(completion: @escaping (Result<[Data], Error>) -> Void) {
    let group = DispatchGroup()
    var results: [Result<Data, Error>] = []
    for i in 0..<10 {
        group.enter()
        DispatchQueue.global().async {
            // Simulate network request
            let delay = Double.random(in: 0...1)
            sleep(UInt32(delay))
            if i % 2 == 0 {
                let data = Data([UInt8(i)])
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "Network Error", code: i, userInfo: nil)))
            }
            group.leave()
        }
    }
    group.notify(queue: .main) {
        results = results.map{$0}
        completion(.success(results.compactMap{$0.success}))
    }
}