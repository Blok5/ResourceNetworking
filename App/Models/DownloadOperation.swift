// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Игорь Симаков
// Описание: Класс для управления состоянием запросов. Необходимо для измежения одновременного асинхронного потока запросов в сеть. Каждый следуюющий запрос будет начинаться после того, как завершился предыдущий

import Foundation

class DownloadOperation: Operation {
    private var task : URLSessionDownloadTask!
    
    enum OperationState {
        case ready
        case executing
        case finished
    }
    
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isReady: Bool { state == .ready }
    override var isExecuting: Bool { state == .executing }
    override var isFinished: Bool { state == .finished }
    
    init(session: URLSession, downloadTaskURL: URL, completionHandler: ((URL?, URLResponse?, Error?) -> Void)?) {
        super.init()
        
        task = session.downloadTask(with: downloadTaskURL, completionHandler: { [weak self] (localURLOrNil, responseOrNil, errorOrNil) in
            if let completionHandler = completionHandler {
                completionHandler(localURLOrNil, responseOrNil, errorOrNil)
            }
            
            self?.state = .finished
        })
    }
    
    override func start() {
        if (self.isCancelled) {
            state = .finished
            return
        }
        state = .executing
        print("downloading")
        self.task.resume()
    }
    
    override func cancel() {
        super.cancel()
        self.task.cancel()
    }
}
